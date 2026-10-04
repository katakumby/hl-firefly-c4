"""Offline architecture validation, exports and light/browser build stages. Standard library only."""
import argparse
from contextlib import contextmanager
from copy import deepcopy
from datetime import datetime, timezone
import fcntl
import hashlib
import json
import math
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

from workspace_paths import ROOT, BUILD, REFERENCE, VERSION, TOOLCHAIN, discover_workspaces, output_directory, workspace_path
from diagram_renderers import render, renderer_versions, require_capability
from view_sources import index_views, safe_name
from artifact_store import atomic_json, staging, publish, recover, confined, prune_empty
import native_exports

JAVA = ['java', '-Dio.netty.noUnsafe=true', '--enable-native-access=ALL-UNNAMED', '-jar', '/usr/local/structurizr.war']
# Native exporter, filename prefix and extension for each public export format.
EXPORT_FORMATS = {
    'plantuml': ('plantuml/c4plantuml', 'structurizr-', 'puml'),
    'mermaid': ('mermaid', 'structurizr-', 'mmd'),
    'svg': ('plantuml/c4plantuml', '', 'svg'),
    'png': ('plantuml/c4plantuml', '', 'png'),
}


def timestamp():
    return datetime.now(timezone.utc).isoformat()


def source_fingerprint():
    """No host Git executable or .git mount is needed."""
    digest = hashlib.sha256()
    paths = [ROOT / name for name in ('README.md', 'workspace.dsl', 'model.dsl',
             'compose.yaml', '.env')]
    # Additional root-level entrypoints and include fragments are valid authoring inputs.
    for extension in ('dsl', 'puml', 'pumlinc', 'mmd'):
        paths.extend(ROOT.glob('*.' + extension))
    for tree in ('model', 'views', 'styles', 'uml', 'workspaces', 'documentation',
                 'decisions', 'templates', 'scripts', 'tests', 'ci', 'docker'):
        for directory, directories, files in os.walk(ROOT / tree):
            directories[:] = [name for name in directories if not name.startswith('.')
                              and name not in ('__pycache__', 'node_modules', 'build')]
            paths.extend(Path(directory) / name for name in files
                         if name not in ('workspace.json', 'workspace.json.bak') and not name.endswith('.pyc'))
    for path in sorted(set(paths)):
        if not path.is_file():
            continue
        digest.update(path.relative_to(ROOT).as_posix().encode() + b'\0')
        digest.update(hashlib.sha256(path.read_bytes()).digest())
    return digest.hexdigest()


@contextmanager
def command_lock():
    """One writer per checkout; OS releases the lock if a container is interrupted."""
    BUILD.mkdir(parents=True, exist_ok=True)
    with (BUILD / '.tools.lock').open('a') as stream:
        try:
            fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError as exc:
            raise RuntimeError('Another architecture command is running in this checkout') from exc
        try:
            recover(BUILD)
            yield
        finally:
            fcntl.flock(stream, fcntl.LOCK_UN)


def run_java(arguments, log, timeout=240, check=True):
    log.append('structurizr ' + ' '.join(arguments) + '\n')
    try:
        result = subprocess.run(JAVA + arguments, cwd=ROOT, capture_output=True, text=True,
                                encoding='utf-8', errors='replace', timeout=timeout)
    except subprocess.TimeoutExpired as exc:
        # TimeoutExpired may contain bytes even when subprocess.run uses text=True.
        for output in (exc.stdout, exc.stderr):
            if output:
                log[-1] += output.decode('utf-8', errors='replace') if isinstance(output, bytes) else output
        log[-1] += f'\nTimed out after {exc.timeout} seconds'
        raise
    log[-1] += result.stdout + result.stderr
    if check and result.returncode:
        raise RuntimeError(log[-1][-4000:])
    return result


def inspect_workspace(path, logs):
    """Separate native quality findings from inspector execution failures."""
    result = run_java(['inspect', '-workspace', str(path), '-severity', 'error,warning'],
                      logs, check=False)
    findings, unexpected = [], []
    for line in result.stdout.splitlines():
        if not line.strip():
            continue
        match = re.fullmatch(r'\s*(ERROR|WARNING)\s*\|\s*([\w.-]+)\s*\|\s*(.+)', line)
        if match:
            findings.append(dict(zip(('severity', 'rule', 'message'), match.groups())))
        else:
            unexpected.append(line)
    # The pinned inspector exits with the finding count (limited to a Unix exit
    # byte). A nonzero status with a crash/unknown diagnostic is still a failure.
    if result.returncode and (not findings or unexpected or result.stderr.strip()
                              or result.returncode != len(findings) % 256):
        raise RuntimeError('Inspector execution failed:\n' + logs[-1][-4000:])
    return findings


