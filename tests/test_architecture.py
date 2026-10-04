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
import artifact_store as store
from workspace_paths import ROOT, BUILD, REFERENCE


@contextmanager
def checkout():
    with tempfile.TemporaryDirectory() as temporary, ExitStack() as stack:
        root = Path(temporary)
        architecture = root
        (root / 'README.md').write_text('[Draft](missing.md)')
        values = dict(ROOT=root, BUILD=root / 'build',
                      REFERENCE=architecture / 'workspace.dsl')
        for module in (cli, paths):
            for name, value in values.items():
                stack.enter_context(patch.object(module, name, value))
        yield architecture


def contents(directory):
    return {path.name: path.read_bytes() for path in directory.iterdir()}


def native_output(files):
    def run(arguments, logs, **kwargs):
        output = Path(arguments[arguments.index('-output') + 1])
        output.mkdir()
        for name, content in files.items():
            (output / name).write_text(content)
    return run


@contextmanager
def export_fixture(keys=('one',)):
    with checkout():
        paths.REFERENCE.write_text(BASE)
        directory = paths.output_directory(paths.REFERENCE)
        directory.mkdir(parents=True)
        destination = cli.BUILD / 'source/diagrams'
        destination.mkdir(parents=True)
        (destination / 'previous-output.puml').write_text('previous success')
        item = cli.artifact(Path('source/diagrams/previous-output.puml'), paths.REFERENCE,
            paths.REFERENCE, 'plantuml', 'fixture', 'one', kind='c4', renderer='plantuml', dependencies=[])
        cli.atomic_json(cli.BUILD / 'source.json', {'schema_version': 2, 'artifacts': [item]})
        raw = {'views': {'systemContextViews': [{'key': key} for key in keys]}}
        cli.atomic_json(directory / 'workspace.json', raw)
        cli.atomic_json(directory / 'validation.json', {'passed': True})
        (directory / 'validation.log').write_text('valid')
        report = {'passed': True, 'source_sha256': 'fixture', 'inspection_findings': [], 'workspace': 'workspace.dsl'}
        mapping = {key: (paths.REFERENCE, Path('diagrams') / key) for key in keys}
        with patch.object(cli, 'validate', return_value={paths.REFERENCE: report}), \
             patch.object(cli, 'index_views', return_value=mapping), \
             patch.object(cli, 'source_fingerprint', return_value='fixture'):
            yield directory, destination


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
            first = architecture / 'workspaces/TeamA/workspace.dsl'
            cross = architecture / 'workspaces/TeamB/experiment/workspace.dsl'
            variant = architecture / 'workspaces/TeamB/variants/target/workspace.dsl'
            for path in (first, cross, variant):
                path.parent.mkdir(parents=True, exist_ok=True)
            first.write_text(BASE)
            paths.REFERENCE.write_text('workspace extends workspaces/TeamA/workspace.dsl {\n}')
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
            initiative = architecture / 'workspaces/example/workspace.dsl'
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
        with checkout() as root, patch.dict(os.environ, {'PLAYWRIGHT_BROWSERS_PATH': '/nonexistent'}):
            paths.REFERENCE.write_text('Invalid unrelated DSL')
            workspace = root / 'workspaces/example/workspace.dsl'
            workspace.parent.mkdir(parents=True)
            workspace.write_text(BASE)
            arguments = ['architecture.py', 'build-source', '--workspace', str(workspace)]
            before = cli.source_fingerprint()
            with patch.object(sys, 'argv', arguments):
                self.assertEqual(0, cli.main())
            complete = cli.BUILD / 'source/workspaces/example'
            self.assertEqual({'unprefixed.puml', 'duplicate-selection.puml', 'flow.puml'},
                             {p.name for p in complete.iterdir()})
            for file in complete.glob('*.puml'):
                text = file.read_text()
                self.assertTrue(text.startswith('@startuml'))
                self.assertTrue(text.strip().endswith('@enduml'))
                self.assertIn('!include <C4/C4>', text)
                self.assertIn('System(A, "A"', text)
                self.assertIn('SHOW_LEGEND(true)', text)
            self.assertIn('Rel(A, B, "1: Calls"', (complete / 'flow.puml').read_text())
            self.assertNotIn('Calls', (complete / 'unprefixed.puml').read_text())
            previous = contents(complete)
            untouched = next(item for item in cli.inventory() if item['view'] == 'unprefixed')
            with patch.object(sys, 'argv', arguments + ['--view', 'flow']):
                self.assertEqual(0, cli.main())
            self.assertEqual(previous, contents(complete))
            self.assertEqual(untouched, next(item for item in cli.inventory() if item['view'] == 'unprefixed'))
            self.assertEqual(before, cli.source_fingerprint())
            self.assertFalse(paths.output_directory(paths.REFERENCE).exists())
            self.assertFalse((cli.BUILD / '.staging').exists())


