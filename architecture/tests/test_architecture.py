"""Container-only regressions for native commands and artifact safety."""
from contextlib import contextmanager, ExitStack
from copy import deepcopy
import json
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
        with self.assertRaisesRegex(ValueError, 'exactly one'):
            cli.select_view(raw, 'missing')

    def test_export_paths_cannot_escape_output_directory(self):
        with self.assertRaisesRegex(ValueError, 'safe file names'):
            cli.select_view({'views': {'systemContextViews': [{'key': '../escape'}]}}, None)


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
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            directory = Path(temporary)
            destination = directory / 'exports/all/svg'
            destination.mkdir(parents=True)
            (destination / 'old.svg').write_text('old')
            with patch.object(cli, 'output_directory', return_value=directory), \
                 patch.object(cli, 'fresh_workspace', return_value=({'views': {}}, {'source_sha256': 'fixture'})), \
                 patch.object(cli, 'run_java', side_effect=RuntimeError('render failed')):
                with self.assertRaisesRegex(RuntimeError, 'render failed'):
                    cli.export(REFERENCE, 'svg')
            self.assertEqual('old', (destination / 'old.svg').read_text())

    def test_command_lock_blocks_a_second_process(self):
        with cli.command_lock():
            command = [sys.executable, '-B', '-c', "from architecture import command_lock;\nwith command_lock(): print('unexpected')"]
            result = subprocess.run(command, cwd=ARCHITECTURE / 'scripts', capture_output=True, text=True)
            self.assertNotEqual(0, result.returncode)
            self.assertIn('Another architecture command', result.stderr)
        with cli.command_lock():
            pass

    def test_export_replaces_removed_files_only_after_success(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            directory = Path(temporary)
            destination = directory / 'exports/all/svg'
            destination.mkdir(parents=True)
            (destination / 'removed.svg').write_text('old')
            raw = {'views': {'systemContextViews': [{'key': 'one'}]}}
            def render(arguments, logs, **kwargs):
                output = Path(arguments[arguments.index('-output') + 1])
                output.mkdir()
                (output / 'one.svg').write_text('<svg/>')
            with patch.object(cli, 'output_directory', return_value=directory), \
                 patch.object(cli, 'fresh_workspace', return_value=(raw, {'source_sha256': 'fixture'})), \
                 patch.object(cli, 'source_fingerprint', return_value='fixture'), \
                 patch.object(cli, 'run_java', side_effect=render):
                cli.export(REFERENCE, 'svg')
            self.assertFalse((destination / 'removed.svg').exists())
            self.assertTrue((destination / 'one.svg').exists())

    def test_legend_cannot_mask_a_missing_diagram(self):
        with tempfile.TemporaryDirectory(dir=BUILD) as temporary:
            raw = {'views': {'systemContextViews': [{'key': 'one'}, {'key': 'two'}]}}
            def render(arguments, logs, **kwargs):
                output = Path(arguments[arguments.index('-output') + 1])
                output.mkdir()
                (output / 'one.svg').write_text('<svg/>')
                (output / 'one-key.svg').write_text('<svg/>')
            with patch.object(cli, 'output_directory', return_value=Path(temporary)), \
                 patch.object(cli, 'fresh_workspace', return_value=(raw, {'source_sha256': 'fixture'})), \
                 patch.object(cli, 'run_java', side_effect=render):
                with self.assertRaisesRegex(ValueError, 'every requested diagram'):
                    cli.export(REFERENCE, 'svg')


if __name__ == '__main__':
    unittest.main()
