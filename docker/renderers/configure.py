"""Configure the pinned Structurizr image's browser for offline Mermaid rendering."""
import hashlib
import json
from pathlib import Path
import subprocess

root = Path('/opt/renderers')
browsers = list(Path('/ms-playwright').glob('chromium-*/chrome-*/chrome'))
if len(browsers) != 1:
    raise RuntimeError('Expected exactly one bundled Chromium browser')
(root / 'puppeteer.json').write_text(json.dumps({
    'executablePath': str(browsers[0]),
    'args': ['--no-sandbox', '--disable-dev-shm-usage'],
}))

def output(*arguments):
    return subprocess.check_output(arguments, text=True).strip()

versions = {
    'plantuml': output('java', '-jar', '/opt/plantuml/plantuml.jar', '-version').splitlines()[0],
    'plantuml_sha256': hashlib.sha256(Path('/opt/plantuml/plantuml.jar').read_bytes()).hexdigest(),
    'node': output('node', '--version'),
    'chromium': output(str(browsers[0]), '--version'),
    'os_packages': output('dpkg-query', '-W', 'graphviz', 'fonts-dejavu-core'),
    'npm_lock_sha256': hashlib.sha256((root / 'package-lock.json').read_bytes()).hexdigest(),
}
for package in ('@mermaid-js/mermaid-cli', 'mermaid', 'puppeteer'):
    versions[package] = json.loads((root / 'node_modules' / package / 'package.json').read_text())['version']
(root / 'versions.json').write_text(json.dumps(versions, indent=2) + '\n')
