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
                cli.export_native([], 'svg')
        else:
            self.assertTrue(Path('/opt/renderers/puppeteer.json').is_file())
        with patch.object(renderers, 'has_capability', return_value=False), checkout():
            with self.assertRaisesRegex(ValueError, 'tools-browser'):
                cli.build_preview('mermaid')
            self.assertFalse(json.loads((cli.BUILD / '.reports/preview-mermaid.json').read_text())['passed'])

    @patch.object(cli, 'render', side_effect=quick_render)
    def test_portable_package_and_independent_previews_never_repeat_source_generation(self, _):
        for order in [('mermaid', 'plantuml'), ('plantuml', 'mermaid')]:
            with self.subTest(order=order), checkout() as root:
                seed(root)
                cli.build_source()
                sources = deepcopy(cli.inventory('source'))
                self.assertEqual(5, len(sources))
                self.assertFalse((cli.BUILD / 'preview').exists())
                package = root / 'handoff'
                package.mkdir()
                packages.package(package)
                self.assertFalse((package / 'preview').exists())
                self.assertFalse((package / '.tools.lock').exists())
                with checkout() as relocated:
                    seed(relocated)
                    shutil.copytree(package, cli.BUILD)
                    source_bytes = {p.relative_to(cli.BUILD): p.read_bytes() for p in cli.BUILD.rglob('*') if p.is_file()}
                    # Ordinary validation does not replace frozen handoff reports.
                    live = cli.BUILD / '.reports/workspace.dsl/validation.json'
                    live.parent.mkdir(parents=True)
                    live.write_text('{"latest": "unrelated attempt"}')
                    with patch.object(cli, 'require_capability'), patch.object(cli, 'stage_c4', side_effect=AssertionError('C4 repeated')), \
                         patch.object(cli, 'validate', side_effect=AssertionError('DSL reparsed')):
                        for renderer in order:
                            cli.build_preview(renderer)
                    self.assertEqual(sources, cli.inventory('source'))
                    for name, value in source_bytes.items():
                        self.assertEqual(value, (cli.BUILD / name).read_bytes(), name)
                    self.assertEqual(10, len(cli.inventory('preview-plantuml') + cli.inventory('preview-mermaid')))
                    for renderer in order:
                        output = relocated / ('package-' + renderer)
                        output.mkdir()
                        packages.package(output, stage='preview', renderer=renderer)
                        self.assertTrue((output / ('preview-' + renderer + '.json')).exists())
                        self.assertFalse((output / 'source').exists())

    @patch.object(cli, 'render', side_effect=quick_render)
    @patch.dict(os.environ, ARCHITECTURE_SOURCE_REVISION='commit-a')
    def test_handoff_rejections_before_rendering(self, _):
        with checkout() as root, patch.object(cli, 'require_capability'):
            seed(root)
            with self.assertRaisesRegex(ValueError, 'Missing source'):
                cli.build_preview('mermaid')
            cli.build_source()
            with patch.dict(os.environ, ARCHITECTURE_SOURCE_REVISION='commit-b'), self.assertRaisesRegex(ValueError, 'different commit'):
                cli.build_preview('mermaid')
            report = cli.BUILD / '.reports/source.json'
            original = report.read_bytes()
            for mutation in ('failed', 'version', 'toolchain', 'renderers', 'outputs', 'shape', 'reports'):
                data = json.loads(original)
                if mutation == 'failed': data['passed'] = False
                if mutation == 'version': data['handoff_version'] = 99
                if mutation == 'toolchain': data['toolchain'] = {}
                if mutation == 'renderers': data['renderers'] = {}
                if mutation == 'outputs': data['outputs'] = []
                if mutation == 'shape': data.pop('artifacts')
                if mutation == 'reports': data.pop('reports')
                report.write_text(json.dumps(data))
                with patch.object(cli, 'render') as renderer, self.subTest(mutation=mutation), self.assertRaises(ValueError):
                    cli.build_preview('mermaid')
                renderer.assert_not_called()
            report.write_bytes(original)
            target = cli.BUILD / cli.inventory('source')[0]['output']
            previous = target.read_bytes()
            for value in (None, b'corrupt'):
                if value is None: target.unlink()
                else: target.write_bytes(value)
                with self.assertRaisesRegex(ValueError, 'missing or modified'):
                    cli.build_preview('mermaid')
                target.write_bytes(previous)
            (root / 'workspace.dsl').write_text(BASE + '\n// source changed')
            with self.assertRaisesRegex(ValueError, 'stale'):
                cli.build_preview('mermaid')

    @patch.object(cli, 'render', side_effect=quick_render)
    def test_sources_preserve_previews_then_renderer_prunes_only_after_success(self, _):
        with checkout() as root, patch.object(cli, 'require_capability'):
            seed(root)
            cli.build_source()
            cli.build_preview('mermaid')
            old_inventory = deepcopy(cli.inventory('preview-mermaid'))
            old = root / 'workspaces/team/uml/nested/flow.mmd'
            moved = old.with_name('renamed.mmd')
            old.rename(moved)
            cli.build_source()
            self.assertEqual(old_inventory, cli.inventory('preview-mermaid'))
            before = content()
            with patch.object(cli, 'render', side_effect=RuntimeError('Mermaid failed')), self.assertRaises(RuntimeError):
                cli.build_preview('mermaid')
            self.assertEqual(before, content())
            output = root / 'failed-package'
            output.mkdir()
            with self.assertRaisesRegex(ValueError, 'incomplete or stale'):
                packages.package(output, stage='preview', renderer='mermaid')
            cli.build_preview('mermaid')
            self.assertFalse((cli.BUILD / 'preview/workspaces/team/uml/nested/flow.svg').exists())
            before = content()
            inventory = (cli.BUILD / 'preview-mermaid.json').read_bytes()
            cli.build_preview('mermaid')
            self.assertEqual(before, content())
            self.assertEqual(inventory, (cli.BUILD / 'preview-mermaid.json').read_bytes())
            moved.unlink()
            cli.build_source()
            cli.build_preview('mermaid')
            self.assertEqual([], cli.inventory('preview-mermaid'))
            self.assertFalse((cli.BUILD / '.staging').exists())

    @patch.object(cli, 'render', side_effect=quick_render)
    def test_preview_publication_failure_restores_every_file(self, _):
        with checkout() as root, patch.object(cli, 'require_capability'):
            seed(root)
            cli.build_source()
            cli.build_preview('mermaid')
            before = content()
            inventory = (cli.BUILD / 'preview-mermaid.json').read_bytes()
            rename = Path.rename
            def reject_inventory(source, target):
                if source.name == 'preview-mermaid.json': raise OSError('cannot publish inventory')
                return rename(source, target)
            with patch.object(Path, 'rename', reject_inventory), self.assertRaises(OSError):
                cli.build_preview('mermaid')
            self.assertEqual(before, content())
            self.assertEqual(inventory, (cli.BUILD / 'preview-mermaid.json').read_bytes())
            self.assertFalse(json.loads((cli.BUILD / '.reports/preview-mermaid.json').read_text())['passed'])

    @patch.object(cli, 'render', side_effect=quick_render)
    def test_format_transition_pruning_cannot_erase_new_owner(self, _):
        for old_format, new_format in [('mermaid', 'plantuml'), ('plantuml', 'mermaid')]:
            for order in [(old_format, new_format), (new_format, old_format)]:
                with self.subTest(order=order), checkout() as root, patch.object(cli, 'require_capability'):
                    (root / 'workspace.dsl').write_text(BASE)
                    source = root / ('uml/flow.' + ('mmd' if old_format == 'mermaid' else 'puml'))
                    source.parent.mkdir()
                    source.write_text('sequenceDiagram\nA->>B: Before' if old_format == 'mermaid' else '@startuml\nA -> B: Before\n@enduml')
                    cli.build_source()
                    cli.build_preview(old_format)
                    replacement = source.with_suffix('.mmd' if new_format == 'mermaid' else '.puml')
                    replacement.write_text('sequenceDiagram\nA->>B: After' if new_format == 'mermaid' else '@startuml\nA -> B: After\n@enduml')
                    with self.assertRaisesRegex(ValueError, 'collision'):
                        cli.build_source()
                    source.unlink()
                    cli.build_source()
                    for renderer in order:
                        cli.build_preview(renderer)
                    self.assertIn('After', (cli.BUILD / 'preview/uml/flow.svg').read_text())
                    self.assertFalse(any(i['source'].endswith('flow.' + source.suffix[1:]) for i in cli.inventory('preview-' + old_format)))

    @patch.object(cli, 'render', side_effect=quick_render)
    def test_selection_coverage_preflight_and_sibling_retention(self, _):
        with checkout() as root, patch.object(cli, 'require_capability'):
            seed(root)
            team = root / 'workspaces/team/workspace.dsl'
            team.write_text(BASE)
            cli.build_source([team], ['flow', 'flow'])
            self.assertEqual(['source/workspaces/team/flow.puml'], [i['output'] for i in cli.inventory('source')])
            with self.assertRaisesRegex(ValueError, 'only a selection'):
                cli.build_preview('plantuml')
            with self.assertRaisesRegex(ValueError, 'only selected views'):
                cli.build_preview('plantuml', [team])
            with self.assertRaisesRegex(ValueError, 'missing-one.*missing-two'):
                cli.build_preview('plantuml', [team], ['missing-one', 'missing-two'])
            cli.build_preview('plantuml', [team], ['flow'])
            cli.build_source()
            cli.build_preview('plantuml')
            before = {i['output']: (cli.BUILD / i['output']).read_bytes() for i in cli.inventory('preview-plantuml')}
            cli.build_preview('plantuml', [team], ['flow'])
            self.assertEqual(before, {name: (cli.BUILD / name).read_bytes() for name in before})
            with self.assertRaisesRegex(ValueError, 'do not have C4'):
                cli.build_preview('mermaid', [team], ['flow'])

    def test_portable_include_closure_is_copied_once_and_helpers_are_not_diagrams(self):
        with checkout() as root:
            (root / 'workspace.dsl').write_text(BASE)
            files = {'uml/nested/main.puml': '@startuml\n!include ../../shared/participants.puml\nA -> B\n@enduml',
                     'shared/participants.puml': '!include types.inc\nparticipant A\nparticipant B',
                     'shared/types.inc': 'skinparam monochrome true',
                     'uml/helpers.puml': 'participant C',
                     'uml/other.puml': '@startuml\n!include helpers.puml\nC -> C\n@enduml'}
            for name, text in files.items():
                path = root / name; path.parent.mkdir(parents=True, exist_ok=True); path.write_text(text)
            cli.build_source()
            for name in files:
                self.assertEqual((root / name).read_bytes(), (cli.BUILD / 'source' / name).read_bytes())
            self.assertEqual(3, len([i for i in cli.inventory('source') if i['kind'] == 'include']))
            cli.verify_source_handoff()
            def generated_only(source, output, logs):
                self.assertTrue(source.is_relative_to(cli.BUILD / 'source'))
                quick_render(source, output, logs)
            with patch.object(cli, 'render', side_effect=generated_only):
                cli.build_preview('plantuml')
            self.assertFalse((cli.BUILD / 'preview/uml/helpers.svg').exists())
            (root / 'shared/types.inc').write_text('changed include')
            with self.assertRaisesRegex(ValueError, 'stale'):
                cli.build_preview('plantuml')

    def test_selected_source_handoff_refreshes_renderable_include_dependencies(self):
        with checkout() as root:
            (root / 'workspace.dsl').write_text(BASE)
            helper = root / 'uml/library.puml'
            helper.parent.mkdir()
            helper.write_text('@startuml\n!startsub participants\nparticipant A\n!endsub\n@enduml')
            team = root / 'workspaces/team/workspace.dsl'
            team.parent.mkdir(parents=True)
            team.write_text(BASE)
            diagram = team.parent / 'uml/sequence.puml'
            diagram.parent.mkdir()
            diagram.write_text('@startuml\n!include ../../../uml/library.puml!participants\nA -> A\n@enduml')
            cli.build_source()
            helper.write_text(helper.read_text() + "\n' include updated\n")
            cli.build_source([team])
            report, _ = cli.verify_source_handoff()
            self.assertIn('source/uml/library.puml', report['outputs'])
            self.assertEqual(helper.read_bytes(), (cli.BUILD / 'source/uml/library.puml').read_bytes())

    def test_layout_and_local_settings_do_not_change_ordinary_freshness(self):
        with checkout() as root:
            seed(root)
            cli.build_source()
            before = cli.source_fingerprint()
            (root / 'workspace.json').write_text('{"saved":"new coordinates"}')
            (root / 'docker').mkdir()
            (root / 'docker/local.env').write_text('LOCAL=1')
            self.assertEqual(before, cli.source_fingerprint())
            cli.verify_source_handoff()


