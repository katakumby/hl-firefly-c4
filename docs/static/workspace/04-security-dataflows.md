# Security example dataflows

All keys below start with `100-security-example-`. These are selected static
relationships in C4 container views, not sequence or deployment diagrams.
The catalog overview deliberately shows alternatives; each example selects one
path. No browser or application credentials are implied to flow to unrelated
identity providers.

| View suffix | Selected flow |
|---|---|
| `login-ad` | Member application and browser → Keycloak → AD DS LDAP; bind result and attributes return to Keycloak |
| `broker-entra` | Application → Keycloak → Entra via browser OIDC; code and token responses return to Keycloak |
| `broker-adfs` | Application → Keycloak → AD FS via browser SAML; AD FS validates against AD DS |
| `directory-sync` | AD DS ↔ Cloud Sync agent ↔ provisioning service → Entra directory |
| `privileged-access` | Operator → PVWA/PSM → managed target; CPM changes target credentials and updates the Vault |
| `secret-delivery` | PAM Vault → Vault Synchronizer → Conjur → authorized application |
| `key-protection` | Application → Entra workload token endpoint → HSM API; cryptographic results return |
| `dlt-signing` | EVMConnect → proposed custom signing adapter → HSM; adapter submits signed transaction to Besu |

## Authentication and directory synchronization

The LDAP example validates supplied credentials against AD DS and returns bind
status and selected user attributes. Keycloak can import mapped user data; it
does not import AD passwords. The example's LDAP transport is LDAPS.

For OIDC brokering, Keycloak redirects the browser to Entra, the browser returns
an authorization code, and Keycloak exchanges that code through the token
endpoint. Entra returns a signed identity-token response. For SAML brokering,
the browser carries the authentication request and signed assertion between
Keycloak and AD FS. AD FS obtains the domain authentication result and account
attributes from AD DS. Browser-mediated labels describe those front-channel
transfers; they do not mean that user credentials are posted server-to-server
between the identity providers. Focused broker views exclude direct application
login to the upstream provider and exclude the competing Keycloak LDAP route.

Cloud Sync's agent establishes the outbound service channel. Synchronization
requests arrive over that established channel; the agent queries scoped AD
objects and returns attributes for cloud-side processing and directory updates.
The arrows describe data direction, not who opened a network connection. This
example covers directory objects, not password-hash synchronization, password
writeback or an AD FS sign-in dependency.

## Privileged access and application secrets

The operator requests access through PVWA and connects through an authorized
PSM session client. PSM retrieves permitted credentials, opens the example SSH
session and uploads recordings to the Vault. Credentials used to open a session
are not shown as being disclosed to the operator. CPM verifies or changes the
target password and writes successful changes back to the Vault. The exact
target password commands are platform-specific reference choices.

Vault Synchronizer reads selected Vault account metadata and credential values,
maps them to Conjur variables and writes updates through Conjur's API. A workload
authenticates with its configured Conjur authenticator and receives a short-lived
access token. Policy authorization permits only selected variable reads, after
which the API returns the authorized application secret. The authentication
method is intentionally not claimed to be a built-in FireFly integration.
The source-backed Vault synchronization feature belongs to the enterprise
selection, not Conjur OSS. Synchronization is not modeled as atomic with target
rotation; applications must handle credential rollover and refresh in a future
implementation.

## HSM operations and the proposed signing adapter

The application acquires an Entra workload token for the Managed HSM audience.
HSM token validation and local RBAC authorize the selected key operation.
Sign requests contain a digest and key identifier; wrapping requests contain
the key-wrapping input. Responses contain a signature or wrapped data key.
This diagram does not claim that Managed HSM stores general application secrets.
Private signing keys are non-exportable in this example. Public keys, key
identifiers and permitted cryptographic results may leave the HSM.

The DLT adapter is optional custom application code that has not been implemented
by this architecture task. It would replace the signing-proxy endpoint selected
for EVMConnect, while the existing filesystem-wallet reference remains intact.
The adapter prepares the chain-aware Ethereum signing payload and Keccak-256
digest, requests secp256k1 signing, normalizes low-s and determines recovery
parity, verifies the recovered sender, encodes the transaction, and calls
`eth_sendRawTransaction`. Besu returns a transaction hash or rejection; a hash
does not prove ledger inclusion or finality. Existing receipt/event processing
continues to supply those outcomes.

Azure documents P-256K/secp256k1 and ES256K support, but its algorithm description
refers to SHA-256 digests. This catalog does not establish that submitting an
Ethereum Keccak digest is a supported interoperable signing configuration.
Before implementation, confirm the API's digest semantics and supported key
operations, returned signature representation, low-s normalization, recovery
parity, key-version-to-address mapping and chain-specific transaction encoding
against known Ethereum vectors. Curve support alone is insufficient evidence.
Fail closed on token, authorization, key-version or signature-validation errors;
do not introduce fallback key export. Cryptographic interoperability and runtime
error handling are requirements for future adapter implementation, not results
of the DSL validation.

Application transaction keys are separate from Besu node/validator keys and
peer-transport identity. No validator-key migration, provisioning, recovery
topology, quorum configuration or cloud deployment is part of this reference.
