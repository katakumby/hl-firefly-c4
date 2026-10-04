"""Native folder semantics and matching local provenance/freshness traversal."""
import json
from pathlib import Path
import tempfile
import unittest

from test_architecture import checkout
import architecture as cli
import workspace_paths as paths
from source_inputs import include_files
from view_sources import index_views


def write_files(root, files):
    for name, text in files.items():
        path = root / name
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)


class NativeDirectoryIncludes(unittest.TestCase):
    def test_native_and_provenance_share_recursive_filename_order(self):
        with checkout() as root:
            write_files(root, {
                'workspace.dsl': '''workspace {
 properties {
  "structurizr.inspection.*" "info"
 }
 model {
  !include fragments/model
 }
 views {
  !include fragments/views
 }
}''',
                # Create files out of order; later files depend on earlier context.
                'fragments/model/30-close.inc': '}\n',
                'fragments/model/20-body/api.inc': 'api = container "API" "Test API" "HTTP"\n',
                'fragments/model/10-open.inc': 's = softwareSystem "System" {\n',
                'fragments/views/30-close.inc': '}\n',
                'fragments/views/20-body/include.inc': 'include *\n',
                'fragments/views/10-open.inc': 'systemLandscape "landscape" {\n',
            })
            cli.build_source([paths.REFERENCE])
            artifact, = cli.inventory()
            self.assertEqual('fragments/views/10-open.inc', artifact['source'])
            self.assertEqual('source/fragments/views/landscape.puml', artifact['output'])

    def test_scope_folders_preserve_groups_and_container_component_ownership(self):
        with checkout() as root:
            write_files(root, {
                'workspace.dsl': '''workspace {
 !identifiers hierarchical
 !impliedRelationships false
 properties {
  "structurizr.inspection.*" "info"
 }
 model {
  !include model/external-systems/systems
  !include model/relationships
 }
 views {
  systemLandscape "landscape" {
   include *
  }
 }
}''',
                'model/relationships/nested/calls.inc': 'a.api -> b.api "Calls" "HTTP"\n',
            })
            for key in ('a', 'b'):
                write_files(root, {
                    f'model/external-systems/systems/{key}.dsl': 'group "Shared group" {\n'
                    + key + ' = softwareSystem "System ' + key + '" {\n'
                    + '!include ../containers/' + key + '\n}\n}\n',
                    f'model/external-systems/containers/{key}/api.dsl': 'api = container "API" "Test API" "HTTP" {\n'
                    + 'handler = component "Handler" "Handles requests" "Python"\n}\n',
                    f'model/external-systems/containers/{key}/storage/store.inc': 'store = container "Store" "Test store" "SQL"\n',
                })
            report = cli.validate([paths.REFERENCE])[paths.REFERENCE]
            self.assertTrue(report['passed'], report)
            raw = json.loads((paths.output_directory(paths.REFERENCE) / 'workspace.json').read_text())
            systems = {system['name']: system for system in raw['model']['softwareSystems']}
            self.assertEqual({'System a', 'System b'}, set(systems))
            apis = {}
            for name, system in systems.items():
                self.assertEqual('Shared group', system['group'])
                containers = {container['name']: container for container in system['containers']}
                self.assertEqual({'API', 'Store'}, set(containers))
                apis[name] = containers['API']
                self.assertEqual(['Handler'], [c['name'] for c in apis[name]['components']])
            self.assertNotEqual(apis['System a']['components'][0]['id'],
                                apis['System b']['components'][0]['id'])
            relation, = apis['System a']['relationships']
            self.assertEqual(apis['System b']['id'], relation['destinationId'])

    def test_native_rejects_duplicate_leaves_prose_and_wildcard_paths(self):
        for target, files, error in (
            ('fragments', {'leaf.dsl': 'a = person "A"\n',
                           'nested/wrapper.dsl': '!include ../leaf.dsl\n'}, 'already exists'),
            ('fragments', {'leaf.dsl': 'a = person "A"\n',
                           'README.md': 'THIS IS NOT DSL\n'}, 'Unexpected tokens'),
            ('fragments/*.dsl', {'leaf.dsl': 'a = person "A"\n'}, 'could not be found'),
        ):
            with self.subTest(target=target, error=error), checkout() as root:
                write_files(root, {f'fragments/{name}': text for name, text in files.items()})
                paths.REFERENCE.write_text('workspace {\n model {\n !include ' + target + '\n }\n}\n')
                report = cli.validate([paths.REFERENCE])[paths.REFERENCE]
                self.assertFalse(report['passed'])
                self.assertIn(error, '\n'.join(report['errors']))


class LocalDirectoryIncludes(unittest.TestCase):
    def test_recursive_order_keeps_hidden_files_and_all_suffixes(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            names = ['30-close.inc', '20-body/nested/content.txt', '10-open.dsl', '.draft/first.dsl']
            write_files(root, {f'fragments/{name}': '// fragment\n' for name in names})
            self.assertEqual(sorted(names), [p.relative_to(root / 'fragments').as_posix()
                                             for p in include_files(root / 'fragments', root)])

    def test_nested_targets_cannot_escape_or_include_excluded_directories(self):
        with tempfile.TemporaryDirectory() as temporary, tempfile.TemporaryDirectory() as external:
            root, outside = Path(temporary), Path(external)
            write_files(outside, {'leaf.inc': '// outside\n'})
            nested = root / 'fragments/nested'
            nested.mkdir(parents=True)
            link = nested / 'external'
            for target in (outside / 'leaf.inc', outside):
                link.symlink_to(target, target_is_directory=target.is_dir())
                with self.subTest(target=target), self.assertRaisesRegex(ValueError, 'must stay inside the repository'):
                    list(include_files(root / 'fragments', root))
                link.unlink()
            for excluded in ('.cache', 'build', '.agents'):
                directory = nested / excluded
                directory.mkdir()
                with self.subTest(excluded=excluded), self.assertRaisesRegex(ValueError, 'excluded generated/cache/agent'):
                    list(include_files(root / 'fragments', root))
                directory.rmdir()

    def test_directory_symlink_cycle_is_rejected(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            nested = root / 'fragments/nested'
            nested.mkdir(parents=True)
            (nested / 'loop').symlink_to(root / 'fragments', target_is_directory=True)
            with self.assertRaisesRegex(ValueError, 'Cyclic local include directory'):
                list(include_files(root / 'fragments', root))

    def test_provenance_rejects_nested_include_cycles_and_duplicate_views(self):
        cases = (
            ({'nested/loop.dsl': '!include ../../workspace.dsl\n'}, 'Cyclic DSL include/extension'),
            ({'view.dsl': 'systemLandscape "one" {\n}\n',
              'nested/wrapper.dsl': '!include ../view.dsl\n'}, 'Ambiguous view source'),
        )
        for files, error in cases:
            with self.subTest(error=error), checkout() as root:
                paths.REFERENCE.write_text('workspace {\n views {\n !include fragments\n }\n}\n')
                write_files(root, {f'fragments/{name}': text for name, text in files.items()})
                with self.assertRaisesRegex(ValueError, error):
                    index_views(paths.REFERENCE, root, [])


if __name__ == '__main__':
    unittest.main()