def inspection_message(finding):
    return f'{finding["severity"]} | {finding["rule"]} | {finding["message"]}'


def inventory():
    file = BUILD / 'artifacts.json'
    return json.loads(file.read_text())['artifacts'] if file.exists() else []


def legacy_files():
    """Recognize the prior managed layout without deleting unrelated historical files."""
    selected = set()
    for metadata in (BUILD / 'c4').rglob('export.json'):
        report = json.loads(metadata.read_text())
        for name in report.get('outputs', []):
            if Path(name).name != name:
                raise ValueError(f'Unsafe legacy output name: {name}')
            selected.add(metadata.parent / name)
        selected.add(metadata)
    for report in (BUILD / 'c4').rglob('validation.json'):
        if 'workspace' in json.loads(report.read_text()):
            for name in ('workspace.json', 'validation.json', 'validation.log', 'export-status.json', 'export.log'):
                selected.add(report.parent / name)
    manifest = BUILD / 'build.json'
    if manifest.exists() and json.loads(manifest.read_text()).get('layout_version') != 2:
        for output in json.loads(manifest.read_text()).get('outputs', []):
            relative = Path(output).relative_to('build')
            if relative.parts[0] in ('c4', 'uml', 'workspaces'):
                selected.add(confined(BUILD, relative))
    cache = BUILD / '.reports/legacy.json'
    if cache.exists():
        selected.update(confined(BUILD, item) for item in json.loads(cache.read_text()))
        selected.add(cache)
    return {p for p in selected if p.is_file()}


def clean_build():
    """Explicitly remove inventory-managed artifacts, preserving unrelated files."""
    if BUILD.resolve() != ROOT.resolve() / 'build':
        raise ValueError('Refusing to clean outside build')
    managed = {confined(BUILD, item['output']) for item in inventory()} | legacy_files()
    for file in managed:
        file.unlink(missing_ok=True)
    for name in ('artifacts.json', 'build.json', 'build.log'):
        (BUILD / name).unlink(missing_ok=True)
    reports = confined(BUILD, '.reports')
    if reports.exists():
        shutil.rmtree(reports)
    prune_empty(BUILD, managed)
    print('Cleaned managed artifacts (preserved local settings, unrelated files and writer lock)', flush=True)


def validate(paths=None, inspections_blocking=True):
    """Native parsing/validation always block; inspection policy is caller-specific."""
    selected = [workspace_path(p) for p in (paths if paths is not None else discover_workspaces())]
    before = source_fingerprint()
    parsed, reports, logs = {}, {}, {}
    BUILD.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='architecture-validate-') as temporary:
        for index, path in enumerate(selected):
            logs[path] = []
            report = {'workspace': path.relative_to(ROOT).as_posix(),
                      'structurizr_version': VERSION, 'source_sha256': before,
                      'inspection_severity': 'error,warning',
                      'inspection_policy': 'strict' if inspections_blocking else 'report-only',
                      'inspection_passed': None, 'inspection_findings': [],
                      'passed': False, 'errors': []}
            reports[path] = report
            try:
                directory = Path(temporary) / str(index)
                directory.mkdir()
                # The native parser resolves includes and workspace extensions.
                run_java(['export', '-workspace', str(path), '-format', 'json', '-output', str(directory)], logs[path])
                files = list(directory.glob('*.json'))
                if len(files) != 1:
                    raise ValueError('Parser did not produce exactly one JSON workspace')
                # Reuse the parsed workspace for both official commands.
                run_java(['validate', '-workspace', str(files[0])], logs[path])
                findings = inspect_workspace(files[0], logs[path])
                report['inspection_findings'] = findings
                report['inspection_passed'] = not findings
                parsed[path] = json.loads(files[0].read_text(encoding='utf-8-sig'))
                report['passed'] = not (inspections_blocking and findings)
                if not report['passed']:
                    report['errors'].append(f'Inspection reported {len(findings)} error/warning findings')
            except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
                report['errors'].append(str(exc))
            report['completed_at'] = timestamp()
        unchanged = before == source_fingerprint()
        for path, report in reports.items():
            if not unchanged:
                report.update(passed=False, errors=report['errors'] + ['Sources changed during validation'])
            directory = output_directory(path)
            directory.mkdir(parents=True, exist_ok=True)
            if report['passed']:
                atomic_json(directory / 'workspace.json', parsed[path])
            atomic_json(directory / 'validation.json', report)
            (directory / 'validation.log').write_text('\n'.join(logs[path] + report['errors']), encoding='utf-8')
            summary = 'PASS' if report['passed'] else 'FAIL'
            if report['inspection_findings']:
                summary += f' ({len(report["inspection_findings"])} inspection findings; {report["inspection_policy"]})'
            print(f'{report["workspace"]}: {summary}', flush=True)
            for finding in report['inspection_findings']:
                print('  ' + inspection_message(finding), flush=True)
            for error in report['errors']:
                print(error, file=sys.stderr)
        return reports


