# 1. Deploy a contract

[Use-case index and shared notation](README.md)

Deploy the compiled `SimpleStorage` contract using a member's FireFly signing identity, then obtain the deployed address.

**Prerequisites:** A running namespace uses EVMConnect and FireFly Signer; the signing account is permitted and has sufficient funds if gas is charged. Establish the [durable operation subscription](README.md#asynchronous-application-pattern) before submitting. Compile the official tutorial's Solidity example beforehand; FireFly receives bytecode and ABI, not Solidity source.

**Outcome:** A successful deployment operation exposes the address as `output.contractLocation.address`. Save that address for API registration.

## API and example

`POST /contracts/deploy` accepts `contract` (compiled bytecode), `definition` (ABI), `input` (constructor arguments), and optional `key` and `idempotencyKey`. `SimpleStorage` has no constructor arguments. Retain the returned operation `id` and `tx`; `tx` references the FireFly transaction, not the Ethereum transaction hash.

Receive `blockchain_contract_deploy_op_succeeded` or `blockchain_contract_deploy_op_failed` through the durable subscription. Correlate `event.reference` with the operation `id`, persist the result, then ACK. The diagrams show success; the [recovery use case](07-failures-and-recovery.md) covers missing results and failures.

The diagrams use the default asynchronous request. `?confirm=true` is an optional waiting mode; a request timeout still requires status reconciliation.

All API paths in this document use the namespace prefix `/api/v1/namespaces/{ns}` unless stated otherwise. The diagrams abbreviate that prefix. Names and addresses are example values.

## Software-system sequence

```mermaid
---
title: UC1 - Deploy a contract - software systems
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

    Note over App,FF: Durable operation subscription already connected
    App->>FF: Deploy bytecode and ABI [HTTPS REST / JSON]
    FF-->>App: 202 Accepted, operation identifier [HTTPS REST / JSON]
    FF->>Ledger: Submit signed deployment [Ethereum JSON-RPC / HTTP]
    Note over Ledger: Network consensus and EVM contract creation
    loop Until receipt and required confirmations
        FF->>Ledger: Get receipt and block data [Ethereum JSON-RPC / HTTP]
        Ledger-->>FF: Receipt or pending, block data [Ethereum JSON-RPC / HTTP]
    end
    Note over FF: Transaction-confirmation policy satisfied
    FF-->>App: Deployment succeeded event, address [WebSocket / JSON over TLS]
    App->>FF: ACK after durable processing [WebSocket / JSON over TLS]
```

## Container sequence

```mermaid
---
title: UC1 - Deploy a contract - containers
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
        %% C4: DB=firefly.pg
        participant DB as Core PostgreSQL<br/>database<br/>[Container]<br/>PostgreSQL
        %% C4: EVM=firefly.evm
        participant EVM as EVMConnect<br/>+ FFTM<br/>[Container]<br/>Go
        %% C4: TxDB=firefly.fftmDb
        participant TxDB as FFTM PostgreSQL<br/>database<br/>[Container]<br/>PostgreSQL
        %% C4: Signer=firefly.signer
        participant Signer as FireFly Signer<br/>[Container]<br/>Go
    end

    box rgb(255,247,224) Private Besu network
        %% C4: Besu=besu.node
        participant Besu as Besu node<br/>[Container]<br/>Java / Besu<br/>RocksDB
    end

    Note over App,Core: Durable operation subscription already connected
    App->>Core: POST /contracts/deploy [HTTPS REST / JSON]
    Core->>DB: Store transaction and deployment operation [PostgreSQL wire / TLS]
    Core->>EVM: Enqueue deployment bytecode and ABI [HTTP REST / JSON]
    Note over EVM,Signer: Encode and prepare before acceptance, RPCs via Signer
    EVM->>TxDB: Persist managed transaction and allocated nonce [PostgreSQL wire / TLS]
    EVM-->>Core: Managed transaction accepted [HTTP REST / JSON]
    Core-->>App: 202 Accepted, operation id and tx [HTTPS REST / JSON]
    EVM->>Signer: eth_sendTransaction, creation data and nonce [Ethereum JSON-RPC / HTTP]
    Signer->>Signer: Sign using member account key [Go / secp256k1]
    Signer->>Besu: eth_sendRawTransaction [Ethereum JSON-RPC / HTTP]
    Besu-->>Signer: Transaction hash [Ethereum JSON-RPC / HTTP]
    Signer-->>EVM: Transaction hash [Ethereum JSON-RPC / HTTP]
    Note over Besu: QBFT orders the block, EVM creates the contract
    loop Track receipt and required confirmations
        EVM->>Signer: Get receipt and block data [Ethereum JSON-RPC / HTTP]
        Signer->>Besu: Forward tracking RPCs [Ethereum JSON-RPC / HTTP]
        Besu-->>Signer: Receipt or pending, block data [Ethereum JSON-RPC / HTTP]
        Signer-->>EVM: Receipt or pending, block data [Ethereum JSON-RPC / HTTP]
    end
    Note over EVM: Transaction-confirmation policy satisfied
    EVM->>TxDB: Persist receipt and terminal status [PostgreSQL wire / TLS]
    EVM-->>Core: TransactionSuccess summary, best effort [WebSocket / JSON]
    Core->>DB: Store status, output and completion event [PostgreSQL wire / TLS]
    Core-->>App: Deployment succeeded event, address [WebSocket / JSON over TLS]
    App->>Core: ACK after durable processing [WebSocket / JSON over TLS]
    Core->>DB: Advance subscription offset [PostgreSQL wire / TLS]
```

## Behavior and failure cases

- Acceptance, block inclusion, connector confirmation and application processing are separate milestones. Core returns after the connector accepts the managed transaction; blockchain submission and completion proceed asynchronously.
- Invalid ABI/bytecode or constructor parameters can fail validation or transaction preparation. Account rejection, inadequate gas, or a reverted constructor prevents successful deployment.
- A pending receipt is not failure. Track the original operation after a timeout; use the same idempotency key when reconciling submission as described in [use case 7](07-failures-and-recovery.md).
- Contract compilation, key provisioning, nonce/gas preparation RPCs, and consensus internals are prerequisites or summarized steps. Application signing keys are separate from Besu validator keys.
- The transaction-result notification is best effort. A missed notification can leave Core pending; durable application replay alone cannot resolve it. Use [targeted reconciliation](07-failures-and-recovery.md#reconcile-a-missing-completion) without creating a new business action.
- Normal completion supplies `output.contractLocation.address`. If the connector notification was lost, recovery can obtain the address from `detail.receipt.contractLocation.address`; do not assume reconciliation repopulates that output field.

## Official sources

- [Ethereum smart-contract tutorial](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/tutorials/custom_contracts/ethereum.md).
- [Blockchain Connector Toolkit](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/architecture/blockchain_connector_framework.md).
- [Official API specification](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/swagger/swagger.yaml).
- [FireFly Signer proxy behavior](https://github.com/hyperledger-firefly/signer/blob/cfafd71fb4d2c3061a946f6466269877c3f04d9d/README.md).
- [Operation events](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/reference/types/_includes/event_description.md).
- [FFTM confirmation and terminal status](https://github.com/hyperledger-firefly/transaction-manager/blob/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/txhandler/simple/policyloop.go#L335-L357).
- [Result summaries and best-effort delivery](https://github.com/hyperledger-firefly/transaction-manager/blob/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/fftm/transaction_events_handler.go#L94-L120).

The [evidence baseline and model mapping](README.md#evidence-baseline) distinguish documented behavior from this workspace's configuration choices.
