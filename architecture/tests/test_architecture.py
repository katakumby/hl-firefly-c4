"""Container-only regressions for native commands and artifact safety."""
from contextlib import contextmanager, ExitStack
from copy import deepcopy
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
import architecture as cli
import workspace_paths as paths
from workspace_paths import ARCHITECTURE, BUILD, REFERENCE


@contextmanager
def checkout():
    with tempfile.TemporaryDirectory(dir=BUILD) as temporary, ExitStack() as stack:
        root = Path(temporary)
        architecture = root / 'architecture'
        architecture.mkdir()
        (root / 'README.md').write_text('[Draft](missing.md)')
        values = dict(ROOT=root, ARCHITECTURE=architecture, BUILD=root / 'build/architecture',
                      REFERENCE=architecture / 'workspace.dsl')
        for module in (cli, paths):
            for name, value in values.items():
                stack.enter_context(patch.object(module, name, value))
        yield architecture


BASE = '''workspace {
 properties {
  "structurizr.inspection.*" "info"
 }
 model {
  a = softwareSystem "A" {
   properties {
    "architecture.id" "same-optional-value"
   }
   c = container "Runtime" {
    x = component "X"
   }
  }
  b = softwareSystem "B" {
   properties {
    "architecture.id" "same-optional-value"
   }
  }
  r = a -> b "Calls"
 }
 views {
  systemLandscape "unprefixed" {
   include a b
   exclude r
   autoLayout lr
  }
  systemLandscape "duplicate-selection" {
   include a b
   exclude r
   autoLayout lr
  }
  dynamic * "flow" {
   a -> b "Calls"
   autoLayout lr
  }
 }
}'''


class NativeWorkflow(unittest.TestCase):
    def test_native_policy_accepts_flexible_models_and_inheritance(self):
        with checkout() as architecture:
            first = architecture / 'initiatives/TeamA/workspace.dsl'
            cross = architecture / 'initiatives/TeamB/experiment/workspace.dsl'
            variant = architecture / 'initiatives/TeamB/variants/target/workspace.dsl'
            for path in (first, cross, variant):
                path.parent.mkdir(parents=True, exist_ok=True)
            first.write_text(BASE)
            paths.REFERENCE.write_text('workspace extends initiatives/TeamA/workspace.dsl {\n}')
            cross.write_text('workspace extends ../../TeamA/workspace.dsl {\n}')
            variant.write_text('workspace extends ../../experiment/workspace.dsl {\n}')
            template = architecture / 'templates/example/workspace.dsl'
            template.parent.mkdir(parents=True)
            template.write_text('Not an entrypoint')
            self.assertNotIn(template, paths.discover_workspaces())
            reports = cli.validate()
            self.assertEqual({paths.REFERENCE, first, cross, variant}, set(reports))
            self.assertTrue(all(report['passed'] for report in reports.values()), reports)
            for path in reports:
                log = (paths.output_directory(path) / 'validation.log').read_text()
                self.assertIn('structurizr validate -workspace', log)
                self.assertIn('-severity error,warning', log)
                raw = json.loads((paths.output_directory(path) / 'workspace.json').read_text())
                self.assertTrue(raw['views']['dynamicViews'])

    def test_native_errors_and_warnings_fail_but_info_and_ignore_pass(self):
        with checkout():
            for severity in ('error', 'warning', 'info', 'ignore'):
                with self.subTest(severity=severity):
                    paths.REFERENCE.write_text(BASE.replace('"structurizr.inspection.*" "info"',
                                                           f'"structurizr.inspection.*" "{severity}"'))
                    report = cli.validate([paths.REFERENCE])[paths.REFERENCE]
                    self.assertEqual(severity in ('info', 'ignore'), report['passed'], report)
                    self.assertIn('structurizr inspect', (paths.output_directory(paths.REFERENCE) / 'validation.log').read_text())

    def test_native_failure_preserves_previous_json(self):
        with checkout():
            paths.REFERENCE.write_text(BASE)
            self.assertTrue(cli.validate([paths.REFERENCE])[paths.REFERENCE]['passed'])
            destination = paths.output_directory(paths.REFERENCE) / 'workspace.json'
            previous = destination.read_bytes()
            paths.REFERENCE.write_text('workspace {\n !include missing.dsl\n}')
            self.assertFalse(cli.validate([paths.REFERENCE])[paths.REFERENCE]['passed'])
            self.assertEqual(previous, destination.read_bytes())

    def test_selected_workspace_does_not_validate_unrelated_entrypoints(self):
        with checkout() as architecture:
            paths.REFERENCE.write_text('Invalid DSL')
            initiative = architecture / 'initiatives/example/workspace.dsl'
            initiative.parent.mkdir(parents=True)
            initiative.write_text(BASE)
            reports = cli.validate([initiative])
            self.assertEqual({initiative}, set(reports))
            self.assertTrue(reports[initiative]['passed'], reports)

    def test_selection_does_not_mutate_input(self):
        raw = {'views': {'systemContextViews': [{'key': 'one'}, {'key': 'two'}]}}
        before = deepcopy(raw)
        self.assertEqual([{'key': 'one'}], cli.select_view(raw, 'one')['views']['systemContextViews'])
        self.assertEqual(before, raw)
        for key in ('missing', ''):
            with self.subTest(key=key), self.assertRaisesRegex(ValueError, 'exactly one'):
                cli.select_view(raw, key)

    def test_export_paths_cannot_escape_output_directory(self):
        with self.assertRaisesRegex(ValueError, 'safe file names'):
            cli.select_view({'views': {'systemContextViews': [{'key': '../escape'}]}}, None)