def fresh_workspace(path):
    report = validate([path], inspections_blocking=False)[path]
    if not report['passed']:
        raise ValueError('Validation failed. Previous exports were not updated.')
    raw = json.loads((output_directory(path) / 'workspace.json').read_text(encoding='utf-8'))
    return raw, report


def selected_keys(keys):
    if keys is None:
        return None
    return list(dict.fromkeys([keys] if isinstance(keys, str) else keys))


def select_view(raw, key):
    raw = deepcopy(raw)
    keys = selected_keys(key)
    if keys is not None:
        available = view_keys(raw)
        invalid = [key for key in keys if available.count(key) != 1]
        if invalid:
            raise ValueError('View keys must each identify exactly one existing diagram; unknown or ambiguous: '
                             + ', '.join(repr(key) for key in invalid))
        for kind, views in raw['views'].items():
            if kind.endswith('Views'):
                raw['views'][kind] = [view for view in views if view['key'] in keys]
    # The exporter uses view keys as file names. Reject paths rather than silently renaming them.
    for kind, views in raw['views'].items():
        if kind.endswith('Views'):
            for view in views:
                safe_name(view['key'])
    return raw


def produce_diagrams(raw, format, stage, logs, c4_source=None):
    native_format, _, _ = EXPORT_FORMATS[format]
    atomic_json(stage / 'workspace.json', raw)
    diagrams = stage / 'diagrams'
    if format in ('svg', 'png'):
        if c4_source is None:
            c4_source = stage / 'c4'
            run_java(['export', '-workspace', str(stage / 'workspace.json'), '-format', native_format,
                      '-output', str(c4_source)], logs, timeout=600)
        diagrams.mkdir()
        for key in view_keys(raw):
            render(c4_source / f'structurizr-{key}.puml', diagrams / f'{key}.{format}', logs)
    else:
        run_java(['export', '-workspace', str(stage / 'workspace.json'), '-format', native_format,
                  '-output', str(diagrams)], logs, timeout=600)
    return diagrams


def view_keys(raw):
    return [diagram['key'] for kind, views in raw['views'].items()
            if kind.endswith('Views') for diagram in views]


def stage_export(raw, report, format, view, stage, logs, c4_source=None):
    stage.mkdir(parents=True, exist_ok=True)
    diagrams = produce_diagrams(raw, format, stage, logs, c4_source)
    native_format, prefix, extension = EXPORT_FORMATS[format]
    expected = [diagrams / f'{prefix}{key}.{extension}' for key in view_keys(raw)]
    if not expected or any(not file.is_file() or file.stat().st_size == 0 for file in expected):
        raise ValueError('Exporter did not produce every requested diagram')
    metadata = report | {'format': format, 'native_format': native_format, 'view': view,
                         'outputs': [file.name for file in expected]}
    if format in ('svg', 'png'):
        metadata['renderers'] = renderer_versions()
    atomic_json(diagrams / 'export.json', metadata)
    return diagrams


def artifact(output, source, workspace, format, fingerprint, key=None):
    confined(BUILD, output)
    return {'output': output.as_posix(), 'source': source.relative_to(ROOT).as_posix(),
            'workspace': workspace.relative_to(ROOT).as_posix() if workspace else None,
            'view': key, 'format': format, 'source_sha256': fingerprint,
            'structurizr_version': VERSION if key else None,
            'renderers': renderer_versions() if format in ('svg', 'png') else {},
            'completed_at': timestamp()}


def c4_plan(path, raw, formats, fingerprint):
    mapping = index_views(path, ROOT, view_keys(raw))
    return [artifact(stem.with_suffix(stem.suffix + '.' + EXPORT_FORMATS[format][2]),
                     source, path, format, fingerprint, key)
            for key, (source, stem) in mapping.items() for format in formats]


def check_collisions(entries):
    seen = {}
    for entry in entries:
        output = entry['output']
        folded = output.casefold()
        if folded in seen:
            raise ValueError(f'Diagram output collision: {seen[folded]} and {entry["source"]}: {output}')
        confined(BUILD, output)
        seen[folded] = entry['source']


