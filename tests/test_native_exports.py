"""On-demand selection, layout preservation, real offline GIFs and atomic publication."""
from contextlib import redirect_stderr
from copy import deepcopy
import io
import json
from pathlib import Path
import struct
import sys
import unittest
from unittest.mock import patch

from test_architecture import checkout, BASE
from test_output_layout import quick_render
import architecture as cli
import workspace_paths as paths
import native_exports as native
from diagram_renderers import check_gif, check_image, has_capability

NATIVE = '''workspace {
 properties {
  "structurizr.inspection.*" "info"
 }
 !identifiers hierarchical
 model {
  s = softwareSystem "Example" {
   a = container "API" "Current API" "HTTP"
   b = container "Backend" "Current backend" "Java"
   a -> b "Calls" "HTTP"
   b -> a "Returns" "HTTP"
  }
 }
 views {
  container s "manual" {
   include *
  }
  container s "reveal" {
   include *
   autoLayout lr
   animation {
    s.a
    s.b
   }
  }
  dynamic s "flow" {
   s.a -> s.b "Request"
   s.b -> s.a "Response"
   s.a -> s.b "Next request"
  }
 }
}'''


def save_layout(workspace):
    raw, _ = cli.fresh_workspace(workspace)
    for kind, view in native.views(raw).values():
        if view.get('automaticLayout'):
            continue
        view['dimensions'] = {'width': 1000, 'height': 750}
        for index, element in enumerate(view['elements']):
            element.update(x=50 + index * 520, y=80 + index * 260)
        for relation in view.get('relationships', []):
            relation.update(vertices=[{'x': 400, 'y': 250}], position=65)
    workspace.with_suffix('.json').write_text(json.dumps(raw))
    return raw


def managed_contents():
    return {item['output']: (cli.BUILD / item['output']).read_bytes() for item in cli.inventory()}


class Selection(unittest.TestCase):
    def test_cli_defaults_and_multiple_view_keys_validate_once(self):
        with checkout():
            paths.REFERENCE.write_text(BASE)
            arguments = ['architecture.py', 'build-source', '--view', 'flow', '--view', 'unprefixed', '--view', 'flow']
            with patch.object(sys, 'argv', arguments), patch.object(cli, 'validate', wraps=cli.validate) as validate:
                self.assertEqual(0, cli.main())
            self.assertEqual(1, validate.call_count)
            self.assertEqual({'source/flow.puml', 'source/unprefixed.puml'}, set(managed_contents()))
            status = json.loads((cli.BUILD / '.reports/source.json').read_text())
            self.assertEqual(['flow', 'unprefixed'], status['selection']['views'])

    def test_all_workspaces_include_nested_variants_with_isolated_keys(self):
        with checkout() as root:
            paths.REFERENCE.write_text(BASE)
            child = root / 'workspaces/team/workspace.dsl'
            variant = root / 'workspaces/team/variants/future/workspace.dsl'
            variant.parent.mkdir(parents=True)
            child.write_text('workspace extends ../../workspace.dsl {\n}')
            variant.write_text('workspace extends ../../workspace.dsl {\n}')
            with patch.object(sys, 'argv', ['architecture.py', 'build-source', '--all-workspaces']):
                self.assertEqual(0, cli.main())
            self.assertEqual(9, len(cli.inventory()))
            for prefix in ('', 'workspaces/team/', 'workspaces/team/variants/future/'):
                self.assertIn('source/' + prefix + 'flow.puml', managed_contents())

    def test_invalid_cli_combinations_and_gif_timing(self):
        cases = [
            ['build-source', '--all-workspaces', '--workspace', 'workspace.dsl'],
            ['build-source', '--all-workspaces', '--view', 'one'],
            ['export-native', '--all-workspaces', '--view', 'one'],
            ['export-native', '--format', 'svg', '--frame-duration', '2'],
            *[['export-native', '--format', 'gif', '--frame-duration', value]
              for value in ('0', '-1', 'nan', 'inf', '656')],
        ]
        for args in cases:
            with self.subTest(args=args), redirect_stderr(io.StringIO()), \
                 patch.object(sys, 'argv', ['architecture.py', *args]), self.assertRaises(SystemExit) as error:
                cli.main()
            self.assertEqual(2, error.exception.code)

    def test_unknown_keys_are_reported_together_before_rendering(self):
        with checkout():
            paths.REFERENCE.write_text(BASE)
            operations = [lambda: cli.build_source([paths.REFERENCE], ['missing-one', 'flow', 'missing-two'])]
            if has_capability('native'):
                operations.append(lambda: cli.export_native([paths.REFERENCE], 'svg', ['missing-one', 'flow', 'missing-two']))
            for operation in operations:
                with patch.object(cli, 'stage_c4') as c4, patch.object(native, 'render_native') as renderer:
                    with self.assertRaisesRegex(ValueError, "missing-one.*missing-two"):
                        operation()
                    c4.assert_not_called()
                    renderer.assert_not_called()

    def test_later_workspace_failure_preserves_entire_batch(self):
        with checkout() as root:
            paths.REFERENCE.write_text(BASE)
            other = root / 'workspaces/other/workspace.dsl'
            other.parent.mkdir(parents=True)
            other.write_text(BASE)
            selected = [paths.REFERENCE, other]
            cli.build_source(selected)
            before = managed_contents()
            inventory = (cli.BUILD / 'source.json').read_bytes()
            stage = cli.stage_c4
            def fail_later(workspace, *args):
                if workspace == other:
                    raise RuntimeError('Second workspace failed')
                return stage(workspace, *args)
            with patch.object(cli, 'stage_c4', side_effect=fail_later), self.assertRaisesRegex(RuntimeError, 'Second workspace'):
                cli.build_source(selected)
            self.assertEqual(before, managed_contents())
            self.assertEqual(inventory, (cli.BUILD / 'source.json').read_bytes())
            for workspace in selected:
                report = json.loads((cli.BUILD / '.reports/source.json').read_text())
                self.assertFalse(report['passed'])
                self.assertEqual([], report['outputs'])
            self.assertFalse((cli.BUILD / '.staging').exists())