class C4PlantUMLExport(unittest.TestCase):
    def test_native_default_and_explicit_single_view_exports_without_a_browser(self):
        with checkout() as architecture, patch.dict(os.environ, {
            'PLAYWRIGHT_BROWSERS_PATH': '/nonexistent-plantuml-test-browsers',
            'PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD': '1',
        }):
            paths.REFERENCE.write_text('Invalid unrelated DSL')
            workspace = architecture / 'initiatives/example/workspace.dsl'
            workspace.parent.mkdir(parents=True)
            workspace.write_text(BASE)
            arguments = ['architecture.py', 'export', '--workspace', str(workspace.relative_to(cli.ROOT))]
            before = cli.source_fingerprint()
            directory = paths.output_directory(workspace)
            mermaid = directory / 'exports/all/mermaid/structurizr-flow.mmd'
            mermaid.parent.mkdir(parents=True)
            mermaid.write_text('Existing Mermaid export')
            complete = directory / 'exports/all/plantuml'
            complete.mkdir(parents=True)
            (complete / 'structurizr-flow.puml').write_text('Previous plain PlantUML diagram')
            (complete / 'structurizr-flow-key.puml').write_text('Obsolete separate legend')
            with patch.object(sys, 'argv', arguments):
                self.assertEqual(0, cli.main())
            expected = {'export.json'} | {
                f'structurizr-{key}.puml' for key in ('unprefixed', 'duplicate-selection', 'flow')
            }
            self.assertEqual(expected, {p.name for p in complete.iterdir()})
            for file in complete.glob('*.puml'):
                content = file.read_text()
                self.assertTrue(content.startswith('@startuml'))
                self.assertTrue(content.strip().endswith('@enduml'))
                self.assertIn('!include <C4/C4>', content)
                self.assertIn('System(A, "A"', content)
                self.assertIn('SHOW_LEGEND(true)', content)
            self.assertIn('Rel(A, B, "1: Calls"', (complete / 'structurizr-flow.puml').read_text())
            self.assertNotIn('Calls', (complete / 'structurizr-unprefixed.puml').read_text())
            report = json.loads((complete / 'export.json').read_text())
            self.assertTrue(report['passed'])
            self.assertEqual('plantuml', report['format'])
            self.assertEqual('plantuml/c4plantuml', report['native_format'])
            self.assertIsNone(report['view'])
            self.assertEqual(before, report['source_sha256'])
            previous = {p.name: p.read_bytes() for p in complete.iterdir()}
            selection = 'view-' + hashlib.sha256(b'flow').hexdigest()[:12]
            single = directory / 'exports' / selection / 'plantuml'
            single.mkdir(parents=True)
            (single / 'structurizr-flow-key.puml').write_text('Obsolete separate legend')
            with patch.object(sys, 'argv', arguments + ['--view', 'flow', '--format', 'plantuml']):
                self.assertEqual(0, cli.main())
            self.assertEqual({'structurizr-flow.puml', 'export.json'}, {p.name for p in single.iterdir()})
            self.assertIn('Rel(A, B, "1: Calls"', (single / 'structurizr-flow.puml').read_text())
            self.assertEqual('flow', json.loads((single / 'export.json').read_text())['view'])
            self.assertIn('-format plantuml/c4plantuml', (directory / 'export.log').read_text())
            self.assertEqual(previous, {p.name: p.read_bytes() for p in complete.iterdir()})
            self.assertEqual('Existing Mermaid export', mermaid.read_text())
            self.assertEqual(before, cli.source_fingerprint())
            self.assertFalse(paths.output_directory(paths.REFERENCE).exists())


