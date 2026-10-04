"""Two-image capabilities, portable handoffs and scoped browser publication."""
from copy import deepcopy
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from test_architecture import checkout, BASE
from test_output_layout import quick_render
import architecture as cli
import ci_artifacts as packages
import diagram_renderers as renderers


def seed(root):
    (root / 'workspace.dsl').write_text(BASE)
    for name, text in [('uml/nested/sequence.puml', '@startuml\nA -> B: Request\n@enduml'),
                       ('workspaces/team/uml/nested/flow.mmd', 'sequenceDiagram\nA->>B: Request\n')]:
        file = root / name
        file.parent.mkdir(parents=True, exist_ok=True)
        file.write_text(text)


def content():
    return {item['output']: (cli.BUILD / item['output']).read_bytes() for item in cli.inventory()}


class Stages(unittest.TestCase):
    def test_installed_capabilities_and_browser_free_runtime(self):
        versions = renderers.renderer_versions()
        self.assertIn('plantuml', versions['capabilities'])
        if versions['profile'] == 'light':
            self.assertIsNone(shutil.which('node'))
            self.assertFalse(Path('/ms-playwright').exists())
            self.assertFalse(Path('/opt/renderers/node_modules').exists())
            with self.assertRaisesRegex(ValueError, 'tools-browser'):
                cli.export_batch([], 'svg', native=True)
        else:
            self.assertTrue(Path('/opt/renderers/puppeteer.json').is_file())
            self.assertTrue(renderers.has_capability('native'))
        with patch.object(renderers, 'has_capability', return_value=False), checkout():
            with self.assertRaisesRegex(ValueError, 'tools-browser'):
                cli.build_browser()
            self.assertFalse(json.loads((cli.BUILD / 'build.json').read_text())['passed'])

    @patch.object(cli, 'render', side_effect=quick_render)
    def test_portable_package_and_completion_never_repeat_light_generation(self, _):
        with checkout() as root:
            seed(root)
            cli.build()
            light = deepcopy(cli.inventory())
            self.assertEqual(8, len([p for p in light if p['format'] in ('svg', 'png')]))
            self.assertFalse(json.loads((cli.BUILD / 'build.json').read_text())['complete'])
            snapshot = cli.BUILD / '.layouts/workspace.dsl/workspace.json'
            snapshot.parent.mkdir(parents=True)
            snapshot.write_text('local-only')
            package = root / 'handoff'
            package.mkdir()
            with patch.object(packages, 'BUILD', cli.BUILD):
                packages.package(package)
            self.assertFalse((package / '.layouts').exists())
            self.assertEqual(light, json.loads((package / 'artifacts.json').read_text())['artifacts'])
            with checkout() as relocated:
                seed(relocated)
                shutil.copytree(package, cli.BUILD)
                # Ad-hoc exports/validation can replace the latest reports without
                # invalidating the light stage's frozen workspace evidence.
                live = cli.BUILD / '.reports/workspace.dsl/validation.json'
                live.parent.mkdir(parents=True)
                live.write_text('{"latest": "unrelated export attempt"}')
                with patch.object(cli, 'require_capability'), patch.object(cli, 'stage_c4', side_effect=AssertionError('C4 repeated')), \
                     patch.object(cli, 'validate', side_effect=AssertionError('DSL reparsed')):
                    cli.build_browser()
                self.assertEqual(light, [p for p in cli.inventory() if not cli.browser_artifact(p)])
                self.assertTrue(json.loads((cli.BUILD / 'build.json').read_text())['complete'])
                output = relocated / 'full'
                output.mkdir()
                with patch.object(packages, 'BUILD', cli.BUILD):
                    packages.package(output, stage='full')
                self.assertTrue((output / 'workspaces/team/uml/nested/flow.svg').is_file())
                self.assertEqual(len(cli.inventory()), len(json.loads((output / 'artifacts.json').read_text())['artifacts']))

    @patch.object(cli, 'render', side_effect=quick_render)
    @patch.dict(os.environ, ARCHITECTURE_SOURCE_REVISION='commit-a')
    def test_handoff_rejections_before_rendering(self, _):
        with checkout() as root, patch.object(cli, 'require_capability'):
            seed(root)
            with self.assertRaisesRegex(ValueError, 'Missing lightweight'):
                cli.build_browser()
            with patch.dict(os.environ, ARCHITECTURE_SOURCE_REVISION='commit-a'):
                cli.build()
                with patch.dict(os.environ, ARCHITECTURE_SOURCE_REVISION='commit-b'), self.assertRaisesRegex(ValueError, 'different commit'):
                    cli.build_browser()
            report = cli.BUILD / '.reports/build-light.json'
            original = report.read_bytes()
            for mutation in ('failed', 'version', 'toolchain', 'deferred', 'shape', 'reports'):
                data = json.loads(original)
                if mutation == 'failed': data['passed'] = False
                if mutation == 'version': data['handoff_version'] = 99
                if mutation == 'toolchain': data['toolchain'] = {}
                if mutation == 'deferred': data['deferred'] = []
                if mutation == 'shape': data.pop('deferred')
                if mutation == 'reports': data.pop('reports')
                report.write_text(json.dumps(data))
                with patch.object(cli, 'render') as renderer, self.subTest(mutation=mutation), self.assertRaises(ValueError):
                    cli.build_browser()
                renderer.assert_not_called()
            report.write_bytes(original)
            target = cli.BUILD / cli.inventory()[0]['output']
            previous = target.read_bytes()
            for value in (None, b'corrupt'):
                if value is None: target.unlink()
                else: target.write_bytes(value)
                with self.assertRaisesRegex(ValueError, 'missing or modified'):
                    cli.build_browser()
                target.write_bytes(previous)
            (root / 'workspace.dsl').write_text(BASE + '\n// source changed')
            with self.assertRaisesRegex(ValueError, 'stale'):
                cli.build_browser()

    @patch.object(cli, 'render', side_effect=quick_render)
    def test_deferred_outputs_preserved_then_pruned_only_after_browser_success(self, _):
        with checkout() as root, patch.object(cli, 'require_capability'):
            seed(root)
            cli.build()
            cli.build_browser()
            browser = [item for item in cli.inventory() if cli.browser_artifact(item)]
            old = root / 'workspaces/team/uml/nested/flow.mmd'
            moved = old.with_name('renamed.mmd')
            old.rename(moved)
            cli.build()
            self.assertEqual(browser, [item for item in cli.inventory() if cli.browser_artifact(item)])
            before = content()
            with patch.object(cli, 'render', side_effect=RuntimeError('Mermaid failed')), self.assertRaises(RuntimeError):
                cli.build_browser()
            self.assertEqual(before, content())
            with patch.object(packages, 'BUILD', cli.BUILD):
                output = root / 'failed-package'
                output.mkdir()
                with self.assertRaisesRegex(ValueError, 'incomplete or stale'):
                    packages.package(output, stage='full')
            cli.build_browser()
            self.assertFalse((cli.BUILD / 'workspaces/team/uml/nested/flow.svg').exists())
            paths = set(content())
            cli.build_browser()
            self.assertEqual(paths, set(content()))
            moved.unlink()
            cli.build()
            cli.build_browser()
            self.assertFalse(any(cli.browser_artifact(item) for item in cli.inventory()))
            self.assertFalse((cli.BUILD / '.staging').exists())

    @patch.object(cli, 'render', side_effect=quick_render)
    def test_browser_publication_failure_restores_every_file(self, _):
        with checkout() as root, patch.object(cli, 'require_capability'):
            seed(root)
            cli.build()
            cli.build_browser()
            before = content()
            inventory = (cli.BUILD / 'artifacts.json').read_bytes()
            rename = Path.rename
            def reject_inventory(source, target):
                if source.name == 'artifacts.json': raise OSError('cannot publish inventory')
                return rename(source, target)
            with patch.object(Path, 'rename', reject_inventory), self.assertRaises(OSError):
                cli.build_browser()
            self.assertEqual(before, content())
            self.assertEqual(inventory, (cli.BUILD / 'artifacts.json').read_bytes())
            self.assertFalse(json.loads((cli.BUILD / 'build.json').read_text())['complete'])

    @patch.object(cli, 'render', side_effect=quick_render)
    def test_mermaid_to_plantuml_transition_and_cross_format_collision(self, _):
        with checkout() as root, patch.object(cli, 'require_capability'):
            seed(root)
            cli.build()
            cli.build_browser()
            source = root / 'workspaces/team/uml/nested/flow.mmd'
            source.with_suffix('.puml').write_text('@startuml\nA -> B\n@enduml')
            before = content()
            with self.assertRaisesRegex(ValueError, 'collision'):
                cli.build()
            self.assertEqual(before, content())
            source.unlink()
            cli.build()
            self.assertFalse(any(cli.browser_artifact(item) for item in cli.inventory()))
            cli.build_browser()  # Empty browser stage is a verified successful no-op.


