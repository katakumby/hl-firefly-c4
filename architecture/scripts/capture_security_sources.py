"""Capture only security-catalog documentation; preserve existing evidence."""
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import urllib.request
import urllib.error
import argparse

ROOT = Path(__file__).resolve().parents[2]
PAGES = {
    'security-keycloak': 'https://www.keycloak.org/docs/latest/server_admin/index.html',
    'security-keycloak-db': 'https://www.keycloak.org/server/db',
    'security-hsm': 'https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control',
    'security-hsm-keys': 'https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details',
    'security-hsm-sign': 'https://learn.microsoft.com/en-us/rest/api/keyvault/keys/sign/sign?view=rest-keyvault-keys-2025-07-01',
    'security-hsm-get-key': 'https://learn.microsoft.com/en-us/rest/api/keyvault/keys/get-key/get-key?view=rest-keyvault-keys-2025-07-01',
    'security-pam': 'https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm',
    'security-conjur': 'https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm',
    'security-conjur-sync': 'https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm',
    'security-entra': 'https://learn.microsoft.com/en-us/entra/architecture/architecture',
    'security-entra-oidc': 'https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc',
    'security-cloud-sync': 'https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync',
    'security-ad': 'https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview',
    'security-adfs': 'https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview',
    'security-adfs-claims': 'https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine',
    'security-ethereum-transactions': 'https://ethereum.org/en/developers/docs/transactions/',
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--only', nargs='+', choices=sorted(PAGES), help='Refresh only the named source records.')
    selected = set(parser.parse_args().only or PAGES)
    cache = ROOT / '.cache/sources-security'
    cache.mkdir(parents=True, exist_ok=True)
    inventory = json.loads((ROOT / 'architecture/references/sources.json').read_text(encoding='utf-8'))
    captured = {}
    for key, url in PAGES.items():
        if key not in selected:
            continue
        request = urllib.request.Request(url, headers={'User-Agent': 'C4-Security-Catalog/1.0'})
        method = 'Direct HTTP document snapshot'
        suffix = '.html'
        try:
            with urllib.request.urlopen(request, timeout=60) as response:
                raw = response.read()
                resolved = response.url
        except urllib.error.HTTPError as error:
            snapshot = ROOT / '.cache/sources-security-web' / (key + '.txt')
            if key not in ('security-pam', 'security-conjur', 'security-conjur-sync') or not snapshot.exists():
                raise
            raw = snapshot.read_bytes()
            resolved = url
            method = f'Web reader text excerpt; direct HTTP returned {error.code}'
            suffix = '.txt'
        if len(raw) < 1000:
            raise RuntimeError(f'Unexpectedly short documentation response: {url}')
        path = cache / (key + suffix)
        path.write_bytes(raw)
        captured[key] = {
            'url': url, 'resolved_url': resolved,
            'sha256': hashlib.sha256(raw).hexdigest(), 'bytes': len(raw),
            'cache': path.relative_to(ROOT).as_posix(),
            'retrieved_at': datetime.now(timezone.utc).isoformat(),
            'capture_method': method,
            'classification': 'Official product documentation; logical decomposition is inferred',
        }
        print(f'{key}: {len(raw)} bytes', flush=True)
    inventory['pages'].update(captured)
    inventory['security_retrieved_at'] = datetime.now(timezone.utc).isoformat()
    (ROOT / 'architecture/references/sources.json').write_text(json.dumps(inventory, indent=2) + '\n', encoding='utf-8')


if __name__ == '__main__':
    main()
