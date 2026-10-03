"""Offline renderers. Sources stay read-only; each source produces one image."""
import json
from pathlib import Path
import struct
import subprocess
import xml.etree.ElementTree as ET

RENDERERS = Path('/opt/renderers')


def renderer_versions():
    return json.loads((RENDERERS / 'versions.json').read_text())


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
