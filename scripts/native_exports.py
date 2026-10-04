"""On-demand Structurizr rendering using the approved image's offline browser assets."""
import functools
import hashlib
import http.server
import json
import math
from pathlib import Path
import subprocess
import tempfile
import threading
import xml.etree.ElementTree as ET
from zipfile import ZipFile

from artifact_store import atomic_json, confined
from diagram_renderers import check_image, renderer_versions, check_gif

WAR = Path('/usr/local/structurizr.war')
GIFSHOT = 'WEB-INF/classes/static/static/js/gifshot-0.4.4.js'
DRIVER = Path(__file__).with_name('native_renderer.cjs')


def layout_path(workspace, root, build):
    return confined(build, Path('.layouts') / workspace.relative_to(root) / 'workspace.json')


def layout_fingerprint(workspace, root, build):
    path = layout_path(workspace, root, build)
    return hashlib.sha256(path.read_bytes()).hexdigest() if path.exists() else None


def output_path(stem, format, role='diagram'):
    suffix = '.structurizr-key.' if role == 'key' else '.structurizr.'
    return stem.with_name(stem.name + suffix + format)


def views(raw):
    return {view['key']: (kind, view) for kind, values in raw['views'].items()
            if kind.endswith('Views') for view in values}


def is_animated(raw, key):
    kind, view = views(raw)[key]
    return bool(view.get('relationships')) if kind == 'dynamicViews' else len(view.get('animations', [])) > 1


def versions():
    with ZipFile(WAR) as archive:
        gifshot = archive.read(GIFSHOT)
        diagram = archive.read('WEB-INF/classes/static/static/js/structurizr-diagram.js')
    return renderer_versions() | {'gifshot': '0.4.4', 'gifshot_sha256': hashlib.sha256(gifshot).hexdigest(),
                                 'structurizr_diagram_sha256': hashlib.sha256(diagram).hexdigest()}


def prepare(workspace, raw, keys, explicit, format, duration, root, build, stage, logs, run_java):
    stage.mkdir(parents=True, exist_ok=True)
    skipped = [key for key in keys if format == 'gif' and not is_animated(raw, key)]
    if skipped and explicit:
        raise ValueError('GIF requires animated views; no animation: ' + ', '.join(skipped))
    keys = [key for key in keys if key not in skipped]
    if skipped:
        message = 'Skipped nonanimated views: ' + ', '.join(skipped)
        logs.append(message)
        print(message, flush=True)
    snapshot = layout_path(workspace, root, build)
    fingerprint = layout_fingerprint(workspace, root, build)
    current = stage / 'current.json'
    atomic_json(current, raw)
    merged = raw
    warnings = []
    if snapshot.exists() and keys:
        # Freeze the snapshot used by the merge. Publication checks its fingerprint again.
        frozen = stage / 'layout.json'
        frozen.write_bytes(snapshot.read_bytes())
        if hashlib.sha256(frozen.read_bytes()).hexdigest() != fingerprint:
            raise ValueError('Captured layout changed while reading it')
        saved = json.loads(frozen.read_text())
        unmatched = sorted(set(keys) - set(views(saved)))
        if unmatched:
            warnings.append('No exact saved view key; native layout matching may recover it: ' + ', '.join(unmatched))
        target = stage / 'merged.json'
        run_java(['merge', '-workspace', str(current), '-layout', str(frozen), '-output', str(target)], logs)
        merged = json.loads(target.read_text())
        # Model and animation content must come from today's DSL, not the saved viewer copy.
        if merged.get('model') != raw.get('model'):
            raise ValueError('Layout merge unexpectedly changed the current model')
        before, after = views(raw), views(merged)
        if set(before) != set(after):
            raise ValueError('Layout merge unexpectedly changed the current view keys')
        for key, (_, view) in before.items():
            for field in ('animations', 'automaticLayout'):
                if field in view:
                    after[key][1][field] = view[field]
                else:
                    after[key][1].pop(field, None)
    after = views(merged)
    missing = []
    for key in keys:
        kind, view = after[key]
        if kind == 'filteredViews':
            kind, view = after[view['baseViewKey']]
        if kind == 'imageViews' or view.get('automaticLayout'):
            continue
        dimensions = view.get('dimensions', {})
        valid_canvas = all(isinstance(dimensions.get(axis), (int, float))
                           and math.isfinite(dimensions[axis]) and dimensions[axis] > 0
                           for axis in ('width', 'height'))
        valid_positions = all(all(isinstance(element.get(axis), (int, float))
                                 and math.isfinite(element[axis]) for axis in ('x', 'y'))
                              for element in view.get('elements', []))
        if fingerprint is None or not valid_canvas or not valid_positions:
            missing.append(key)
    if missing:
        raise ValueError('Saved manual layout is missing for: ' + ', '.join(missing)
                         + '. Arrange and save these views in Structurizr, then run capture-layout.')
    for warning in warnings:
        logs.append('WARNING: ' + warning)
        print('WARNING: ' + warning, flush=True)
    atomic_json(current, merged)
    return {'workspace': str(current), 'keys': keys, 'format': format, 'frame_duration': duration,
            'layout_sha256': fingerprint, 'skipped_views': skipped, 'warnings': warnings}