def stage_c4(path, raw, report, formats, entries, stage, logs):
    replacements = []
    c4_source = None
    for format in formats:
        diagrams = stage_export(raw, report, format, None, stage / format, logs, c4_source)
        if format == 'plantuml':
            c4_source = diagrams
        _, prefix, extension = EXPORT_FORMATS[format]
        for entry in entries:
            if entry['format'] == format:
                source = diagrams / f'{prefix}{entry["view"]}.{extension}'
                entry['output_sha256'] = hashlib.sha256(source.read_bytes()).hexdigest()
                replacements.append((source, BUILD / entry['output']))
        print(f'Generated {path.relative_to(ROOT)}: {format}', flush=True)
    return replacements


def commit_artifacts(entries, retained, replacements, removed, stage):
    check_collisions(entries + retained)
    staged_inventory = stage / 'artifacts.json'
    atomic_json(staged_inventory, {'schema_version': 1,
                'artifacts': sorted(entries + retained, key=lambda item: item['output'])})
    replacements.extend((None, path) for path in sorted(removed)
                        if path not in {destination for _, destination in replacements})
    replacements.append((staged_inventory, BUILD / 'artifacts.json'))
    publish(replacements, stage / 'previous')


def capture_layout(path):
    """Explicitly preserve viewer-authored layout; never put it in the artifact inventory."""
    source = path.with_suffix('.json')
    if not source.is_file():
        raise ValueError(f'Save the workspace in the Structurizr viewer first: {source.relative_to(ROOT)}')
    original = source.read_bytes()
    raw = json.loads(original)
    if not isinstance(raw.get('model'), dict) or not isinstance(raw.get('views'), dict):
        raise ValueError('Saved layout must be a complete Structurizr JSON workspace')
    destination = native_exports.layout_path(path, ROOT, BUILD)
    logs = []
    with staging(BUILD) as stage:
        saved = stage / 'workspace.json'
        saved.write_bytes(original)
        run_java(['validate', '-workspace', str(saved)], logs)
        if source.read_bytes() != original:
            raise ValueError('Viewer workspace changed during capture; save again and retry')
        metadata = stage / 'capture.json'
        atomic_json(metadata, {'workspace': path.relative_to(ROOT).as_posix(),
                    'source': source.relative_to(ROOT).as_posix(), 'captured_at': timestamp(),
                    'layout_sha256': hashlib.sha256(original).hexdigest(), 'structurizr_version': VERSION})
        publish([(saved, destination), (metadata, destination.with_name('capture.json'))], stage / 'previous')
    print(f'Captured layout: {destination.relative_to(ROOT)}', flush=True)


def export(path, format, view=None):
    """Retain the single-workspace Python entrypoint for existing callers."""
    return export_batch([path], format, view)