class Wrapper(unittest.TestCase):
    def test_image_selection_and_missing_image_do_not_fall_back(self):
        with tempfile.TemporaryDirectory() as temporary:
            binary = Path(temporary) / 'docker'
            binary.write_text('#!/bin/sh\nif [ "$1" = image ]; then exit "${MISSING_IMAGE:-0}"; fi\nprintf "%s\\n" "$@"\n')
            binary.chmod(0o755)
            env = os.environ | {'PATH': temporary + ':' + os.environ['PATH'], 'ARCHITECTURE_UID': '1000',
                'ARCHITECTURE_TOOLS_IMAGE': 'dlt-architecture-tools-light',
                'ARCHITECTURE_BROWSER_IMAGE': 'dlt-architecture-tools-browser'}
            for args, image in [(['build'], 'light'), (['build-browser'], 'browser'),
                                (['export-native'], 'browser'), (['--browser', 'test'], 'browser')]:
                result = subprocess.run([str(cli.ROOT / 'docker/run.sh'), *args], env=env, text=True, capture_output=True)
                self.assertEqual(0, result.returncode, result.stderr)
                self.assertIn('dlt-architecture-tools-' + image + '\n', result.stdout)
                self.assertIn('--network\nnone', result.stdout)
                self.assertNotIn('--build', result.stdout)
            result = subprocess.run([str(cli.ROOT / 'docker/run.sh'), 'build-browser'],
                env=env | {'MISSING_IMAGE': '1'}, text=True, capture_output=True)
            self.assertNotEqual(0, result.returncode)
            self.assertIn('not loaded', result.stderr)
            self.assertEqual('', result.stdout)


