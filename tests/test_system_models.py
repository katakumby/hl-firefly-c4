"""Native system-owned fragments and the existing published-view reference rules."""
from contextlib import redirect_stderr, redirect_stdout
import io
import json
import sys
import unittest
from unittest.mock import patch

from test_architecture import checkout
from test_includes import write_files
import architecture as cli
import workspace_paths as paths


MODEL = '''workspace {
 !identifiers hierarchical
 !impliedRelationships false
 properties {
  "structurizr.inspection.*" "info"
 }
 model {
  !include model/people.dsl
  !include model/external-systems
  !include model/platform
  !include model/relationships/integrations
 }
}'''


def shared_workspace(root):
    write_files(root, {
        'model.dsl': MODEL,
        'model/people.dsl': '// Shared actors may be added here.\n',
        'model/platform/00-system.dsl': '// No approved platform definition yet.\n',
        'model/relationships/integrations/links.dsl': '// Cross-system links load last.\n',
        'workspace.dsl': 'workspace extends model.dsl {\n views {\n !include views\n }\n}\n',
        'views/platform/landscape.dsl': 'systemLandscape "landscape" {\n include *\n}\n',
    })


def product(root, key):
    prefix = f'model/external-systems/{key}'
    write_files(root, {
        f'{prefix}/00-system.dsl': 'group "Reference products" {\n'
        + key + ' = softwareSystem "Product ' + key + '"\n}\n',
        f'{prefix}/10-containers/api.dsl': '!element ' + key + ' {\n'
        ' api = container "API" "Accepts requests" "HTTP" {\n'
        '  handler = component "Handler" "Handles requests" "Python"\n }\n}\n',
        f'{prefix}/10-containers/storage/store.dsl': '!element ' + key + ' {\n'
        ' store = container "Store" "Persists data" "SQL"\n}\n',
        f'{prefix}/20-relationships/internal.dsl': key + '.api -> ' + key + '.store "Stores" "SQL"\n',
    })


def by_identifier(raw):
    result = {}

    def visit(element):
        result[element['properties']['structurizr.dsl.identifier']] = element
        for collection in ('containers', 'components'):
            for child in element.get(collection, []):
                visit(child)

    for system in raw['model'].get('softwareSystems', []):
        visit(system)
    return result


def selection_workspace(root, selection):
    shared_workspace(root)
    # Keep ordinary inspection findings enabled; they must not hide parser errors.
    (root / 'model.dsl').write_text(MODEL.replace('"structurizr.inspection.*" "info"', ''))
    for key in ('target', 'survivor'):
        write_files(root, {
            f'model/external-systems/{key}/00-system.dsl':
                key + ' = softwareSystem "' + key.title() + '" {\n tags "Published"\n}\n',
        })
    (root / 'views/platform/landscape.dsl').write_text(
        'systemLandscape "landscape" {\n ' + selection + '\n}\n')


