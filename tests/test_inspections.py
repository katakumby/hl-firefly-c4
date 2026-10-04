"""Quality findings are visible but do not gate generated diagrams."""
from contextlib import redirect_stdout
import io
import json
from pathlib import Path
import subprocess
import unittest
from unittest.mock import patch

from test_architecture import checkout, BASE
from test_output_layout import quick_render
import architecture as cli
import workspace_paths as paths


class InspectionPolicy(unittest.TestCase):
    def test_report_only_validation_preserves_findings_without_failing(self):
        with checkout():
            for severity in ('error', 'warning'):
                with self.subTest(severity=severity):
                    paths.REFERENCE.write_text(BASE.replace('"info"', f'"{severity}"'))
                    output = io.StringIO()
                    with redirect_stdout(output):
                        report = cli.validate(inspections_blocking=False)[paths.REFERENCE]
                    self.assertTrue(report['passed'], report)
                    self.assertFalse(report['inspection_passed'])
                    self.assertEqual('report-only', report['inspection_policy'])
                    self.assertTrue(report['inspection_findings'])
                    self.assertTrue(all(f['severity'] == severity.upper() for f in report['inspection_findings']))
                    self.assertIn('inspection findings; report-only', output.getvalue())
                    self.assertIn('model.container.technology', output.getvalue())
                    self.assertTrue((paths.output_directory(paths.REFERENCE) / 'workspace.json').is_file())
                    self.assertFalse(cli.validate()[paths.REFERENCE]['passed'])

    @patch.object(cli, 'render', side_effect=quick_render)
    def test_build_and_export_succeed_and_record_quality_findings(self, _):
        with checkout():
            paths.REFERENCE.write_text(BASE.replace('"info"', '"error"'))
            cli.build()
            status = json.loads((cli.BUILD / 'build.json').read_text())
            self.assertTrue(status['passed'])
            findings = status['inspection_findings']
            self.assertTrue(findings)
            self.assertEqual({'workspace.dsl'}, {f['workspace'] for f in findings})
            self.assertIn(findings[0]['message'], (cli.BUILD / 'build.log').read_text())
            self.assertTrue((cli.BUILD / 'flow.svg').is_file())
            cli.export(paths.REFERENCE, 'plantuml', 'flow')
            exported = json.loads((paths.output_directory(paths.REFERENCE) / 'export-status.json').read_text())
            self.assertTrue(exported['passed'])
            self.assertTrue(exported['inspection_findings'])
            self.assertTrue((cli.BUILD / 'flow.puml').is_file())

    def test_malformed_dsl_still_blocks_build_and_preserves_previous_files(self):
        with checkout():
            paths.REFERENCE.write_text('workspace {\n !include missing.dsl\n}')
            cli.BUILD.mkdir()
            previous = cli.BUILD / 'previous.svg'
            previous.write_text('previous success')
            with self.assertRaisesRegex(ValueError, 'Validation failed'):
                cli.build()
            self.assertEqual('previous success', previous.read_text())
            status = json.loads((cli.BUILD / 'build.json').read_text())
            self.assertFalse(status['passed'])
            self.assertEqual([], status['outputs'])

    def test_inspector_crashes_and_timeouts_are_not_quality_findings(self):
        with checkout():
            paths.REFERENCE.write_text(BASE)
            run_java = cli.run_java
            for failure in ('crash', 'timeout'):
                def fail_inspect(arguments, logs, **kwargs):
                    if arguments[0] == 'inspect':
                        if failure == 'timeout':
                            raise subprocess.TimeoutExpired('inspect', 240)
                        logs.append('Inspector crashed')
                        return subprocess.CompletedProcess([], 1, '', 'Unexpected Java failure')
                    return run_java(arguments, logs, **kwargs)
                with self.subTest(failure=failure), patch.object(cli, 'run_java', side_effect=fail_inspect):
                    report = cli.validate(inspections_blocking=False)[paths.REFERENCE]
                self.assertFalse(report['passed'])
                self.assertIsNone(report['inspection_passed'])
                self.assertTrue(report['errors'])

    def test_findings_do_not_hide_an_unexpected_inspector_exit(self):
        finding = 'WARNING | model.example | Example finding\n'
        for code, stdout, stderr in [(2, finding, ''), (1, finding, 'Java failure'),
                                     (1, finding + 'Unexpected failure\n', '')]:
            result = subprocess.CompletedProcess([], code, stdout, stderr)
            with self.subTest(code=code, stderr=stderr), patch.object(cli, 'run_java', return_value=result):
                with self.assertRaisesRegex(RuntimeError, 'Inspector execution failed'):
                    cli.inspect_workspace(Path('workspace.json'), ['diagnostic'])
        result = subprocess.CompletedProcess([], 0, finding * 256, '')
        with patch.object(cli, 'run_java', return_value=result):
            self.assertEqual(256, len(cli.inspect_workspace(Path('workspace.json'), [])))


if __name__ == '__main__':
    unittest.main()