@unittest.skipUnless(renderers.has_capability('native'), 'Provider JavaScript fixtures run in tools-browser')
class ProviderSelection(unittest.TestCase):
    def test_github_exact_commit_success_expiry_and_pagination(self):
        script = r'''
const assert = require('node:assert/strict');
const select = require('/workspace/ci/select-light-run.cjs');
const request = {owner:'org',repo:'repo',workflow_id:'architecture.yaml',sha:'abc',branch:'main'};
const base = {head_sha:'abc',head_branch:'main',status:'completed',conclusion:'success',event:'push',run_attempt:1};
const runs = [{...base,id:1,run_number:1}, {...base,id:2,run_number:2},
 {...base,id:3,run_number:3,head_sha:'other'}, {...base,id:4,run_number:4,conclusion:'failure'},
 {...base,id:5,run_number:5,head_branch:'other'}, {...base,id:6,run_number:6,event:'schedule'}];
const artifacts = {1:[{id:101,name:'architecture-light',expired:false}],
 2:[{id:102,name:'architecture-light',expired:true}]};
const api = {rest:{actions:{listWorkflowRuns:'runs',listWorkflowRunArtifacts:'artifacts'}},
 paginate:async (method,args) => method==='runs' ? runs : artifacts[args.run_id] || []};
(async () => {
 assert.deepEqual(await select(api,request), {run_id:1,artifact_id:101});
 artifacts[2][0].expired=false;
 assert.deepEqual(await select(api,request), {run_id:2,artifact_id:102});
 artifacts[2][0].expires_at='2000-01-01T00:00:00Z';
 assert.deepEqual(await select(api,request), {run_id:1,artifact_id:101});
 artifacts[1]=[];
 await assert.rejects(select(api,request), /Run the light job/);
})().catch(error => {console.error(error); process.exitCode=1;});
'''
        result = subprocess.run(['node', '-e', script], capture_output=True, text=True)
        self.assertEqual(0, result.returncode, result.stderr)
