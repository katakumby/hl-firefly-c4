# 3. Query contract state

[Use-case index and shared notation](README.md)

Read the integer held by `SimpleStorage` through its generated API.

**Prerequisites:** The deployed contract has the registered `simple-storage` API from use case 2. The configured Besu RPC endpoint is reachable.

**Outcome:** The caller receives the decoded current value, for example `{"output":"3"}`.

## API and example

`POST /apis/simple-storage/query/get` with `{}` executes the contract's view method. HTTP POST is the FireFly query interface; it does not imply an Ethereum transaction.

All API paths in this document use the namespace prefix `/api/v1/namespaces/{ns}` unless stated otherwise. The diagrams abbreviate that prefix. Names and addresses are example values.

## Software-system sequence

```mermaid
---
title: UC3 - Query contract state - software systems
config:
  theme: default
  sequence:
    mirrorActors: false
    wrap: true
---
sequenceDiagram
    autonumber
%% C4: App=apps; FF=firefly; Ledger=besu
    participant App as Member application<br/>reference<br/>[Software System]
    participant FF as Hyperledger FireFly<br/>[Software System]
    participant Ledger as Private Besu<br/>network<br/>[Software System]

    App->>FF: Query SimpleStorage.get [HTTPS REST / JSON]
    FF->>Ledger: Read contract state with eth_call [Ethereum JSON-RPC / HTTP]
    Note over Ledger: Local EVM simulation, no state commit or new consensus round
    Ledger-->>FF: ABI-encoded return value [Ethereum JSON-RPC / HTTP]
    FF-->>App: Decoded output [HTTPS REST / JSON]
```

## Container sequence

```mermaid
---
title: UC3 - Query contract state - containers
config:
  theme: default
  sequence:
    mirrorActors: false
    wrap: true
---
sequenceDiagram
    autonumber
box rgb(235,245,255) Member application reference
        %% C4: App=apps.client
        participant App as Member business<br/>application<br/>[Container]<br/>REST client
    end
    box rgb(235,250,240) Hyperledger FireFly
        %% C4: Core=firefly.core
        participant Core as FireFly Core<br/>[Container]<br/>Go
        %% C4: EVM=firefly.evm
        participant EVM as EVMConnect<br/>+ FFTM<br/>[Container]<br/>Go
        %% C4: Signer=firefly.signer
        participant Signer as FireFly Signer<br/>[Container]<br/>Go
    end

    box rgb(255,247,224) Private Besu network
        %% C4: Besu=besu.node
        participant Besu as Besu node<br/>[Container]<br/>Java / Besu<br/>RocksDB
    end

    App->>Core: POST /apis/simple-storage/query/get [HTTPS REST / JSON]
    Note over Core: Resolve the registered API and FFI from local metadata
    Core->>EVM: Query contract address and method [HTTP REST / JSON]
    EVM->>Signer: eth_call, ABI-encoded input [Ethereum JSON-RPC / HTTP]
    Signer->>Besu: Forward eth_call unchanged [Ethereum JSON-RPC / HTTP]
    Note over Signer: No transaction signature or nonce allocation
    Note over Besu: Execute get in the EVM without committing state
    Besu-->>Signer: ABI-encoded result [Ethereum JSON-RPC / HTTP]
    Signer-->>EVM: ABI-encoded result [Ethereum JSON-RPC / HTTP]
    EVM-->>Core: Decoded output [HTTP REST / JSON]
    Core-->>App: JSON output value [HTTPS REST / JSON]
```

## Behavior and failure cases

- The configured RPC route passes through FireFly Signer even for reads. Signer proxies `eth_call`; it does not sign it.
- A query does not create a managed blockchain transaction, charge transaction gas, or commit contract changes. EVM execution still has resource limits.
- RPC unavailability, a mismatched ABI/address, or a reverted simulation returns an error rather than a valid result.
- The value reflects the state available to the queried node. Wait for the preceding write's successful execution before assuming a query will reflect it. Core metadata storage is omitted from the diagram because this flow focuses on ledger reads.

## Official sources

- [Ethereum smart-contract tutorial](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/tutorials/custom_contracts/ethereum.md).
- [FireFly Signer: passthrough JSON-RPC](https://github.com/hyperledger-firefly/signer/blob/cfafd71fb4d2c3061a946f6466269877c3f04d9d/README.md).

The [evidence baseline and model mapping](README.md#evidence-baseline) distinguish documented behavior from this workspace's configuration choices.
