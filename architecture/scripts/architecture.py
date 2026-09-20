"""Container-only commands: validate and export (C4-PlantUML by default). Standard library only."""
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

from workspace_paths import ROOT, ARCHITECTURE, BUILD, REFERENCE, VERSION, discover_workspaces, output_directory, workspace_path

JAVA = ['java', '-Dio.netty.noUnsafe=true', '--enable-native-access=ALL-UNNAMED', '-jar', '/usr/local/structurizr.war']
# Native exporter, filename prefix and extension for each public export format.
EXPORT_FORMATS = {
    'plantuml': ('plantuml/c4plantuml', 'structurizr-', 'puml'),
    'mermaid': ('mermaid', 'structurizr-', 'mmd'),
    'svg': ('svg', '', 'svg'),
    'png': ('png', '', 'png'),
}


def timestamp():
    return datetime.now(timezone.utc).isoformat()


def source_fingerprint():
    """No host Git executable or .git mount is needed."""
    digest = hashlib.sha256()
    paths = [ROOT / 'README.md', *ARCHITECTURE.rglob('*')]
    for path in sorted(paths):
        if not path.is_file() or path.is_relative_to(ARCHITECTURE / 'references/legacy'):
            continue
        if '__pycache__' in path.parts or '.structurizr' in path.parts or path.suffix == '.pyc':
            continue
        if path.name in ('workspace.json', 'workspace.json.bak'):
            continue
        digest.update(path.relative_to(ROOT).as_posix().encode() + b'\0')
        digest.update(hashlib.sha256(path.read_bytes()).digest())
    return digest.hexdigest()


def atomic_json(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode='w', encoding='utf-8', dir=path.parent, delete=False) as stream:
        temporary = Path(stream.name)
        json.dump(value, stream, indent=2)
        stream.write('\n')
    try:
        os.replace(temporary, path)
    finally:
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
    result = subprocess.run(JAVA + arguments, cwd=ROOT, capture_output=True, text=True,
                            encoding='utf-8', errors='replace', timeout=timeout)
    log.append('structurizr ' + ' '.join(arguments) + '\n' + result.stdout + result.stderr)
    if result.returncode:
        raise RuntimeError(log[-1][-4000:])
    return result


def clean_build():
    """Clear generated architecture output while holding the checkout writer lock."""
    expected = ROOT.resolve() / 'build' / 'architecture'
    if BUILD.resolve() != expected:
        raise ValueError('Refusing to clean outside build/architecture')
    for path in BUILD.iterdir():
        # Keep the locked inode and optional user-authored Compose settings.
        if path.name in ('.tools.lock', 'local.env'):
            continue
        if path.is_symlink() or not path.is_dir():
            path.unlink()
        else:
            shutil.rmtree(path)
    print('Cleaned build/architecture/ (preserved local.env and command lock)', flush=True)


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
            (directory / 'validation.log').write_text('\n'.join(logs.get(path, []) + report['errors']), encoding='utf-8')
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


def export(path, format, view=None):
    native_format, prefix, extension = EXPORT_FORMATS[format]
    raw, report = fresh_workspace(path)
    raw = select_view(raw, view)
    # Keep each requested selection separate so an individual export cannot erase a full set.
    selection = 'all' if view is None else 'view-' + hashlib.sha256(view.encode()).hexdigest()[:12]
    destination = output_directory(path) / 'exports' / selection / format
    destination.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='export-', dir=BUILD) as temporary:
        stage = Path(temporary)
        atomic_json(stage / 'workspace.json', raw)
        logs = []
        try:
            run_java(['export', '-workspace', str(stage / 'workspace.json'), '-format', native_format,
                      '-output', str(stage / 'diagrams')], logs, timeout=600)
            # Native text exporters prefix filenames; image exports use bare view keys.
            expected = [stage / 'diagrams' / (prefix + diagram['key'] + '.' + extension)
                        for kind, views in raw['views'].items() if kind.endswith('Views') for diagram in views]
            if not expected or any(not diagram.is_file() or diagram.stat().st_size == 0 for diagram in expected):
                raise ValueError('Exporter did not produce every requested diagram')
            if source_fingerprint() != report['source_sha256']:
                raise ValueError('Sources changed during export')
            atomic_json(stage / 'diagrams/export.json', report | {
                'format': format, 'native_format': native_format, 'view': view,
            })
            backup = stage / 'previous'
            if destination.exists():
                destination.rename(backup)
            try:
                (stage / 'diagrams').rename(destination)
            except OSError:
                if backup.exists():
                    backup.rename(destination)
                raise
        finally:
            (output_directory(path) / 'export.log').write_text('\n'.join(logs), encoding='utf-8')
    print(f'Exported {format.upper()}: {destination.relative_to(ROOT)}')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='command', required=True)
    for name in ('validate', 'export'):
        command = commands.add_parser(name)
        command.add_argument('--workspace', default=None if name == 'validate' else str(REFERENCE))
        if name == 'export':
            command.add_argument('--format', choices=EXPORT_FORMATS, default='plantuml',
                                 help='Output format (default: plantuml using C4-PlantUML; svg/png use the native browser renderer)')
            command.add_argument('--view', help='Export only this view key (default: all views)')
            command.add_argument('--clean', action='store_true',
                                 help='Clear build/architecture before export, preserving local.env')
    args = parser.parse_args()
    try:
        if not Path('/usr/local/structurizr.war').is_file():
            raise RuntimeError('Run this command through the Docker Compose tools service')
        with command_lock():
            if args.command == 'validate':
                return 0 if all(r['passed'] for r in validate([args.workspace] if args.workspace else None).values()) else 1
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
