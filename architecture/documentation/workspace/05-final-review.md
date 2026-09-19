# Final logical architecture review

Reviewed: 2026-09-19. Input: the reference `architecture/workspace.dsl`. Review scope:
all modeled systems, containers, components, relationships and static view
selections. The corrections below predate the modular migration. Current
maintenance edits DSL fragments directly; Python generates only derived
catalogs and reports from the parsed workspace.

## Findings corrected

| Finding | Correction |
|---|---|
| Explorer React code was a Core component and its HTTP request was labeled as an in-process Go call. | Explorer is a browser container with an explicit Core API boundary. Core still serves its assets. |
| Sandbox browser and Node.js code shared one runtime boundary. | Separate browser and server containers; the SDK remains embedded in the server. |
| One PostgreSQL container combined Core and FFTM data ownership, with a separate standby container. | Separate logical Core and FFTM databases, no replica container or WAL flow in this static model. |
| EVMConnect's WebSocket component name also claimed webhook delivery. | Restrict its name/responsibility to WebSocket; keep the distinct webhook component. |
| Hosted smart contracts could be mistaken for native Besu modules. | Separate component groups for Besu implementation and hosted application contracts; retain the reference classifications. |
| Five authored arrows never appeared in views. | Include the relevant endpoints in focused views; retire the obsolete standby arrow. Add an alternative EVM-network view. |
| The storage-adapter view contained three disconnected diagram sections. | Include existing batch/data responsibilities that connect the flows; no artificial dependency added. |
| Application, tools and operations systems lacked their own context views. | Add focused contexts while preserving all existing view keys. |
| Several lower-level return/integration paths had no level-1 counterpart. | Add explicit event, starter, PAM, synchronization and proposed signing summaries. |
| HSM signing response also claimed public-key metadata. | Separate Sign results from Get Key public metadata requests/responses. Show protected cryptographic operations and results at container level. |
| A catalog relationship identifier retained an obsolete identity-plugin description. | Rebuild the identifier from the corrected action and validate that mapping. |

Browser separation and data-store ownership follow the official
[C4 container definition](https://c4model.com/abstractions/container).
Replica/failover details belong to
[deployment modeling](https://c4model.com/diagrams/container).
The pinned [Sandbox README](https://github.com/hyperledger-firefly/sandbox/blob/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/README.md)
and [Dockerfile](https://github.com/hyperledger-firefly/sandbox/blob/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/Dockerfile)
distinguish its server from the browser build. The pinned
[Explorer source](https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5/src)
grounds the browser responsibility. Their existing evidence snapshots were reused.

Microsoft's [Sign response](https://learn.microsoft.com/en-us/rest/api/keyvault/keys/sign/sign?view=rest-keyvault-keys-2025-07-01)
contains the operation result and key identifier;
[Get Key](https://learn.microsoft.com/en-us/rest/api/keyvault/keys/get-key/get-key?view=rest-keyvault-keys-2025-07-01)
retrieves public key material. Only these two new official references were
captured during the review, with fingerprints and retrieval metadata.

## Grouping decisions

| Navigation group | Separate systems retained |
|---|---|
| FireFly ecosystem | FireFly, developer tools, peer member boundary |
| EVM ledger networks | Private Besu example, other EVM networks |
| Fabric ecosystem | Fabric network, Fabric CA |
| Tezos ecosystem | Tezos network, Signatory |
| Cardano ecosystem | Cardano network, Blockfrost |
| Legacy connector infrastructure | Kafka, MongoDB receipt service |
| Identity and federation | Keycloak, Entra ID, AD DS, AD FS |
| Privileged access and secrets | CyberArk PAM, Conjur Enterprise |
| Azure cryptographic services | Managed HSM, Azure Resource Manager |

[Structurizr groups](https://docs.structurizr.com/dsl/language#group) organize
elements at the same level. These groupings are architecture judgments for
navigation; they make no common ownership, tenant, trust, hosting or mandatory
co-installation claim. Application, operations, Corda, Docker and managed-target
boundaries remain outside these product groups where no useful peer grouping
was established. Actors remain outside product groups.

## Similarities intentionally retained

- ERC-20/ERC-721 and ERC-1155 connectors have similarly named responsibilities
  in different runtime implementations. Merging them would lose product boundaries.
- FFTM embedded in EVMConnect and TezosConnect has distinct host ownership and
  pinned dependency versions. It is not an extra service or a duplicate runtime.
- SDK/API facades, adapters and transports represent different responsibilities;
  multiple components mapped to one source package are not automatically duplicates.
- Keycloak, Entra ID and AD FS overlap in authentication capability but remain
  independent products. AD DS is the directory/domain-authentication boundary.
- PAM manages privileged accounts and sessions; Conjur serves workload secrets.
  Their synchronization relationship does not make them one software system.
- HSM protected storage, Conjur persistence and Entra service subdivisions remain
  the previously accepted logical reference abstractions. Their boxes do not
  assert verified proprietary process layouts.
- Peer members represent external instances of the same reusable architecture,
  rather than copies of every local container.

## Identifier changes and navigation

| Previous element | Current representation |
|---|---|
| `firefly.core.explorer` | `firefly.explorer` container and `firefly.explorer.app` component |
| `tools.sandbox.frontend` | `tools.sandboxUi` container and `tools.sandboxUi.app` component |
| `firefly.pg` (combined server) | Retained identifier, narrowed to the Core logical database |
| `firefly.pgReplica` | Retired deployment instance; FFTM data now belongs to `firefly.fftmDb` |
| `tools.sandbox` | Retained identifier, narrowed to the Node.js server |

New view keys: `05-context-applications`, `06-context-tools`,
`07-context-operations`, `24-explorer-browser`, `68-sandbox-browser`,
`77-other-evm-network`. All original view keys are retained. The 38 security
views retain their keys and product coverage.

## Verification and limits

The [validation report](../../../build/architecture/reference/reports/validation-summary.md) records
fresh parser, inspector and semantic audit results. Fault-injection tests run
separately with `python -B -m unittest discover -s architecture/scripts -p test_workspace_validation.py`.
Checks cover unique definitions, same-owner duplicate names, precise parsed
scopes/groups, visible directional relationships, full relationship coverage,
connected views, C4 hierarchy and in-process call boundaries. Source coverage
checks every inventoried implementation file against an explicit responsibility
or support-code classification. This is traceability, not line-by-line runtime
behavior verification.

The review does not certify a deployed system or proprietary internals.
Ethereum/HSM digest compatibility, low-s normalization, recovery parity, key
version/address association and RPC compatibility remain requirements for the
proposed adapter. No native FireFly HSM support or private-key export is claimed.
No code, dynamic or deployment diagrams were added. Historical deployment data
and exports remain unchanged. Rendering and visual-layout QA remain outside the
requested DSL/documentation scope.