def export_batch(paths, format, views=None, native=False, frame_duration=3):
    if native:
        require_capability('native')
    paths = [workspace_path(path) for path in paths]
    keys = selected_keys(views)
    command = 'export-native' if native else 'export'
    renderer = 'structurizr' if native else 'c4plantuml'
    statuses, logs = {}, {path: [] for path in paths}
    selection = {'workspaces': [p.relative_to(ROOT).as_posix() for p in paths], 'views': keys}
    batch = {'selection': selection, 'format': format, 'renderer': renderer,
             'passed': False, 'errors': [], 'outputs': [], 'started_at': timestamp()}
    batch_file = BUILD / '.reports' / f'{command}-status.json'
    for path in paths:
        directory = output_directory(path)
        directory.mkdir(parents=True, exist_ok=True)
        statuses[path] = {'workspace': path.relative_to(ROOT).as_posix(), 'format': format,
                          'view': keys[0] if keys and len(keys) == 1 else None, 'views': keys,
                          'renderer': renderer, 'passed': False, 'errors': [], 'outputs': [],
                          'selection': selection, 'started_at': batch['started_at']}
        atomic_json(directory / f'{command}-status.json', statuses[path] | {'in_progress': True})
    atomic_json(batch_file, batch | {'in_progress': True})
    try:
        with staging(BUILD) as stage:
            entries, jobs, layout_inputs = [], {}, {}
            # Preflight every selection before invoking any image/text renderer.
            for path in paths:
                raw, report = fresh_workspace(path)
                status = statuses[path]
                status.update(source_sha256=report['source_sha256'],
                              inspection_findings=report.get('inspection_findings', []))
                selected = select_view(raw, keys)
                workspace_stage = stage / command / path.relative_to(ROOT)
                if native:
                    mapping = index_views(path, ROOT, view_keys(raw))
                    request = native_exports.prepare(path, raw, view_keys(selected), keys is not None,
                        format, frame_duration, ROOT, BUILD, workspace_stage, logs[path], run_java)
                    layout_inputs[path] = request['layout_sha256']
                    status.update({key: request[key] for key in ('layout_sha256', 'skipped_views', 'warnings')})
                    status['frame_duration'] = frame_duration if format == 'gif' else None
                    versions = native_exports.versions()
                    plan = []
                    for key in request['keys']:
                        source, stem = mapping[key]
                        for role in ('diagram', 'key') if format != 'gif' else ('diagram',):
                            output = native_exports.output_path(stem, format, role)
                            entry = artifact(output, source, path, format, report['source_sha256'], key)
                            entry.update(renderer='structurizr', role=role, renderers=versions,
                                         layout_sha256=request['layout_sha256'],
                                         frame_duration=frame_duration if format == 'gif' else None)
                            plan.append(entry)
                    jobs[path] = (request, report, plan, workspace_stage)
                else:
                    plan = [entry for entry in c4_plan(path, raw, [format], report['source_sha256'])
                            if keys is None or entry['view'] in keys]
                    jobs[path] = (selected, report, plan, workspace_stage)
                entries.extend(plan)
            old = inventory()
            replaced = [item for item in old if item['workspace'] in selection['workspaces']
                        and item['view'] is not None and item['format'] == format
                        and (item.get('renderer') == 'structurizr') == native
                        and (keys is None or item['view'] in keys)]
            retained = [item for item in old if item not in replaced]
            check_collisions(entries + retained)
            replacements, generated = [], []
            for path, (request, report, plan, workspace_stage) in jobs.items():
                if native:
                    print(f'Rendering native {format.upper()}: {path.relative_to(ROOT)} '
                          f'({len(request["keys"])} views)', flush=True)
                    results = native_exports.render_native(request, workspace_stage, logs[path], run_java)
                    for entry in plan:
                        result = results.get((entry['view'], entry['role']))
                        if result is None:
                            if entry['role'] == 'key':
                                continue  # Image views have no native diagram key.
                            raise ValueError(f'Native renderer omitted view {entry["view"]}')
                        source, details = result
                        entry.update(details, output_sha256=hashlib.sha256(source.read_bytes()).hexdigest())
                        replacements.append((source, BUILD / entry['output']))
                        generated.append(entry)
                else:
                    replacements.extend(stage_c4(path, request, report, [format], plan, workspace_stage, logs[path]))
                    generated.extend(plan)
            if any(source_fingerprint() != report['source_sha256'] for _, report, _, _ in jobs.values()):
                raise ValueError('Sources changed during export')
            for path, fingerprint in layout_inputs.items():
                if native_exports.layout_fingerprint(path, ROOT, BUILD) != fingerprint:
                    raise ValueError(f'Captured layout changed during export: {path.relative_to(ROOT)}')
            commit_artifacts(generated, retained, replacements,
                             {BUILD / item['output'] for item in replaced}, stage)
        batch.update(passed=True, outputs=[entry['output'] for entry in generated])
        for path, status in statuses.items():
            status.update(passed=True, outputs=[entry['output'] for entry in generated
                                               if entry['workspace'] == status['workspace']])
        print(f'Exported {format.upper()}: {len(generated)} canonical files under build/ (see artifacts.json)', flush=True)
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        batch['errors'].append(str(exc))
        for status in statuses.values():
            status['errors'].append(f'Export batch not published: {exc}')
        raise
    finally:
        for path, status in statuses.items():
            directory = output_directory(path)
            atomic_json(directory / f'{command}-status.json', status | {'in_progress': False, 'completed_at': timestamp()})
            (directory / f'{command}.log').write_text('\n'.join(logs[path] + status['errors']), encoding='utf-8')
        atomic_json(batch_file, batch | {'in_progress': False, 'completed_at': timestamp()})


def discover_uml():
    roots = [ROOT / 'uml', *sorted((ROOT / 'workspaces').rglob('uml'))]
    selected, stems = [], {}
    visited = set()
    for root in roots:
        for source in sorted(root.rglob('*')):
            if not source.is_file() or source.suffix not in ('.puml', '.mmd'):
                continue
            if source in visited:
                continue
            visited.add(source)
            source.resolve().relative_to(ROOT.resolve())
            relative = source.relative_to(ROOT)
            stem = relative.with_suffix('').as_posix().casefold()
            if stem in stems:
                raise ValueError(f'Diagram output collision: {stems[stem]} and {relative}')
            stems[stem] = relative
            selected.append(source)
    return selected


def browser_artifact(item):
    return item.get('view') is None and Path(item['source']).suffix == '.mmd'


