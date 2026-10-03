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
    paths = [ROOT / name for name in ('README.md', 'AGENTS.md', 'workspace.dsl', 'model.dsl',
             'compose.yaml', 'Dockerfile', '.env', '.dockerignore')]
    # Additional root-level entrypoints and include fragments are valid authoring inputs.
    for extension in ('dsl', 'puml', 'pumlinc', 'mmd'):
        paths.extend(ROOT.glob('*.' + extension))
    for tree in ('model', 'views', 'styles', 'uml', 'workspaces', 'documentation',
                 'decisions', 'templates', 'scripts', 'tests'):
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


def atomic_json(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = None
    try:
        with tempfile.NamedTemporaryFile(mode='w', encoding='utf-8', dir=path.parent, delete=False) as stream:
            temporary = Path(stream.name)
            json.dump(value, stream, indent=2)
            stream.write('\n')
        os.replace(temporary, path)
    finally:
        if temporary is not None:
            temporary.unlink(missing_ok=True)


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


def clean_build():
    """Clear generated architecture output while holding the checkout writer lock."""
    expected = ROOT.resolve() / 'build'
    if BUILD.resolve() != expected:
        raise ValueError('Refusing to clean outside build')
    for path in BUILD.iterdir():
        # Keep the locked inode and optional user-authored Compose settings.
        if path.name not in ('c4', 'uml', 'workspaces', 'build.json', 'build.log'):
            continue
        if path.is_symlink() or not path.is_dir():
            path.unlink()
        else:
            shutil.rmtree(path)
    print('Cleaned current architecture output (preserved local.env, legacy outputs and command lock)', flush=True)


def validate(paths=None):
    """Delegate parsing, validation and inspection policy entirely to Structurizr."""
    selected = [workspace_path(p) for p in (paths if paths is not None else discover_workspaces())]
    before = source_fingerprint()
    parsed, reports, logs = {}, {}, {}
    BUILD.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='validate-', dir=BUILD) as temporary:
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
                if not view['key'] or any(char in view['key'] for char in '/\\:') or view['key'] in ('.', '..'):
                    raise ValueError('Diagram keys used for export must be safe file names')
    return raw


def publish(replacements, backup_root):
    """Publish a set of staged directories/files, rolling back on a failed rename."""
    backups, installed = [], []
    try:
        for index, (source, destination) in enumerate(replacements):
            destination.parent.mkdir(parents=True, exist_ok=True)
            backup = backup_root / str(index)
            if destination.exists():
                destination.rename(backup)
                backups.append((backup, destination))
            source.rename(destination)
            installed.append(destination)
    except OSError:
        for destination in reversed(installed):
            if destination.is_dir():
                shutil.rmtree(destination)
            else:
                destination.unlink()
        for backup, destination in reversed(backups):
            backup.rename(destination)
        raise


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


def export(path, format, view=None):
    directory = output_directory(path)
    directory.mkdir(parents=True, exist_ok=True)
    status = {'workspace': path.relative_to(ROOT).as_posix(), 'format': format, 'view': view,
              'passed': False, 'errors': []}
    atomic_json(directory / 'export-status.json', status | {'in_progress': True, 'started_at': timestamp()})
    logs = []
    try:
        raw, report = fresh_workspace(path)
        raw = select_view(raw, view)
        selection = 'all' if view is None else 'view-' + hashlib.sha256(view.encode()).hexdigest()[:12]
        destination = directory / 'exports' / selection / format
        with tempfile.TemporaryDirectory(prefix='export-', dir=BUILD) as temporary:
            stage = Path(temporary)
            diagrams = stage_export(raw, report, format, view, stage, logs)
            if source_fingerprint() != report['source_sha256']:
                raise ValueError('Sources changed during export')
            backup = stage / 'previous'
            backup.mkdir()
            publish([(diagrams, destination)], backup)
        status.update(passed=True, source_sha256=report['source_sha256'])
        print(f'Exported {format.upper()}: {destination.relative_to(ROOT)}', flush=True)
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        status['errors'].append(str(exc))
        raise
    finally:
        atomic_json(directory / 'export-status.json', status | {'in_progress': False, 'completed_at': timestamp()})
        (directory / 'export.log').write_text('\n'.join(logs + status['errors']), encoding='utf-8')


def discover_uml():
    roots = [ROOT / 'uml', *sorted((ROOT / 'workspaces').rglob('uml'))]
    selected, stems = [], {}
    for root in roots:
        for source in sorted(root.rglob('*')):
            if not source.is_file() or source.suffix not in ('.puml', '.mmd'):
                continue
            source.resolve().relative_to(ROOT.resolve())
            relative = source.relative_to(ROOT)
            stem = relative.with_suffix('').as_posix().casefold()
            if stem in stems:
                raise ValueError(f'Diagram output collision: {stems[stem]} and {relative}')
            stems[stem] = relative
            selected.append(source)
    return selected


def build():
    """Validate once, stage every image/text export, then publish the complete build."""
    status = {'passed': False, 'errors': [], 'outputs': [], 'sources': []}
    logs = []
    BUILD.mkdir(parents=True, exist_ok=True)
    atomic_json(BUILD / 'build.json', status | {'in_progress': True, 'started_at': timestamp()})
    try:
        sources = discover_uml()
        reports = validate()
        if not reports or not all(report['passed'] for report in reports.values()):
            raise ValueError('Validation failed. Previous build artifacts were not updated.')
        fingerprint = next(iter(reports.values()))['source_sha256']
        status.update(source_sha256=fingerprint, structurizr_version=VERSION, renderers=renderer_versions())
        with tempfile.TemporaryDirectory(prefix='build-', dir=BUILD) as temporary:
            stage = Path(temporary)
            replacements = []
            for index, (path, report) in enumerate(reports.items()):
                raw = select_view(json.loads((output_directory(path) / 'workspace.json').read_text()), None)
                status['sources'].append(path.relative_to(ROOT).as_posix())
                c4_source = None
                for format in ('plantuml', 'svg', 'png'):
                    diagrams = stage_export(raw, report, format, None, stage / str(index) / format, logs, c4_source)
                    if format == 'plantuml':
                        c4_source = diagrams
                    destination = output_directory(path) / 'exports/all' / format
                    replacements.append((diagrams, destination))
                    status['outputs'].extend((destination / p.name).relative_to(ROOT).as_posix()
                                             for p in sorted(diagrams.iterdir()))
                    print(f'Built {path.relative_to(ROOT)}: {format}', flush=True)
            # Mirror only authored UML outputs here; C4 artifacts have their own namespace.
            authored = stage / 'authored'
            for name in ('uml', 'workspaces'):
                (authored / name).mkdir(parents=True)
                replacements.append((authored / name, BUILD / name))
            for source in sources:
                relative = source.relative_to(ROOT)
                status['sources'].append(relative.as_posix())
                for format in ('svg', 'png'):
                    output = (authored / relative).with_suffix('.' + format)
                    render(source, output, logs)
                    status['outputs'].append((BUILD / relative).with_suffix('.' + format).relative_to(ROOT).as_posix())
                print(f'Built {relative}: svg, png', flush=True)
            if source_fingerprint() != fingerprint:
                raise ValueError('Sources changed during build')
            backup = stage / 'previous'
            backup.mkdir()
            publish(replacements, backup)
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
                                 help='Clear current diagram outputs before export, preserving local.env and legacy outputs')
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