class MermaidExport(unittest.TestCase):
    def test_native_explicit_all_and_single_view_without_a_browser(self):
        with checkout(), patch.dict(os.environ, {
            'PLAYWRIGHT_BROWSERS_PATH': '/nonexistent-mermaid-test-browsers',
            'PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD': '1',
        }):
            paths.REFERENCE.write_text(BASE)
            before = cli.source_fingerprint()
            with patch.object(sys, 'argv', ['architecture.py', 'export', '--format', 'mermaid']):
                self.assertEqual(0, cli.main())
            directory = paths.output_directory(paths.REFERENCE)
            complete = directory / 'exports/all/mermaid'
            filenames = {'structurizr-unprefixed.mmd', 'structurizr-duplicate-selection.mmd',
                         'structurizr-flow.mmd', 'export.json'}
            self.assertEqual(filenames, {p.name for p in complete.iterdir()})
            static = (complete / 'structurizr-unprefixed.mmd').read_text()
            self.assertIn('graph LR', static)
            self.assertIn('>A</div>', static)
            self.assertIn('>B</div>', static)
            self.assertIn('[Software System]', static)
            self.assertNotIn('Calls', static)
            self.assertIn('Calls', (complete / 'structurizr-flow.mmd').read_text())
            metadata = json.loads((complete / 'export.json').read_text())
            self.assertEqual('mermaid', metadata['format'])
            self.assertIsNone(metadata['view'])
            self.assertEqual(before, metadata['source_sha256'])
            self.assertTrue(metadata['passed'])
            previous = {p.name: p.read_bytes() for p in complete.iterdir()}
            image = directory / 'exports/all/svg/keep.svg'
            image.parent.mkdir(parents=True)
            image.write_text('existing image')
            with patch.object(sys, 'argv', ['architecture.py', 'export', '--format', 'mermaid', '--view', 'flow']):
                self.assertEqual(0, cli.main())
            selection = 'view-' + hashlib.sha256(b'flow').hexdigest()[:12]
            single = directory / 'exports' / selection / 'mermaid'
            self.assertEqual({'structurizr-flow.mmd', 'export.json'}, {p.name for p in single.iterdir()})
            self.assertEqual((complete / 'structurizr-flow.mmd').read_bytes(),
                             (single / 'structurizr-flow.mmd').read_bytes())
            self.assertEqual('flow', json.loads((single / 'export.json').read_text())['view'])
            self.assertEqual(previous, {p.name: p.read_bytes() for p in complete.iterdir()})
            self.assertEqual('existing image', image.read_text())
            log = (directory / 'export.log').read_text()
            self.assertIn('-format mermaid', log)
            self.assertNotIn('-format svg', log)
            self.assertEqual(before, cli.source_fingerprint())

    def test_native_explicit_workspace_and_variant_export(self):
        with checkout() as architecture:
            paths.REFERENCE.write_text('Invalid unrelated DSL')
            initiative = architecture / 'initiatives/example/workspace.dsl'
            variant = architecture / 'initiatives/example/variants/target/workspace.dsl'
            initiative.parent.mkdir(parents=True)
            variant.parent.mkdir(parents=True)
            initiative.write_text(BASE)
            variant.write_text('workspace extends ../../workspace.dsl {\n}')
            outputs = {}
            for workspace in (initiative, variant):
                with self.subTest(workspace=workspace), patch.object(sys, 'argv', [
                    'architecture.py', 'export', '--workspace', str(workspace.relative_to(cli.ROOT)),
                    '--format', 'mermaid',
                ]):
                    self.assertEqual(0, cli.main())
                output = paths.output_directory(workspace) / 'exports/all/mermaid'
                self.assertEqual(3, len(list(output.glob('*.mmd'))))
                report = json.loads((output / 'export.json').read_text())
                self.assertEqual(workspace.relative_to(cli.ROOT).as_posix(), report['workspace'])
                for previous, contents in outputs.items():
                    self.assertEqual(contents, {p.name: p.read_bytes() for p in previous.iterdir()})
                outputs[output] = {p.name: p.read_bytes() for p in output.iterdir()}
            self.assertFalse(paths.output_directory(paths.REFERENCE).exists())

    def test_bad_selection_and_validation_failure_preserve_mermaid(self):
        with checkout():
            paths.REFERENCE.write_text(BASE)
            with patch.object(sys, 'argv', ['architecture.py', 'export', '--format', 'mermaid']):
                self.assertEqual(0, cli.main())
            output = paths.output_directory(paths.REFERENCE) / 'exports/all/mermaid'
            previous = {p.name: p.read_bytes() for p in output.iterdir()}
            for key in ('missing', ''):
                with self.subTest(key=key), patch.object(sys, 'argv', ['architecture.py', 'export', '--format', 'mermaid', '--view', key]):
                    self.assertEqual(1, cli.main())
                self.assertEqual(previous, {p.name: p.read_bytes() for p in output.iterdir()})
            paths.REFERENCE.write_text('workspace {\n !include missing.dsl\n}')
            with patch.object(sys, 'argv', ['architecture.py', 'export', '--format', 'mermaid']):
                self.assertEqual(1, cli.main())
            self.assertEqual(previous, {p.name: p.read_bytes() for p in output.iterdir()})
            self.assertFalse(json.loads((output.parents[2] / 'validation.json').read_text())['passed'])

    def test_incomplete_or_empty_text_output_preserves_previous_exports(self):
        for format, extension in (('mermaid', 'mmd'), ('plantuml', 'puml')):
            for failure in ('missing', 'empty', 'wrong-name'):
                with self.subTest(format=format, failure=failure), tempfile.TemporaryDirectory(dir=BUILD) as temporary:
                    directory = Path(temporary)
                    destination = directory / 'exports/all' / format
                    destination.mkdir(parents=True)
                    (destination / f'previous.{extension}').write_text('previous success')
                    (destination / 'export.json').write_text('{"passed": true}')
                    previous = {p.name: p.read_bytes() for p in destination.iterdir()}
                    raw = {'views': {'systemContextViews': [{'key': 'one'}, {'key': 'two'}]}}
                    def incomplete_export(arguments, logs, **kwargs):
                        output = Path(arguments[arguments.index('-output') + 1])
                        output.mkdir()
                        (output / f'structurizr-one.{extension}').write_text('native output')
                        if failure == 'empty':
                            (output / f'structurizr-two.{extension}').touch()
                        elif failure == 'wrong-name':
                            (output / f'two.{extension}').write_text('native output')
                    with patch.object(cli, 'output_directory', return_value=directory), \
                         patch.object(cli, 'fresh_workspace', return_value=(raw, {'source_sha256': 'fixture'})), \
                         patch.object(cli, 'run_java', side_effect=incomplete_export):
                        with self.assertRaisesRegex(ValueError, 'every requested diagram'):
                            cli.export(REFERENCE, format)
                    self.assertEqual(previous, {p.name: p.read_bytes() for p in destination.iterdir()})

    def test_sources_changed_during_export_preserves_previous_mermaid(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            directory = Path(temporary)
            destination = directory / 'exports/all/mermaid'
            destination.mkdir(parents=True)
            (destination / 'structurizr-one.mmd').write_text('previous success')
            (destination / 'export.json').write_text('{"source_sha256": "previous"}')
            previous = {p.name: p.read_bytes() for p in destination.iterdir()}
            raw = {'views': {'systemContextViews': [{'key': 'one'}]}}
            def export_diagram(arguments, logs, **kwargs):
                output = Path(arguments[arguments.index('-output') + 1])
                output.mkdir()
                (output / 'structurizr-one.mmd').write_text('graph LR\n  A --> B')
            with patch.object(cli, 'output_directory', return_value=directory), \
                 patch.object(cli, 'fresh_workspace', return_value=(raw, {'source_sha256': 'fixture'})), \
                 patch.object(cli, 'source_fingerprint', return_value='changed'), \
                 patch.object(cli, 'run_java', side_effect=export_diagram):
                with self.assertRaisesRegex(ValueError, 'Sources changed during export'):
                    cli.export(REFERENCE, 'mermaid')
            self.assertEqual(previous, {p.name: p.read_bytes() for p in destination.iterdir()})


class FailureHandling(unittest.TestCase):
    def test_clean_build_preserves_settings_lock_sources_and_other_builds(self):
        with checkout() as architecture:
            paths.REFERENCE.write_text('Authored DSL')
            other = cli.ROOT / 'build/evidence/snapshot'
            other.parent.mkdir(parents=True)
            other.write_text('Evidence')
            with cli.command_lock():
                lock_inode = (cli.BUILD / '.tools.lock').stat().st_ino
                (cli.BUILD / 'local.env').write_text('LOCAL_SETTING=8082')
                stale = cli.BUILD / 'old-run/nested/diagram.svg'
                stale.parent.mkdir(parents=True)
                stale.write_text('Obsolete diagram')
                (cli.BUILD / 'old-report.json').write_text('{}')
                cli.clean_build()
                self.assertEqual({'.tools.lock', 'local.env'}, {p.name for p in cli.BUILD.iterdir()})
                self.assertEqual(lock_inode, (cli.BUILD / '.tools.lock').stat().st_ino)
                self.assertEqual('LOCAL_SETTING=8082', (cli.BUILD / 'local.env').read_text())
            self.assertEqual('Authored DSL', paths.REFERENCE.read_text())
            self.assertEqual('Evidence', other.read_text())

    def test_clean_build_rejects_an_unexpected_root(self):
        with checkout() as architecture:
            paths.REFERENCE.write_text('Authored DSL')
            with patch.object(cli, 'BUILD', architecture):
                with self.assertRaisesRegex(ValueError, 'Refusing to clean'):
                    cli.clean_build()
            self.assertEqual('Authored DSL', paths.REFERENCE.read_text())

    def test_clean_build_does_not_follow_symlinks(self):
        with checkout() as architecture:
            paths.REFERENCE.write_text('Authored DSL')
            with cli.command_lock():
                (cli.BUILD / 'linked-directory').symlink_to(architecture, target_is_directory=True)
                (cli.BUILD / 'linked-file').symlink_to(paths.REFERENCE)
                cli.clean_build()
            self.assertEqual('Authored DSL', paths.REFERENCE.read_text())

    def test_native_viewer_outputs_do_not_change_source_fingerprint(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            root = Path(temporary)
            architecture = root / 'architecture'
            architecture.mkdir()
            (root / 'README.md').write_text('Fixture')
            (architecture / 'workspace.dsl').write_text('Authored DSL')
            with patch.object(cli, 'ROOT', root), patch.object(cli, 'ARCHITECTURE', architecture):
                before = cli.source_fingerprint()
                (architecture / 'workspace.json').write_text('Native viewer cache')
                (architecture / '.structurizr').mkdir()
                (architecture / '.structurizr/structurizr.log').write_text('Native viewer log')
                self.assertEqual(before, cli.source_fingerprint())
                (architecture / 'workspace.dsl').write_text('Changed DSL')
                self.assertNotEqual(before, cli.source_fingerprint())

    def test_failed_validation_preserves_previous_json(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            destination = Path(temporary)
            (destination / 'workspace.json').write_text('previous-success')
            with patch.object(cli, 'output_directory', return_value=destination), \
                 patch.object(cli, 'run_java', side_effect=RuntimeError('parser failed')):
                reports = cli.validate([REFERENCE])
            self.assertFalse(reports[REFERENCE]['passed'])
            self.assertEqual('previous-success', (destination / 'workspace.json').read_text())
            self.assertFalse(json.loads((destination / 'validation.json').read_text())['passed'])

    def test_native_validation_failure_prevents_publication(self):
        run_native = cli.run_java
        commands = []
        def reject_native_validation(arguments, logs, **kwargs):
            commands.append(arguments[0])
            if arguments[0] == 'validate':
                raise RuntimeError('native validation rejected fixture')
            return run_native(arguments, logs, **kwargs)
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            destination = Path(temporary)
            (destination / 'workspace.json').write_text('previous-success')
            with patch.object(cli, 'output_directory', return_value=destination), \
                 patch.object(cli, 'run_java', side_effect=reject_native_validation):
                reports = cli.validate([REFERENCE])
            self.assertEqual(['export', 'validate'], commands)
            self.assertFalse(reports[REFERENCE]['passed'])
            self.assertIn('native validation rejected fixture', reports[REFERENCE]['errors'][0])
            self.assertEqual('previous-success', (destination / 'workspace.json').read_text())

    def test_failed_export_preserves_previous_files(self):
        for format, filename in (('mermaid', 'structurizr-old.mmd'), ('plantuml', 'structurizr-old.puml'),
                                 ('svg', 'old.svg'), ('png', 'old.png')):
            with self.subTest(format=format), tempfile.TemporaryDirectory(dir=BUILD) as temporary:
                directory = Path(temporary)
                destination = directory / 'exports/all' / format
                destination.mkdir(parents=True)
                (destination / filename).write_text('old')
                with patch.object(cli, 'output_directory', return_value=directory), \
                     patch.object(cli, 'fresh_workspace', return_value=({'views': {}}, {'source_sha256': 'fixture'})), \
                     patch.object(cli, 'run_java', side_effect=RuntimeError('export failed')):
                    with self.assertRaisesRegex(RuntimeError, 'export failed'):
                        cli.export(REFERENCE, format)
                self.assertEqual('old', (destination / filename).read_text())

    def test_command_lock_blocks_a_second_process(self):
        with cli.command_lock():
            command = [sys.executable, '-B', '-c', "from architecture import command_lock;\nwith command_lock(): print('unexpected')"]
            result = subprocess.run(command, cwd=ARCHITECTURE / 'scripts', capture_output=True, text=True)
            self.assertNotEqual(0, result.returncode)
            self.assertIn('Another architecture command', result.stderr)
        with cli.command_lock():
            pass

    def test_export_replaces_removed_files_only_after_success(self):
        for format, filename in (('mermaid', 'structurizr-one.mmd'), ('plantuml', 'structurizr-one.puml'),
                                 ('svg', 'one.svg'), ('png', 'one.png')):
            with self.subTest(format=format), tempfile.TemporaryDirectory(dir=BUILD) as temporary:
                directory = Path(temporary)
                destination = directory / 'exports/all' / format
                destination.mkdir(parents=True)
                (destination / 'removed-file').write_text('old')
                other_format = 'svg' if format == 'mermaid' else 'mermaid'
                preserved = [directory / 'exports/all' / other_format / 'keep',
                             directory / 'exports/view-other' / format / 'keep']
                for path in preserved:
                    path.parent.mkdir(parents=True)
                    path.write_text('preserve')
                raw = {'views': {'systemContextViews': [{'key': 'one'}]}}
                def export_diagram(arguments, logs, **kwargs):
                    output = Path(arguments[arguments.index('-output') + 1])
                    output.mkdir()
                    (output / filename).write_text('native output')
                with patch.object(cli, 'output_directory', return_value=directory), \
                     patch.object(cli, 'fresh_workspace', return_value=(raw, {'source_sha256': 'fixture'})), \
                     patch.object(cli, 'source_fingerprint', return_value='fixture'), \
                     patch.object(cli, 'run_java', side_effect=export_diagram):
                    cli.export(REFERENCE, format)
                self.assertEqual({filename, 'export.json'}, {p.name for p in destination.iterdir()})
                for path in preserved:
                    self.assertEqual('preserve', path.read_text())

    def test_legend_cannot_mask_a_missing_diagram(self):
        for format, prefix, extension in (('svg', '', 'svg'), ('plantuml', 'structurizr-', 'puml')):
            with self.subTest(format=format), tempfile.TemporaryDirectory(dir=BUILD) as temporary:
                raw = {'views': {'systemContextViews': [{'key': 'one'}, {'key': 'two'}]}}
                def export_diagram(arguments, logs, **kwargs):
                    output = Path(arguments[arguments.index('-output') + 1])
                    output.mkdir()
                    (output / f'{prefix}one.{extension}').write_text('native output')
                    (output / f'{prefix}one-key.{extension}').write_text('native legend')
                with patch.object(cli, 'output_directory', return_value=Path(temporary)), \
                     patch.object(cli, 'fresh_workspace', return_value=(raw, {'source_sha256': 'fixture'})), \
                     patch.object(cli, 'run_java', side_effect=export_diagram):
                    with self.assertRaisesRegex(ValueError, 'every requested diagram'):
                        cli.export(REFERENCE, format)


if __name__ == '__main__':
    unittest.main()
