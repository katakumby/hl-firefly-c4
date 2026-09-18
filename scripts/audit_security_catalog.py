"""Semantic guardrails for the security reference, independent of generation."""
import re


def audit_security_catalog(catalog, sources):
    checks = []
    def check(value, message):
        checks.append({'check': 'Security catalog: '+message, 'passed': bool(value)})
    elements = {e['id']: e for e in catalog['elements']}
    relationships = catalog['relationships']
    views = {v['key']: v for v in catalog['views']}
    products = {'keycloak', 'managedHsm', 'cyberarkPam', 'conjur', 'entraId', 'adDs', 'adFs'}
    security = [e for e in elements.values() if 'SecurityCatalog' in e.get('tags', '').split(',')]
    check(products <= set(elements), 'all seven requested products exist')
    for product in sorted(products):
        check(any(v['kind']=='systemContext' and v['scope']==product for v in views.values()), product+' has a system-context view')
        check(any(v['kind']=='container' and v['scope']==product for v in views.values()), product+' has a container view')
        check(any(v['kind']=='component' and v['scope'].startswith(product+'.') for v in views.values()), product+' has component detail')
    official = {v['url']: v for k, v in sources['pages'].items() if k.startswith('security-')}
    for e in security:
        evidence = e.get('sources', [])
        check(bool(evidence) and all(url in official for url in evidence), e['id']+' references captured product documentation')
        check(e.get('classification') in {'Documented product capability', 'Logical reference abstraction',
              'Proposed reference integration', 'Reference choice', 'External integration boundary'}, e['id']+' declares its evidence limits')
        if e['kind']=='component' and not e['id'].startswith(('keycloak.', 'apps.hsmSigner.')):
            check(e['classification']=='Logical reference abstraction', e['id']+' does not claim verified proprietary internals')
    for url, evidence in official.items():
        check(bool(re.fullmatch('[0-9a-f]{64}', evidence.get('sha256', ''))) and
              evidence.get('bytes', 0)>0 and evidence.get('retrieved_at') and evidence.get('capture_method'),
              url+' has fingerprint, retrieval time and capture method')
    security_relationships = [r for r in relationships if 'SecurityCatalog' in r.get('tags', '').split(',')]
    allowed_urls = set(official) | {e['source'] for e in elements.values()}
    check(all(r.get('evidence') and set(r['evidence'])<=allowed_urls and r.get('classification')
              for r in security_relationships), 'every added dataflow has evidence and inference classification')
    check(all(any(t in r['tags'].split(',') for t in ('IdentityFlow', 'DirectoryFlow', 'SecretFlow', 'KeyFlow', 'PrivilegedFlow', 'SecurityAdminFlow'))
              for r in security_relationships), 'every added dataflow declares its information category')

    def scenario(suffix):
        v = views.get('100-security-example-'+suffix)
        check(v is not None, suffix+' example exists')
        return [r for r in relationships if v and r['id'] in v['relationships']]

    for suffix, forbidden in (
        ('broker-entra', [{'apps.client', 'entraId.authentication'}]),
        ('broker-adfs', [{'apps.client', 'adFs.service'}, {'keycloak.server', 'adDs.directory'}]),
    ):
        rels = scenario(suffix)
        check(not any({r['source'], r['destination']} in forbidden for r in rels), suffix+' excludes competing direct-login paths')
        check(any('browser' in (r['description']+' '+r['technology']).lower() for r in rels), suffix+' identifies browser mediation')
    for suffix in ('login-ad', 'privileged-access', 'secret-delivery', 'directory-sync'):
        scenario(suffix)
    sync = scenario('directory-sync')
    pairs = {(r['source'], r['destination']) for r in sync}
    check({('entraId.agent', 'adDs.directory'), ('adDs.directory', 'entraId.agent'),
           ('entraId.agent', 'entraId.provisioning'), ('entraId.provisioning', 'entraId.directory')} <= pairs,
          'directory synchronization follows the explicit provisioning agent')
    keys = scenario('key-protection')
    app_tokens = [r for r in keys if {r['source'], r['destination']}=={'apps.client', 'entraId.authentication'}]
    check(len(app_tokens)==2 and all('HSM-audience' in r['description'] for r in app_tokens), 'HSM example uses workload tokens rather than browser login')
    signing = scenario('dlt-signing')
    signing_pairs = {(r['source'], r['destination']) for r in signing}
    check({('firefly.evm', 'apps.hsmSigner'), ('apps.hsmSigner', 'managedHsm.service'),
           ('apps.hsmSigner', 'besu.node')} <= signing_pairs, 'DLT path includes an explicit custom adapter')
    check('firefly.signer' not in {x for r in signing for x in (r['source'], r['destination'])}, 'DLT example does not claim native FireFly Signer HSM support')
    check(all('ReferenceIntegration' in r['tags'] for r in relationships
              if r['source'].startswith('apps.hsmSigner') or r['destination'].startswith('apps.hsmSigner')),
          'all custom signing adapter relationships are marked proposed')
    check(all(r['destination']=='managedHsm.service.crypto' for r in relationships if r['source']=='managedHsm.keys'),
          'protected key storage has no external key-material egress')
    hsm_egress = [r for r in relationships if r['source'].startswith('managedHsm') and not r['destination'].startswith('managedHsm')]
    def exports_private_key(r):
        text = r['description'].lower()
        text = re.sub(r'(?:never|without|no) (?:the )?(?:hsm )?private[ -]key(?: material)?', '', text)
        return bool(re.search(r'private[ -]key', text))
    check(not any(exports_private_key(r) for r in hsm_egress), 'HSM output descriptions contain no private-key export claim')
    check(not any(r['source'].startswith('firefly.signer') and r['destination'].startswith('managedHsm') for r in relationships),
          'existing FireFly filesystem wallet is not presented as HSM-integrated')
    check(not any(r['source'].startswith('azureManagement') and r['destination'].startswith(('managedHsm.keys', 'managedHsm.service.crypto')) for r in relationships),
          'resource management does not bypass HSM local key authorization')
    check(all(v['kind'] in ('systemLandscape', 'systemContext', 'container', 'component')
              for key, v in views.items() if key.startswith('100-security-')), 'only static C4 levels 1-3 are added')
    return checks
