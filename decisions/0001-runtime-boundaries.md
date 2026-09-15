# 1. Preserve real runtime boundaries

Date: 2026-09-15

## Status

Accepted

## Context

FireFly is a pluggable set of runtimes. Treating every library or visual feature as a separate pod produces an inaccurate deployment.

## Decision

Model Explorer inside Core, FFTM inside EVMConnect, Go plugin shims inside Core, remote connectors as separate containers, and smart-contract artifacts inside Besu's execution boundary. Keep datastore and deployment roles explicit. Component diagrams stop at logical modules.

## Consequences

The expanded member models are generated from one component definition to prevent drift. Supporting database, Kubo and platform internals remain black-box dependencies. Optional integrations are documented separately from the selected runtime path.

