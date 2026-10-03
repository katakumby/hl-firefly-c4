# Security product catalog: C4 levels 1–3

This is a product reference catalog with independent example integrations.
It does not prescribe one combined identity stack or claim these products are
already connected to FireFly. `workspace.dsl` selects the full reference
catalog. Initiatives may select individual views from the same shared model.
These references do not prescribe code or deployment architecture.

## Navigation

Start at `100-security-landscape`. Each product has a context view and a
container view with the following stable keys. Component views use the same
prefix plus the product/container identifier and `-components`.

| Product | Context suffix | Container suffix | Component scopes |
|---|---|---|---|
| Keycloak | `keycloak-context` | `keycloak-containers` | Server |
| Azure Managed HSM | `managedHsm-context` | `managedHsm-containers` | Data-plane service |
| CyberArk PAM Self-Hosted | `cyberarkPam-context` | `cyberarkPam-containers` | Vault, PVWA, CPM, PSM |
| Conjur Enterprise | `conjur-context` | `conjur-containers` | Service, Vault Synchronizer |
| Microsoft Entra ID | `entraId-context` | `entraId-containers` | Authentication, directory, provisioning, agent |
| AD DS | `adDs-context` | `adDs-containers` | Domain-controller services |
| AD FS | `adFs-context` | `adFs-containers` | Federation service |

Prepend `100-security-` to every suffix. For example,
`100-security-keycloak-server-components` drills into Keycloak's server.
`100-security-apps-hsmSigner-components` details the proposed signing adapter.
There are 38 security views: one landscape, seven contexts, seven container
overviews, fifteen component views and eight static scenario views.

## Product and runtime boundaries

Keycloak owns a server and a PostgreSQL reference database. Authentication,
protocol endpoints, identity brokering, LDAP federation, token mapping,
administration, sessions/cache and persistence are inside the server. Its
embedded cache is not modeled as a separate service.

Managed HSM exposes a logical data-plane service and protected key store.
Its components describe API access, token validation, local RBAC, key lifecycle,
cryptographic operations and auditing. These are functional abstractions, not
Microsoft's physical service implementation. Azure Resource Manager remains an
external control-plane boundary; resource-management access does not bypass key
authorization. The example is Managed HSM, not Key Vault's general secret store.

CyberArk PAM has four runtime containers: Digital Vault, Password Vault Web
Access (PVWA), Central Policy Manager (CPM) and Privileged Session Manager (PSM).
Credential storage/auditing, access workflows, target password changes and
session brokering/recording stay within their respective containers. The
managed target is a generic SSH-accessible system, not an invented FireFly
administration endpoint.

Conjur Enterprise is the selected product, also documented as Secrets Manager
Self-Hosted. It has a logical service, service-owned encrypted persistence and
Vault Synchronizer runtime. No leader/follower, standby or storage-placement
topology is specified. PAM rotates credentials; the synchronizer delivers
selected values to Conjur, which authenticates and authorizes consuming workloads.

Entra's authentication, directory/API and provisioning boundaries are logical
managed-service views. The Cloud Sync agent is a distinct customer-managed
runtime. AD DS owns directory authentication and domain records, while AD FS
owns federation and claims issuance. None of these is FireFly's consortium
identity manager or its unfinished identity extension.

## Legend and evidence

| Convention | Meaning |
|---|---|
| Standard C4 fills | Person, software system, container or component |
| Cylinder | Logical data store; not necessarily a database server |
| Dashed blue-grey border, `LogicalReference` | Inferred logical responsibility or proprietary boundary |
| Dashed ochre border/arrow, `ReferenceIntegration` | Proposed or configurable application example |
| Blue `IdentityFlow` | Authentication proof, claims, token or identity metadata |
| Green `DirectoryFlow` | Directory objects, attributes, configuration or synchronization |
| Purple `SecretFlow` | Secret access, authorized values or synchronized credentials |
| Gold `KeyFlow` | Key identifiers, cryptographic inputs, signatures or wrapped keys |
| Red `PrivilegedFlow` | Privileged-account operations, sessions or recordings |
| Grey `SecurityAdminFlow` | Security configuration and administration |

Reference-integration styling takes precedence over arrow category color.
Arrow labels and protocol metadata carry meaning without relying on color.
Reverse arrows name meaningful returned data, not an unlabeled bidirectional
dependency. Protocol labels marked logical do not assert undocumented wire formats.

Ordinary relationships have no DSL variable names. Views select complete sets
of arrows by their source and destination. The HSM workload-token request and
response retain descriptive names so the key-protection example can select
those two arrows without introducing the alternative browser-login path.

Element properties distinguish documented capabilities, logical reference
abstractions and proposed integrations. Relationship classifications explicitly
identify architecture inferences. Element URLs and `architecture.sources`
properties in the [DSL definitions](../../model/external-systems) identify the
supporting documentation. The former source inventory and coverage reports are
available in Git history. Broad product guides support capability-level claims, not
claims about unpublished classes or microservices. This pass does not perform
visual rendering or operational interoperability tests.