class AuthoredSources(unittest.TestCase):
    def test_authored_mermaid_bytes_are_copied_without_syntax_validation(self):
        with checkout() as root:
            paths.REFERENCE.write_text(BASE)
            source = root / 'uml/sequence.mmd'
            source.parent.mkdir()
            source.write_bytes(b'---\nconfig: {}\n---\nsequenceDiagram\n%% canonical IDs\nA->>B: Call\n')
            cli.build_source()
            self.assertEqual(source.read_bytes(), (cli.BUILD / 'source/uml/sequence.mmd').read_bytes())
            self.assertEqual([source], [root / i['source'] for i in cli.inventory('source') if i['format'] == 'mermaid'])
            self.assertFalse((cli.BUILD / 'preview').exists())

    def test_nested_workspace_source_export_preserves_siblings(self):
        with checkout() as root:
            paths.REFERENCE.write_text('Invalid unrelated DSL')
            parent = root / 'workspaces/example/workspace.dsl'
            variant = root / 'workspaces/example/variants/target/workspace.dsl'
            variant.parent.mkdir(parents=True)
            parent.write_text(BASE)
            variant.write_text('workspace extends ../../workspace.dsl {\n}')
            for workspace in (parent, variant):
                cli.build_source([workspace])
            self.assertEqual(6, len(cli.inventory('source')))
            self.assertTrue((cli.BUILD / 'source/workspaces/example/flow.puml').exists())
            self.assertTrue((cli.BUILD / 'source/workspaces/example/variants/target/flow.puml').exists())

    def test_bad_selection_and_validation_failure_preserve_source(self):
        with checkout():
            paths.REFERENCE.write_text(BASE)
            cli.build_source()
            previous = contents(cli.BUILD / 'source')
            for key in ('missing', ''):
                with self.subTest(key=key), self.assertRaisesRegex(ValueError, 'exactly one'):
                    cli.build_source([paths.REFERENCE], [key])
            paths.REFERENCE.write_text('workspace {\n !include missing.dsl\n}')
            with self.assertRaisesRegex(ValueError, 'Validation failed'):
                cli.build_source()
            self.assertEqual(previous, contents(cli.BUILD / 'source'))


class FailureHandling(unittest.TestCase):
    def test_clean_build_preserves_lock_and_saved_layout_and_local_settings_outside_build(self):
        with checkout() as root:
            paths.REFERENCE.write_text('Authored DSL')
            saved = root / 'workspace.json'
            saved.write_text('Saved layout')
            settings = root / 'docker/local.env'
            settings.parent.mkdir()
            settings.write_text('LOCAL=1')
            with cli.command_lock():
                inode = (cli.BUILD / '.tools.lock').stat().st_ino
                for name in ('source/a.puml', 'preview/a.svg', '.layouts/old/workspace.json', 'unrelated/old.log'):
                    path = cli.BUILD / name
                    path.parent.mkdir(parents=True, exist_ok=True)
                    path.write_text('old')
                (cli.BUILD / 'local.env').write_text('old settings')
                with self.assertRaisesRegex(ValueError, 'Move build/local.env'):
                    cli.clean_build()
                (cli.BUILD / 'local.env').unlink()
                cli.clean_build()
                self.assertEqual({'.tools.lock'}, {p.name for p in cli.BUILD.iterdir()})
                self.assertEqual(inode, (cli.BUILD / '.tools.lock').stat().st_ino)
            self.assertEqual('Saved layout', saved.read_text())
            self.assertEqual('LOCAL=1', settings.read_text())
            self.assertEqual('Authored DSL', paths.REFERENCE.read_text())

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
        with checkout() as root:
            (root / 'workspace.dsl').write_text('Authored DSL')
            before = cli.source_fingerprint()
            (root / 'workspace.json').write_text('Native viewer cache')
            (root / '.structurizr').mkdir()
            (root / '.structurizr/structurizr.log').write_text('Native viewer log')
            self.assertEqual(before, cli.source_fingerprint())
            (root / 'workspace.dsl').write_text('Changed DSL')
            self.assertNotEqual(before, cli.source_fingerprint())

    def test_native_validation_failure_prevents_publication(self):
        run_native = cli.run_java
        commands = []
        def reject_native_validation(arguments, logs, **kwargs):
            commands.append(arguments[0])
            if arguments[0] == 'validate':
                raise RuntimeError('native validation rejected fixture')
            return run_native(arguments, logs, **kwargs)
        with tempfile.TemporaryDirectory() as temporary:
            destination = Path(temporary)
            (destination / 'workspace.json').write_text('previous-success')
            with patch.object(cli, 'output_directory', return_value=destination), \
                 patch.object(cli, 'run_java', side_effect=reject_native_validation):
                reports = cli.validate([REFERENCE])
            self.assertEqual(['export', 'validate'], commands)
            self.assertFalse(reports[REFERENCE]['passed'])
            self.assertIn('native validation rejected fixture', reports[REFERENCE]['errors'][0])
            self.assertEqual('previous-success', (destination / 'workspace.json').read_text())

    def test_command_lock_blocks_a_second_process(self):
        with checkout(), cli.command_lock():
            command = [sys.executable, '-B', '-c',
                       "import sys; from pathlib import Path; import architecture; "
                       "architecture.BUILD = Path(sys.argv[1]);\n"
                       "with architecture.command_lock(): print('unexpected')", str(cli.BUILD)]
            result = subprocess.run(command, cwd=ROOT / 'scripts', capture_output=True, text=True)
            self.assertNotEqual(0, result.returncode)
            self.assertIn('Another architecture command', result.stderr)
        with cli.command_lock():
            pass

    def test_atomic_json_failure_cleans_temporary_files_and_preserves_previous_report(self):
        for failure in ('serialization', 'write', 'replace'):
            with self.subTest(failure=failure), tempfile.TemporaryDirectory() as temporary, ExitStack() as stack:
                destination = Path(temporary) / 'report.json'
                destination.write_text('previous report')
                value = {'invalid': object()} if failure == 'serialization' else {'passed': True}
                if failure == 'write':
                    def partial_write(value, stream, **kwargs):
                        stream.write('{')
                        raise OSError('write failed')
                    stack.enter_context(patch.object(store.json, 'dump', side_effect=partial_write))
                elif failure == 'replace':
                    stack.enter_context(patch.object(store.os, 'replace', side_effect=OSError('replace failed')))
                with self.assertRaises((TypeError, OSError)):
                    cli.atomic_json(destination, value)
                self.assertEqual({'report.json': b'previous report'}, contents(destination.parent))


