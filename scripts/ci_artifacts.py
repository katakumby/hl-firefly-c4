"""Copy only successful current build outputs, or diagnostic reports, to /artifacts."""
import argparse
import hashlib
import json
from pathlib import Path
import shutil

from architecture import BUILD, command_lock, inventory, source_fingerprint, verify_light_handoff
from artifact_store import confined, atomic_json


def package(destination, diagnostics=False, stage='light'):
    destination = Path(destination)
    if not destination.is_dir():
        raise ValueError('Mount an empty writable artifact directory at /artifacts')
    if any(destination.iterdir()):
        raise ValueError('Artifact directory must be empty (use isolated CI staging)')
    selected = set()
    packaged_entries = []
    with command_lock():
        if not diagnostics:
            if stage not in ('light', 'full'):
                raise ValueError('Package stage must be light or full')
            light, digest = verify_light_handoff()
            status = light
            selected.update(confined(BUILD, path) for path in light['reports'])
            selected.update(BUILD / '.reports' / name for name in ('build-light.json', 'build-light.log'))
            if stage == 'full':
                status = json.loads((BUILD / '.reports/build-browser.json').read_text())
                if (not status.get('complete') or status.get('light_sha256') != digest
                        or status.get('source_revision') != light['source_revision']):
                    raise ValueError('Refusing to package an incomplete or stale browser build')
                selected.update(BUILD / '.reports' / name for name in ('build-browser.json', 'build-browser.log'))
            fingerprint = source_fingerprint()
            if not status['passed'] or status.get('in_progress') or status['source_sha256'] != fingerprint:
                raise ValueError('Refusing to package a failed or stale build as successful')
            entries = {entry['output']: entry for entry in inventory()}
            if stage == 'full':
                expected = {(item['source'], item['output'], item['format']) for item in light['deferred']}
                actual = {(item['source'], item['output'], item['format']) for item in status['artifacts']}
                if (actual != expected or len(actual) != len(status['artifacts'])
                        or status['outputs'] != light['outputs'] + ['build/' + item['output'] for item in status['artifacts']]
                        or any(entries.get(item['output']) != item for item in status['artifacts'])):
                    raise ValueError('Refusing to package incomplete or modified browser artifacts')
            # Only the chosen stage's verified outputs belong in this handoff.
            for output in status['outputs']:
                relative = Path(output).relative_to('build').as_posix()
                entry = entries[relative]
                file = confined(BUILD, relative)
                if entry['source_sha256'] != fingerprint or hashlib.sha256(file.read_bytes()).hexdigest() != entry['output_sha256']:
                    raise ValueError(f'Refusing to package stale or modified artifact: {relative}')
                selected.add(file)
                packaged_entries.append(entry)
        else:
            selected.update(p for p in (BUILD / '.reports').rglob('*') if p.is_file() and p.suffix in ('.json', '.log'))
            selected.update(p for p in (BUILD / 'build.json', BUILD / 'build.log') if p.is_file())
        selected.update(p for p in (BUILD / '.reports').glob('tests*.log') if p.is_file())
        for file in sorted(selected):
            relative = file.relative_to(BUILD)
            confined(BUILD, relative)
            target = destination / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(file, target)
        if not diagnostics:
            atomic_json(destination / 'artifacts.json', {'schema_version': 1,
                        'artifacts': sorted(packaged_entries, key=lambda item: item['output'])})
            atomic_json(destination / 'build.json', status)
            shutil.copyfile(BUILD / '.reports' / ('build-light.log' if stage == 'light' else 'build-browser.log'),
                            destination / 'build.log')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--diagnostics', action='store_true')
    parser.add_argument('--stage', choices=('light', 'full'), default='light')
    args = parser.parse_args()
    package('/artifacts', args.diagnostics, args.stage)
