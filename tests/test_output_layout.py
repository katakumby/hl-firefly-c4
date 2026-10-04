"""Stable destinations, provenance, inventory pruning and crash recovery."""
import json
from pathlib import Path
import unittest
from unittest.mock import patch

from test_architecture import checkout, BASE
import architecture as cli
import workspace_paths as paths
import artifact_store as store
from view_sources import index_views


def quick_render(source, output, logs):
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text('rendered ' + source.read_text())


class Provenance(unittest.TestCase):
    def test_recursive_views_multiple_per_file_and_nested_inheritance(self):
        with checkout() as root:
            source = root / 'views/nested/all.inc'
            source.parent.mkdir(parents=True)
            source.write_text(BASE.split(' views {', 1)[1].rsplit('}', 1)[0].rsplit('}', 1)[0])
            paths.REFERENCE.write_text(BASE.split(' views {', 1)[0] + '\n views {\n !include views\n }\n}')
            parent = root / 'workspaces/team/workspace.dsl'
            variant = root / 'workspaces/team/variants/future/workspace.dsl'
            variant.parent.mkdir(parents=True)
            parent.write_text('workspace extends ../../workspace.dsl {\n}')
            variant.write_text('workspace extends ../../workspace.dsl {\n}')
            for workspace in (paths.REFERENCE, parent, variant):
                cli.build_source([workspace])
                for key in ('unprefixed', 'duplicate-selection', 'flow'):
                    output = cli.BUILD / 'source' / workspace.relative_to(root).parent / 'views/nested' / (key + '.puml')
                    self.assertTrue(output.is_file(), output)
            self.assertEqual(9, len(cli.inventory()))

    def test_quotes_comments_and_other_blocks_do_not_create_declarations(self):
        with checkout() as root:
            source = paths.REFERENCE
            source.write_text('''workspace {
 model {
  container "not a view" {
   description "text { and } // kept"
  }
 }
 views {
  /* systemLandscape "comment" { } */
  systemLandscape "name.with.dots" "a description with {braces}" {
  }
 }
}''')
            mapping = index_views(source, root, ['name.with.dots'])
            self.assertEqual((source, Path('name.with.dots')), mapping['name.with.dots'])

    def test_missing_ambiguous_unsafe_and_generated_keys_fail_closed(self):
        for declaration, keys, message in [
            ('systemLandscape {\n}', ['generated'], 'Explicit stable'),
            ('systemLandscape "one" {\n}\nsystemLandscape "one" {\n}', ['one'], 'Ambiguous'),
            ('systemLandscape "../escape" {\n}', ['../escape'], 'safe file names'),
            ('systemLandscape "${KEY}" {\n}', ['resolved'], 'differs from native')]:
            with self.subTest(declaration=declaration), checkout() as root:
                paths.REFERENCE.write_text('workspace {\n views {\n' + declaration + '\n}\n}')
                with self.assertRaisesRegex(ValueError, message):
                    index_views(paths.REFERENCE, root, keys)

    def test_colliding_case_keys_fail_before_publication(self):
        with checkout():
            paths.REFERENCE.write_text(BASE.replace('duplicate-selection', 'UNPREFIXED'))
            with self.assertRaisesRegex(ValueError, 'output collision'):
                cli.build_source([paths.REFERENCE])
            self.assertFalse(list(cli.BUILD.glob('*.puml')))


