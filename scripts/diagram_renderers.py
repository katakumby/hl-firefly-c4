"""Offline renderers. Sources stay read-only; each source produces one image."""
from copy import deepcopy
from functools import lru_cache
import hashlib
import json
from pathlib import Path
import re
import struct
import subprocess
import xml.etree.ElementTree as ET

RENDERERS = Path('/opt/renderers')
RENDERER_SOURCES = Path(__file__).resolve().parents[1] / 'docker/renderers'


def check_gif(path):
    """Inspect GIF structure and timing without opening images or adding dependencies."""
    data = Path(path).read_bytes()
    if len(data) < 14 or data[:6] not in (b'GIF87a', b'GIF89a'):
        raise ValueError(f'Invalid GIF: {path}')
    width, height = struct.unpack('<HH', data[6:10])
    if not width or not height:
        raise ValueError(f'Empty GIF canvas: {path}')
    offset = 13 + (3 * 2 ** ((data[10] & 7) + 1) if data[10] & 128 else 0)
    frames, delays, delay = 0, [], None

    def blocks(position):
        while position < len(data) and data[position]:
            position += 1 + data[position]
        if position >= len(data):
            raise ValueError(f'Truncated GIF: {path}')
        return position + 1

    while offset < len(data):
        kind = data[offset]
        offset += 1
        if kind == 0x3B:
            if offset != len(data) or not frames:
                raise ValueError(f'Incomplete or multiple GIF images: {path}')
            return {'width': width, 'height': height, 'frames': frames, 'delays_centiseconds': delays}
        if kind == 0x21 and offset < len(data):
            label = data[offset]
            offset += 1
            if label == 0xF9:
                if offset + 6 > len(data) or data[offset] != 4:
                    raise ValueError(f'Invalid GIF control block: {path}')
                delay = int.from_bytes(data[offset + 2:offset + 4], 'little')
            offset = blocks(offset)
        elif kind == 0x2C and offset + 10 <= len(data):
            left, top, frame_width, frame_height = struct.unpack('<HHHH', data[offset:offset + 8])
            if not frame_width or not frame_height or left + frame_width > width or top + frame_height > height:
                raise ValueError(f'GIF frame outside canvas: {path}')
            packed = data[offset + 8]
            offset += 9 + (3 * 2 ** ((packed & 7) + 1) if packed & 128 else 0)
            offset = blocks(offset + 1)  # Skip LZW minimum code size, then image data.
            frames += 1
            delays.append(delay)
            delay = None
        else:
            raise ValueError(f'Invalid GIF block: {path}')
    raise ValueError(f'Truncated GIF: {path}')


def toolchain_error(reason, profile=None):
    service = 'tools-browser' if profile == 'browser' else 'tools' if profile == 'light' else 'tools/tools-browser'
    return ValueError(f'{reason}. Acquire an approved {service} image matching this checkout, '
                      'or ask the platform team to rebuild it with docker/compose.maintenance.yaml.')


@lru_cache(maxsize=2)
def _renderer_versions(path):
    try:
        versions = json.loads(path.read_text())
        if not isinstance(versions, dict):
            raise ValueError('Expected an object')
        return versions
    except (OSError, ValueError) as exc:
        raise toolchain_error(f'Missing or invalid installed toolchain metadata: {path}') from exc


def renderer_versions():
    # The image filesystem is immutable. Copies keep callers from changing the cache.
    return deepcopy(_renderer_versions(RENDERERS / 'versions.json'))


def _check_metadata(versions):
    profile = versions.get('profile') if isinstance(versions, dict) else None
    common = ('structurizr_version', 'structurizr_sha256', 'java', 'python',
              'plantuml_version', 'plantuml_sha256', 'os_packages')
    browser = ('node', 'chromium', 'npm_lock_sha256', '@mermaid-js/mermaid-cli', 'mermaid', 'puppeteer')
    if (not isinstance(versions, dict) or versions.get('metadata_version') != 1
            or profile not in ('light', 'browser')
            or any(not isinstance(versions.get(key), str) or not versions[key]
                   for key in common + (browser if profile == 'browser' else ()))):
        raise toolchain_error('Missing or incompatible installed toolchain identity metadata', profile)
    capabilities = versions.get('capabilities')
    required = ['structurizr', 'plantuml'] + (['mermaid', 'native'] if profile == 'browser' else [])
    if not isinstance(capabilities, list) or any(item not in capabilities for item in required):
        raise toolchain_error('Missing installed toolchain capabilities', profile)
    for key in ('structurizr_sha256', 'plantuml_sha256') + (('npm_lock_sha256',) if profile == 'browser' else ()):
        if not re.fullmatch(r'[0-9a-f]{64}', versions[key]):
            raise toolchain_error(f'Invalid installed toolchain checksum: {key}', profile)


