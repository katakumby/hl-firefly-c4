"""Immutable completed runs, atomic status publication and cross-process locks."""
from contextlib import contextmanager
from datetime import datetime, timezone
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import time
import uuid
from workspace_paths import ROOT, BUILD, output_directory


def timestamp():
    return datetime.now(timezone.utc).isoformat()


def atomic_json(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, temporary = tempfile.mkstemp(dir=path.parent, prefix='.' + path.name, suffix='.tmp')
    try:
        with os.fdopen(fd, 'w', encoding='utf-8', newline='\n') as stream:
            json.dump(value, stream, indent=2)
            stream.write('\n')
            stream.flush()
            os.fsync(stream.fileno())
        # Windows readers can briefly hold a handle that disallows replacement.
        for attempt in range(20):
            try:
                os.replace(temporary, path)
                break
            except PermissionError:
                if attempt == 19:
                    raise
                time.sleep(0.05)
    finally:
        Path(temporary).unlink(missing_ok=True)


@contextmanager
def file_lock(path):
    """OS locks release on process exit; the persistent file is not an owner marker."""
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('a+b') as stream:
        stream.seek(0, 2)
        if stream.tell() == 0:
            stream.write(b'0')
            stream.flush()
        stream.seek(0)
        try:
            if os.name == 'nt':
                import msvcrt
                msvcrt.locking(stream.fileno(), msvcrt.LK_NBLCK, 1)
            else:
                import fcntl
                fcntl.flock(stream.fileno(), fcntl.LOCK_EX | fcntl.LOCK_NB)
        except OSError as exc:
            raise RuntimeError(f'Another process owns {path}; retry when it finishes') from exc
        try:
            yield
        finally:
            stream.seek(0)
            if os.name == 'nt':
                msvcrt.locking(stream.fileno(), msvcrt.LK_UNLCK, 1)
            else:
                fcntl.flock(stream.fileno(), fcntl.LOCK_UN)


def new_run(directory):
    directory = Path(directory)
    run_id = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S%fZ-') + uuid.uuid4().hex[:8]
    run = directory / 'runs' / run_id
    (run / 'reports').mkdir(parents=True)
    if any((directory / name).exists() for name in ('workspace.json', 'model-catalog.json', 'parsed')):
        (directory / 'HISTORICAL-OUTPUTS.md').write_text(
            '# Historical flat outputs\n\nFiles outside `runs/` predate isolated publication. '
            'They are retained, no longer updated, and must not be used as current input. '
            'Resolve the latest successful run through `status.json`.\n', encoding='utf-8')
    return run


def read_status(directory):
    path = Path(directory) / 'status.json'
    return json.loads(path.read_text(encoding='utf-8')) if path.exists() else {}


def resolve_run(directory, successful=True):
    directory = Path(directory).resolve()
    status = read_status(directory)
    entry = status.get('last_successful' if successful else 'latest_attempt')
    if not entry:
        raise ValueError(f'No {"successful" if successful else "completed"} run at {directory}; run validation first')
    run = (directory / 'runs' / entry['id']).resolve()
    if run.parent != directory / 'runs':
        raise ValueError('Run manifest escapes its workspace directory')
    manifest = json.loads((run / 'reports/run.json').read_text(encoding='utf-8'))
    if successful and not manifest['passed']:
        raise ValueError('Successful-run pointer references a failed run')
    return run, manifest


def successful_run(workspace):
    return resolve_run(output_directory(workspace))[0]


def publish(directory, run, manifest):
    """Caller holds the workspace lock; status is the only mutable run selector."""
    directory, run = Path(directory), Path(run)
    atomic_json(run / 'reports/run.json', manifest)
    old = read_status(directory)
    entry = {key: manifest[key] for key in ('passed', 'completed_at', 'source_sha256') if key in manifest}
    entry['id'] = run.name
    status = {'schema_version': 1, 'workspace': manifest['workspace'], 'latest_attempt': entry,
              'last_successful': entry if manifest['passed'] else old.get('last_successful')}
    atomic_json(directory / 'status.json', status)


def active_preview_runs():
    result = subprocess.run(['docker', 'ps', '--filter', f'label=com.dlt-architecture.root={ROOT}',
                             '--format', '{{.Label "com.dlt-architecture.run"}}'],
                            capture_output=True, text=True, timeout=20)
    if result.returncode:
        raise RuntimeError('Cannot determine active preview runs; retention skipped')
    return set(result.stdout.split())


def retain_runs(directory, protected=(), keep=5):
    """Only remove completed runs owned by this store, never historical outputs."""
    directory = Path(directory).resolve()
    directory.relative_to(BUILD.resolve())
    runs = directory / 'runs'
    status = read_status(directory)
    protected = set(protected) | {entry['id'] for entry in
        (status.get('latest_attempt'), status.get('last_successful')) if entry}
    completed = sorted((p for p in runs.iterdir() if p.is_dir() and not p.is_symlink()
                        and (p / 'reports/run.json').is_file()), reverse=True)
    protected.update(p.name for p in completed[:keep])
    for path in completed:
        if path.name not in protected:
            if path.resolve().parent != runs or path.is_symlink():
                raise ValueError('Unsafe retention target')
            shutil.rmtree(path)
