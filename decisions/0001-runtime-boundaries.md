# 1. Preserve real runtime boundaries

Date: 2026-09-15

## Status

Accepted

## Context

FireFly is a pluggable set of runtimes. Treating every library or visual feature as a separate pod produces an inaccurate deployment.

## Decision

Model Explorer inside Core, FFTM inside EVMConnect, Go plugin shims inside Core, remote connectors as separate containers, and smart-contract artifacts inside Besu's execution boundary. Keep datastore and deployment roles explicit. Component diagrams stop at logical modules.

## Consequences

Define the FireFly software system, containers and components once. Members A, B and C are deployment instances of those containers, with member-specific deployment groups that prevent cross-member database, key and private-storage relationships. Data Exchange and IPFS also join dedicated peer groups. Besu is one reusable node definition; instance configuration selects validator, RPC and discovery roles. The QBFT component is active only in validator instances.

Use scoped outgoing relationships and meaningful hierarchical element identifiers. Relationships have no artificial numbered identifiers; views select their source and destination directly. Supporting database, Kubo and platform internals remain black-box dependencies. Optional integrations are documented separately from the selected runtime path.

The DSL uses the official [scoped relationship syntax](https://docs.structurizr.com/dsl/language#relationship) and [deployment groups](https://docs.structurizr.com/dsl/cookbook/deployment-groups/) to separate implementation reuse from member isolation.

