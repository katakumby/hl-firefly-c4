"""Security product reference catalog, independent of deployment placement.

Public capabilities ground the model; proprietary internals are explicitly
logical abstractions. Reference integrations are diagram examples, not shipped
FireFly functionality. All relationships are authored, not implied.
"""
from model_data import rows

PRODUCTS = ('keycloak', 'managedHsm', 'cyberarkPam', 'conjur', 'entraId', 'adDs', 'adFs')
PREFIX = '100-security-'


def extend_security_model(E, R, V, add, rel, view, kids, source):
    original_elements = set(E)
    original_relationship_count = len(R)

    def element(ident, kind, name, description, technology, evidence, tags='', classification='Documented product capability'):
        add(ident, kind, name, description, technology, evidence,
            tags=','.join(filter(None, ('SecurityCatalog', tags))), classification=classification)
        E[ident]['sources'] = [E[ident]['source']]

    def system(ident, name, description, evidence):
        element(ident, 'softwareSystem', name, description, '', evidence)

    def runtime(ident, name, description, technology, evidence, logical=False, store=False):
        element(ident, 'container', name, description, technology, evidence,
                ','.join(filter(None, ('LogicalReference' if logical else '', 'Database' if store else ''))),
                'Logical reference abstraction' if logical else 'Documented product capability')

    def components(parent, definitions, evidence, technology, logical=False):
        for ident, name, description in rows(definitions):
            element(parent+'.'+ident, 'component', name,
                    ('Logical reference: ' if logical else '')+description, technology, evidence,
                    'LogicalReference' if logical else '',
                    'Logical reference abstraction' if logical else 'Documented product capability')

    def flow(a, b, description, technology, family='IdentityFlow', example=False, evidence=()):
        rel(a, b, description, technology, 'Dataflow,SecurityCatalog,'+family+(',ReferenceIntegration' if example else ''))
        r = R[-1]
        assert (r['source'], r['destination'], r['description']) == (a, b, description)
        r['classification'] = ('Proposed reference integration; not built-in FireFly functionality' if example
                               else 'Architecture dataflow inferred from documented product capabilities')
        r['evidence'] = list(dict.fromkeys([E[a]['source'], E[b]['source']]+[source(s) for s in evidence]))

    def local(parent, definitions, family='IdentityFlow', example=False):
        for a, b, description in rows(definitions):
            flow(parent+'.'+a, parent+'.'+b, description, 'In-process logical interface', family, example)

    def diagram(kind, scope, suffix, title, elements, relationship_filter=None):
        view(kind, scope, PREFIX+suffix, title, elements)
        if relationship_filter:
            V[-1]['relationships'] = [r['id'] for r in R if r['id'] in V[-1]['relationships'] and relationship_filter(r)]
        selected = set(V[-1]['elements'])
        connected = {r[k] for r in R if r['id'] in V[-1]['relationships']
                     for k in ('source', 'destination')}
        assert selected <= connected, (suffix, selected-connected)

    element('securityAdmin', 'person', 'Security administrator',
            'Configures identity, privileged access, secret policies and key permissions in these reference examples.',
            '', 'security-pam', classification='Reference choice')
    element('managedTarget', 'softwareSystem', 'Managed target system',
            'Example SSH-accessible administrative target whose privileged account is rotated and sessions are controlled by PAM.',
            '', 'security-pam', classification='Reference choice')
    element('azureManagement', 'softwareSystem', 'Azure Resource Manager',
            'External management-plane boundary; applies Azure RBAC to Managed HSM resource administration, not key operations.',
            '', 'security-hsm', classification='External integration boundary')

    system('keycloak', 'Keycloak', 'Identity and access management: SSO, federation, brokering and token issuance.', 'security-keycloak')
    runtime('keycloak.server', 'Keycloak server', 'Hosts login, administration, federation and protocol services; cache is embedded.', 'Java / Keycloak', 'security-keycloak')
    runtime('keycloak.database', 'Keycloak database', 'Persists realm configuration, users, credentials and persistent session state.', 'PostgreSQL (reference choice)', 'security-keycloak-db', store=True)
    components('keycloak.server', '''
endpoints|OIDC and SAML endpoints|Accepts authorization, token and federation requests and returns protocol responses.
authentication|Authentication flows|Evaluates configured authenticators and required authentication steps.
broker|Identity broker|Delegates login to an external OIDC or SAML identity provider through the browser.
ldap|LDAP user federation|Queries AD user attributes and validates credentials by LDAP bind; never imports AD passwords.
tokens|Token and claim mapping|Builds and signs tokens or assertions with mapped roles and attributes.
admin|Administration|Manages realms, clients, users, roles and identity-provider configuration.
sessions|Session and embedded cache management|Tracks login sessions and cached realm or user data in the server runtime.
persistence|Persistence adapter|Reads and writes realm, user and persistent session records.
''', 'security-keycloak', 'Java / Keycloak')
    local('keycloak.server', '''
endpoints|authentication|Passes authorization request and authentication context
authentication|broker|Delegates selected external-provider login
authentication|ldap|Passes directory lookup and credential validation requests
ldap|authentication|Returns user attributes and credential validation outcome
broker|authentication|Returns verified external identity claims
authentication|sessions|Creates or resolves authenticated user session
sessions|tokens|Supplies session identity and client scope
tokens|endpoints|Returns signed tokens or SAML assertions
admin|persistence|Writes realm, client and federation settings
authentication|persistence|Reads local credentials and realm authentication settings
sessions|persistence|Reads and writes persistent session records
''')
    flow('keycloak.server', 'keycloak.database', 'Reads and writes realm, user and session records', 'PostgreSQL / TLS', 'DirectoryFlow')
    flow('keycloak.server.persistence', 'keycloak.database', 'Reads and writes realm, user and session records', 'PostgreSQL / TLS', 'DirectoryFlow')

    system('managedHsm', 'Azure Managed HSM', 'Protects cryptographic keys and performs authorized cryptographic operations; not a general secret or certificate store.', 'security-hsm')
    runtime('managedHsm.service', 'Managed HSM data-plane service', 'Logical managed-service boundary for key operations and local role assignments; physical HSM topology is excluded.', 'Azure Managed HSM / HTTPS API', 'security-hsm', logical=True)
    runtime('managedHsm.keys', 'HSM-protected key storage', 'Logical protected store for non-exportable example private keys, key versions and local role data; not a separate database server.', 'HSM-protected managed storage (logical)', 'security-hsm-keys', logical=True, store=True)
    components('managedHsm.service', '''
api|Data-plane API|Accepts authenticated key-management and cryptographic requests.
authentication|Entra token validation|Validates token signature, issuer and resource audience using trusted metadata.
authorization|Local RBAC authorization|Checks Managed HSM local roles and key scope separately from Azure resource-management RBAC.
lifecycle|Key lifecycle|Creates and versions keys and manages permitted key operations and role assignments.
crypto|Cryptographic operations|Performs sign, verify, encrypt, decrypt, wrap and unwrap operations supported by the selected key.
audit|Operation auditing|Records principal, operation, key identifier and outcome without secret key material.
''', 'security-hsm', 'Managed service responsibility / implementation undisclosed', logical=True)
    local('managedHsm.service', '''
api|authentication|Passes bearer token and requested resource audience
authentication|authorization|Passes validated caller identity and requested operation
authorization|lifecycle|Authorizes key lifecycle or local role-management command
authorization|crypto|Authorizes cryptographic operation on the selected key version
crypto|api|Returns signature, ciphertext or wrapped-key result
lifecycle|api|Returns key identifier, public metadata and operation outcome
api|audit|Records caller, key identifier, operation and outcome
''', 'KeyFlow')
    for caller in ('managedHsm.service', 'managedHsm.service.lifecycle'):
        flow(caller, 'managedHsm.keys', 'Creates or updates protected keys, versions and local role records', 'Protected managed-service storage interface', 'KeyFlow')
    flow('managedHsm.service.crypto', 'managedHsm.keys', 'Invokes cryptographic operation using protected key handle; no private-key export', 'Protected cryptographic interface (logical)', 'KeyFlow')
    flow('managedHsm.keys', 'managedHsm.service.crypto', 'Returns cryptographic result without private key material', 'Protected cryptographic interface (logical)', 'KeyFlow')

    system('cyberarkPam', 'CyberArk PAM Self-Hosted', 'Controls privileged credentials, password rotation and recorded administrative sessions.', 'security-pam')
    for ident, name, desc in (
        ('vault', 'Digital Vault', 'Protects privileged credentials, Safe permissions and audit/session records.'),
        ('pvwa', 'Password Vault Web Access', 'Provides the web interface and APIs for privileged-account access and administration.'),
        ('cpm', 'Central Policy Manager', 'Verifies, rotates and reconciles managed target-account passwords.'),
        ('psm', 'Privileged Session Manager', 'Brokers privileged target sessions and records session activity.'),
    ):
        runtime('cyberarkPam.'+ident, name, desc, 'CyberArk PAM / proprietary service', 'security-pam')
    components('cyberarkPam.vault', '''
access|Vault access interface|Accepts authenticated Safe, credential and record operations.
policy|Safe permissions|Checks access permissions for credentials and records.
storage|Protected credential storage|Owns encrypted credential and Safe records inside the Vault boundary.
audit|Audit and recording storage|Retains access audit records and uploaded session recordings.
''', 'security-pam', 'Vault responsibility / proprietary implementation', logical=True)
    local('cyberarkPam.vault', '''
access|policy|Passes caller identity and requested Safe operation
policy|storage|Authorizes credential read or write
storage|access|Returns permitted credential or metadata response
access|audit|Stores access events or uploaded session recordings
''', 'PrivilegedFlow')
    components('cyberarkPam.pvwa', '''
portal|Web portal and API|Accepts account access, session-launch and administration requests.
approval|Access request workflow|Evaluates configured request and approval requirements.
vaultClient|Vault client|Retrieves permitted account metadata or credentials and submits administration changes.
sessions|Session launch|Creates authorized session connection details for the session manager.
''', 'security-pam', 'PVWA responsibility / proprietary implementation', logical=True)
    local('cyberarkPam.pvwa', '''
portal|approval|Submits requested account and access justification
approval|vaultClient|Passes approved credential or metadata request
approval|sessions|Authorizes target session launch
vaultClient|portal|Returns authorized account metadata and access outcome
''', 'PrivilegedFlow')
    components('cyberarkPam.cpm', '''
scheduler|Password management scheduler|Selects target accounts requiring verification, change or reconciliation.
rotation|Password rotation orchestration|Coordinates target password change and Vault credential update.
target|Target platform connector|Runs the configured target-specific password verification or change operation.
vaultClient|Vault credential client|Reads current credentials and writes successfully changed credentials.
''', 'security-pam', 'CPM responsibility / proprietary implementation', logical=True)
    local('cyberarkPam.cpm', '''
scheduler|rotation|Passes account identifier and password management task
rotation|vaultClient|Requests current credential and target account metadata
vaultClient|rotation|Returns permitted credential and target details
rotation|target|Passes password verification or change operation
target|rotation|Returns target password operation outcome
rotation|vaultClient|Submits successfully changed credential for storage
''', 'PrivilegedFlow')
    components('cyberarkPam.psm', '''
broker|Session broker|Accepts authorized session requests and retrieves target credentials.
target|Target session connector|Establishes the example SSH session using the vaulted privileged account.
recorder|Session recorder|Captures session activity and uploads recordings to the Vault.
''', 'security-pam', 'PSM responsibility / proprietary implementation', logical=True)
    local('cyberarkPam.psm', '''
broker|target|Passes authorized target and privileged credential
target|recorder|Supplies session activity for recording
target|broker|Returns session output and completion status
''', 'PrivilegedFlow')
    for caller in ('cyberarkPam.pvwa', 'cyberarkPam.pvwa.vaultClient', 'cyberarkPam.cpm', 'cyberarkPam.cpm.vaultClient', 'cyberarkPam.psm', 'cyberarkPam.psm.broker'):
        flow(caller, 'cyberarkPam.vault', 'Submits permitted Safe credential or metadata operations', 'CyberArk Vault protocol / encrypted channel', 'PrivilegedFlow')
        flow('cyberarkPam.vault', caller, 'Returns authorized credential or account metadata', 'CyberArk Vault protocol / encrypted channel', 'SecretFlow')
    for caller in ('cyberarkPam.psm', 'cyberarkPam.psm.recorder'):
        flow(caller, 'cyberarkPam.vault', 'Uploads session recordings and audit metadata', 'CyberArk Vault protocol / encrypted channel', 'PrivilegedFlow')
    for caller in ('cyberarkPam.pvwa', 'cyberarkPam.pvwa.sessions'):
        flow(caller, 'cyberarkPam.psm', 'Supplies authorized session-launch context via the user session client', 'Session connection parameters / client-mediated', 'PrivilegedFlow')
    for caller in ('cyberarkPam.cpm', 'cyberarkPam.cpm.target'):
        flow(caller, 'managedTarget', 'Verifies or changes the privileged target password', 'SSH / target-specific password commands', 'PrivilegedFlow', True)
        flow('managedTarget', caller, 'Returns password verification or change outcome', 'SSH / target command response', 'PrivilegedFlow', True)
    for caller in ('cyberarkPam.psm', 'cyberarkPam.psm.target'):
        flow(caller, 'managedTarget', 'Opens privileged SSH session and relays administrator commands', 'SSH', 'PrivilegedFlow', True)
        flow('managedTarget', caller, 'Returns command output and session state', 'SSH', 'PrivilegedFlow', True)

    system('conjur', 'CyberArk Conjur Enterprise', 'Enterprise workload secret access; documented as Secrets Manager Self-Hosted. OSS is not the selected variant.', 'security-conjur')
    runtime('conjur.service', 'Conjur service', 'Logical enterprise runtime for policy, workload authentication and secret APIs; no leader/follower placement is specified.', 'Conjur Enterprise / HTTPS API', 'security-conjur', logical=True)
    runtime('conjur.store', 'Conjur encrypted persistence', 'Logical service-owned storage for encrypted secrets, identity and policy state; not an independently provisioned database claim.', 'Service-owned encrypted persistence (logical)', 'security-conjur', logical=True, store=True)
    runtime('conjur.synchronizer', 'Vault Synchronizer', 'Reads selected PAM Vault accounts and synchronizes their secret values into Conjur Enterprise.', 'CyberArk Vault Synchronizer', 'security-conjur-sync')
    components('conjur.service', '''
api|Secret and policy API|Accepts authenticated secret and policy operations.
authentication|Workload authentication|Validates the configured workload identity proof and issues a short-lived Conjur access token.
policy|Policy authorization|Evaluates workload permissions for the requested secret variable or policy resource.
secrets|Secret access|Returns only authorized secret values and accepts permitted updates.
audit|Access auditing|Records workload, variable identifier and operation outcome without secret values.
''', 'security-conjur', 'Conjur responsibility / logical reference', logical=True)
    local('conjur.service', '''
api|authentication|Submits configured workload authentication proof
authentication|api|Returns short-lived Conjur access token
api|policy|Passes token identity, variable path and requested operation
policy|secrets|Authorizes secret variable read or update
secrets|api|Returns authorized secret value or update status
api|audit|Records workload, variable identifier and operation outcome
''', 'SecretFlow')
    components('conjur.synchronizer', '''
reader|Vault account reader|Reads selected Vault accounts and changed credentials.
mapping|Account-to-variable mapping|Maps selected Vault account metadata to Conjur variable identifiers.
writer|Conjur update client|Authenticates to Conjur and writes synchronized secret values.
''', 'security-conjur-sync', 'Synchronizer responsibility / proprietary implementation', logical=True)
    local('conjur.synchronizer', '''
reader|mapping|Supplies selected account identifier, metadata and credential version
mapping|writer|Supplies mapped variable identifier and updated secret value
''', 'SecretFlow')
    for caller in ('conjur.service', 'conjur.service.secrets'):
        flow(caller, 'conjur.store', 'Reads or writes encrypted secret records and versions', 'Service-owned persistence interface (logical)', 'SecretFlow')
    flow('conjur.service.policy', 'conjur.store', 'Reads workload permissions and variable policy records', 'Service-owned persistence interface (logical)', 'SecretFlow')
    for caller in ('conjur.synchronizer', 'conjur.synchronizer.reader'):
        flow(caller, 'cyberarkPam.vault', 'Reads configured Vault accounts and changed credential versions', 'CyberArk Vault protocol / encrypted channel', 'SecretFlow', evidence=('security-conjur-sync',))
        flow('cyberarkPam.vault', caller, 'Returns selected account metadata and credentials', 'CyberArk Vault protocol / encrypted channel', 'SecretFlow', evidence=('security-conjur-sync',))
    for caller in ('conjur.synchronizer', 'conjur.synchronizer.writer'):
        flow(caller, 'conjur.service', 'Authenticates and writes mapped secret variable values', 'HTTPS / Conjur API', 'SecretFlow', evidence=('security-conjur-sync',))

    system('entraId', 'Microsoft Entra ID', 'Cloud identity, token issuance, directory administration and provisioning; separate from AD DS and AD FS.', 'security-entra')
    for ident, name, description, evidence in (
        ('authentication', 'Authentication and token service', 'Logical identity-platform service for user and application authentication and token issuance.', 'security-entra-oidc'),
        ('directory', 'Directory and administration API', 'Logical directory and Microsoft Graph-facing boundary for users, groups, applications and policies.', 'security-entra'),
        ('provisioning', 'Cloud Sync provisioning service', 'Orchestrates selected AD object synchronization and commits directory changes.', 'security-cloud-sync'),
    ):
        runtime('entraId.'+ident, name, description, 'Microsoft Entra managed service (logical)', evidence, logical=True)
    runtime('entraId.agent', 'Cloud Sync provisioning agent', 'Customer-managed runtime that queries AD DS through outbound-established communication with the provisioning service.', 'Microsoft Entra provisioning agent / Windows service', 'security-cloud-sync')
    components('entraId.authentication', '''
endpoints|Identity protocol endpoints|Accepts OIDC authorization and OAuth token requests.
credentials|Identity authentication|Validates configured user or application authentication proof.
policy|Access-policy evaluation|Applies applicable sign-in and access requirements for this identity and resource.
tokens|Token issuance|Issues signed ID and access tokens with audience-specific claims.
''', 'security-entra-oidc', 'Identity-platform responsibility / implementation undisclosed', logical=True)
    local('entraId.authentication', '''
endpoints|credentials|Passes authorization or token request with authentication proof
credentials|policy|Supplies authenticated identity and sign-in context
policy|tokens|Supplies permitted identity, audience and scopes
tokens|endpoints|Returns signed ID or access token response
''')
    components('entraId.directory', '''
api|Directory administration API|Accepts authorized directory reads and changes through public administrative interfaces.
authorization|Directory authorization|Checks caller permissions for the requested directory resource operation.
records|Directory object access|Reads and writes identity, group, application and policy records.
''', 'security-entra', 'Directory responsibility / implementation undisclosed', logical=True)
    local('entraId.directory', '''
api|authorization|Passes caller, directory resource and operation
authorization|records|Authorizes identity or policy record access
records|api|Returns directory objects or update outcome
''', 'DirectoryFlow')
    components('entraId.provisioning', '''
scheduler|Provisioning orchestration|Schedules scoped synchronization work and tracks incremental progress.
mapping|Provisioning mapping and processing|Processes returned attributes according to configured scopes and mappings.
writer|Directory update client|Commits processed object changes to the Entra directory.
''', 'security-cloud-sync', 'Cloud Sync logical responsibility', logical=True)
    local('entraId.provisioning', '''
scheduler|mapping|Submits returned directory object changes and synchronization state
mapping|writer|Supplies filtered and mapped directory object changes
''', 'DirectoryFlow')
    components('entraId.agent', '''
channel|Outbound service channel|Receives synchronization requests through the agent-established service connection.
directory|AD query connector|Queries scoped AD objects and returns requested attributes.
response|Synchronization response|Returns directory data and progress information to cloud provisioning.
''', 'security-cloud-sync', 'Provisioning agent logical responsibility', logical=True)
    local('entraId.agent', '''
channel|directory|Passes requested directory scope and attribute query
directory|response|Supplies selected object attributes and query outcome
response|channel|Returns synchronization data for the established service channel
''', 'DirectoryFlow')
    for caller in ('entraId.authentication', 'entraId.authentication.credentials', 'entraId.authentication.policy'):
        flow(caller, 'entraId.directory', 'Reads identity, application and applicable policy records', 'Microsoft internal service interface (logical)', 'DirectoryFlow')
    for caller in ('entraId.provisioning', 'entraId.provisioning.writer'):
        flow(caller, 'entraId.directory', 'Commits scoped user, group and contact changes', 'Microsoft internal directory interface (logical)', 'DirectoryFlow')
    for caller in ('entraId.agent', 'entraId.agent.channel'):
        flow(caller, 'entraId.provisioning', 'Establishes outbound channel and returns requested directory attributes', 'TLS / Cloud Sync service channel via Azure Service Bus', 'DirectoryFlow')
        flow('entraId.provisioning', caller, 'Delivers scoped synchronization requests over the agent-established channel', 'SCIM / established Cloud Sync channel', 'DirectoryFlow')
    flow('entraId.provisioning.scheduler', 'entraId.agent', 'Delivers scoped directory synchronization requests', 'SCIM / agent-established service channel', 'DirectoryFlow')
    flow('entraId.agent', 'entraId.provisioning.mapping', 'Returns scoped object attributes and synchronization progress', 'TLS / established Cloud Sync channel', 'DirectoryFlow')

    system('adDs', 'Microsoft Active Directory Domain Services', 'Directory identities, LDAP queries and Kerberos authentication for the enterprise domain.', 'security-ad')
    runtime('adDs.directory', 'Domain-controller services', 'Logical AD DS runtime; no server instances, sites or replication topology are modeled.', 'Windows Server / AD DS', 'security-ad')
    runtime('adDs.database', 'AD directory data store', 'Domain-controller-owned directory objects, schema and account records.', 'NTDS directory database / owned storage', 'security-ad', store=True)
    runtime('adDs.sysvol', 'SYSVOL store', 'Domain-controller-owned policy templates and scripts; no filesystem deployment is specified.', 'SYSVOL / owned filesystem', 'security-ad', store=True)
    components('adDs.directory', '''
ldap|LDAP directory interface|Accepts directory searches and authenticated binds.
kdc|Kerberos KDC|Validates domain authentication and issues Kerberos tickets.
access|Directory access and authorization|Applies directory permissions and resolves requested account attributes.
persistence|Directory persistence|Reads and writes directory objects and account records.
replication|Directory replication responsibility|Processes directory change records; controller topology is deliberately omitted.
policy|Group Policy and SYSVOL access|Supplies domain policy metadata and policy-file references.
''', 'security-ad', 'AD DS logical responsibility', logical=True)
    local('adDs.directory', '''
ldap|access|Passes bind or directory search request
access|persistence|Reads permitted account attributes or updates directory objects
kdc|persistence|Reads account authentication and ticket-policy records
replication|persistence|Applies replicated directory change records
policy|access|Reads authorized Group Policy object metadata
''', 'DirectoryFlow')
    for caller in ('adDs.directory', 'adDs.directory.persistence'):
        flow(caller, 'adDs.database', 'Reads and writes directory objects, account records and change state', 'Local directory database interface', 'DirectoryFlow')
    for caller in ('adDs.directory', 'adDs.directory.policy'):
        flow(caller, 'adDs.sysvol', 'Reads domain policy templates and script references', 'Local filesystem access', 'DirectoryFlow')
    for caller in ('entraId.agent', 'entraId.agent.directory'):
        flow(caller, 'adDs.directory', 'Queries selected users, groups, contacts and requested attributes', 'LDAP / protected domain connection', 'DirectoryFlow')
        flow('adDs.directory', caller, 'Returns scoped directory object attributes and change information', 'LDAP / protected domain connection', 'DirectoryFlow')
    for caller in ('keycloak.server', 'keycloak.server.ldap'):
        flow(caller, 'adDs.directory', 'Queries user attributes and validates supplied credentials by LDAP bind', 'LDAPS', 'IdentityFlow', True)
        flow('adDs.directory', caller, 'Returns user attributes and bind result; does not export passwords', 'LDAPS', 'IdentityFlow', True)

    system('adFs', 'Microsoft Active Directory Federation Services', 'Federates AD-backed identities and issues claims to relying parties; separate from directory synchronization.', 'security-adfs')
    runtime('adFs.service', 'AD FS federation service', 'Authenticates users and issues claims under configured relying-party trust policy.', 'Windows Server / AD FS', 'security-adfs')
    runtime('adFs.configuration', 'AD FS configuration store', 'Stores trust, claim-rule and federation configuration; WID is the reference store choice.', 'Windows Internal Database (reference choice)', 'security-adfs', store=True)
    components('adFs.service', '''
endpoints|Federation protocol endpoints|Accepts relying-party requests and returns browser-mediated federation responses.
authentication|Authentication adapters|Validates user authentication through configured domain mechanisms.
claims|Claims engine|Transforms incoming claims and directory attributes using configured claim rules.
tokens|Token issuance|Signs and issues claims tokens for the configured relying party.
configuration|Trust and configuration access|Loads relying-party trusts, claims rules and signing configuration.
audit|Federation auditing|Records authentication, claims issuance outcome and request context.
''', 'security-adfs-claims', 'AD FS logical responsibility', logical=True)
    local('adFs.service', '''
endpoints|authentication|Passes relying-party authentication request and user context
authentication|claims|Supplies authenticated identity and requested attributes
claims|tokens|Supplies transformed claims and relying-party audience
tokens|endpoints|Returns signed federation response
claims|configuration|Loads applicable claims transformation and issuance rules
tokens|configuration|Loads token-signing and relying-party trust settings
endpoints|audit|Records federation request context and issuance outcome
''')
    for caller in ('adFs.service', 'adFs.service.configuration'):
        flow(caller, 'adFs.configuration', 'Reads federation trusts, claim rules and signing configuration', 'WID / local configuration database interface', 'DirectoryFlow')
    for caller in ('adFs.service', 'adFs.service.authentication'):
        flow(caller, 'adDs.directory', 'Validates domain authentication and resolves account attributes', 'Kerberos / protected directory interfaces', 'IdentityFlow')
        flow('adDs.directory', caller, 'Returns domain authentication result and requested attributes', 'Kerberos / protected directory interfaces', 'IdentityFlow')

    # Reference integrations are additive: no existing FireFly auth or wallet
    # implementation is redefined. Browser mediation is explicit in the labels.
    for target, protocol in (('keycloak.server', 'OIDC'), ('entraId.authentication', 'OIDC'), ('adFs.service', 'SAML 2.0')):
        flow('business', target, 'Submits sign-in interaction through the user browser', 'HTTPS / browser '+protocol, example=True)
        flow('apps.client', target, 'Submits authorization request via browser and configured protocol client', 'HTTPS / '+protocol+' reference client', example=True)
        flow(target, 'apps.client', 'Returns authenticated identity tokens or assertions through the selected protocol flow', 'HTTPS / '+protocol+' reference client', example=True)
    for target in ('keycloak.server.endpoints', 'entraId.authentication.endpoints', 'adFs.service.endpoints'):
        flow('apps.client', target, 'Submits relying-party authorization request using the reference client', 'HTTPS / OIDC or SAML as configured', example=True)
        flow(target, 'apps.client', 'Returns signed identity response through the configured browser/client flow', 'HTTPS / OIDC or SAML as configured', example=True)
    for caller in ('keycloak.server', 'keycloak.server.broker'):
        flow(caller, 'entraId.authentication', 'Redirects browser with OIDC authorization request', 'HTTPS / browser-mediated OIDC', example=True)
        flow('entraId.authentication', caller, 'Returns authorization code through browser redirect', 'HTTPS / OIDC redirect', example=True)
        flow(caller, 'entraId.authentication', 'Exchanges authorization code with client authentication for tokens', 'HTTPS / OAuth token endpoint', example=True)
        flow('entraId.authentication', caller, 'Returns signed ID token and token endpoint response', 'HTTPS / OAuth token response', example=True)
        flow(caller, 'adFs.service', 'Redirects browser with SAML authentication request', 'HTTPS / browser-mediated SAML 2.0', example=True)
        flow('adFs.service', caller, 'Returns signed SAML assertion through browser POST', 'HTTPS / browser-mediated SAML 2.0', example=True)
    for target in ('conjur.service', 'conjur.service.api'):
        flow('apps.client', target, 'Authenticates workload and requests permitted secret variable', 'HTTPS / Conjur authentication and secrets APIs', 'SecretFlow', True)
        flow(target, 'apps.client', 'Returns short-lived access token or authorized application secret', 'HTTPS / Conjur API response', 'SecretFlow', True)
    for target in ('managedHsm.service', 'managedHsm.service.api'):
        flow('apps.client', target, 'Submits bearer token, key identifier and digest or key-wrapping input', 'HTTPS / Managed HSM REST API', 'KeyFlow', True)
        flow(target, 'apps.client', 'Returns signature or wrapped data key; never the HSM private key', 'HTTPS / Managed HSM REST response', 'KeyFlow', True)
    flow('apps.client', 'entraId.authentication', 'Authenticates workload identity and requests HSM-audience access token', 'HTTPS / OAuth 2.0 client credentials', 'IdentityFlow', True)
    flow('entraId.authentication', 'apps.client', 'Returns HSM-audience workload access token', 'HTTPS / OAuth 2.0 token response', 'IdentityFlow', True)
    for caller in ('managedHsm.service', 'managedHsm.service.authentication'):
        flow(caller, 'entraId.authentication', 'Retrieves issuer metadata and public signing keys for cached token verification', 'HTTPS / OpenID metadata and JWKS', 'IdentityFlow')
    for target in ('cyberarkPam.pvwa', 'cyberarkPam.pvwa.portal'):
        flow('operator', target, 'Requests approved privileged-account access or recorded target session', 'HTTPS / PAM web portal', 'PrivilegedFlow', True)
    for target in ('cyberarkPam.psm', 'cyberarkPam.psm.broker'):
        flow('operator', target, 'Connects authorized session client and submits administrative input', 'PSM-supported session client / encrypted connection', 'PrivilegedFlow', True)
        flow(target, 'operator', 'Returns brokered session output and completion status', 'PSM-supported session client / encrypted connection', 'PrivilegedFlow', True)
    for target in ('adDs.directory', 'adDs.directory.kdc'):
        flow('business', target, 'Requests domain sign-in and service tickets through the domain client', 'Kerberos / domain client', example=True)
        flow(target, 'business', 'Returns Kerberos ticket response to the domain client', 'Kerberos / domain client', example=True)

    # No physical HSM, deployment node, new FireFly plugin, or native wallet
    # integration is asserted. The proposed adapter belongs to applications.
    element('apps.hsmSigner', 'container', 'Proposed HSM signing adapter',
            'Optional custom Ethereum RPC signing proxy; requires implementation and compatibility testing. Not built into FireFly Signer.',
            'Reference adapter / Ethereum JSON-RPC + Azure REST', 'security-hsm-keys',
            'Optional,ReferenceIntegration', 'Proposed reference integration')
    for ident, name, desc in rows('''
transactions|Transaction preparation|Prepares chain-aware Ethereum signing payloads and Keccak-256 digests; preserves supplied transaction fields.
hsm|HSM access client|Acquires an Entra application token and requests signing with the selected non-exportable secp256k1 key.
signature|Signature conversion and validation|Normalizes low-s, determines recovery parity and verifies the Ethereum sender before transaction encoding.
rpc|RPC submission|Submits the encoded signed transaction to Besu and returns the transaction hash or RPC error.
'''):
        element('apps.hsmSigner.'+ident, 'component', name, 'Proposed reference: '+desc,
                'Custom integration responsibility / implementation required', 'security-ethereum-transactions',
                'Optional,ReferenceIntegration', 'Proposed reference integration')
        E['apps.hsmSigner.'+ident]['sources'].append(source('security-hsm-keys'))
    local('apps.hsmSigner', '''
transactions|hsm|Passes Ethereum digest, key version and required signing algorithm
hsm|signature|Returns HSM signature, public key and original signing digest
signature|rpc|Supplies verified and encoded signed Ethereum transaction
rpc|transactions|Returns submitted transaction hash or RPC error
''', 'KeyFlow', True)
    flow('firefly.evm', 'apps.hsmSigner', 'Submits unsigned transaction to the proposed alternative signing proxy', 'Ethereum JSON-RPC / HTTPS (reference)', 'KeyFlow', True)
    flow('firefly.evm', 'apps.hsmSigner.transactions', 'Submits unsigned Ethereum transaction fields', 'Ethereum JSON-RPC / HTTPS (reference)', 'KeyFlow', True)
    flow('apps.hsmSigner', 'firefly.evm', 'Returns transaction hash or signing/submission error', 'Ethereum JSON-RPC response', 'KeyFlow', True)
    for caller in ('apps.hsmSigner', 'apps.hsmSigner.hsm'):
        flow(caller, 'entraId.authentication', 'Authenticates application identity and requests Managed HSM access token', 'HTTPS / OAuth 2.0 client credentials', 'IdentityFlow', True)
        flow('entraId.authentication', caller, 'Returns Managed HSM audience access token', 'HTTPS / OAuth 2.0 token response', 'IdentityFlow', True)
        flow(caller, 'managedHsm.service', 'Submits Ethereum digest for secp256k1 signing; compatibility must be verified', 'HTTPS / Managed HSM Sign API (proposed)', 'KeyFlow', True, ('security-hsm-keys', 'security-ethereum-transactions'))
        flow('managedHsm.service', caller, 'Returns signature and public key metadata; never private key material', 'HTTPS / Managed HSM API response', 'KeyFlow', True)
    for caller in ('apps.hsmSigner', 'apps.hsmSigner.rpc'):
        flow(caller, 'besu.node', 'Submits encoded signed transaction for validation and propagation', 'Ethereum JSON-RPC / eth_sendRawTransaction', 'KeyFlow', True)
        flow('besu.node', caller, 'Returns transaction hash or JSON-RPC rejection', 'Ethereum JSON-RPC response', 'KeyFlow', True)

    # Explicit level-1 relationships, because impliedRelationships is disabled.
    for product in PRODUCTS:
        mechanism = ('Protected LDAP / directory administration' if product=='adDs' else
                     'AD FS administration / PowerShell' if product=='adFs' else 'HTTPS / product administration interface')
        flow('securityAdmin', product, 'Configures '+E[product]['name']+' access policy and reviews administrative outcomes', mechanism, 'SecurityAdminFlow', True)
    for product in ('keycloak', 'entraId', 'adFs'):
        flow('apps', product, 'Requests application sign-in and identity claims', 'HTTPS / OIDC or SAML reference flow', example=True)
        flow(product, 'apps', 'Returns identity tokens or assertions for application access', 'HTTPS / configured identity protocol', example=True)
        flow('business', product, 'Completes user sign-in through browser-mediated authentication', 'HTTPS / user browser', example=True)
    flow('keycloak', 'adDs', 'Requests LDAP user attributes and credential validation', 'LDAPS', example=True)
    flow('adDs', 'keycloak', 'Returns user attributes and credential validation outcome', 'LDAPS', example=True)
    for target, protocol in (('entraId', 'OIDC'), ('adFs', 'SAML 2.0')):
        flow('keycloak', target, 'Delegates login through browser-mediated '+protocol+' federation', 'HTTPS / '+protocol, example=True)
        flow(target, 'keycloak', 'Returns verified identity claims through the configured federation flow', 'HTTPS / '+protocol, example=True)
    flow('adFs', 'adDs', 'Requests domain authentication and account attributes', 'Kerberos / protected directory access')
    flow('adDs', 'adFs', 'Returns domain authentication result and account attributes', 'Kerberos / protected directory access')
    flow('entraId', 'adDs', 'Queries selected directory objects through the Cloud Sync provisioning agent', 'Protected LDAP / agent-established TLS service channel', 'DirectoryFlow')
    flow('adDs', 'entraId', 'Returns selected identity attributes for Cloud Sync provisioning', 'Protected LDAP / agent-established TLS service channel', 'DirectoryFlow')
    flow('business', 'adDs', 'Requests domain sign-in and service tickets through the domain client', 'Kerberos', example=True)
    flow('operator', 'cyberarkPam', 'Requests approved privileged access and submits session commands', 'HTTPS / PAM portal and encrypted session client', 'PrivilegedFlow', True)
    flow('cyberarkPam', 'managedTarget', 'Rotates target credentials and brokers recorded privileged sessions', 'SSH / target-specific password commands', 'PrivilegedFlow', True)
    flow('cyberarkPam', 'conjur', 'Supplies selected Vault credentials through Vault Synchronizer', 'CyberArk Vault protocol + HTTPS / Conjur API', 'SecretFlow', evidence=('security-conjur-sync',))
    flow('apps', 'conjur', 'Authenticates workload and requests permitted application secrets', 'HTTPS / Conjur API', 'SecretFlow', True)
    flow('conjur', 'apps', 'Returns short-lived token or authorized application secret', 'HTTPS / Conjur API response', 'SecretFlow', True)
    flow('apps', 'managedHsm', 'Submits authorized signing or key-wrapping request', 'HTTPS / Managed HSM REST API', 'KeyFlow', True)
    flow('managedHsm', 'apps', 'Returns signature or wrapped key result without private key material', 'HTTPS / Managed HSM REST response', 'KeyFlow', True)
    flow('managedHsm', 'entraId', 'Retrieves issuer metadata and public signing keys for caller token verification', 'HTTPS / OpenID metadata and JWKS')
    flow('securityAdmin', 'azureManagement', 'Submits Managed HSM resource administration request', 'HTTPS / Azure Resource Manager API', 'SecurityAdminFlow', True)
    flow('azureManagement', 'managedHsm', 'Applies resource-management changes authorized by Azure RBAC; does not grant key access', 'Azure management-plane interface', 'SecurityAdminFlow')
    flow('azureManagement', 'managedHsm.service', 'Applies resource-management changes; key access still requires local RBAC', 'Azure management-plane interface (logical)', 'SecurityAdminFlow')

    admin_targets = ('keycloak.server', 'keycloak.server.admin', 'managedHsm.service', 'managedHsm.service.lifecycle',
                     'cyberarkPam.pvwa', 'cyberarkPam.pvwa.portal', 'conjur.service', 'conjur.service.api',
                     'entraId.directory', 'entraId.directory.api', 'adDs.directory', 'adDs.directory.ldap',
                     'adFs.service', 'adFs.service.configuration')
    for target in admin_targets:
        mechanism = ('Protected LDAP / directory administration' if target.startswith('adDs.') else
                     'AD FS administration / PowerShell configuration interface' if target.startswith('adFs.') else
                     'HTTPS / product administration API')
        flow('securityAdmin', target, 'Submits authorized configuration or access-policy changes', mechanism, 'SecurityAdminFlow', True)

    diagram('systemLandscape', '', 'landscape', 'System Landscape - Security product reference catalog',
            list(PRODUCTS)+['securityAdmin', 'business', 'operator', 'apps', 'managedTarget', 'azureManagement'])
    contexts = {
        'keycloak': ['business', 'apps', 'adDs', 'entraId', 'adFs'],
        'managedHsm': ['apps', 'entraId', 'azureManagement'],
        'cyberarkPam': ['operator', 'managedTarget', 'conjur'],
        'conjur': ['apps', 'cyberarkPam'],
        'entraId': ['apps', 'business', 'adDs', 'keycloak', 'managedHsm'],
        'adDs': ['business', 'keycloak', 'entraId', 'adFs'],
        'adFs': ['business', 'apps', 'adDs', 'keycloak'],
    }
    externals = {
        'keycloak': ['business', 'apps.client', 'adDs.directory', 'entraId.authentication', 'adFs.service'],
        'managedHsm': ['apps.client', 'entraId.authentication', 'azureManagement'],
        'cyberarkPam': ['operator', 'managedTarget', 'conjur.synchronizer'],
        'conjur': ['apps.client', 'cyberarkPam.vault'],
        'entraId': ['apps.client', 'business', 'adDs.directory'],
        'adDs': ['business', 'keycloak.server', 'adFs.service', 'entraId.agent'],
        'adFs': ['business', 'apps.client', 'adDs.directory', 'keycloak.server'],
    }
    for product in PRODUCTS:
        diagram('systemContext', product, product+'-context', 'System Context - '+E[product]['name']+' reference',
                [product, 'securityAdmin']+contexts[product])
        diagram('container', product, product+'-containers', 'Container - '+E[product]['name']+' logical reference',
                kids(product)+['securityAdmin']+externals[product])

    component_contexts = {
        'keycloak.server': ['apps.client', 'securityAdmin', 'keycloak.database', 'adDs.directory', 'entraId.authentication', 'adFs.service'],
        'managedHsm.service': ['apps.client', 'securityAdmin', 'managedHsm.keys', 'entraId.authentication'],
        'cyberarkPam.vault': [],
        'cyberarkPam.pvwa': ['operator', 'securityAdmin', 'cyberarkPam.vault', 'cyberarkPam.psm'],
        'cyberarkPam.cpm': ['cyberarkPam.vault', 'managedTarget'],
        'cyberarkPam.psm': ['operator', 'cyberarkPam.vault', 'managedTarget'],
        'conjur.service': ['apps.client', 'securityAdmin', 'conjur.store'],
        'conjur.synchronizer': ['cyberarkPam.vault', 'conjur.service'],
        'entraId.authentication': ['apps.client', 'entraId.directory'],
        'entraId.directory': ['securityAdmin'],
        'entraId.provisioning': ['entraId.agent', 'entraId.directory'],
        'entraId.agent': ['adDs.directory', 'entraId.provisioning'],
        'adDs.directory': ['business', 'securityAdmin', 'adDs.database', 'adDs.sysvol'],
        'adFs.service': ['apps.client', 'securityAdmin', 'adDs.directory', 'adFs.configuration'],
        'apps.hsmSigner': ['firefly.evm', 'managedHsm.service', 'entraId.authentication', 'besu.node'],
    }
    for parent, external in component_contexts.items():
        diagram('component', parent, parent.replace('.', '-')+'-components',
                'Component - '+E[parent]['name']+': '+('proposed integration' if parent=='apps.hsmSigner' else 'logical responsibilities'),
                kids(parent)+external)

    examples = [
        ('keycloak', 'login-ad', 'Keycloak login with AD LDAP', ['business', 'apps.client', 'keycloak.server', 'adDs.directory']),
        ('keycloak', 'broker-entra', 'Browser-mediated Keycloak and Entra OIDC', ['business', 'apps.client', 'keycloak.server', 'entraId.authentication']),
        ('keycloak', 'broker-adfs', 'Browser-mediated Keycloak and AD FS SAML', ['business', 'apps.client', 'keycloak.server', 'adFs.service', 'adDs.directory']),
        ('entraId', 'directory-sync', 'AD identity synchronization through Cloud Sync', ['adDs.directory', 'entraId.agent', 'entraId.provisioning', 'entraId.directory']),
        ('cyberarkPam', 'privileged-access', 'PAM password rotation and recorded sessions', ['operator', 'cyberarkPam.pvwa', 'cyberarkPam.vault', 'cyberarkPam.cpm', 'cyberarkPam.psm', 'managedTarget']),
        ('conjur', 'secret-delivery', 'Vault synchronization and workload secret retrieval', ['cyberarkPam.vault', 'conjur.synchronizer', 'conjur.service', 'conjur.store', 'apps.client']),
        ('managedHsm', 'key-protection', 'Entra-authenticated HSM signing and key wrapping', ['apps.client', 'entraId.authentication', 'managedHsm.service', 'managedHsm.keys']),
        ('apps', 'dlt-signing', 'Proposed HSM-backed Ethereum transaction signing', ['firefly.evm', 'apps.hsmSigner', 'entraId.authentication', 'managedHsm.service', 'besu.node']),
    ]
    for scope, suffix, title, selected in examples:
        def selected_flow(r):
            pair = {r['source'], r['destination']}
            if suffix in ('broker-entra', 'broker-adfs') and 'apps.client' in pair:
                return not bool(pair & {'entraId.authentication', 'adFs.service'})
            if suffix=='broker-adfs' and pair=={'keycloak.server', 'adDs.directory'}:
                return False
            if suffix=='key-protection' and pair=={'apps.client', 'entraId.authentication'}:
                return 'HSM-audience' in r['description']
            return True
        diagram('container', scope, 'example-'+suffix, 'Container - Example: '+title, selected, selected_flow)

    # Every new element must be explicitly evidenced and every new arrow must
    # name its information transfer. Existing views and logical elements remain
    # intact; these examples do not replace the filesystem-wallet reference.
    assert all('SecurityCatalog' in E[i]['tags'] and E[i]['sources'] for i in set(E)-original_elements)
    assert all(r['description'] and r['technology'] and r['evidence'] for r in R[original_relationship_count:])