class ExportPublication(unittest.TestCase):
    def test_incomplete_output_preserves_previous_exports(self):
        for failure in ('missing', 'empty', 'wrong-name', 'legend-only'):
            with self.subTest(failure=failure), export_fixture(('one', 'two')) as (_, destination):
                before = contents(destination)
                files = {'structurizr-one.puml': 'native output'}
                if failure == 'empty': files['structurizr-two.puml'] = ''
                if failure == 'wrong-name': files['unexpected.puml'] = 'output'
                if failure == 'legend-only': files['structurizr-two-key.puml'] = 'legend'
                with patch.object(cli, 'run_java', side_effect=native_output(files)):
                    with self.assertRaisesRegex(ValueError, 'every requested diagram'):
                        cli.build_source()
                self.assertEqual(before, contents(destination))

    def test_failed_export_preserves_previous_files(self):
        with export_fixture() as (_, destination):
            before = contents(destination)
            with patch.object(cli, 'run_java', side_effect=RuntimeError('export failed')):
                with self.assertRaisesRegex(RuntimeError, 'export failed'):
                    cli.build_source()
            self.assertEqual(before, contents(destination))

    def test_sources_changed_during_export_preserves_previous_files(self):
        with export_fixture() as (_, destination):
            before = contents(destination)
            with patch.object(cli, 'source_fingerprint', return_value='changed'), \
                 patch.object(cli, 'run_java', side_effect=native_output({'structurizr-one.puml': 'new'})):
                with self.assertRaisesRegex(ValueError, 'Sources changed'):
                    cli.build_source()
            self.assertEqual(before, contents(destination))

    def test_success_replaces_obsolete_files_and_preserves_unmanaged_files(self):
        with export_fixture() as (_, destination):
            (destination / 'unmanaged.txt').write_text('preserve')
            with patch.object(cli, 'run_java', side_effect=native_output({'structurizr-one.puml': 'native output'})):
                cli.build_source()
            self.assertEqual({'one.puml', 'unmanaged.txt'}, {p.name for p in destination.iterdir()})

    def test_publication_failure_restores_previous_export(self):
        rename = Path.rename
        def fail_publication(path, target):
            if path.name == 'source.json':
                raise OSError('publication failed')
            return rename(path, target)
        with export_fixture() as (_, destination):
            before = contents(destination)
            with patch.object(cli, 'run_java', side_effect=native_output({'structurizr-one.puml': 'new'})), \
                 patch.object(Path, 'rename', fail_publication):
                with self.assertRaisesRegex(OSError, 'publication failed'):
                    cli.build_source()
            self.assertEqual(before, contents(destination))

    def test_timeout_logs_partial_output_and_preserves_previous_files(self):
        for stdout, stderr in ((b'partial output', b'partial error'), ('partial output', 'partial error'), (None, None)):
            with self.subTest(stdout=stdout), export_fixture() as (_, destination):
                before = contents(destination)
                timeout = subprocess.TimeoutExpired('java', 600, output=stdout, stderr=stderr)
                with patch.object(cli.subprocess, 'run', side_effect=timeout):
                    with self.assertRaises(subprocess.TimeoutExpired):
                        cli.build_source()
                log = (cli.BUILD / '.reports/source.log').read_text()
                self.assertIn('-format plantuml/c4plantuml', log)
                self.assertIn('Timed out after 600 seconds', log)
                if stdout:
                    self.assertIn('partial output', log)
                    self.assertIn('partial error', log)
                self.assertEqual(before, contents(destination))


if __name__ == '__main__':
    unittest.main()
