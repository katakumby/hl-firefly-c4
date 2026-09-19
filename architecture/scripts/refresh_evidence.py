"""Explicit, transactional evidence refresh. Validation never invokes this command."""
import argparse
from copy import deepcopy
import json
from pathlib import Path
import re
import sys
import urllib.error
import urllib.request
import uuid
from artifact_store import atomic_json, file_lock, timestamp
from evidence_sources import STATIC_REPOS, STATIC_PAGES, SECURITY_PAGES
from evidence_store import SnapshotStore, sha256, verify_inventory, local_path
from workspace_paths import ROOT, SOURCES

BESU_FILES = ['JsonRpcHttpService.java', 'EthProtocolManager.java', 'TransactionPool.java',
              'PeerDiscoveryAgent.java', 'AccountPermissioningController.java', 'NodePermissioningController.java',
              'QbftBesuControllerBuilder.java', 'QbftBlockHeightManager.java', 'AbstractBlockProcessor.java',
              'WorldStateArchive.java', 'RocksDBKeyValueStorageFactory.java', 'SecurityModule.java', 'PrometheusMetricsSystem.java']


def get(url):
    request = urllib.request.Request(url, headers={'User-Agent': 'Architecture-Evidence-Refresh/1.0'})
    with urllib.request.urlopen(request, timeout=60) as response:
        return response.read()


class Refresher:
    def __init__(self, inventory, root=ROOT, fetch=get):
        self.inventory = inventory
        self.root = Path(root)
        self.store = SnapshotStore(root)
        self.fetch = fetch

    def document(self, url, **metadata):
        return self.store.document(self.fetch(url), url, **metadata)

    def repository(self, key, repository, ref='HEAD'):
        commit = json.loads(self.fetch(f'https://api.github.com/repos/{repository}/commits/{ref}'))
        sha = commit['sha']
        tree = json.loads(self.fetch(f'https://api.github.com/repos/{repository}/git/trees/{commit["commit"]["tree"]["sha"]}?recursive=1'))
        if tree.get('truncated'):
            raise ValueError(f'Truncated repository inventory: {repository}')
        entry = {'repository': repository, 'commit': sha, 'tree': tree['sha'], 'requested_ref': ref,
                 'url': f'https://github.com/{repository}/tree/{sha}', 'retrieved_at': timestamp(),
                 'paths': [item['path'] for item in tree['tree']], 'documents': {}}
        old = self.inventory['repositories'].get(key, {})
        paths = set(old.get('documents', {})) | {'README.md', 'go.mod', 'package.json', 'Dockerfile'}
        if key == 'firefly':
            paths |= {p for p in entry['paths'] if p.startswith('doc-site/docs/') and p.endswith('.md') and
                      any(s in p for s in ('architecture/', 'key_components/', 'tutorials/chains/', 'multiparty/', 'supernode_concept'))}
            paths |= {p for p in entry['paths'] if p.endswith('/factory.go')}
        paths |= {p for p in entry['paths'] if p.endswith('README.md') and p.count('/') <= 2}
        for path in sorted(paths & set(entry['paths'])):
            entry['documents'][path] = self.document(f'https://raw.githubusercontent.com/{repository}/{sha}/{path}')
        self.inventory['repositories'][key] = entry
        return entry

    def pinned_document(self, owner, name):
        repository = self.inventory['repositories'][owner]
        document = repository['documents'].get(name)
        if document and local_path(self.root, document['cache']).exists():
            raw = local_path(self.root, document['cache']).read_bytes()
            if sha256(raw) != document['sha256']:
                raise ValueError(f'Corrupted input evidence: {owner}/{name}')
            return raw, document
        document = self.document(f'https://raw.githubusercontent.com/{repository["repository"]}/{repository["commit"]}/{name}')
        repository['documents'][name] = document
        return local_path(self.root, document['cache']).read_bytes(), document

    def bindings(self, owners):
        definitions = [('evmconnect', 'fftm', 'transaction-manager'), ('evmconnect', 'evmsigner', 'signer'),
                       ('firefly', 'common', 'common'), ('tezosconnect', 'tezosfftm', 'transaction-manager'),
                       ('sandbox', 'sdk', 'sdk-nodejs')]
        replacements = {}
        for owner, library, module in definitions:
            if owner not in owners:
                continue
            if owner == 'sandbox':
                raw, document = self.pinned_document(owner, 'server/package-lock.json')
                version = json.loads(raw)['packages']['node_modules/@hyperledger/firefly-sdk']['version']
                ref = 'v' + version
            else:
                raw, document = self.pinned_document(owner, 'go.mod')
                match = re.search(r'github.com/hyperledger(?:-firefly|/firefly)/(?:firefly-)?' + re.escape(module) + r'\s+(v\S+)', raw.decode())
                if not match:
                    raise ValueError(f'Missing {module} binding in {owner}/go.mod')
                version = match[1]
                ref = version.rsplit('-', 1)[-1] if re.search(r'-[0-9a-f]{12}$', version) else version
            entry = self.repository(library, 'hyperledger-firefly/' + module, ref)
            replacements[(owner, library)] = {'runtime': owner, 'library': library, 'version': version,
                                              'commit': entry['commit'], 'evidence': document['url']}
        retained = [d for d in self.inventory.get('embedded_dependencies', [])
                    if (d['runtime'], d['library']) not in replacements]
        self.inventory['embedded_dependencies'] = retained + list(replacements.values())

    def static(self):
        for key, repository in STATIC_REPOS.items():
            self.repository(key, repository)
        self.bindings({'evmconnect', 'firefly', 'tezosconnect', 'sandbox'})
        for key, url in STATIC_PAGES.items():
            self.inventory['pages'][key] = self.document(url)
        self.inventory['static_retrieved_at'] = timestamp()

    def components(self):
        self.bindings({'tezosconnect', 'sandbox'})
        for key, entry in self.inventory['repositories'].items():
            if key in ('besu', 'charts', 'samples', 'evmsigner'):
                continue
            url = f'https://codeload.github.com/{entry["repository"]}/tar.gz/{entry["commit"]}'
            entry['source_archive'] = self.store.archive(key, entry['commit'], self.fetch(url), url)
        self.besu()

    def besu(self):
        entry = self.inventory['repositories']['besu']
        for name in BESU_FILES:
            paths = [p for p in entry['paths'] if p.endswith('/' + name) and '/src/main/' in p]
            if len(paths) != 1:
                raise ValueError(f'Ambiguous Besu evidence: {name}: {paths}')
            path = paths[0]
            entry['documents'][path] = self.document(f'https://raw.githubusercontent.com/{entry["repository"]}/{entry["commit"]}/{path}')

    def security(self, only=None):
        selected = set(only or SECURITY_PAGES)
        if not selected <= SECURITY_PAGES.keys():
            raise ValueError('Unknown security evidence key')
        for key in sorted(selected):
            url = SECURITY_PAGES[key]
            try:
                raw = self.fetch(url)
                if len(raw) < 1000:
                    raise ValueError(f'Unexpectedly short documentation response: {url}')
                document = self.store.document(raw, url, resolved_url=url,
                    capture_method='Direct HTTP document snapshot',
                    classification='Official product documentation; logical decomposition is inferred')
            except urllib.error.HTTPError:
                old = self.inventory['pages'].get(key, {})
                if key not in ('security-pam', 'security-conjur', 'security-conjur-sync') or not old.get('cache'):
                    raise
                raw = local_path(self.root, old['cache']).read_bytes()
                if sha256(raw) != old['sha256']:
                    raise ValueError(f'Corrupted fallback snapshot: {key}')
                # An old captured excerpt is not a new retrieval; preserve its timestamp and provenance.
                document = deepcopy(old)
                document['last_refresh_attempt'] = timestamp()
            self.inventory['pages'][key] = document
        self.inventory['security_retrieved_at'] = timestamp()