def check_toolchain(pins, handoff_versions=None):
    """Verify installed identities against checkout pins and an optional handoff.

    Both approved profiles must agree on shared renderer versions. Their upstream
    WAR packaging and Java runtimes may differ; compare those only within a profile.
    """
    installed = renderer_versions()
    _check_metadata(installed)
    expected = {'structurizr_version': pins.get('STRUCTURIZR_VERSION'),
                'plantuml_version': pins.get('PLANTUML_VERSION')}
    if installed['profile'] == 'browser':
        expected['node'] = 'v' + pins.get('NODE_VERSION', '')
        try:
            dependencies = json.loads((RENDERER_SOURCES / 'package.json').read_text())['dependencies']
            expected.update({name: dependencies[name] for name in ('@mermaid-js/mermaid-cli', 'mermaid', 'puppeteer')})
            expected['npm_lock_sha256'] = hashlib.sha256((RENDERER_SOURCES / 'package-lock.json').read_bytes()).hexdigest()
        except (OSError, ValueError, KeyError, TypeError) as exc:
            raise toolchain_error('Missing or invalid checkout renderer dependency pins', installed['profile']) from exc
    mismatches = [key for key, value in expected.items() if installed.get(key) != value]
    if mismatches:
        raise toolchain_error('Installed toolchain does not match checkout pins: ' + ', '.join(mismatches), installed['profile'])
    if handoff_versions is not None:
        _check_metadata(handoff_versions)
        shared = ('structurizr_version', 'plantuml_version', 'plantuml_sha256', 'os_packages')
        if installed['profile'] == handoff_versions['profile']:
            shared += ('structurizr_sha256', 'java', 'python')
            if installed['profile'] == 'browser':
                shared += ('node', 'chromium', 'npm_lock_sha256', '@mermaid-js/mermaid-cli', 'mermaid', 'puppeteer')
        mismatches = [key for key in shared if installed[key] != handoff_versions[key]]
        if mismatches:
            raise toolchain_error('Recorded build has an incompatible toolchain: ' + ', '.join(mismatches), installed['profile'])
    return installed


def has_capability(name):
    return name in renderer_versions().get('capabilities', [])


def require_capability(name):
    if not has_capability(name):
        service = 'tools-browser' if name in ('mermaid', 'native') else 'tools'
        raise ValueError(f'This image lacks {name} support. Use the approved {service} image/service; '
                         'acquire it explicitly before execution.')


def check_image(path):
    """Reject missing files, renderer error text, and incomplete image streams."""
    path = Path(path)
    data = path.read_bytes()
    if path.suffix == '.svg':
        if ET.fromstring(data).tag != '{http://www.w3.org/2000/svg}svg':
            raise ValueError(f'Invalid SVG: {path}')
    elif path.suffix == '.png':
        if not data.startswith(b'\x89PNG\r\n\x1a\n'):
            raise ValueError(f'Invalid PNG: {path}')
        offset = 8
        while offset + 12 <= len(data):
            size = struct.unpack('>I', data[offset:offset + 4])[0]
            kind = data[offset + 4:offset + 8]
            offset += size + 12
            if kind == b'IEND' and size == 0 and offset == len(data):
                return
        raise ValueError(f'Incomplete or multiple PNG images: {path}')
    else:
        raise ValueError(f'Unsupported image format: {path.suffix}')


def render(source, output, logs, timeout=180):
    source, output = Path(source).resolve(), Path(output).resolve()
    format = output.suffix.lstrip('.')
    if format not in ('svg', 'png'):
        raise ValueError(f'Unsupported rendering format: {format}')
    require_capability('mermaid' if source.suffix == '.mmd' else 'plantuml')
    output.parent.mkdir(parents=True, exist_ok=True)
    if source.suffix == '.puml':
        # Pipe controls the output name; cwd preserves includes relative to the source.
        command = ['java', '-Djava.awt.headless=true', '-DPLANTUML_LIMIT_SIZE=16384',
                   '-jar', '/opt/plantuml/plantuml.jar',
                   '-failfast2', '-charset', 'UTF-8', '-t' + format, '-pipe']
        if format == 'png':
            # Twice PlantUML's default 96 DPI, without changing vector output or sources.
            command.append('-Sdpi=192')
        stdin = source.read_bytes()
    elif source.suffix == '.mmd':
        command = ['node', str(RENDERERS / 'node_modules/@mermaid-js/mermaid-cli/src/cli.js'),
                   '-p', str(RENDERERS / 'puppeteer.json'), '-i', str(source), '-o', str(output)]
        stdin = None
    else:
        raise ValueError(f'Unsupported diagram source: {source}')
    logs.append(f'Render {source} -> {output}\n')
    try:
        result = subprocess.run(command, input=stdin, cwd=source.parent, capture_output=True, timeout=timeout)
    except subprocess.TimeoutExpired as exc:
        logs.append(f'Renderer timed out after {timeout} seconds\n')
        raise RuntimeError(f'Renderer timed out for {source}') from exc
    logs.append(result.stderr.decode('utf-8', errors='replace'))
    if result.returncode:
        raise RuntimeError(f'Rendering failed for {source}: {logs[-1][-4000:]}')
    if source.suffix == '.puml':
        output.write_bytes(result.stdout)
    else:
        logs.append(result.stdout.decode('utf-8', errors='replace'))
    try:
        check_image(output)
    except (OSError, ValueError, ET.ParseError) as exc:
        raise ValueError(f'Renderer did not produce a valid {format.upper()} for {source}: {exc}') from exc
