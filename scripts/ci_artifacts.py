"""Copy only successful current build outputs, or diagnostic reports, to /artifacts."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil

from architecture import BUILD, command_lock, inventory, source_fingerprint
from artifact_store import confined


def package(destination, diagnostics=False):
    destination = Path(destination)
    if not destination.is_dir():
        raise ValueError('Mount an empty writable artifact directory at /artifacts')
    if any(destination.iterdir()):
        raise ValueError('Artifact directory must be empty (use isolated CI staging)')
    selected = set()
    with command_lock():
        if not diagnostics:
            status = json.loads((BUILD / 'build.json').read_text())
            fingerprint = source_fingerprint()
            if not status['passed'] or status.get('in_progress') or status['source_sha256'] != fingerprint:
                raise ValueError('Refusing to package a failed or stale build as successful')
            entries = {entry['output']: entry for entry in inventory()}
            # Optional exports can have older freshness; only package this full build's outputs.
            for output in status['outputs']:
                relative = Path(output).relative_to('build').as_posix()
                entry = entries[relative]
                file = confined(BUILD, relative)
                if entry['source_sha256'] != fingerprint or hashlib.sha256(file.read_bytes()).hexdigest() != entry['output_sha256']:
                    raise ValueError(f'Refusing to package stale or modified artifact: {relative}')
                selected.add(file)
            selected.add(BUILD / 'artifacts.json')
        selected.update(p for p in (BUILD / '.reports').rglob('*') if p.is_file() and p.suffix in ('.json', '.log'))
        selected.update(p for p in (BUILD / 'build.json', BUILD / 'build.log') if p.is_file())
        for file in sorted(selected):
            relative = file.relative_to(BUILD)
            confined(BUILD, relative)
            target = destination / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(file, target)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--diagnostics', action='store_true')
    args = parser.parse_args()
    package('/artifacts', args.diagnostics)