def refresh(scope='All', only=None, root=ROOT, inventory_path=None, fetch=get, updater=None):
    root = Path(root).resolve()
    inventory_path = Path(inventory_path or root / 'architecture/references/sources.json')
    directory = root / 'build/architecture/evidence-refresh'
    directory.mkdir(parents=True, exist_ok=True)
    with file_lock(directory / '.refresh.lock'):
        original = inventory_path.read_bytes()
        candidate = deepcopy(json.loads(original))
        previously_missing = set(verify_inventory(candidate, root)['missing_caches'])
        run = directory / uuid.uuid4().hex
        run.mkdir()
        receipt = {'scope': scope, 'started_at': timestamp(), 'passed': False}
        try:
            if updater:
                updater(candidate)
            else:
                worker = Refresher(candidate, root, fetch)
                if scope in ('All', 'Static'):
                    worker.static()
                if scope in ('All', 'Components'):
                    worker.components()
                if scope == 'Besu':
                    worker.besu()
                if scope in ('All', 'Security'):
                    worker.security(only)
            integrity = verify_inventory(candidate, root)
            newly_missing = set(integrity['missing_caches']) - previously_missing
            if newly_missing:
                integrity['errors'].append('New or previously available evidence is missing: ' + ', '.join(sorted(newly_missing)[:5]))
                integrity['passed'] = False
            atomic_json(run / 'integrity.json', integrity)
            if not integrity['passed']:
                raise ValueError('; '.join(integrity['errors']))
            atomic_json(run / 'candidate.json', candidate)
            if inventory_path.read_bytes() != original:
                raise RuntimeError('Evidence inventory changed concurrently; candidate was not published')
            atomic_json(inventory_path, candidate)
            receipt['passed'] = True
            receipt['changed_revisions'] = {key: entry['commit'] for key, entry in candidate['repositories'].items()
                if entry['commit'] != json.loads(original)['repositories'].get(key, {}).get('commit')}
        except Exception as exc:
            receipt['failure'] = str(exc)
            raise
        finally:
            receipt['completed_at'] = timestamp()
            atomic_json(run / 'receipt.json', receipt)
        print(f'Evidence published atomically. Receipt: {run / "receipt.json"}')
        print('Review changed revisions with authored DSL evidence URLs before completing this maintenance change.')
        return receipt


def main(default_scope='All'):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--scope', choices=('All', 'Static', 'Components', 'Besu', 'Security'), default=default_scope)
    parser.add_argument('--only', nargs='+', choices=sorted(SECURITY_PAGES))
    args = parser.parse_args()
    if args.only and args.scope != 'Security':
        parser.error('--only is supported only for Security scope')
    try:
        refresh(args.scope, args.only)
        return 0
    except (ValueError, RuntimeError, OSError, KeyError) as exc:
        print(str(exc), file=sys.stderr)
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