def phase_status(phase):
    return {'layout_version': 2, 'handoff_version': 1, 'stage': phase, 'complete': False,
            'passed': False, 'errors': [], 'outputs': [], 'sources': [], 'artifacts': [],
            'inspection_findings': [], 'started_at': timestamp(), 'toolchain': TOOLCHAIN,
            'source_revision': os.environ.get('ARCHITECTURE_SOURCE_REVISION') or None,
            'ci_run': os.environ.get('ARCHITECTURE_CI_RUN') or None}


def write_phase(status, logs, in_progress=False):
    value = status | {'in_progress': in_progress}
    if not in_progress:
        value['completed_at'] = timestamp()
    report = BUILD / '.reports' / f'build-{status["stage"]}.json'
    atomic_json(report, value)
    report.with_suffix('.log').write_text('\n'.join(logs + status['errors']), encoding='utf-8')
    atomic_json(BUILD / 'build.json', value)
    (BUILD / 'build.log').write_text('\n'.join(logs + status['errors']), encoding='utf-8')


def verify_light_handoff():
    """Verify an earlier light build without reparsing DSL or regenerating its files."""
    try:
        return _verify_light_handoff()
    except (KeyError, TypeError, AttributeError) as exc:
        raise ValueError('Malformed lightweight handoff; run tools build first.') from exc


def _verify_light_handoff():
    file = BUILD / '.reports/build-light.json'
    if not file.is_file():
        raise ValueError('Missing lightweight handoff. Run tools build for this checkout/commit first.')
    report = json.loads(file.read_text())
    if (report.get('handoff_version') != 1 or report.get('stage') != 'light'
            or not report.get('passed') or report.get('in_progress')
            or report.get('source_sha256') != source_fingerprint() or report.get('toolchain') != TOOLCHAIN):
        raise ValueError('Lightweight handoff is incompatible, failed or stale; run tools build first.')
    revision = os.environ.get('ARCHITECTURE_SOURCE_REVISION') or None
    if revision and report.get('source_revision') != revision:
        raise ValueError('Lightweight handoff belongs to a different commit; run the light job for this commit.')
    entries = {item['output']: item for item in inventory()}
    if not report.get('artifacts') or report['outputs'] != ['build/' + item['output'] for item in report['artifacts']]:
        raise ValueError('Incomplete lightweight artifact manifest')
    for item in report['artifacts']:
        path = confined(BUILD, item['output'])
        if (entries.get(item['output']) != item or not path.is_file()
                or hashlib.sha256(path.read_bytes()).hexdigest() != item['output_sha256']):
            raise ValueError(f'Lightweight artifact is missing or modified: {item["output"]}')
    if not report.get('reports'):
        raise ValueError('Lightweight handoff is missing its workspace reports')
    for relative, digest in report['reports'].items():
        path = confined(BUILD, relative)
        if not path.is_file() or hashlib.sha256(path.read_bytes()).hexdigest() != digest:
            raise ValueError(f'Lightweight report is missing or modified: {relative}')
    # Re-discover authored paths to verify the deferred plan, including collisions.
    expected = {(p.relative_to(ROOT).as_posix(), p.relative_to(ROOT).with_suffix('.' + f).as_posix(), f)
                for p in discover_uml() if p.suffix == '.mmd' for f in ('svg', 'png')}
    actual = {(item['source'], item['output'], item['format']) for item in report['deferred']}
    if actual != expected or len(actual) != len(report['deferred']):
        raise ValueError('Deferred Mermaid manifest does not match current sources')
    check_collisions(report['artifacts'] + report['deferred'])
    return report, hashlib.sha256(file.read_bytes()).hexdigest()


