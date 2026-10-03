"""Container-only commands: validate, export and build (C4-PlantUML by default). Standard library only."""
import argparse
from contextlib import contextmanager
from copy import deepcopy
from datetime import datetime, timezone
import fcntl
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

from workspace_paths import ROOT, BUILD, REFERENCE, VERSION, discover_workspaces, output_directory, workspace_path
from diagram_renderers import render, renderer_versions
from view_sources import index_views, safe_name
from artifact_store import atomic_json, staging, publish, recover, confined, prune_empty

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


def run_java(arguments, log, timeout=240):
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
    if result.returncode:
        raise RuntimeError(log[-1][-4000:])


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


def validate(paths=None):
    """Delegate parsing, validation and inspection policy entirely to Structurizr."""
    selected = [workspace_path(p) for p in (paths if paths is not None else discover_workspaces())]
    before = source_fingerprint()
    parsed, reports, logs = {}, {}, {}
    BUILD.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='architecture-validate-') as temporary:
        for index, path in enumerate(selected):
            logs[path] = []
            report = {'workspace': path.relative_to(ROOT).as_posix(),
                      'structurizr_version': VERSION, 'source_sha256': before,
                      'inspection_severity': 'error,warning', 'passed': False, 'errors': []}
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
                run_java(['inspect', '-workspace', str(files[0]), '-severity', 'error,warning'], logs[path])
                parsed[path] = json.loads(files[0].read_text(encoding='utf-8-sig'))
                report['passed'] = True
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
            print(f'{report["workspace"]}: {"PASS" if report["passed"] else "FAIL"}', flush=True)
            for error in report['errors']:
                print(error, file=sys.stderr)
        return reports


def fresh_workspace(path):
    report = validate([path])[path]
    if not report['passed']:
        raise ValueError('Validation failed. Previous exports were not updated.')
    raw = json.loads((output_directory(path) / 'workspace.json').read_text(encoding='utf-8'))
    return raw, report


def select_view(raw, key):
    raw = deepcopy(raw)
    if key is not None:
        count = 0
        for kind, views in raw['views'].items():
            if kind.endswith('Views'):
                selected = [view for view in views if view['key'] == key]
                count += len(selected)
                raw['views'][kind] = selected
        if count != 1:
            raise ValueError('View key must identify exactly one existing diagram')
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


def export(path, format, view=None):
    directory = output_directory(path)
    directory.mkdir(parents=True, exist_ok=True)
    status = {'workspace': path.relative_to(ROOT).as_posix(), 'format': format, 'view': view,
              'passed': False, 'errors': []}
    atomic_json(directory / 'export-status.json', status | {'in_progress': True, 'started_at': timestamp()})
    logs = []
    try:
        with staging(BUILD) as stage:
            raw, report = fresh_workspace(path)
            # Index the whole workspace before selection, cross-checking native keys.
            plan = c4_plan(path, raw, [format], report['source_sha256'])
            raw = select_view(raw, view)
            entries = [entry for entry in plan if view is None or entry['view'] == view]
            old = inventory()
            replaced = [item for item in old if item['workspace'] == status['workspace']
                        and item['view'] is not None and item['format'] == format
                        and (view is None or item['view'] == view)]
            retained = [item for item in old if item not in replaced]
            check_collisions(entries + retained)
            replacements = stage_c4(path, raw, report, [format], entries, stage / 'c4', logs)
            if source_fingerprint() != report['source_sha256']:
                raise ValueError('Sources changed during export')
            commit_artifacts(entries, retained, replacements,
                             {BUILD / item['output'] for item in replaced}, stage)
        status.update(passed=True, source_sha256=report['source_sha256'],
                      outputs=[item['output'] for item in entries])
        print(f'Exported {format.upper()}: {len(entries)} canonical files under build/ (see artifacts.json)', flush=True)
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        status['errors'].append(str(exc))
        raise
    finally:
        atomic_json(directory / 'export-status.json', status | {'in_progress': False, 'completed_at': timestamp()})
        (directory / 'export.log').write_text('\n'.join(logs + status['errors']), encoding='utf-8')


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


