"""Record the installed toolchain; configure Chromium only in the browser target."""
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import zipfile


def sha256(path):
    with Path(path).open('rb') as stream:
        return hashlib.file_digest(stream, 'sha256').hexdigest()


def structurizr_identity(path):
    with zipfile.ZipFile(path) as archive:
        manifest = archive.read('META-INF/MANIFEST.MF').decode('utf-8')
    # Manifest continuation lines start with a space.
    manifest = manifest.replace('\r\n ', '').replace('\n ', '')
    match = re.search(r'^Implementation-Version: (.+)$', manifest, re.MULTILINE)
    if not match:
        raise ValueError('Structurizr WAR has no Implementation-Version')
    return {'structurizr_version': match[1].strip(), 'structurizr_sha256': sha256(path)}


def output(*arguments):
    return subprocess.check_output(arguments, text=True).strip()


def configure(profile):
    if profile not in ('light', 'browser'):
        raise ValueError('Expected light or browser profile')
    root = Path('/opt/renderers')
    plantuml = output('java', '-jar', '/opt/plantuml/plantuml.jar', '-version').splitlines()[0]
    match = re.search(r'^PlantUML version (\S+)', plantuml)
    if not match:
        raise ValueError('Cannot identify installed PlantUML version')
    versions = {
        'metadata_version': 1,
        'profile': profile,
        'capabilities': ['structurizr', 'plantuml'],
        **structurizr_identity('/usr/local/structurizr.war'),
        'java': output('java', '--version').splitlines()[0],
        'python': sys.version.split()[0],
        'plantuml': plantuml,
        'plantuml_version': match[1],
        'plantuml_sha256': sha256('/opt/plantuml/plantuml.jar'),
        'os_packages': output('dpkg-query', '-W', 'graphviz', 'fonts-dejavu-core'),
    }
    if profile == 'browser':
        browsers = list(Path('/ms-playwright').glob('chromium-*/chrome-*/chrome'))
        if len(browsers) != 1:
            raise RuntimeError('Expected exactly one bundled Chromium browser')
        (root / 'puppeteer.json').write_text(json.dumps({
            'executablePath': str(browsers[0]),
            'args': ['--no-sandbox', '--disable-dev-shm-usage'],
        }))
        versions['capabilities'].extend(['mermaid', 'native'])
        versions.update(node=output('node', '--version'), chromium=output(str(browsers[0]), '--version'),
                        npm_lock_sha256=sha256(root / 'package-lock.json'))
        for package in ('@mermaid-js/mermaid-cli', 'mermaid', 'puppeteer'):
            versions[package] = json.loads((root / 'node_modules' / package / 'package.json').read_text())['version']
    (root / 'versions.json').write_text(json.dumps(versions, indent=2) + '\n')


if __name__ == '__main__':
    configure(sys.argv[1])
