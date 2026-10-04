"""Focused regressions for source freshness and exporter capability diagnostics."""
import unittest
from pathlib import Path
import tempfile
from unittest.mock import patch

from test_architecture import checkout, BASE
from test_output_layout import quick_render
import architecture as cli


FILTERED = '''workspace {
 properties {
  "structurizr.inspection.*" "info"
 }
 model {
  a = softwareSystem "A" {
   tags "Future"
  }
  b = softwareSystem "B"
  a -> b "Uses"
 }
 views {
  systemLandscape "base" {
   include *
  }
  filtered "base" include "Future" "future" {
  }
 }
}'''


class SourceFreshness(unittest.TestCase):
    @patch.object(cli, 'render', side_effect=quick_render)
    def test_changed_hidden_mermaid_source_invalidates_handoff_before_render(self, _):
        with checkout() as root:
            (root / 'workspace.dsl').write_text(BASE)
            diagram = root / 'uml/.draft/sequence.mmd'
            diagram.parent.mkdir(parents=True)
            diagram.write_text('sequenceDiagram\nA->>B: Original\n')
            cli.build()
            diagram.write_text('sequenceDiagram\nA->>B: Changed\n')
            with patch.object(cli, 'require_capability'), patch.object(cli, 'render') as render:
                with self.assertRaisesRegex(ValueError, 'stale'):
                    cli.build_browser()
                render.assert_not_called()

    def test_fingerprint_follows_custom_local_includes_and_extension_chains(self):
        with checkout() as root:
            files = {
                'workspace.dsl': 'workspace extends dependencies/base.dsl {\n}\n',
                'dependencies/base.dsl': 'workspace {\n model {\n !include fragments\n }\n}\n',
                'dependencies/fragments/model.inc': 'a = softwareSystem "A"\n',
                'uml/sequence.puml': '@startuml\n!include_once "../dependencies/plant uml.inc"\n@enduml\n',
                'dependencies/plant uml.inc': '!include_many participants.inc!shared\n',
                'dependencies/participants.inc': 'participant A\n!include "plant uml.inc"\n',
                'workspaces/.experiment/workspace.dsl': BASE,
            }
            for name, contents in files.items():
                file = root / name
                file.parent.mkdir(parents=True, exist_ok=True)
                file.write_text(contents)
            for name in ('dependencies/fragments/model.inc', 'dependencies/participants.inc',
                         'workspaces/.experiment/workspace.dsl'):
                before = cli.source_fingerprint()
                file = root / name
                file.write_text(file.read_text() + '\n// changed\n')
                self.assertNotEqual(before, cli.source_fingerprint(), name)

    def test_fingerprint_excludes_caches_outputs_and_unrelated_files(self):
        with checkout() as root:
            (root / 'workspace.dsl').write_text(BASE)
            before = cli.source_fingerprint()
            for name in ('tmp.sql', 'dependencies/unreferenced.txt', '.git/config', '.agents/settings',
                         'uml/.cache/data', 'uml/__pycache__/data', 'uml/node_modules/data',
                         'workspaces/team/.structurizr/log', 'workspaces/team/workspace.json',
                         'build/generated.svg'):
                file = root / name
                file.parent.mkdir(parents=True, exist_ok=True)
                file.write_text('Not an architecture input')
            self.assertEqual(before, cli.source_fingerprint())

    def test_discovery_ignores_named_caches_but_accepts_hidden_authoring_folders(self):
        with checkout() as root:
            (root / 'workspace.dsl').write_text(BASE)
            accepted = ['uml/.draft/sequence.mmd', 'workspaces/.experiment/workspace.dsl',
                        'workspaces/.experiment/uml/.draft/sequence.puml']
            ignored = ['uml/.cache/sequence.mmd', 'workspaces/team/build/workspace.dsl',
                       'workspaces/team/.agents/uml/sequence.puml',
                       'workspaces/team/node_modules/uml/sequence.mmd']
            for name in accepted + ignored:
                file = root / name
                file.parent.mkdir(parents=True, exist_ok=True)
                file.write_text(BASE if file.suffix == '.dsl' else 'diagram source')
            self.assertEqual({accepted[0], accepted[2]},
                             {path.relative_to(root).as_posix() for path in cli.discover_uml()})
            self.assertEqual({'workspace.dsl', accepted[1]},
                             {path.relative_to(root).as_posix() for path in cli.discover_workspaces()})

    def test_existing_dependencies_cannot_escape_freshness_scope(self):
        with checkout() as root, tempfile.TemporaryDirectory() as external:
            (root / 'workspace.dsl').write_text(BASE)
            source = root / 'uml/sequence.puml'
            source.parent.mkdir()
            outside = Path(external) / 'participants.pumlinc'
            outside.write_text('participant External')
            for name in ('build/include.pumlinc', '.agents/include.pumlinc', 'uml/.cache/include.pumlinc'):
                dependency = root / name
                dependency.parent.mkdir(parents=True, exist_ok=True)
                dependency.write_text('participant A')
                source.write_text(f'@startuml\n!include "{dependency}"\n@enduml\n')
                with self.subTest(name=name), self.assertRaisesRegex(ValueError, 'excluded generated/cache/agent'):
                    cli.source_fingerprint()
            source.write_text(f'@startuml\n!include "{outside}"\n@enduml\n')
            with self.assertRaisesRegex(ValueError, 'must stay inside the repository'):
                cli.source_fingerprint()
            # Missing includes still belong to validation of the relevant workspace,
            # and installed/remote libraries are not local source dependencies.
            source.write_text('@startuml\n!include ../missing.pumlinc\n!include <C4/C4_Context>\n'
                              '!include https://example.invalid/remote.puml\n@enduml\n')
            cli.source_fingerprint()


class ExportCapabilities(unittest.TestCase):
    def test_filtered_export_fails_clearly_before_render_but_supported_selection_works(self):
        with checkout() as root:
            workspace = root / 'workspace.dsl'
            workspace.write_text(FILTERED)
            for selection in (None, ['future']):
                with self.subTest(selection=selection), patch.object(cli, 'stage_c4') as export:
                    with self.assertRaisesRegex(ValueError, 'filtered views: future.*tools-browser export-native'):
                        cli.export(workspace, 'plantuml', selection)
                    export.assert_not_called()
            cli.export(workspace, 'plantuml', ['base'])
            self.assertTrue((cli.BUILD / 'base.puml').is_file())

    @patch.object(cli, 'render', side_effect=quick_render)
    def test_filtered_build_fails_before_render_and_preserves_previous_outputs(self, _):
        with checkout() as root:
            workspace = root / 'workspace.dsl'
            workspace.write_text(BASE)
            cli.build()
            inventory = (cli.BUILD / 'artifacts.json').read_bytes()
            files = {item['output']: (cli.BUILD / item['output']).read_bytes() for item in cli.inventory()}
            workspace.write_text(FILTERED)
            with patch.object(cli, 'stage_c4') as export:
                with self.assertRaisesRegex(ValueError, 'filtered views: future'):
                    cli.build()
                export.assert_not_called()
            self.assertEqual(inventory, (cli.BUILD / 'artifacts.json').read_bytes())
            self.assertEqual(files, {item['output']: (cli.BUILD / item['output']).read_bytes()
                                     for item in cli.inventory()})


if __name__ == '__main__':
    unittest.main()