class Inventory(unittest.TestCase):
    @patch.object(cli, 'render', side_effect=quick_render)
    def test_build_twice_rename_move_delete_and_failed_pruning(self, _):
        with checkout() as root:
            paths.REFERENCE.write_text(BASE)
            source = root / 'workspaces/team/uml/nested/sequence.puml'
            source.parent.mkdir(parents=True)
            source.write_text('@startuml\nA -> B\n@enduml')
            cli.build_source(); cli.build_preview('plantuml')
            first = {p.relative_to(cli.BUILD) for p in cli.BUILD.rglob('*') if p.is_file()}
            cli.build_source(); cli.build_preview('plantuml')
            self.assertEqual(first, {p.relative_to(cli.BUILD) for p in cli.BUILD.rglob('*') if p.is_file()})
            previous = cli.BUILD / 'preview' / source.relative_to(root).with_suffix('.svg')
            moved = root / 'workspaces/team/uml/new/path/request.puml'
            moved.parent.mkdir(parents=True); source.rename(moved)
            cli.build_source()
            self.assertFalse((cli.BUILD / 'source' / source.relative_to(root)).exists())
            with patch.object(cli, 'render', side_effect=RuntimeError('renderer unavailable')):
                with self.assertRaisesRegex(RuntimeError, 'unavailable'):
                    cli.build_preview('plantuml')
            self.assertTrue(previous.exists())
            cli.build_preview('plantuml')
            self.assertFalse(previous.exists())
            self.assertTrue((cli.BUILD / 'preview' / moved.relative_to(root).with_suffix('.png')).exists())
            moved.unlink(); cli.build_source(); cli.build_preview('plantuml')
            self.assertFalse((cli.BUILD / 'preview/workspaces').exists())
            self.assertFalse((cli.BUILD / '.staging').exists())
            self.assertEqual(9, len(cli.inventory()))

    @patch.object(cli, 'render', side_effect=quick_render)
    def test_workspace_c4_and_uml_siblings_survive_selected_source_and_preview(self, _):
        with checkout() as root:
            paths.REFERENCE.write_text(BASE)
            workspace = root / 'workspaces/team/workspace.dsl'
            workspace.parent.mkdir(parents=True); workspace.write_text(BASE)
            source = workspace.parent / 'uml/nested/message.puml'
            source.parent.mkdir(parents=True); source.write_text('@startuml\nA -> B: Hello\n@enduml')
            cli.build_source(); cli.build_preview('plantuml')
            old = {p: p.read_bytes() for p in (cli.BUILD / 'preview/workspaces/team').rglob('*') if p.is_file()}
            metadata = cli.inventory('preview-plantuml')
            cli.build_source([workspace], ['flow'])
            self.assertEqual(metadata, cli.inventory('preview-plantuml'))
            cli.build_preview('plantuml', [workspace], ['flow'])
            self.assertEqual(old, {p: p.read_bytes() for p in old})
            self.assertTrue((cli.BUILD / 'source/workspaces/team/uml/nested/message.puml').exists())

    def test_explicit_clean_removes_previous_layout_without_migrating_artifacts(self):
        with checkout():
            paths.REFERENCE.write_text(BASE)
            old = cli.BUILD / 'c4/reference/exports/view-deadbeef/plantuml/old.puml'
            old.parent.mkdir(parents=True); old.write_text('old')
            cli.build_source()
            self.assertTrue(old.exists())
            with cli.command_lock(): cli.clean_build()
            self.assertFalse(old.exists())
            cli.build_source()
            self.assertEqual(3, len(cli.inventory('source')))

    @patch.object(cli, 'render', side_effect=quick_render)
    def test_moved_and_removed_c4_views_prune_only_after_successful_stage(self, _):
        with checkout() as root:
            views = root / 'views/old/main.dsl'
            views.parent.mkdir(parents=True)
            fragments = BASE.split(' views {', 1)[1].rsplit('}', 1)[0].rsplit('}', 1)[0]
            views.write_text(fragments)
            entry = BASE.split(' views {', 1)[0] + '\n views {\n !include views/old/main.dsl\n }\n}'
            paths.REFERENCE.write_text(entry)
            cli.build_source(); cli.build_preview('plantuml')
            old = cli.BUILD / 'preview/views/old/flow.svg'
            moved = root / 'views/new/nested/main.dsl'
            moved.parent.mkdir(parents=True); views.rename(moved)
            paths.REFERENCE.write_text(entry.replace('views/old/main.dsl', 'views/new/nested/main.dsl'))
            with patch.object(cli, 'stage_c4', side_effect=RuntimeError('failed')), self.assertRaises(RuntimeError):
                cli.build_source()
            self.assertTrue((cli.BUILD / 'source/views/old/flow.puml').exists())
            cli.build_source()
            self.assertFalse((cli.BUILD / 'source/views/old').exists())
            self.assertTrue(old.exists())
            cli.build_preview('plantuml')
            self.assertFalse(old.exists())
            self.assertTrue((cli.BUILD / 'preview/views/new/nested/flow.svg').exists())
            moved.write_text(fragments.split('  dynamic *', 1)[0])
            cli.build_source(); cli.build_preview('plantuml')
            self.assertFalse((cli.BUILD / 'preview/views/new/nested/flow.svg').exists())
            self.assertEqual(6, len(cli.inventory()))