def build():
    """Validate and stage everything before changing any published diagram."""
    status = {'layout_version': 2, 'passed': False, 'errors': [], 'outputs': [], 'sources': []}
    logs = []
    BUILD.mkdir(parents=True, exist_ok=True)
    # Capture legacy inventory before replacing the old attempt manifest.
    legacy = legacy_files()
    if legacy:
        cache = BUILD / '.reports/legacy.json'
        atomic_json(cache, sorted(p.relative_to(BUILD).as_posix() for p in legacy if p != cache))
        legacy.add(cache)
    atomic_json(BUILD / 'build.json', status | {'in_progress': True, 'started_at': timestamp()})
    try:
        with staging(BUILD) as stage:
            sources = discover_uml()
            reports = validate()
            if not reports or not all(report['passed'] for report in reports.values()):
                raise ValueError('Validation failed. Previous build artifacts were not updated.')
            fingerprint = next(iter(reports.values()))['source_sha256']
            status.update(source_sha256=fingerprint, structurizr_version=VERSION, renderers=renderer_versions())
            entries, workspaces, possible = [], {}, set()
            for path, report in reports.items():
                raw = select_view(json.loads((output_directory(path) / 'workspace.json').read_text()), None)
                plan = c4_plan(path, raw, EXPORT_FORMATS, fingerprint)
                possible.update((item['output'], item['source'], item['workspace'], item['view'], item['format']) for item in plan)
                selected = [item for item in plan if item['format'] != 'mermaid']
                workspaces[path] = (raw, selected)
                entries.extend(selected)
                status['sources'].append(path.relative_to(ROOT).as_posix())
            for source in sources:
                relative = source.relative_to(ROOT)
                owners = [p for p in reports if source.is_relative_to(p.parent)]
                owner = max(owners, key=lambda p: len(p.parts)) if owners else None
                entries.extend(artifact(relative.with_suffix('.' + format), source, owner, format, fingerprint)
                               for format in ('svg', 'png'))
                status['sources'].append(relative.as_posix())
            old = inventory()
            retained = [item for item in old if item['format'] == 'mermaid'
                        and (item['output'], item['source'], item['workspace'], item['view'], item['format']) in possible]
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
            commit_artifacts(entries, retained, replacements, removed, stage)
        status['passed'] = True
        print('Built all diagrams: build/build.json', flush=True)
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        status['errors'].append(str(exc))
        status['outputs'] = []
        raise
    finally:
        atomic_json(BUILD / 'build.json', status | {'in_progress': False, 'completed_at': timestamp()})
        (BUILD / 'build.log').write_text('\n'.join(logs + status['errors']), encoding='utf-8')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='command', required=True)
    commands.add_parser('build', help='Validate and render every C4 and standalone UML diagram as SVG and PNG')
    for name in ('validate', 'export'):
        command = commands.add_parser(name)
        command.add_argument('--workspace', default=None if name == 'validate' else str(REFERENCE))
        if name == 'export':
            command.add_argument('--format', choices=EXPORT_FORMATS, default='plantuml',
                                 help='Output format (default: plantuml using C4-PlantUML; svg/png render C4-PlantUML)')
            command.add_argument('--view', help='Export only this view key (default: all views)')
            command.add_argument('--clean', action='store_true',
                                 help='Clear inventory-managed outputs before export, preserving local settings and unrelated files')
    args = parser.parse_args()
    try:
        if not Path('/usr/local/structurizr.war').is_file():
            raise RuntimeError('Run this command through the Docker Compose tools service')
        with command_lock():
            if args.command == 'validate':
                return 0 if all(r['passed'] for r in validate([args.workspace] if args.workspace else None).values()) else 1
            if args.command == 'build':
                build()
                return 0
            path = workspace_path(args.workspace)
            if args.clean:
                clean_build()
            export(path, args.format, args.view)
        return 0
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        print(str(exc), file=sys.stderr)
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