class Wrapper(unittest.TestCase):
    def test_image_selection_and_missing_image_do_not_fall_back(self):
        with tempfile.TemporaryDirectory() as temporary:
            binary = Path(temporary) / 'docker'
            binary.write_text('#!/bin/sh\nif [ "$1" = image ]; then exit "${MISSING_IMAGE:-0}"; fi\nprintf "%s\\n" "$@"\n')
            binary.chmod(0o755)
            env = os.environ | {'PATH': temporary + ':' + os.environ['PATH'], 'ARCHITECTURE_UID': '1000',
                'ARCHITECTURE_TOOLS_IMAGE': 'dlt-architecture-tools-light',
                'ARCHITECTURE_BROWSER_IMAGE': 'dlt-architecture-tools-browser'}
            for args, image in [(['build-source'], 'light'), (['build-preview', '--renderer', 'plantuml'], 'light'), (['build-preview', '--renderer', 'mermaid'], 'browser'),
                                (['export-native'], 'browser'), (['--browser', 'test'], 'browser')]:
                result = subprocess.run([str(cli.ROOT / 'docker/run.sh'), *args], env=env, text=True, capture_output=True)
                self.assertEqual(0, result.returncode, result.stderr)
                self.assertIn('dlt-architecture-tools-' + image + '\n', result.stdout)
                self.assertIn('--network\nnone', result.stdout)
                self.assertNotIn('--build', result.stdout)
            result = subprocess.run([str(cli.ROOT / 'docker/run.sh'), 'build-preview', '--renderer', 'mermaid'],
                env=env | {'MISSING_IMAGE': '1'}, text=True, capture_output=True)
            self.assertNotEqual(0, result.returncode)
            self.assertIn('not loaded', result.stderr)
            self.assertEqual('', result.stdout)