class SystemOwnedModels(unittest.TestCase):
    def test_native_fragments_preserve_groups_hierarchical_ids_and_relationships(self):
        with checkout() as root:
            shared_workspace(root)
            product(root, 'a')
            product(root, 'b')
            (root / 'model/relationships/integrations/links.dsl').write_text(
                'a.api -> b.api "Calls" "HTTP"\n')
            raw, report = cli.fresh_workspace(paths.REFERENCE)
            self.assertTrue(report['passed'])
            elements = by_identifier(raw)
            self.assertEqual({'a', 'a.api', 'a.api.handler', 'a.store',
                              'b', 'b.api', 'b.api.handler', 'b.store'}, set(elements))
            for key in ('a', 'b'):
                self.assertEqual('Reference products', elements[key]['group'])
                self.assertNotIn('group', elements[key + '.api'])
                self.assertEqual([elements[key + '.api.handler']], elements[key + '.api']['components'])
                self.assertEqual({elements[key + '.api']['id'], elements[key + '.store']['id']},
                                 {container['id'] for container in elements[key]['containers']})
            destinations = {relation['destinationId'] for relation in elements['a.api']['relationships']}
            self.assertEqual({elements['a.store']['id'], elements['b.api']['id']}, destinations)

    def test_new_products_containers_and_platform_are_discovered_without_import_edits(self):
        with checkout() as root:
            shared_workspace(root)
            product(root, 'a')
            before, _ = cli.fresh_workspace(paths.REFERENCE)
            self.assertEqual({'a'}, {system['properties']['structurizr.dsl.identifier']
                                    for system in before['model']['softwareSystems']})
            unchanged = {name: (root / name).read_bytes() for name in (
                'workspace.dsl', 'model.dsl', 'model/external-systems/a/00-system.dsl')}
            product(root, 'b')
            write_files(root, {
                'model/external-systems/a/10-containers/worker.dsl':
                    '!element a {\n worker = container "Worker" "Runs jobs" "Python"\n}\n',
                'model/external-systems/a/20-relationships/worker.dsl':
                    'a.worker -> a.store "Stores jobs" "SQL"\n',
                'model/platform/00-system.dsl': 'platform = softwareSystem "Platform"\n',
                'model/platform/10-containers/api.dsl':
                    '!element platform {\n api = container "Platform API" "Serves clients" "Java"\n}\n',
                'model/relationships/integrations/links.dsl':
                    'platform.api -> a.api "Calls" "HTTP"\n',
                'views/external-systems/a/containers.dsl':
                    'container a "a-containers" {\n include *\n}\n',
            })
            cli.export(paths.REFERENCE, 'plantuml')
            raw = json.loads((paths.output_directory(paths.REFERENCE) / 'workspace.json').read_text())
            elements = by_identifier(raw)
            self.assertIn('a.worker', elements)
            self.assertIn('b.api.handler', elements)
            self.assertEqual([elements['platform.api']], elements['platform']['containers'])
            self.assertEqual(elements['a.api']['id'], elements['platform.api']['relationships'][0]['destinationId'])
            for name, content in unchanged.items():
                self.assertEqual(content, (root / name).read_bytes())
            self.assertEqual({'views/platform/landscape.puml', 'views/external-systems/a/a-containers.puml'},
                             {item['output'] for item in cli.inventory()})

    def test_cross_system_relationships_require_the_final_integration_phase(self):
        with checkout() as root:
            shared_workspace(root)
            product(root, 'a')
            product(root, 'z')
            premature = root / 'model/external-systems/a/20-relationships/cross.dsl'
            premature.write_text('a.api -> z.api "Calls" "HTTP"\n')
            with redirect_stderr(io.StringIO()), redirect_stdout(io.StringIO()):
                report = cli.validate([paths.REFERENCE], inspections_blocking=False)[paths.REFERENCE]
            self.assertFalse(report['passed'])
            self.assertIn('z.api', '\n'.join(report['errors']))
            premature.rename(root / 'model/relationships/integrations/cross.dsl')
            _, report = cli.fresh_workspace(paths.REFERENCE)
            self.assertTrue(report['passed'])

    def test_deleted_explicit_reference_blocks_build_until_view_is_updated(self):
        with checkout() as root:
            selection_workspace(root, 'include target survivor')
            cli.export(paths.REFERENCE, 'plantuml')
            output = paths.BUILD / 'views/platform/landscape.puml'
            previous = output.read_bytes()
            (root / 'model/external-systems/target/00-system.dsl').unlink()
            with patch.object(sys, 'argv', ['architecture.py', 'build']), \
                 patch.object(cli, 'stage_c4') as renderer, \
                 redirect_stderr(io.StringIO()), redirect_stdout(io.StringIO()):
                self.assertEqual(1, cli.main())
            renderer.assert_not_called()
            self.assertEqual(previous, output.read_bytes())
            report = json.loads((paths.output_directory(paths.REFERENCE) / 'validation.json').read_text())
            self.assertEqual('report-only', report['inspection_policy'])
            self.assertFalse(report['passed'])
            self.assertIn('"target" does not exist', '\n'.join(report['errors']))
            (root / 'views/platform/landscape.dsl').write_text(
                'systemLandscape "landscape" {\n include survivor\n}\n')
            cli.export(paths.REFERENCE, 'plantuml')
            self.assertIn('"Survivor"', output.read_text())
            self.assertNotIn('"Target"', output.read_text())

    def test_generic_views_intentionally_follow_wildcard_and_selector_membership(self):
        for selection in ('include *', 'include element.tag==Published'):
            with self.subTest(selection=selection), checkout() as root:
                selection_workspace(root, selection)
                cli.export(paths.REFERENCE, 'plantuml')
                output = paths.BUILD / 'views/platform/landscape.puml'
                self.assertIn('"Target"', output.read_text())
                view_source = (root / 'views/platform/landscape.dsl').read_bytes()
                (root / 'model/external-systems/target/00-system.dsl').unlink()
                cli.export(paths.REFERENCE, 'plantuml')
                self.assertNotIn('"Target"', output.read_text())
                self.assertIn('"Survivor"', output.read_text())
                self.assertEqual(view_source, (root / 'views/platform/landscape.dsl').read_bytes())


if __name__ == '__main__':
    unittest.main()