def build():
    """Publish non-browser diagrams; retain Mermaid outputs for browser completion."""
    require_capability('plantuml')
    status = phase_status('light') | {'deferred': [], 'reports': {}}
    logs = []
    BUILD.mkdir(parents=True, exist_ok=True)
    # Capture legacy inventory before replacing the old attempt manifest.
    legacy = legacy_files()
    if legacy:
        cache = BUILD / '.reports/legacy.json'
        atomic_json(cache, sorted(p.relative_to(BUILD).as_posix() for p in legacy if p != cache))
        legacy.add(cache)
    write_phase(status, logs, in_progress=True)
    try:
        with staging(BUILD) as stage:
            sources = discover_uml()
            reports = validate(inspections_blocking=False)
            status['inspection_findings'] = [finding | {'workspace': report['workspace']}
                                             for report in reports.values()
                                             for finding in report['inspection_findings']]
            logs.extend(f'Inspection {finding["workspace"]}: {inspection_message(finding)}'
                        for finding in status['inspection_findings'])
            if not reports or not all(report['passed'] for report in reports.values()):
                raise ValueError('Validation failed. Previous build artifacts were not updated.')
            fingerprint = next(iter(reports.values()))['source_sha256']
            status.update(source_sha256=fingerprint, structurizr_version=VERSION, renderers=renderer_versions())
            entries, workspaces, possible, possible_native = [], {}, set(), set()
            for path, report in reports.items():
                raw = select_view(json.loads((output_directory(path) / 'workspace.json').read_text()), None)
                plan = c4_plan(path, raw, EXPORT_FORMATS, fingerprint)
                possible.update((item['output'], item['source'], item['workspace'], item['view'], item['format']) for item in plan)
                mapping = index_views(path, ROOT, view_keys(raw))
                for key, (source, stem) in mapping.items():
                    for format in ('svg', 'png', 'gif'):
                        if format == 'gif' and not native_exports.is_animated(raw, key):
                            continue
                        for role in ('diagram', 'key') if format != 'gif' else ('diagram',):
                            possible_native.add((native_exports.output_path(stem, format, role).as_posix(),
                                source.relative_to(ROOT).as_posix(), path.relative_to(ROOT).as_posix(), key, format))
                selected = [item for item in plan if item['format'] != 'mermaid']
                workspaces[path] = (raw, selected)
                entries.extend(selected)
                status['sources'].append(path.relative_to(ROOT).as_posix())
            for source in sources:
                relative = source.relative_to(ROOT)
                owners = [p for p in reports if source.is_relative_to(p.parent)]
                owner = max(owners, key=lambda p: len(p.parts)) if owners else None
                target = status['deferred'] if source.suffix == '.mmd' else entries
                target.extend(artifact(relative.with_suffix('.' + format), source, owner, format, fingerprint)
                              for format in ('svg', 'png'))
                status['sources'].append(relative.as_posix())
            old = inventory()
            replaced_paths = {item['output'] for item in entries}
            retained = [item for item in old if item['output'] not in replaced_paths
                        and (browser_artifact(item) or (item.get('renderer') == 'structurizr' and
                             (item['output'], item['source'], item['workspace'], item['view'], item['format']) in possible_native)
                            or (item.get('renderer') != 'structurizr' and item['format'] == 'mermaid' and
                                (item['output'], item['source'], item['workspace'], item['view'], item['format']) in possible))]
            check_collisions(entries + status['deferred'])
            check_collisions(entries + retained)
            replacements = []
            for path, (raw, plan) in workspaces.items():
                replacements.extend(stage_c4(path, raw, reports[path], ('plantuml', 'svg', 'png'),
                                    plan, stage / 'c4' / path.relative_to(ROOT), logs))
            for entry in entries:
                if entry['view'] is not None:
                    continue
                output = stage / 'authored' / entry['output']
                render(ROOT / entry['source'], output, logs)
                entry['output_sha256'] = hashlib.sha256(output.read_bytes()).hexdigest()
                replacements.append((output, BUILD / entry['output']))
                print(f'Generated {entry["source"]}: {entry["format"]}', flush=True)
            if source_fingerprint() != fingerprint:
                raise ValueError('Sources changed during build')
            kept = {item['output'] for item in entries + retained}
            removed = {BUILD / item['output'] for item in old if item['output'] not in kept} | legacy
            # Deleted workspace reports must not linger as apparently active workspaces.
            report_directories = {output_directory(path) for path in reports}
            for file in (BUILD / '.reports').rglob('validation.json'):
                if file.parent not in report_directories:
                    removed.update(p for p in file.parent.iterdir() if p.is_file())
            status['outputs'] = ['build/' + item['output'] for item in entries]
            status['artifacts'] = entries
            for directory in report_directories:
                for name in ('workspace.json', 'validation.json', 'validation.log'):
                    file = directory / name
                    # Keep handoff reports separate from the latest ad-hoc export
                    # diagnostics, which native/manual commands may overwrite.
                    relative = Path('.reports/light') / directory.relative_to(BUILD / '.reports') / name
                    frozen = stage / 'reports' / relative
                    frozen.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copyfile(file, frozen)
                    status['reports'][relative.as_posix()] = hashlib.sha256(frozen.read_bytes()).hexdigest()
                    replacements.append((frozen, confined(BUILD, relative)))
            removed.update(file for file in (BUILD / '.reports/light').rglob('*')
                           if file.is_file() and file.relative_to(BUILD).as_posix() not in status['reports'])
            commit_artifacts(entries, retained, replacements, removed, stage)
        status['passed'] = True
        print(f'Built lightweight diagrams: build/build.json ({len(status["deferred"]) // 2} Mermaid sources deferred; '
              f'{len(status["inspection_findings"])} inspection findings)', flush=True)
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        status['errors'].append(str(exc))
        status['outputs'] = []
        raise
    finally:
        write_phase(status, logs)


