# 2. Use EVMConnect and FireFly Signer for the private Besu example

Date: 2026-09-18

## Status

Accepted

## Context

The example needs a concrete signing, transaction, event and private-data path.

## Decision

Select EVMConnect with its dependency-pinned embedded FFTM, FireFly Signer,
PostgreSQL persistence, HTTPS Data Exchange, IPFS and optional standard token
connectors. Use private Besu with QBFT and local node/account permissioning.
Keep application signing keys separate from Besu node/validator keys. Private
payloads travel off-chain, independently of blockchain commitments.

## Consequences

Alternative connectors and stores are documented separately. This decision
does not validate the preserved validator count, deployment placement, recovery
automation or availability objectives. Those require the next review.
