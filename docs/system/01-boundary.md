# System boundary and traceability

This system is part of the three-member FireFly/Besu reference. Its name and element descriptions establish its responsibility; containers and components have immutable official-source URLs.

FireFly is defined once at the logical level. Members A, B and C instantiate its containers with separate identities, deployment groups and private data. Besu has one node implementation whose deployment instances select validator, RPC and discovery roles. The QBFT component is inactive on non-validator instances.

The workspace documentation explains protocols, optional connectors, AKS placement, recovery conditions and evidence limits. The source and coverage catalogs accompany the DSL. Infrastructure and example application choices are explicitly classified as reference choices.

The linked decisions apply to the overall reference architecture. See diagrams belonging to this system for its exact runtime boundary and dataflows.