def build_browser():
    """Complete only deferred Mermaid outputs from a verified light handoff."""
    status, logs = phase_status('browser'), []
    write_phase(status, logs, in_progress=True)
    try:
        require_capability('mermaid')
        with staging(BUILD) as stage:
            light, digest = verify_light_handoff()
            status.update(source_sha256=light['source_sha256'], light_sha256=digest,
                          source_revision=light['source_revision'], renderers=renderer_versions(),
                          inspection_findings=light['inspection_findings'])
            entries = deepcopy(light['deferred'])
            for item in entries:
                item.update(renderers=renderer_versions(), completed_at=timestamp())
            old = inventory()
            retained = [item for item in old if not browser_artifact(item)]
            check_collisions(entries + retained)
            replacements = []
            for item in entries:
                output = stage / 'browser' / item['output']
                render(ROOT / item['source'], output, logs)
                item['output_sha256'] = hashlib.sha256(output.read_bytes()).hexdigest()
                replacements.append((output, BUILD / item['output']))
                print(f'Generated {item["source"]}: {item["format"]}', flush=True)
            if verify_light_handoff()[1] != digest:
                raise ValueError('Lightweight handoff changed during browser rendering')
            removed = {BUILD / item['output'] for item in old if browser_artifact(item)}
            commit_artifacts(entries, retained, replacements, removed, stage)
            status.update(artifacts=entries, outputs=light['outputs'] + ['build/' + item['output'] for item in entries],
                          sources=light['sources'], passed=True, complete=True)
        print('Completed ordinary diagrams: build/build.json (native exports remain on demand)', flush=True)
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        status['errors'].append(str(exc))
        status.update(passed=False, complete=False, outputs=[])
        raise
    finally:
        write_phase(status, logs)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='command', required=True)
    commands.add_parser('build', help='Validate and render C4/PlantUML; defer Mermaid images')
    commands.add_parser('build-browser', help='Complete Mermaid images from a matching successful lightweight build')
    for name in ('validate', 'export', 'export-native', 'capture-layout'):
        command = commands.add_parser(name)
        selection = command.add_mutually_exclusive_group()
        selection.add_argument('--workspace', help='Workspace DSL path (exports default to workspace.dsl)')
        if name in ('export', 'export-native'):
            selection.add_argument('--all-workspaces', action='store_true', help='Export every discovered workspace')
            command.add_argument('--format', choices=EXPORT_FORMATS if name == 'export' else ('svg', 'png', 'gif'),
                                 default='plantuml' if name == 'export' else 'svg')
            command.add_argument('--view', action='append', help='View key; repeat to select several (default: all views)')
        if name == 'export':
            command.add_argument('--clean', action='store_true',
                                 help='Clear inventory-managed outputs before export, preserving local settings and unrelated files')
        if name == 'export-native':
            command.add_argument('--frame-duration', type=float, help='GIF seconds per frame (default: 3)')
    args = parser.parse_args()
    if args.command in ('export', 'export-native') and args.all_workspaces and args.view:
        parser.error('--all-workspaces cannot be combined with --view; select one workspace')
    if args.command == 'export-native' and args.frame_duration is not None:
        if args.format != 'gif':
            parser.error('--frame-duration applies only to --format gif')
        if not math.isfinite(args.frame_duration) or not 0.01 <= args.frame_duration <= 655.35:
            parser.error('--frame-duration must be between 0.01 and 655.35 seconds')
    try:
        if not Path('/usr/local/structurizr.war').is_file():
            raise RuntimeError('Run this command through the Docker Compose tools service')
        with command_lock():
            if args.command == 'validate':
                return 0 if all(r['passed'] for r in validate([args.workspace] if args.workspace else None).values()) else 1
            if args.command == 'build':
                build()
                return 0
            if args.command == 'build-browser':
                build_browser()
                return 0
            if args.command == 'capture-layout':
                capture_layout(workspace_path(args.workspace or REFERENCE))
                return 0
            if args.command == 'export' and args.clean:
                clean_build()
            selected = discover_workspaces() if args.all_workspaces else [workspace_path(args.workspace or REFERENCE)]
            export_batch(selected, args.format, args.view, native=args.command == 'export-native',
                         frame_duration=round(getattr(args, 'frame_duration', None) or 3, 2))
        return 0
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        print(str(exc), file=sys.stderr)
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