class Recovery(unittest.TestCase):
    def test_interruption_rolls_back_files_deletions_and_inventory(self):
        with checkout():
            cli.BUILD.mkdir()
            stage = cli.BUILD / '.staging'
            stage.mkdir()
            old = cli.BUILD / 'old.svg'
            old.write_text('previous')
            new = stage / 'new.svg'
            new.write_text('new')
            rename = Path.rename
            def interrupt(source, destination):
                result = rename(source, destination)
                raise KeyboardInterrupt('interrupted after installation')
            with patch.object(Path, 'rename', interrupt), self.assertRaises(KeyboardInterrupt):
                cli.publish([(None, old), (new, cli.BUILD / 'new.svg')], stage / 'previous')
            self.assertFalse(old.exists())
            self.assertTrue((cli.BUILD / 'new.svg').exists())
            # A new writer recovers before reusing the fixed scratch directory.
            with cli.command_lock():
                self.assertEqual('previous', old.read_text())
                self.assertFalse((cli.BUILD / 'new.svg').exists())
                self.assertFalse(stage.exists())
            store.recover(cli.BUILD)  # idempotent

    def test_committed_journal_and_abandoned_render_scratch_are_cleaned(self):
        with checkout():
            cli.BUILD.mkdir()
            stage = cli.BUILD / '.staging'
            stage.mkdir()
            new = stage / 'new.svg'
            new.write_text('new')
            cli.publish([(new, cli.BUILD / 'new.svg')], stage / 'previous')
            store.recover(cli.BUILD)
            self.assertEqual('new', (cli.BUILD / 'new.svg').read_text())
            stage.mkdir()
            (stage / 'partial.png').write_text('interrupted rendering')
            with cli.command_lock():
                self.assertFalse(stage.exists())

    def test_symlink_and_path_traversal_destinations_are_rejected(self):
        with checkout() as root:
            cli.BUILD.mkdir()
            (cli.BUILD / 'linked').symlink_to(root)
            for relative in ('../outside.svg', 'linked/anything.svg', '/tmp/outside.svg'):
                with self.subTest(relative=relative), self.assertRaises(ValueError):
                    store.confined(cli.BUILD, relative)

class Packaging(unittest.TestCase):
    def test_package_excludes_local_state_previews_and_failed_outputs(self):
        import ci_artifacts
        with checkout() as root:
            paths.REFERENCE.write_text(BASE)
            cli.build_source()
            (cli.BUILD / 'local.env').write_text('SECRET=keep-local')
            output = root / 'package'; output.mkdir()
            ci_artifacts.package(output)
            self.assertTrue((output / 'source/unprefixed.puml').exists())
            self.assertFalse((output / 'preview').exists())
            self.assertFalse((output / 'local.env').exists())
            self.assertFalse((output / '.tools.lock').exists())
            self.assertFalse((output / '.staging').exists())
            failed = root / 'failure'; failed.mkdir()
            cli.atomic_json(cli.BUILD / '.reports/source.json', {'passed': False})
            with self.assertRaisesRegex(ValueError, 'failed or stale'):
                ci_artifacts.package(failed)
            ci_artifacts.package(failed, diagnostics=True)
            self.assertFalse((failed / 'source').exists())
            self.assertTrue((failed / '.reports/workspace.dsl/validation.json').exists())


if __name__ == '__main__':
    unittest.main()