class QuietHandler(http.server.SimpleHTTPRequestHandler):
    def log_message(self, *_):
        pass


def render_native(request, stage, logs, run_java):
    if not request['keys']:
        return {}
    # Renderer scratch uses container /tmp, not the read-only source checkout.
    with tempfile.TemporaryDirectory(prefix='structurizr-native-') as temporary:
        scratch = Path(temporary)
        site, output = scratch / 'site', stage / 'images'
        output.mkdir(parents=True, exist_ok=True)
        run_java(['export', '-workspace', request['workspace'], '-format', 'static', '-output', str(site)], logs, timeout=600)
        with ZipFile(WAR) as archive:
            (site / 'js/gifshot-0.4.4.js').write_bytes(archive.read(GIFSHOT))
        server = http.server.ThreadingHTTPServer(('127.0.0.1', 0), functools.partial(QuietHandler, directory=str(site)))
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        config = scratch / 'request.json'
        atomic_json(config, request | {'url': f'http://127.0.0.1:{server.server_port}', 'output': str(output)})
        try:
            result = subprocess.run(['node', str(DRIVER), str(config)], capture_output=True, text=True,
                                    timeout=max(180, 180 * len(request['keys'])))
            logs.extend((result.stdout, result.stderr))
            if result.returncode:
                raise RuntimeError('Native renderer failed: ' + (result.stderr or result.stdout)[-4000:])
        except subprocess.TimeoutExpired as exc:
            logs.append('Native renderer timed out')
            raise RuntimeError('Native renderer timed out') from exc
        finally:
            server.shutdown()
            server.server_close()
            thread.join()
    manifest = json.loads((output / 'rendered.json').read_text())
    results = {}
    for item in manifest:
        key, role = item['view'], item['role']
        if key not in request['keys'] or role not in ('diagram', 'key') or (key, role) in results:
            raise ValueError('Unexpected or duplicate native renderer output')
        file = confined(output, item['file'])
        if file.suffix != '.' + request['format']:
            raise ValueError('Unexpected native output format')
        details = {}
        if request['format'] == 'gif':
            details = check_gif(file)
            if details['frames'] < 2 or details['frames'] != item['frames']:
                raise ValueError(f'Incomplete GIF animation: {key}')
            expected_delay = round(request['frame_duration'] * 100)
            if any(delay != expected_delay for delay in details['delays_centiseconds']):
                raise ValueError(f'Unexpected GIF timing: {key}')
        else:
            try:
                check_image(file)
            except ET.ParseError as exc:
                raise ValueError(f'Native renderer produced malformed SVG: {key}: {exc}') from exc
        results[(key, role)] = (file, details)
    return results
