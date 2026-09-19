"""Immutable evidence objects and revision-specific repository snapshots."""
from datetime import datetime, timezone
import hashlib
import io
import json
from pathlib import Path, PurePosixPath
import re
import tarfile
import tempfile
from artifact_store import atomic_json

REQUIRED_BINDINGS = {('evmconnect', 'fftm'), ('evmconnect', 'evmsigner'),
                     ('firefly', 'common'), ('tezosconnect', 'tezosfftm'), ('sandbox', 'sdk')}
SOURCE_SUFFIXES = {'.go', '.ts', '.tsx', '.rs', '.java', '.kt', '.json', '.yaml', '.yml',
                   '.md', '.mod', '.toml', '.xml', '.properties', '.gradle', '.sol'}


def local_path(root, relative):
    path = (Path(root) / relative).resolve()
    path.relative_to(Path(root).resolve())
    return path


def sha256(raw):
    return hashlib.sha256(raw).hexdigest()


class SnapshotStore:
    def __init__(self, root):
        self.root = Path(root).resolve()
        self.base = self.root / '.cache/architecture/evidence'

    def object(self, raw):
        digest = sha256(raw)
        path = self.base / 'objects' / digest
        path.parent.mkdir(parents=True, exist_ok=True)
        if path.exists():
            if sha256(path.read_bytes()) != digest:
                raise ValueError(f'Corrupted immutable evidence object: {path}')
        else:
            with tempfile.NamedTemporaryFile(dir=path.parent, delete=False) as stream:
                temporary = Path(stream.name)
                stream.write(raw)
            try:
                temporary.replace(path)
            finally:
                temporary.unlink(missing_ok=True)
        return path

    def document(self, raw, url, **extra):
        path = self.object(raw)
        return {'url': url, 'sha256': sha256(raw), 'bytes': len(raw),
                'cache': path.relative_to(self.root).as_posix(),
                'retrieved_at': datetime.now(timezone.utc).isoformat(), **extra}

    def archive(self, key, commit, raw, url):
        if not re.fullmatch(r'[A-Za-z0-9_-]+', key) or not re.fullmatch(r'[0-9a-f]{40}', commit):
            raise ValueError('Unsafe repository key or commit')
        archive = self.object(raw)
        parent = self.base / 'repositories' / key / commit
        parent.mkdir(parents=True, exist_ok=True)
        destination = parent / sha256(raw)
        if not destination.exists():
            with tempfile.TemporaryDirectory(dir=parent, prefix='extract-') as temporary:
                staged = Path(temporary) / 'snapshot'
                staged.mkdir()
                files = {}
                with tarfile.open(fileobj=io.BytesIO(raw), mode='r:gz') as bundle:
                    for member in bundle:
                        parts = PurePosixPath(member.name).parts
                        if member.name.startswith('/') or '..' in parts or any(':' in p or '\\' in p for p in parts):
                            raise ValueError(f'Unsafe archive path: {member.name}')
                        relative = parts[1:]
                        if not member.isfile() or not relative:
                            continue
                        if any(p in ('node_modules', 'vendor', '.git') for p in relative):
                            continue
                        if Path(relative[-1]).suffix.lower() not in SOURCE_SUFFIXES:
                            continue
                        target = staged.joinpath(*relative).resolve()
                        target.relative_to(staged.resolve())
                        name = '/'.join(relative)
                        if name in files or name == '.snapshot.json':
                            raise ValueError(f'Duplicate/reserved archive entry: {name}')
                        content = bundle.extractfile(member).read()
                        target.parent.mkdir(parents=True, exist_ok=True)
                        target.write_bytes(content)
                        files[name] = sha256(content)
                atomic_json(staged / '.snapshot.json', {'files': files, 'archive_sha256': sha256(raw)})
                staged.rename(destination)
        manifest = json.loads((destination / '.snapshot.json').read_text())
        for name, expected in manifest['files'].items():
            if sha256(local_path(destination, name).read_bytes()) != expected:
                raise ValueError(f'Corrupted source snapshot: {destination}/{name}')
        return {'url': url, 'sha256': sha256(raw), 'files': len(manifest['files']),
                'directory': destination.relative_to(self.root).as_posix(),
                'archive_cache': archive.relative_to(self.root).as_posix(),
                'manifest': (destination / '.snapshot.json').relative_to(self.root).as_posix()}


def verify_inventory(inventory, root, require_cached=False):
    errors, missing = [], []
    checked = 0
    bindings = inventory.get('embedded_dependencies', [])
    pairs = [(d.get('runtime'), d.get('library')) for d in bindings]
    if len(set(pairs)) != len(pairs) or not REQUIRED_BINDINGS <= set(pairs):
        errors.append('Missing or duplicate required embedded dependency bindings')
    repos = inventory.get('repositories', {})
    for binding in bindings:
        runtime, library = binding.get('runtime'), binding.get('library')
        if runtime not in repos or library not in repos or binding.get('commit') != repos.get(library, {}).get('commit'):
            errors.append(f'Inconsistent embedded dependency: {runtime}/{library}')
        if not binding.get('version') or not binding.get('evidence'):
            errors.append(f'Incomplete embedded dependency: {runtime}/{library}')
    def verify_file(relative, expected):
        nonlocal checked
        if not re.fullmatch(r'[0-9a-f]{64}', expected or ''):
            errors.append(f'Invalid evidence fingerprint: {relative}')
            return
        try:
            path = local_path(root, relative)
            if not path.exists():
                missing.append(relative)
            elif sha256(path.read_bytes()) != expected:
                errors.append(f'Evidence fingerprint mismatch: {relative}')
            else:
                checked += 1
        except (OSError, ValueError) as exc:
            errors.append(str(exc))
    def visit(value):
        if isinstance(value, dict):
            if 'cache' in value and 'sha256' in value:
                verify_file(value['cache'], value['sha256'])
            if 'archive_cache' in value:
                verify_file(value['archive_cache'], value.get('sha256'))
            if 'manifest' in value and 'directory' in value:
                try:
                    manifest_path = local_path(root, value['manifest'])
                    if not manifest_path.exists():
                        missing.append(value['manifest'])
                    else:
                        manifest = json.loads(manifest_path.read_text())
                        directory = local_path(root, value['directory'])
                        expected = manifest['files']
                        if manifest.get('archive_sha256') != value['sha256'] or len(expected) != value['files']:
                            errors.append(f'Inconsistent snapshot manifest: {manifest_path}')
                        actual = {p.relative_to(directory).as_posix() for p in directory.rglob('*') if p.is_file() and p != manifest_path}
                        if actual != set(expected):
                            errors.append(f'Snapshot file inventory differs: {directory}')
                        for name, digest in expected.items():
                            path = local_path(directory, name)
                            verify_file(path.relative_to(Path(root).resolve()).as_posix(), digest)
                except (OSError, ValueError, KeyError) as exc:
                    errors.append(str(exc))
            for child in value.values():
                visit(child)
        elif isinstance(value, list):
            for child in value:
                visit(child)
    visit(inventory)
    if require_cached and missing:
        errors.append('Required captured evidence is missing: ' + ', '.join(missing[:5]))
    return {'passed': not errors, 'checked_files': checked, 'missing_caches': sorted(set(missing)), 'errors': errors}
