"""Fetch pinned official source archives for component/dataflow review."""
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path, PurePosixPath
import hashlib
import io
import json
import tarfile
from capture_static_sources import get, ROOT, repo_snapshot, capture

def main():
    inventory = json.loads((ROOT / 'architecture/references/sources.json').read_text(encoding='utf-8'))
    # Tezos embeds its own version of FFTM, independent of EVMConnect's version.
    import re
    doc = inventory['repositories']['tezosconnect']['documents']['go.mod']
    content = (ROOT / doc['cache']).read_text(encoding='utf-8')
    version = re.search(r'github.com/(?:hyperledger-firefly/|hyperledger/firefly-)transaction-manager\s+(v\S+)', content)[1]
    ref = version.rsplit('-', 1)[-1] if re.search(r'-[0-9a-f]{12}$', version) else version
    _, entry = repo_snapshot('tezosfftm', 'hyperledger-firefly/transaction-manager', ref)
    inventory['repositories']['tezosfftm'] = entry
    inventory['embedded_dependencies'] = [d for d in inventory['embedded_dependencies'] if d['runtime'] != 'tezosconnect']
    inventory['embedded_dependencies'].append({'runtime': 'tezosconnect', 'library': 'tezosfftm',
        'version': version, 'commit': entry['commit'], 'evidence': doc['url']})
    sandbox = inventory['repositories']['sandbox']
    lock = capture('sandbox-server_package-lock.json',
        f'https://raw.githubusercontent.com/{sandbox["repository"]}/{sandbox["commit"]}/server/package-lock.json')
    sandbox['documents']['server/package-lock.json'] = lock
    version = json.loads((ROOT / lock['cache']).read_text())['packages']['node_modules/@hyperledger/firefly-sdk']['version']
    _, entry = repo_snapshot('sdk', 'hyperledger-firefly/sdk-nodejs', 'v'+version)
    inventory['repositories']['sdk'] = entry
    inventory['embedded_dependencies'] = [d for d in inventory['embedded_dependencies'] if d['runtime'] != 'sandbox']
    inventory['embedded_dependencies'].append({'runtime': 'sandbox', 'library': 'sdk',
        'version': version, 'commit': entry['commit'], 'evidence': lock['url']})
    keys = [k for k in inventory['repositories'] if k not in ('besu', 'charts', 'samples', 'evmsigner')]
    def fetch(key):
        entry = inventory['repositories'][key]
        url = f'https://codeload.github.com/{entry["repository"]}/tar.gz/{entry["commit"]}'
        raw = get(url)
        base = (ROOT / '.cache' / 'source-code' / key).resolve()
        base.mkdir(parents=True, exist_ok=True)
        count = 0
        with tarfile.open(fileobj=io.BytesIO(raw), mode='r:gz') as archive:
            for member in archive:
                rel = PurePosixPath(member.name).parts[1:]
                if not member.isfile() or not rel or '..' in rel:
                    continue
                if any(part in ('node_modules', 'vendor', '.git') for part in rel):
                    continue
                if Path(rel[-1]).suffix.lower() not in ('.go', '.ts', '.tsx', '.rs', '.java', '.kt', '.json', '.yaml', '.yml', '.md', '.mod', '.toml', '.xml', '.properties', '.gradle', '.sol'):
                    continue
                destination = base.joinpath(*rel).resolve()
                if not destination.is_relative_to(base):
                    raise RuntimeError(f'Unsafe archive path: {member.name}')
                destination.parent.mkdir(parents=True, exist_ok=True)
                destination.write_bytes(archive.extractfile(member).read())
                count += 1
        print(f'{key}: {count} source files', flush=True)
        return key, {'url': url, 'sha256': hashlib.sha256(raw).hexdigest(), 'files': count,
                     'directory': base.relative_to(ROOT).as_posix()}
    with ThreadPoolExecutor(max_workers=5) as pool:
        for key, archive in pool.map(fetch, keys):
            inventory['repositories'][key]['source_archive'] = archive
    from capture_besu_evidence import capture_besu
    capture_besu(inventory)
    (ROOT / 'architecture/references/sources.json').write_text(json.dumps(inventory, indent=2) + '\n', encoding='utf-8')

if __name__ == '__main__':
    main()
