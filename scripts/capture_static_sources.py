"""Capture immutable official architecture evidence, leaving deployment sources alone.

Unlike a Git tree hash, a commit SHA can be used in raw-content/source URLs.
Libraries embedded by Go modules are captured at their dependency version.
"""
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import re
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
CACHE = ROOT / '.cache' / 'sources-static'
REPOS = {
    'firefly': 'hyperledger-firefly/firefly',
    'evmconnect': 'hyperledger-firefly/evmconnect',
    'fftm': 'hyperledger-firefly/transaction-manager',
    'signer': 'hyperledger-firefly/signer',
    'common': 'hyperledger-firefly/common',
    'dx': 'hyperledger-firefly/dataexchange-https',
    'erc20': 'hyperledger-firefly/tokens-erc20-erc721',
    'erc1155': 'hyperledger-firefly/tokens-erc1155',
    'ethconnect': 'hyperledger-firefly/ethconnect',
    'fabconnect': 'hyperledger-firefly/fabconnect',
    'tezosconnect': 'hyperledger-firefly/tezosconnect',
    'cardano': 'hyperledger-firefly/cardano',
    'cordaconnect': 'hyperledger-firefly/cordaconnect',
    'cli': 'hyperledger-firefly/cli',
    'perf': 'hyperledger-firefly/perf-cli',
    'sdk': 'hyperledger-firefly/sdk-nodejs',
    'samples': 'hyperledger-firefly/samples',
    'ui': 'hyperledger-firefly/ui',
    'sandbox': 'hyperledger-firefly/sandbox',
    'besu': 'besu-eth/besu',
}
PAGES = {
    'firefly-head': 'https://hyperledger-firefly.github.io/firefly/head/',
    'firefly-architecture': 'https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/',
    'firefly-plugins': 'https://hyperledger-firefly.github.io/firefly/head/architecture/plugin_architecture/',
    'qbft': 'https://docs.besu-eth.org/private-networks/how-to/configure/consensus/qbft',
    'permissioning': 'https://docs.besu-eth.org/private-networks/concepts/permissioning',
    'besu-rpc': 'https://docs.besu-eth.org/private-networks/reference/api',
    'structurizr-dsl': 'https://docs.structurizr.com/dsl/language',
    'inspect': 'https://docs.structurizr.com/inspect',
    'inspections': 'https://docs.structurizr.com/workspaces/inspections',
}

def get(url):
    request = urllib.request.Request(url, headers={'User-Agent': 'FireFly-C4-Source-Audit'})
    return urllib.request.urlopen(request, timeout=45).read()

def capture(key, url):
    raw = get(url)
    path = CACHE / (key + '.txt')
    path.write_bytes(raw)
    return {'url': url, 'sha256': hashlib.sha256(raw).hexdigest(), 'bytes': len(raw),
            'cache': path.relative_to(ROOT).as_posix(), 'retrieved_at': datetime.now(timezone.utc).isoformat()}

def repo_snapshot(key, repo, ref='HEAD'):
    commit = json.loads(get(f'https://api.github.com/repos/{repo}/commits/{ref}'))
    sha = commit['sha']
    tree = json.loads(get(f'https://api.github.com/repos/{repo}/git/trees/{commit["commit"]["tree"]["sha"]}?recursive=1'))
    if tree.get('truncated'):
        raise RuntimeError(f'Truncated source inventory: {repo}')
    entry = {'repository': repo, 'commit': sha, 'tree': tree['sha'], 'requested_ref': ref,
             'url': f'https://github.com/{repo}/tree/{sha}',
             'retrieved_at': datetime.now(timezone.utc).isoformat(),
             'paths': [x['path'] for x in tree['tree']], 'documents': {}}
    old = json.loads((ROOT / 'sources.json').read_text(encoding='utf-8'))['repositories'].get(key, {})
    paths = set(old.get('documents', {})) | {'README.md', 'go.mod', 'package.json', 'Dockerfile'}
    if key == 'firefly':
        paths |= {p for p in entry['paths'] if p.startswith('doc-site/docs/') and p.endswith('.md') and
                  any(x in p for x in ('architecture/', 'key_components/', 'tutorials/chains/', 'multiparty/', 'supernode_concept'))}
        paths |= {p for p in entry['paths'] if p.endswith('/factory.go')}
    paths |= {p for p in entry['paths'] if p.endswith('README.md') and p.count('/') <= 2}
    for path in sorted(paths & set(entry['paths'])):
        entry['documents'][path] = capture(key + '-' + path.replace('/', '_'),
                                         f'https://raw.githubusercontent.com/{repo}/{sha}/{path}')
    print(f'{key}: {sha} ({len(entry["documents"])} documents)', flush=True)
    return key, entry

def main():
    CACHE.mkdir(parents=True, exist_ok=True)
    inventory = json.loads((ROOT / 'sources.json').read_text(encoding='utf-8'))
    inventory['static_retrieved_at'] = datetime.now(timezone.utc).isoformat()
    with ThreadPoolExecutor(max_workers=6) as pool:
        for key, entry in pool.map(lambda item: repo_snapshot(*item), REPOS.items()):
            inventory['repositories'][key] = entry
    bindings = [('evmconnect', 'fftm', 'transaction-manager'), ('evmconnect', 'evmsigner', 'signer'),
                ('firefly', 'common', 'common')]
    inventory['embedded_dependencies'] = []
    for owner, key, module in bindings:
        doc = inventory['repositories'][owner]['documents']['go.mod']
        content = (ROOT / doc['cache']).read_text(encoding='utf-8')
        match = re.search(r'github.com/hyperledger(?:-firefly|/firefly)/(?:firefly-)?' + re.escape(module) + r'\s+(v\S+)', content)
        if not match:
            raise RuntimeError(f'Missing {module} dependency in {owner}/go.mod')
        version = match[1]
        ref = version.rsplit('-', 1)[-1] if re.search(r'-[0-9a-f]{12}$', version) else version
        _, entry = repo_snapshot(key, 'hyperledger-firefly/' + module, ref)
        inventory['repositories'][key] = entry
        inventory['embedded_dependencies'].append({'runtime': owner, 'library': key, 'version': version,
                                                   'commit': entry['commit'], 'evidence': doc['url']})
    with ThreadPoolExecutor(max_workers=6) as pool:
        for key, document in pool.map(lambda item: (item[0], capture(item[0], item[1])), PAGES.items()):
            inventory['pages'][key] = document
    (ROOT / 'sources.json').write_text(json.dumps(inventory, indent=2) + '\n', encoding='utf-8')

if __name__ == '__main__':
    main()
