# 2. Select a private QBFT Besu integration

Date: 2026-09-15

## Status

Accepted

## Context

The example needs a permissioned Ethereum backend, all token standards and resilience to the loss of any one of three zones.

## Decision

Use EVMConnect/FFTM with FireFly Signer and a private Besu QBFT chain. Use six validators, two per zone, and three private RPC nodes. Members own two validators each in different zones. RPC1 and RPC3 also provide redundant discovery endpoints.

## Consequences

Quorum is four; losing two validators leaves sufficient live participants with no further outage headroom. EVMConnect's singleton nonce manager and node-local filter lifecycle require explicit recovery. EthConnect remains a documented alternative. A permissioned shared chain does not provide per-member confidentiality for on-chain payloads.

