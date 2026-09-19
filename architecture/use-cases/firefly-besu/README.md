# FireFly–Besu smart-contract use cases

Seven use cases describe ordinary Ethereum smart contracts on the workspace's private, permissioned Besu network. Each has two Mermaid sequence diagrams: a simplified software-system view and a container view. These are C4 **dynamic views** using sequence notation, complementing the existing static model.

## Start here

| Use case | Result |
|---|---|
| [1. Deploy a contract](01-deploy-contract.md) | A deployed address and tracked deployment result |
| [2. Register a contract interface and API](02-register-contract-api.md) | A named REST API over a deployed contract |
| [3. Query contract state](03-query-contract-state.md) | A decoded read result without a transaction |
| [4. Update contract state](04-update-contract-state.md) | A tracked state-changing transaction |
| [5. Subscribe to contract events](05-subscribe-contract-events.md) | Acknowledged delivery with reconnection and replay |
| [6. Associate private data with a contract transaction](06-private-data-and-contract.md) | Private payload delivery correlated with a ledger pin |
| [7. Handle failures and uncertain submissions](07-failures-and-recovery.md) | Reconciled outcomes without duplicate business submissions |

Start with 1–5 for the `SimpleStorage` lifecycle. Use 6 for the additional custom-pinning contract requirements and 7 for failure recovery. These documents specify interactions; they do not install a network, deploy contracts, or change runtime APIs.

## Scope and configuration

The selected path is **member application → FireFly Core → EVMConnect with embedded FFTM → FireFly Signer → Besu**. FireFly Signer proxies read RPCs as well as signing writes. Core and FFTM own separate logical PostgreSQL databases. Member-to-member private messaging uses HTTPS Data Exchange.