@unittest.skipUnless(has_capability('native'), 'Native rendering runs in tools-browser')
class NativeLayouts(unittest.TestCase):
    def test_capture_merge_preserves_positions_routes_and_current_dsl(self):
        with checkout() as root:
            paths.REFERENCE.write_text(NATIVE)
            saved = save_layout(paths.REFERENCE)
            snapshot = native.layout_path(paths.REFERENCE, root, cli.BUILD)
            original = snapshot.read_bytes()
            paths.REFERENCE.write_text(NATIVE.replace('Current API', 'Updated API')
                .replace('Next request', 'Updated request').replace('    s.a\n    s.b', '    s.b\n    s.a'))
            current, _ = cli.fresh_workspace(paths.REFERENCE)
            with cli.staging(cli.BUILD) as stage:
                request = native.prepare(paths.REFERENCE, current, ['manual', 'flow'], True,
                    'svg', 3, root, cli.BUILD, stage / 'native', [], cli.run_java)
                merged = json.loads(Path(request['workspace']).read_text())
                self.assertEqual(current['model'], merged['model'])
                self.assertIn('Updated request', json.dumps(merged['views']))
                self.assertNotEqual(native.views(saved)['reveal'][1]['animations'],
                                    native.views(current)['reveal'][1]['animations'])
                self.assertEqual(native.views(current)['reveal'][1]['animations'],
                                 native.views(merged)['reveal'][1]['animations'])
                self.assertEqual([(r['order'], r['description']) for r in native.views(current)['flow'][1]['relationships']],
                                 [(r['order'], r['description']) for r in native.views(merged)['flow'][1]['relationships']])
                for key in ('manual', 'flow'):
                    previous, resulting = native.views(saved)[key][1], native.views(merged)[key][1]
                    self.assertEqual(previous['dimensions'], resulting['dimensions'])
                    self.assertEqual(previous['elements'], resulting['elements'])
                    self.assertEqual(previous['relationships'][0]['vertices'], resulting['relationships'][0]['vertices'])
                    self.assertEqual(65, resulting['relationships'][0]['position'])
            self.assertEqual(original, snapshot.read_bytes())

    def test_missing_invalid_and_incomplete_saved_layouts_fail(self):
        with checkout() as root:
            paths.REFERENCE.write_text(NATIVE)
            with self.assertRaisesRegex(ValueError, 'Saved manual layout is missing'):
                cli.export_native([paths.REFERENCE], 'svg', ['manual'])
            saved = save_layout(paths.REFERENCE)
            file = paths.REFERENCE.with_suffix('.json')
            file.write_text('{ broken')
            with self.assertRaises(ValueError):
                cli.export_native([paths.REFERENCE], 'svg', ['manual'])
            self.assertEqual('{ broken', file.read_text())
            native.views(saved)['manual'][1].pop('dimensions')
            file.write_text(json.dumps(saved))
            with self.assertRaisesRegex(ValueError, 'manual'):
                cli.export_native([paths.REFERENCE], 'svg', ['manual'])

    def test_real_svg_png_and_both_animation_types_then_cleanup(self):
        with checkout() as root:
            paths.REFERENCE.write_text(NATIVE)
            save_layout(paths.REFERENCE)
            snapshot = native.layout_path(paths.REFERENCE, root, cli.BUILD)
            saved = snapshot.read_bytes()
            for format in ('svg', 'png'):
                cli.export_native([paths.REFERENCE], format, ['manual'])
                for suffix in ('structurizr', 'structurizr-key'):
                    check_image(cli.BUILD / f'preview/manual.{suffix}.{format}')
            width, height = struct.unpack('>II', (cli.BUILD / 'preview/manual.structurizr.png').read_bytes()[16:24])
            self.assertEqual((1000, 750), (width, height))
            cli.export_native([paths.REFERENCE], 'gif', ['reveal', 'flow'], frame_duration=0.25)
            for key, count in [('reveal', 2), ('flow', 4)]:
                gif = check_gif(cli.BUILD / f'preview/{key}.structurizr.gif')
                self.assertEqual(count, gif['frames'])
                self.assertEqual([25] * count, gif['delays_centiseconds'])
            original_entries = deepcopy(cli.inventory())
            with patch.object(cli, 'render', side_effect=quick_render), patch.object(native, 'render_native') as renderer:
                cli.build_source()
                renderer.assert_not_called()
            self.assertEqual(original_entries, [item for item in cli.inventory() if item.get('renderer') == 'structurizr'])
            self.assertEqual(saved, snapshot.read_bytes())
            # An ordinary selected SVG export does not replace native SVGs or their metadata.
            with patch.object(cli, 'render', side_effect=quick_render):
                cli.build_preview('plantuml', [paths.REFERENCE], ['manual'])
            self.assertEqual(original_entries, [item for item in cli.inventory() if item.get('renderer') == 'structurizr'])
            cli.clean_build()
            self.assertEqual(saved, snapshot.read_bytes())
            self.assertFalse((cli.BUILD / '.layouts').exists())
            self.assertFalse((cli.BUILD / 'preview/manual.structurizr.svg').exists())

    def test_nonanimated_gif_selection_and_workspace_skip(self):
        with checkout():
            paths.REFERENCE.write_text(NATIVE)
            # No layout is needed for skipped views; no renderer starts on an invalid selection.
            with patch.object(native, 'render_native') as renderer:
                with self.assertRaisesRegex(ValueError, 'no animation: manual'):
                    cli.export_native([paths.REFERENCE], 'gif', ['manual', 'reveal'])
                renderer.assert_not_called()
            save_layout(paths.REFERENCE)
            cli.export_native([paths.REFERENCE], 'gif')
            self.assertEqual({'preview/reveal.structurizr.gif', 'preview/flow.structurizr.gif'}, set(managed_contents()))
            report = json.loads((paths.output_directory(paths.REFERENCE) / 'export-native-status.json').read_text())
            self.assertEqual(['manual'], report['skipped_views'])

    def test_native_batch_failure_layout_change_and_publication_rollback(self):
        with checkout() as root:
            paths.REFERENCE.write_text(BASE)
            other = root / 'workspaces/other/workspace.dsl'
            other.parent.mkdir(parents=True)
            other.write_text(BASE)
            selected = [paths.REFERENCE, other]
            cli.export_native(selected, 'svg')
            before, previous = managed_contents(), (cli.BUILD / 'preview-native.json').read_bytes()
            real_render = native.render_native
            def fail_other(request, stage, *args):
                if 'other' in stage.parts:
                    raise RuntimeError('Later native workspace failed')
                return real_render(request, stage, *args)
            with patch.object(native, 'render_native', side_effect=fail_other), self.assertRaisesRegex(RuntimeError, 'Later native'):
                cli.export_native(selected, 'svg')
            self.assertEqual(before, managed_contents())
            self.assertEqual(previous, (cli.BUILD / 'preview-native.json').read_bytes())
            rename = Path.rename
            def fail_inventory(source, target):
                if source.name == 'preview-native.json':
                    raise OSError('Inventory publication failed')
                return rename(source, target)
            with patch.object(Path, 'rename', fail_inventory), self.assertRaisesRegex(OSError, 'Inventory publication'):
                cli.export_native([paths.REFERENCE], 'svg', ['flow'])
            self.assertEqual(before, managed_contents())
            self.assertEqual(previous, (cli.BUILD / 'preview-native.json').read_bytes())
            with patch.object(native, 'layout_fingerprint', side_effect=[None, 'changed']), self.assertRaisesRegex(ValueError, 'layout changed'):
                cli.export_native([paths.REFERENCE], 'svg', ['flow'])
            self.assertEqual(before, managed_contents())

    def test_gif_validation_rejects_truncated_or_fake_files(self):
        with checkout() as root:
            file = root / 'broken.gif'
            for content in (b'not gif', b'GIF89a', b'GIF89a' + b'\x01\x00' * 2 + b'\0' * 3):
                file.write_bytes(content)
                with self.subTest(content=content), self.assertRaises(ValueError):
                    check_gif(file)

    def test_native_move_delete_and_repeat_prune_only_the_successful_scope(self):
        def render_fixture(request, stage, logs, run_java):
            results = {}
            for key in request['keys']:
                for role in ('diagram', 'key'):
                    file = stage / f'{key}-{role}.svg'
                    file.write_text('<svg xmlns="http://www.w3.org/2000/svg"><text>' + key + '</text></svg>')
                    results[key, role] = (file, {})
            return results
        with checkout() as root, patch.object(native, 'render_native', side_effect=render_fixture):
            old = root / 'views/old/main.dsl'
            old.parent.mkdir(parents=True)
            fragments = BASE.split(' views {', 1)[1].rsplit('}', 1)[0].rsplit('}', 1)[0]
            old.write_text(fragments)
            entry = BASE.split(' views {', 1)[0] + '\n views {\n !include views/old/main.dsl\n }\n}'
            paths.REFERENCE.write_text(entry)
            cli.export_native([paths.REFERENCE], 'svg')
            moved = root / 'views/new/nested/main.dsl'
            moved.parent.mkdir(parents=True)
            old.rename(moved)
            paths.REFERENCE.write_text(entry.replace('views/old/main.dsl', 'views/new/nested/main.dsl'))
            cli.export_native([paths.REFERENCE], 'svg', ['flow'])
            self.assertFalse((cli.BUILD / 'preview/views/old/flow.structurizr.svg').exists())
            self.assertTrue((cli.BUILD / 'preview/views/old/unprefixed.structurizr.svg').exists())
            before = managed_contents()
            with patch.object(native, 'render_native', side_effect=RuntimeError('failed')), self.assertRaises(RuntimeError):
                cli.export_native([paths.REFERENCE], 'svg')
            self.assertEqual(before, managed_contents())
            cli.export_native([paths.REFERENCE], 'svg')
            self.assertFalse((cli.BUILD / 'preview/views/old').exists())
            before = managed_contents()
            cli.export_native([paths.REFERENCE], 'svg')
            self.assertEqual(before, managed_contents())
            moved.write_text(fragments.split('  dynamic *', 1)[0])
            with patch.object(cli, 'render', side_effect=quick_render), patch.object(native, 'render_native') as renderer:
                cli.build_source()
                renderer.assert_not_called()
            cli.export_native([paths.REFERENCE], 'svg')
            self.assertFalse((cli.BUILD / 'preview/views/new/nested/flow.structurizr.svg').exists())
            self.assertTrue((cli.BUILD / 'preview/views/new/nested/unprefixed.structurizr.svg').exists())


if __name__ == '__main__':
    unittest.main()
