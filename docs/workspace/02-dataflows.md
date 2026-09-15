# Dataflows and interfaces

## Application APIs and event delivery

Member applications call their own Core REST API over HTTPS. Core resolves the namespace and authorization plugin before orchestration. The supplied authentication implementation is HTTP Basic Auth; richer OAuth/JWT/RBAC is an integration choice, not an assumed built-in feature. Do not expose the Admin API publicly.

Explorer is bundled with Core. The optional Sandbox has a React frontend, a Node.js backend and an embedded FireFly SDK. CLI and Sandbox are development tools; they are not required production AKS workloads.

Core persists events and subscription offsets and delivers batches over WebSocket or webhook. Consumers acknowledge successfully processed batches. Consumers must tolerate redelivery and reconnect from durable offsets; this reference does not promise end-to-end exactly-once processing.

## Private messaging

Core validates data, resolves recipient groups and builds batches. Its data-exchange shim calls HTTPS Data Exchange through the internal API. The connector transfers envelopes and blobs to the recipient's mTLS peer endpoint. The private data itself does not enter the blockchain or shared IPFS pool.

Private blob bytes and mutable peer metadata use member-specific durable storage. The connector's event queue and in-flight notifications are in memory in the captured implementation. A volume surviving a node failure does not by itself preserve those notifications. Recovery must reconcile unfinished Core operations with sender/receiver results and exercise retransmission and duplicate detection.

Peer ingress must use TCP/TLS passthrough so the connector can authenticate the actual peer certificate. The Core-facing connector API is restricted to the member namespace; it is not the public peer API.

## Broadcast and ledger sequencing

Broadcast payloads are uploaded to IPFS and addressed by CID. FireFly submits batch hashes and references through the blockchain plugin and EVMConnect. Payloads and chain events can arrive in different orders. The inbound aggregator waits for the associated data, validates hashes and emits sequenced application events.

IPFS content in this reference is shared across the consortium, not public by default: use a private Kubo swarm key, controlled bootstrap peers and restricted egress. Private messages never rely on that shared storage. Pins must be retained for the required data-retention period. Peering alone is not a promise that every CID has been replicated to every Kubo node.

## Transactions and tokens

Core or a token connector submits a transaction to EVMConnect. Embedded FFTM assigns the sender nonce, persists the transaction, applies retry/gas policy and invokes the EVM adapter. The Signer resolves the member keystore, signs the transaction and forwards the raw transaction to a synchronized Besu RPC node.

Besu checks permissioning, gossips transactions, orders blocks with QBFT, executes the EVM and persists receipts and state. FireFly multiparty, ERC-20/721/1155 and example business contracts execute in that EVM boundary.

EVMConnect tracks blocks and receipts, confirms events, delivers batches and checkpoints acknowledgements. Token connectors translate contract logs into standard token events for Core. One active nonce manager owns each signing address; other tools must not concurrently allocate nonces for that address.

Use stable, session-affine RPC routing because Ethereum filter identifiers are node-local. On RPC failover, recreate filters/listeners and resume from persisted checkpoints. A load balancer must not silently scatter a filter lifecycle across nodes.

## Persistence and telemetry

Core and FFTM use separate databases and credentials within the member PostgreSQL cluster. Only the current primary accepts application writes; standby relationships are WAL replication, not application load balancing.

Prometheus scrapes Core and Besu metric endpoints; Grafana queries Prometheus. Operator control arrows represent Kubernetes API actions rather than business payload delivery.

