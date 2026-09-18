# Logical system boundary and evidence

The element's description, technology, source URL and evidence classification
define its boundary. Components represent cohesive responsibilities inside their
owning runtime. FireFly and Besu detail is source-backed. Security product
components describe documented capabilities, with inferred proprietary internals
classified as logical reference abstractions rather than verified implementation
modules. Other external systems expose their integration boundaries.

Keycloak, Managed HSM, CyberArk PAM, Conjur Enterprise, Entra ID, AD DS and AD FS
are separate systems. Embedded Keycloak functions remain inside its server.
PAM's Vault, PVWA, CPM and PSM are separate runtime containers. Conjur persistence
is a service-owned logical store. Entra managed-service subdivisions and HSM
service/storage boundaries are logical abstractions, not physical service or
hardware placement claims. Cloud Sync's agent is customer-managed but belongs
to the logical Entra integration boundary. AD FS does not own AD DS identities.

The optional `apps.hsmSigner` container is a proposed application-owned custom
adapter. The existing FireFly filesystem wallet, API authentication and Besu
node-key responsibilities are unchanged. Entra tokens do not themselves grant
Managed HSM key permissions; local HSM authorization remains a separate check.

Explorer and the Sandbox UI are browser runtime containers; bundling their
assets into a server image does not make their code an in-process server
component. Core and FFTM own different logical database containers. A database
replica is an instance of its deployment, not an additional logical data store.
The member-application and operations systems are explicitly reference solution
boundaries. Groups organize related products without merging those boundaries.

All diagram relationships are directed and describe exchanged information or
in-process requests. Optional configurations have dedicated views. Sources are
pinned in sources.json; the source inventory and coverage reports identify the
owning components and any grouped library/support responsibilities.

Only the canonical `workspace.dsl` is inspected in this phase. Deployment
definitions are archived outside the workspace, and existing historical exports
are unvalidated by this pass. The architecture
decisions explain the selected boundaries and inspection policy.