"Private" means membership-restricted Besu with QBFT and configured node/account permissioning. Ordinary calldata, contract state, and events remain available to consortium ledger participants. Private business payloads instead flow off-chain to selected FireFly group members; ledger pins are commitments, not those payloads. This is consistent with [Besu's permissioning model](https://docs.besu-eth.org/private-networks/concepts/permissioning) and [FireFly private messaging](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/tutorials/private_send.md).

TLS on application-facing HTTPS/WSS and PostgreSQL connections, HTTP on the internal connector/RPC links, and the Signer proxy route follow this workspace's reference configuration. They are explicit architecture choices, not claims about product defaults or a deployed environment. Namespace authorization and account/key provisioning are prerequisites. A zero gas price, validator count, connector confirmation depth, or particular deployment topology is not assumed.

## Asynchronous application pattern

The application keeps a durable WebSocket subscription open and receives results as events. Continuous application polling is unnecessary. EVMConnect performs ledger polling; the application uses queries for initial state, missing details, and recovery of operations that stop progressing.

Before submitting the first deployment or invocation, create the namespace subscription with `POST /api/v1/namespaces/{ns}/subscriptions`:

```json
{
  "name": "contract-operations",
  "transport": "websockets",
  "filter": {
    "events": "^blockchain_(contract_deploy|invoke)_op_(succeeded|failed)$"
  },
  "options": { "firstEvent": "newest", "readAhead": 1 }
}
```

This example chooses `newest` because the subscription is created **before** the commands it tracks. Reuse the subscription on restart; do not recreate it or reset its cursor. For pre-existing commands, reconcile their saved operation references.

Connect to the server-level `/ws` endpoint using WSS, then send this on each connection:

```json
{"type":"start","namespace":"default","name":"contract-operations","autoack":false}
```

Use the actual namespace in place of `default`. Persist a command's idempotency key before submission, then retain its returned operation `id` and FireFly transaction `tx`. A completion event's `reference` identifies the operation, included as `operation` in the event payload. Correlate these references; an event can arrive before the HTTP response. Persist its handling result before acknowledging, and make business effects idempotent.

```json
{"type":"ack","id":"<event-id>","subscription":{"namespace":"default","name":"contract-operations"}}
```

The subscription reference in the ACK also supports multiple subscriptions sharing one WebSocket. Reconnect with the same name and namespace; unacknowledged events can repeat.

| Diagram label | Exact event type |
|---|---|
| Deployment succeeded / failed event | `blockchain_contract_deploy_op_succeeded` / `blockchain_contract_deploy_op_failed` |
| Invocation succeeded / failed event | `blockchain_invoke_op_succeeded` / `blockchain_invoke_op_failed` |

The contract-log subscription in use case 5 is separate: `blockchain_event_received` reports contract events, not operation completion. No delivery order is guaranteed between subscriptions. Queries and local interface/API registration remain request/response operations.

### Delivery guarantees and result data

| Interaction | Guarantee and acknowledgement |
|---|---|
| EVMConnect -> Core transaction-result summary | Best effort; no subscription ACK or replay guarantee |
| EVMConnect -> Core contract-event batch | Acknowledged ingestion and connector checkpoint; may replay |
| Core -> application durable subscription | At least once; ACK after durable application processing |

If a connector result is missed, Core can remain `Pending` even though the connector has finished. A durable application subscription cannot replay a completion event that Core has not created. Use targeted `GET /operations/{opid}?fetchstatus=true` reconciliation after an application-defined completion deadline or recovery from an outage, with backoff. Follow [use case 7](07-failures-and-recovery.md); a timeout alone does not justify a new transaction.

| Result | Location and meaning |
|---|---|
| Core operation status and output | `status` and `output`; the output contains a connector result summary |
| Normal deployment address | `output.contractLocation.address`, or `operation.output.contractLocation.address` in the completion event |
| Connector detail | `detail` from `GET /operations/{opid}?fetchstatus=true`, including `detail.status` and `detail.receipt` when available |
| Besu receipt | Ethereum JSON-RPC result retrieved by EVMConnect; distinct from Core's operation output |

The connector applies its configured transaction-confirmation policy before reporting a terminal result. Contract-log confirmation and application acknowledgement are separate milestones. Diagrams show one possible timing; HTTP responses, background submission and event delivery can race.

Sources: [event types and enrichment](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/reference/types/_includes/event_description.md), [durable subscriptions](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/reference/types/_includes/subscription_description.md), [ACK scoping](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/reference/types/_includes/wsack_description.md), [transaction-result delivery](https://github.com/hyperledger-firefly/transaction-manager/blob/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/fftm/transaction_events_handler.go#L94-L120), [summary fields](https://github.com/hyperledger-firefly/transaction-manager/blob/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/apitypes/managed_tx.go#L427-L438), and [confirmation gate](https://github.com/hyperledger-firefly/transaction-manager/blob/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/txhandler/simple/policyloop.go#L335-L357).

## Shared notation

| Notation | Meaning |
|---|---|
| `[Software System]` | A complete system in the simplified view |
| `[Container]` plus a technology line | An application/runtime or data store in the detailed view |
| Mermaid `box` | Owning software-system boundary, with a member qualifier when relevant |
| `->>` | A request, command, or explicit acknowledgement |
| `-->>` | A response or asynchronous notification; the label identifies which |
| `[technology / protocol]` on an arrow | Transport/technology for that interaction, including responses and self-calls |
| `Note` | A summarized responsibility, precondition, or omitted internal detail |
| `loop`, `alt`, `opt`, `par` | Repetition, alternatives, optional behavior, or independently progressing paths |
| Numbered arrows | Reading order within the illustrated path; not a distributed global clock |

Blue boxes identify the member application boundary, green/purple boxes the member FireFly boundaries, and gold the Besu boundary. Text labels carry the same meaning without color. Single-member diagrams refer to the initiating member. A/B in use case 6 distinguish member instances of the same architecture; they do not define new product systems. Each group contains only its own containers.

**Terms:** ABI = Ethereum Application Binary Interface; FFI = FireFly Interface; FFTM = FireFly Transaction Manager; EVM = Ethereum Virtual Machine; QBFT = Besu's proof-of-authority consensus protocol; RPC = remote procedure call; ACK = acknowledgement; mTLS = mutual Transport Layer Security; WSS = WebSocket over TLS.

A C4 container is a running application or a data store, not necessarily a Docker container. Embedded FFTM and Core plugins remain inside their runtimes. The application contract, multiparty contract, EVM, and RocksDB remain responsibilities of the logical Besu node. Notes summarize consensus; no additional validators or physical nodes are introduced. This follows the [C4 container definition](https://c4model.com/abstractions/container) and the existing workspace boundaries.

The diagrams deliberately select the containers relevant to each interaction. Routine key loading, metadata reads, background maintenance, and preparation RPCs may be summarized. RPC replies are drawn back through the configured Signer proxy. Database writes shown in order do not claim a distributed transaction across Core, FFTM, and Besu.

## Model mapping

Participant declarations include `%% C4:` comments carrying the canonical identifiers from [the model catalog](../../../build/architecture/reference/model-catalog.json). Repeated member instances retain the same logical identifiers.

| Canonical ID | Model element | Used at |
|---|---|---|
| `apps` | Member application reference | System level |
| `apps.client` | Member business application | Container level |
| `firefly` | Hyperledger FireFly | System level / owning boundary |
| `firefly.core` | FireFly Core | Container level |
| `firefly.evm` | EVMConnect + FFTM | Container level |
| `firefly.signer` | FireFly Signer | Container level |
| `firefly.dx` | HTTPS Data Exchange | Container level |
| `firefly.pg` | Core PostgreSQL database | Container level |
| `firefly.fftmDb` | FFTM PostgreSQL database | Container level |
| `besu` | Private Besu network | System level / owning boundary |
| `besu.node` | Besu node | Container level |

The existing `peerMembers` element summarizes other member systems in static views. Use case 6 expands that peer role using the same FireFly/member-application definitions with explicit B qualifiers. It does not modify the static catalog.

## Evidence baseline

The requested [FireFly head documentation](https://hyperledger-firefly.github.io/firefly/head/) is a moving reference. This collection uses its official documentation source already pinned in [sources.json](../../references/sources.json), retrieved on 2026-09-18:

| Repository | Pinned revision |
|---|---|
| FireFly Core and documentation | `9d20f3081c9074d5b012427e5572ebc03da8d95d` |
| EVMConnect | `6e12bb4c050677780cf5dd975a926923868b0cb8` |
| FireFly Transaction Manager used by EVMConnect | `5915cbc4e0e30dea25068b770dadbcc8bdfa9321` |
| FireFly Signer | `cfafd71fb4d2c3061a946f6466269877c3f04d9d` |
| HTTPS Data Exchange | `b6a212d531da1ff1c24e762e7156e2593c73d052` |

Per-use-case links point to these official revision-pinned documentation pages. The official Swagger specification and source code resolve API details that the narrative tutorial abbreviates: asynchronous return behavior, operation identifiers, attached private-message selection, and idempotency query-filter spelling. The head website was unavailable to the web reader during preparation; the official pinned source is the reproducible baseline, not a claim to have refreshed head.

Besu documentation was checked on 2026-09-19: [private networks](https://docs.besu-eth.org/private-networks), [permissioning](https://docs.besu-eth.org/private-networks/concepts/permissioning), and [QBFT](https://docs.besu-eth.org/private-networks/how-to/configure/consensus/qbft). These sources support the network's semantics; they do not validate a running deployment.

Diagram rules follow official [C4 dynamic views](https://c4model.com/diagrams/dynamic), [C4 notation](https://c4model.com/diagrams/notation), and [Mermaid sequence syntax](https://mermaid.js.org/syntax/sequenceDiagram.html). The exact end-to-end sequences are architecture-level compositions of documented responsibilities, not a claim to reproduce every internal function call.

## Maintenance and verification

Edit the Markdown Mermaid blocks as the source of truth. There are exactly two diagrams per numbered document and none in this index. Keep system views at software-system level and detailed participants at container level; add the canonical model ID whenever a participant changes. Every arrow must retain its technology label.

For a diagram change, parse and render all affected Mermaid blocks, inspect the resulting layout, check relative links and API/source references, and verify the paired views still describe the same outcome. Temporary render outputs belong in the ignored `build/architecture/use-case-validation/` directory. This documentation does not regenerate `workspace.dsl`, the model catalog, or historical exports.


### Validation completed 2026-09-19

All 14 Mermaid blocks were parsed and rendered with Mermaid 11.12.0 in headless Chromium 127, then visually reviewed as seven diagram pairs. Structural checks verified technology labels on all 215 arrows, canonical C4 identifiers and owning groups, valid JSON examples, and working local links. Rendered text remained within each SVG view box after layout corrections.

Twelve concrete namespace API paths were checked against the pinned official Swagger specification; generated contract API paths were checked against the official tutorial. All 21 distinct revision-pinned FireFly source links were matched to the local official-source snapshot. Completion-event filters, subscription-scoped acknowledgements, confirmation gates, result fields, and recovery behavior were cross-checked against that baseline. These are documentation and diagram checks, not execution tests against a FireFly/Besu deployment. The generated model, evidence inventory, and historical exports were unchanged.

Validation details and SVG/PNG previews are local temporary artifacts under `build/architecture/use-case-validation/`; Markdown remains the deliverable.


See the [existing static dataflows](../../documentation/workspace/02-static-dataflows.md) and [private-Besu architecture decision](../../decisions/adr/0002-private-besu-flow.md) for the surrounding model.