@unittest.skipUnless(renderers.has_capability('native'), 'Provider JavaScript fixtures run in tools-browser')
class ProviderSelection(unittest.TestCase):
    def test_github_exact_commit_success_expiry_and_pagination(self):
        script = r'''
const assert = require('node:assert/strict');
const select = require('/workspace/ci/select-source-run.cjs');
const request = {owner:'org',repo:'repo',workflow_id:'architecture.yaml',sha:'abc',branch:'main'};
const base = {head_sha:'abc',head_branch:'main',status:'completed',conclusion:'success',event:'push',run_attempt:1};
const runs = [{...base,id:1,run_number:1}, {...base,id:2,run_number:2},
 {...base,id:3,run_number:3,head_sha:'other'}, {...base,id:4,run_number:4,conclusion:'failure'},
 {...base,id:5,run_number:5,head_branch:'other'}, {...base,id:6,run_number:6,event:'schedule'}];
const artifacts = {1:[{id:101,name:'architecture-source',expired:false}],
 2:[{id:102,name:'architecture-source',expired:true}]};
const api = {rest:{actions:{listWorkflowRuns:'runs',listWorkflowRunArtifacts:'artifacts'}},
 paginate:async (method,args) => method==='runs' ? runs : artifacts[args.run_id] || []};
(async () => {
 assert.deepEqual(await select(api,request), {run_id:1,artifact_id:101});
 artifacts[2][0].expired=false;
 assert.deepEqual(await select(api,request), {run_id:2,artifact_id:102});
 artifacts[2][0].expires_at='2000-01-01T00:00:00Z';
 assert.deepEqual(await select(api,request), {run_id:1,artifact_id:101});
 artifacts[1]=[];
 await assert.rejects(select(api,request), /Run the source job/);
})().catch(error => {console.error(error); process.exitCode=1;});
'''
        result = subprocess.run(['node', '-e', script], capture_output=True, text=True)
        self.assertEqual(0, result.returncode, result.stderr)
