"""Installed toolchain identity, compatibility and immutable metadata caching."""
from copy import deepcopy
import hashlib
import importlib.util
import json
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch
import zipfile

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / 'scripts'))
import diagram_renderers as renderers
import architecture as cli
from test_architecture import checkout, BASE

spec = importlib.util.spec_from_file_location('configure_renderers', ROOT / 'docker/renderers/configure.py')
configure = importlib.util.module_from_spec(spec)
spec.loader.exec_module(configure)

PINS = {'STRUCTURIZR_VERSION': '2026.06.28', 'PLANTUML_VERSION': '1.2025.10', 'NODE_VERSION': '22.14.0'}
LIGHT = {
    'metadata_version': 1, 'profile': 'light', 'capabilities': ['structurizr', 'plantuml'],
    'structurizr_version': PINS['STRUCTURIZR_VERSION'], 'structurizr_sha256': 'a' * 64,
    'plantuml_version': PINS['PLANTUML_VERSION'], 'plantuml_sha256': 'b' * 64,
    'java': 'openjdk 21.0.11', 'python': '3.12.3', 'os_packages': 'graphviz\t2.42.2\nfonts-dejavu-core\t2.37',
}


class Toolchain(unittest.TestCase):
    def setUp(self):
        renderers._renderer_versions.cache_clear()

    def tearDown(self):
        renderers._renderer_versions.cache_clear()

    def test_war_identity_comes_from_installed_manifest_and_bytes(self):
        with tempfile.TemporaryDirectory() as temporary:
            war = Path(temporary) / 'structurizr.war'
            with zipfile.ZipFile(war, 'w') as archive:
                archive.writestr('META-INF/MANIFEST.MF', 'Manifest-Version: 1.0\r\nImplementation-Version: 2026.\r\n 06.28\r\n')
            identity = configure.structurizr_identity(war)
            self.assertEqual('2026.06.28', identity['structurizr_version'])
            self.assertEqual(hashlib.sha256(war.read_bytes()).hexdigest(), identity['structurizr_sha256'])
            with zipfile.ZipFile(war, 'w') as archive:
                archive.writestr('META-INF/MANIFEST.MF', 'Manifest-Version: 1.0\n')
            with self.assertRaisesRegex(ValueError, 'Implementation-Version'):
                configure.structurizr_identity(war)

    def test_cached_metadata_is_read_once_and_cannot_be_modified_by_callers(self):
        with tempfile.TemporaryDirectory() as temporary, patch.object(renderers, 'RENDERERS', Path(temporary)):
            source = Path(temporary) / 'versions.json'
            source.write_text(json.dumps(LIGHT))
            original = Path.read_text
            with patch.object(Path, 'read_text', autospec=True, side_effect=original) as reads:
                first = renderers.renderer_versions()
                first['capabilities'].append('native')
                first['structurizr_version'] = 'modified'
                self.assertFalse(renderers.has_capability('native'))
                self.assertEqual(LIGHT, renderers.renderer_versions())
                self.assertEqual(1, reads.call_count)

    def test_missing_invalid_and_legacy_metadata_give_image_guidance(self):
        with tempfile.TemporaryDirectory() as temporary, patch.object(renderers, 'RENDERERS', Path(temporary)):
            source = Path(temporary) / 'versions.json'
            for content in (None, 'not JSON', '[]', '{"profile":"light","capabilities":["structurizr"]}'):
                renderers._renderer_versions.cache_clear()
                if content is not None:
                    source.write_text(content)
                with self.subTest(content=content), self.assertRaisesRegex(ValueError, r'Acquire an approved tools.*rebuild'):
                    renderers.check_toolchain(PINS)

    def test_checkout_pin_and_recorded_checksum_mismatches_fail(self):
        for field, value in [('structurizr_version', '2025.01.01'), ('plantuml_version', '1.2024.1'),
                             ('plantuml_sha256', 'invalid'), ('metadata_version', 0), ('java', '')]:
            metadata = LIGHT | {field: value}
            with self.subTest(field=field), patch.object(renderers, 'renderer_versions', return_value=metadata):
                with self.assertRaisesRegex(ValueError, r'Acquire an approved tools image'):
                    renderers.check_toolchain(PINS)
        with patch.object(renderers, 'renderer_versions', return_value=deepcopy(LIGHT)):
            self.assertEqual(LIGHT, renderers.check_toolchain(PINS))
            with self.assertRaisesRegex(ValueError, 'structurizr_sha256'):
                renderers.check_toolchain(PINS, LIGHT | {'structurizr_sha256': 'c' * 64})

    def test_generation_rejects_incompatible_images_before_native_commands(self):
        with checkout() as root, patch.object(renderers, 'renderer_versions',
                return_value=LIGHT | {'structurizr_version': 'old'}), patch.object(cli, 'run_java') as native:
            workspace = root / 'workspace.dsl'
            workspace.write_text(BASE)
            for operation in (lambda: cli.validate(), lambda: cli.capture_layout(workspace), cli.build):
                with self.assertRaisesRegex(ValueError, 'Installed toolchain does not match'):
                    operation()
            native.assert_not_called()
            self.assertFalse(json.loads((cli.BUILD / 'build.json').read_text())['passed'])

    def test_browser_pins_and_handoff_compatibility_allow_profile_extras(self):
        with tempfile.TemporaryDirectory() as temporary, patch.object(renderers, 'RENDERER_SOURCES', Path(temporary)):
            root = Path(temporary)
            packages = {'@mermaid-js/mermaid-cli': '11.12.0', 'mermaid': '11.12.0', 'puppeteer': '23.11.1'}
            (root / 'package.json').write_text(json.dumps({'dependencies': packages}))
            lock = root / 'package-lock.json'
            lock.write_text('{"lockfileVersion":3}')
            browser = LIGHT | packages | {
                'profile': 'browser', 'capabilities': ['structurizr', 'plantuml', 'mermaid', 'native'],
                'node': 'v22.14.0', 'chromium': 'Chromium 144',
                'npm_lock_sha256': hashlib.sha256(lock.read_bytes()).hexdigest(),
                'structurizr_sha256': 'c' * 64, 'java': 'openjdk 25.0.2',
            }
            with patch.object(renderers, 'renderer_versions', return_value=browser):
                self.assertEqual(browser, renderers.check_toolchain(PINS, LIGHT))
                for field in ('plantuml_sha256', 'os_packages', 'structurizr_version'):
                    altered = LIGHT | {field: 'd' * 64 if field.endswith('sha256') else 'different'}
                    with self.subTest(field=field), self.assertRaisesRegex(ValueError, 'incompatible toolchain'):
                        renderers.check_toolchain(PINS, altered)
                with self.assertRaisesRegex(ValueError, 'chromium'):
                    renderers.check_toolchain(PINS, browser | {'chromium': 'Chromium 145'})
                with self.assertRaisesRegex(ValueError, 'node'):
                    renderers.check_toolchain(PINS | {'NODE_VERSION': '20.0.0'})
                lock.write_text('{"lockfileVersion":3,"changed":true}')
                with self.assertRaisesRegex(ValueError, 'npm_lock_sha256'):
                    renderers.check_toolchain(PINS)


if __name__ == '__main__':
    unittest.main()
