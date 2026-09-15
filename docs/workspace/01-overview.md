# FireFly and Besu architecture

## Purpose and scope

This workspace documents a three-member FireFly consortium integrated with a private Besu QBFT network. It covers C4 system context, containers and components; there are no code diagrams. The AKS topology is a proposed reference design, not a deployed or performance-tested installation.

Use the ordered diagram keys: **01–04** for context and alternatives; **10–11** for member containers; **20–40** for FireFly internals; **50–51** for Besu; **60–63** for clients and operations; **80–82** for deployment details; **99** for the complete deployment.

Members A, B and C each have an independent identity, Core database, FFTM database, keystore, mTLS identity, blob store and IPFS identity. They share the private chain and the AKS administrative boundary. Namespaces are logical isolation, not protection against a malicious cluster administrator.

The logical architecture defines FireFly once and Besu's node implementation once. Member and node identities belong to deployment instances, where roles, namespaces, storage and keys differ. Member deployment groups constrain relationship replication; dedicated peer groups allow private Data Exchange, shared IPFS and Besu traffic. Logical diagrams describe the reusable architecture; deployment diagrams show all three members explicitly.

## C4 modeling rules

A container is a runtime or data store, not necessarily a Docker container. Explorer is served by Core and appears inside its component boundary. EVMConnect embeds FireFly Transaction Manager; FFTM is not another pod. PostgreSQL primary and standby containers distinguish deployment roles of the same database implementation. Smart contracts are deployed artifacts executed inside Besu's EVM, not separate AKS processes.

Components group related runtime functionality. Common libraries, individual classes, codecs, test utilities and build tools are not additional architectural components. EIP-712 signing and other Signer library capabilities are documented in the source inventory; the reference proxy only needs its transaction-signing path. Kubo, PostgreSQL and platform operators are supporting runtimes represented as containers; their complete implementation internals are outside the FireFly/Besu component scope.

All diagrams use static model relationships. Two arrows are used where separate command and event workflows matter. A single request arrow can include its response in the label. P2P gossip arrows show a configured communication route, not an exclusive direction of network traffic.

## Evidence and design choices

Each logical element has a source URL and evidence classification. The immutable source revisions and web-document fingerprints are in **sources.json**. **coverage.csv** maps every element to its views. **model-catalog.json** provides machine-readable model and deployment records.

The FireFly head documentation was consulted through its official GitHub source because the published head website could not be retrieved in this environment. Repository snapshots were captured on 15 September 2026. Pinning a source snapshot does not imply that all independently versioned binaries have been integration-tested together.

The shared AKS cluster, Envoy-based ingress, CloudNativePG, placement, storage classes and recovery procedures are reference choices. They are not presented as an official FireFly Azure architecture or as unchanged upstream Helm defaults.

## Legend

Blue: application structure. Gold: Besu and blockchain execution. Cylinders: persistent data stores. Purple outlines: private member state. Green outlines: consortium-shared content. Grey dashed boxes: optional alternatives. Solid arrows: runtime dataflows. Dashed green-grey arrows: operational traffic. Line crossings without endpoints are not additional connections. Every rendered diagram also includes the Structurizr notation key.

