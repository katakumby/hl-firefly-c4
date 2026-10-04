"""Real offline renderer checks and regressions for complete builds."""
from pathlib import Path
import json
import shutil
import struct
import subprocess
import sys
import tempfile
import unittest
import xml.etree.ElementTree as ET
from unittest.mock import patch

from test_architecture import checkout, BASE, contents
import architecture as cli
import workspace_paths as paths
import diagram_renderers as renderer


class Renderers(unittest.TestCase):
    def test_tall_png_is_not_cropped_at_the_default_4096_pixel_limit(self):
        with tempfile.TemporaryDirectory() as temporary:
            source = Path(temporary) / 'tall.puml'
            source.write_text('@startuml\n' + 'A -> B: Message\n' * 220 + '@enduml\n')
            for format in ('svg', 'png'):
                renderer.render(source, source.with_suffix('.' + format), [])
            svg = ET.parse(source.with_suffix('.svg')).getroot()
            svg_height = int(svg.attrib['height'].removesuffix('px'))
            _, png_height = struct.unpack('>II', source.with_suffix('.png').read_bytes()[16:24])
            self.assertGreater(svg_height, 4096)
            self.assertLessEqual(abs(svg_height - png_height), 2)

    def test_offline_formats_and_local_plantuml_includes(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            (root / 'participants.pumlinc').write_text('participant Architect\nparticipant Platform\n')
            plantuml = root / 'sequence.puml'
            plantuml.write_text('@startuml\n!include participants.pumlinc\nArchitect -> Platform: Propose change\n@enduml\n')
            mermaid = root / 'flow.mmd'
            mermaid.write_text('sequenceDiagram\nArchitect->>Platform: Propose change\n')
            before = contents(root)
            for source in (plantuml, mermaid):
                if source.suffix == '.mmd' and not renderer.has_capability('mermaid'):
                    continue
                for format in ('svg', 'png'):
                    with self.subTest(source=source, format=format):
                        output = root / 'rendered' / source.with_suffix('.' + format).name
                        renderer.render(source, output, [])
                        renderer.check_image(output)
                        if format == 'svg':
                            self.assertIn('Propose change', output.read_text())
            self.assertEqual(before, {p.name: p.read_bytes() for p in root.iterdir() if p.is_file()})

    def test_malformed_sources_fail_instead_of_publishing_error_images(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            for name, source in [('broken.puml', '@startuml\nthis is not valid syntax !!!\n@enduml'),
                                 ('broken.mmd', 'sequenceDiagram\nthis is not valid syntax !!!')]:
                if name.endswith('.mmd') and not renderer.has_capability('mermaid'):
                    continue
                file = root / name
                file.write_text(source)
                with self.subTest(source=name), self.assertRaisesRegex(RuntimeError, 'Rendering failed'):
                    renderer.render(file, file.with_suffix('.svg'), [])

    def test_renderer_timeout_and_invalid_output_are_failures(self):
        with tempfile.TemporaryDirectory() as temporary:
            source = Path(temporary) / 'example.puml'
            source.write_text('@startuml\nA -> B\n@enduml')
            log = []
            with patch.object(renderer.subprocess, 'run', side_effect=subprocess.TimeoutExpired('java', 1)):
                with self.assertRaisesRegex(RuntimeError, 'timed out'):
                    renderer.render(source, source.with_suffix('.png'), log, timeout=1)
            self.assertIn('timed out', ''.join(log))
            with patch.object(renderer.subprocess, 'run', return_value=subprocess.CompletedProcess([], 0, b'error text', b'')):
                with self.assertRaisesRegex(ValueError, 'valid PNG'):
                    renderer.render(source, source.with_suffix('.png'), [])


class CompleteBuild(unittest.TestCase):
    def test_real_build_and_failed_rebuild_preserve_previous_outputs(self):
        with checkout() as root:
            paths.REFERENCE.write_text(BASE)
            source = root / 'uml/patterns/request/sequence.puml'
            source.parent.mkdir(parents=True)
            source.write_text('@startuml\nA -> B: Request\n@enduml')
            local = root / 'workspaces/team/uml/sequence.mmd'
            local.parent.mkdir(parents=True)
            local.write_text('sequenceDiagram\nA->>B: Request\n')
            cli.build()
            if renderer.has_capability('mermaid'):
                cli.build_browser()
            status = json.loads((cli.BUILD / 'build.json').read_text())
            self.assertTrue(status['passed'])
            self.assertIn('uml/patterns/request/sequence.puml', status['sources'])
            self.assertIn('workspaces/team/uml/sequence.mmd', status['sources'])
            images = [root / output for output in status['outputs'] if output.endswith(('.svg', '.png'))]
            self.assertEqual(10 if renderer.has_capability('mermaid') else 8, len(images))
            for image in images:
                renderer.check_image(image)
            for entry in cli.inventory():
                if entry['format'] in ('svg', 'png'):
                    self.assertIn('plantuml', entry['renderers'])
            previous = {image: image.read_bytes() for image in images}
            with patch.object(cli, 'render', side_effect=RuntimeError('renderer unavailable')):
                with self.assertRaisesRegex(RuntimeError, 'renderer unavailable'):
                    cli.build()
            self.assertFalse(json.loads((cli.BUILD / 'build.json').read_text())['passed'])
            self.assertEqual(previous, {image: image.read_bytes() for image in images})

    def test_discovery_rejects_collisions_and_keeps_workspace_namespaces(self):
        with checkout() as root:
            for name in ('uml/patterns/test.puml', 'workspaces/a/uml/test.mmd',
                         'workspaces/a/variants/future/uml/test.puml'):
                file = root / name
                file.parent.mkdir(parents=True, exist_ok=True)
                file.write_text('source')
            self.assertEqual(3, len(cli.discover_uml()))
            (root / 'uml/patterns/test.mmd').write_text('duplicate output name')
            with self.assertRaisesRegex(ValueError, 'output collision'):
                cli.discover_uml()

    def test_build_source_mutation_keeps_previous_artifacts(self):
        with checkout() as root:
            paths.REFERENCE.write_text(BASE)
            previous = cli.BUILD / 'uml/existing.svg'
            previous.parent.mkdir(parents=True)
            previous.write_text('previous success')
            def simulated_render(source, output, logs):
                output.parent.mkdir(parents=True, exist_ok=True)
                output.write_text('staged image')
                (root / 'model.dsl').write_text('Changed during build')
            with patch.object(cli, 'render', side_effect=simulated_render):
                with self.assertRaisesRegex(ValueError, 'Sources changed during build'):
                    cli.build()
            self.assertEqual('previous success', previous.read_text())
            self.assertFalse(json.loads((cli.BUILD / 'build.json').read_text())['passed'])

    def test_multi_destination_publication_rolls_back(self):
        with checkout():
            cli.BUILD.mkdir()
            replacements = []
            with cli.staging(cli.BUILD) as stage:
                for name in ('first.svg', 'second.svg'):
                    source, destination = stage / name, cli.BUILD / name
                    source.write_text('new')
                    destination.write_text('previous')
                    replacements.append((source, destination))
                rename = Path.rename
                def fail_second(source, target):
                    if source == stage / 'second.svg':
                        raise OSError('cannot publish second')
                    return rename(source, target)
                with patch.object(Path, 'rename', fail_second):
                    with self.assertRaisesRegex(OSError, 'cannot publish'):
                        cli.publish(replacements, stage / 'previous')
            for _, destination in replacements:
                self.assertEqual('previous', destination.read_text())


class RootAndIsolation(unittest.TestCase):
    def test_fingerprint_excludes_outputs_and_tracks_local_include_files(self):
        with checkout() as root:
            paths.REFERENCE.write_text(BASE)
            include = root / 'uml/shared/participants.pumlinc'
            include.parent.mkdir(parents=True)
            include.write_text('participant A')
            before = cli.source_fingerprint()
            for path in ('.git/config', '.agents/settings', 'build/uml/sequence.svg',
                         '.cache/metadata', 'workspace.json', 'workspaces/a/.structurizr/log'):
                file = root / path
                file.parent.mkdir(parents=True, exist_ok=True)
                file.write_text('generated or local')
            self.assertEqual(before, cli.source_fingerprint())
            include.write_text('participant B')
            self.assertNotEqual(before, cli.source_fingerprint())
            before = cli.source_fingerprint()
            (root / 'alternative.dsl').write_text('Additional entrypoint')
            self.assertNotEqual(before, cli.source_fingerprint())

    def test_checkout_embedded_in_another_repository_without_git(self):
        with tempfile.TemporaryDirectory() as temporary:
            parent = Path(temporary)
            root = parent / 'codebase/modules/architecture'
            root.mkdir(parents=True)
            (parent / '.env').write_text('UNRELATED=1')
            shutil.copytree(cli.ROOT / 'scripts', root / 'scripts')
            shutil.copy(cli.ROOT / '.env', root / '.env')
            (root / 'workspace.dsl').write_text(BASE)
            result = subprocess.run([sys.executable, '-B', str(root / 'scripts/architecture.py'),
                                     'validate', '--workspace', 'workspace.dsl'], cwd=parent,
                                    capture_output=True, text=True, timeout=60)
            self.assertEqual(0, result.returncode, result.stdout + result.stderr)
            self.assertTrue((root / 'build/.reports/workspace.dsl/workspace.json').is_file())
            self.assertFalse((parent / 'build').exists())

    def test_experimental_tags_and_elements_do_not_leak_to_siblings(self):
        with checkout() as root:
            (root / 'model.dsl').write_text('''workspace {
 properties {
  "structurizr.inspection.*" "info"
 }
 model {
  a = softwareSystem "Shared system" {
   tags "Baseline"
  }
 }
}''')
            shared = '''workspace extends model.dsl {
 views {
  systemLandscape "shared" {
   include *
  }
 }
}'''
            paths.REFERENCE.write_text(shared)
            sibling = root / 'workspaces/sibling/workspace.dsl'
            sibling.parent.mkdir(parents=True)
            sibling.write_text(shared.replace('extends model.dsl', 'extends ../../model.dsl'))
            experiment = root / 'workspaces/experiment/workspace.dsl'
            experiment.parent.mkdir(parents=True)
            experiment.write_text('''workspace extends ../../model.dsl {
 model {
  !element a {
   tags "Future"
  }
  b = softwareSystem "Experimental system" {
   tags "Future"
  }
 }
 views {
  systemLandscape "experiment" {
   include element.tag==Future
  }
 }
}''')
            reports = cli.validate()
            self.assertTrue(all(report['passed'] for report in reports.values()), reports)
            for workspace in reports:
                raw = json.loads((paths.output_directory(workspace) / 'workspace.json').read_text())
                systems = raw['model']['softwareSystems']
                self.assertEqual(2 if workspace == experiment else 1, len(systems))
                self.assertEqual(workspace == experiment, 'Future' in systems[0]['tags'])
            for workspace in (paths.REFERENCE, experiment):
                cli.export(workspace, 'plantuml')
                diagrams = cli.BUILD / workspace.relative_to(root).parent
                text = next(diagrams.glob('*.puml')).read_text()
                self.assertEqual(workspace == experiment, 'Experimental system' in text)
            self.assertNotIn('Future', (root / 'model.dsl').read_text())


if __name__ == '__main__':
    unittest.main()
