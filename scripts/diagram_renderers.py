"""Offline renderers. Sources stay read-only; each source produces one image."""
import json
from pathlib import Path
import struct
import subprocess
import xml.etree.ElementTree as ET

RENDERERS = Path('/opt/renderers')


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


def renderer_versions():
    return json.loads((RENDERERS / 'versions.json').read_text())


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
