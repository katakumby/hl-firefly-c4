"""File-level publication with an on-disk rollback journal and bounded scratch space."""
from contextlib import contextmanager
import json
import os
from pathlib import Path
import shutil


def atomic_json(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_name(path.name + '.tmp')
    try:
        with temporary.open('w', encoding='utf-8') as stream:
            json.dump(value, stream, indent=2)
            stream.write('\n')
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, path)
    finally:
        temporary.unlink(missing_ok=True)


def confined(build, relative):
    relative = Path(relative)
    if relative.is_absolute() or '..' in relative.parts or not relative.parts:
        raise ValueError(f'Unsafe artifact path: {relative}')
    path = build / relative
    # Refuse symlink destinations/ancestors even when they point within build.
    for item in (path, *path.parents):
        if item == build.parent:
            break
        if item.is_symlink():
            raise ValueError(f'Symlink in artifact destination: {path}')
    path.resolve().relative_to(build.resolve())
    return path


def remove(path):
    if path.is_dir():
        shutil.rmtree(path)
    else:
        path.unlink(missing_ok=True)


def prune_empty(build, paths=()):
    # Only ancestors of managed files are candidates; preserve unrelated empty folders.
    directories = set()
    for file in paths:
        for parent in file.parents:
            if parent == build:
                break
            parent.relative_to(build)
            directories.add(parent)
    for path in sorted(directories, key=lambda p: len(p.parts), reverse=True):
        if not path.is_symlink():
            try:
                path.rmdir()
            except OSError:
                pass


def recover(build):
    stage = confined(build, '.staging')
    journal = stage / 'publication.json'
    affected = []
    if journal.exists():
        state = json.loads(journal.read_text())
        affected = [confined(build, op['destination']) for op in state['operations']]
        if state['state'] != 'committed':
            # Copy, do not consume backups: recovery itself may be interrupted.
            for operation in reversed(state['operations']):
                destination = confined(build, operation['destination'])
                if operation['previous']:
                    backup = confined(stage / 'previous', operation['destination'])
                    destination.parent.mkdir(parents=True, exist_ok=True)
                    temporary = destination.with_name(destination.name + '.restore')
                    shutil.copy2(backup, temporary)
                    os.replace(temporary, destination)
                else:
                    destination.unlink(missing_ok=True)
    if stage.exists():
        shutil.rmtree(stage)
    prune_empty(build, affected)


@contextmanager
def staging(build):
    # Caller holds the checkout writer lock. Recover before discarding any backups.
    recover(build)
    stage = build / '.staging'
    stage.mkdir(parents=True)
    try:
        yield stage
    finally:
        recover(build)


def publish(replacements, backup_root):
    """Replace/delete files atomically as a recoverable set; never replace parents.

    A None source means removal. Journal is durable before the first mutation.
    Process interruption rolls back on the next command unless commit was recorded.
    """
    stage = backup_root.parent
    build = stage.parent
    operations, seen = [], set()
    backup_root.mkdir(parents=True, exist_ok=True)
    for source, destination in replacements:
        relative = destination.relative_to(build).as_posix()
        destination = confined(build, relative)
        if relative.casefold() in seen:
            raise ValueError(f'Duplicate publication destination: {relative}')
        seen.add(relative.casefold())
        if destination.exists() and not destination.is_file():
            raise ValueError(f'Artifact destination is not a file: {destination}')
        previous = destination.exists()
        if previous:
            backup = backup_root / relative
            backup.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(destination, backup)
        operations.append({'destination': relative, 'previous': previous})
    journal = stage / 'publication.json'
    atomic_json(journal, {'state': 'prepared', 'operations': operations})
    try:
        for source, destination in replacements:
            destination.parent.mkdir(parents=True, exist_ok=True)
            if source is None:
                destination.unlink(missing_ok=True)
            else:
                source.rename(destination)
        atomic_json(journal, {'state': 'committed', 'operations': operations})
    except OSError:
        recover(build)
        raise
