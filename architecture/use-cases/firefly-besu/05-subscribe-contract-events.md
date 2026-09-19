# 5. Subscribe to contract events

[Use-case index and shared notation](README.md)

Receive `SimpleStorage.Changed` events reliably through a durable FireFly subscription and recover delivery after a disconnection.

**Prerequisites:** The contract ABI includes `Changed`; the named API is registered; an application consumer can retain processed event identifiers and acknowledge only after handling an event.

**Outcome:** The application receives `blockchain_event_received`, processes its decoded `Changed` output, and advances its subscription offset through an explicit acknowledgement.

## API and example

Create a listener using `POST /contracts/listeners`, identifying the interface, contract address, and `Changed` event. Set listener `options.firstEvent` to `"oldest"` to include past logs for this tutorial.

Create a durable subscription using `POST /subscriptions` with `name: "simple-storage-events"`, `transport: "websockets"`, `filter.events: "blockchain_event_received"`, `filter.blockchainevent.listener` set to the listener ID, and `options.firstEvent: "oldest"`.

Connect to the server-level `/ws` endpoint over WSS in this workspace example and send:

```json
{"type":"start","namespace":"default","name":"simple-storage-events","autoack":false}
```

After durable processing, send `{"type":"ack","id":"<event-id>","subscription":{"namespace":"default","name":"simple-storage-events"}}`. The subscription reference is required when multiple subscriptions share a WebSocket. The listener's starting block and the application's subscription offset are separate cursors.

All API paths in this document use the namespace prefix `/api/v1/namespaces/{ns}` unless stated otherwise. The diagrams abbreviate that prefix. Names and addresses are example values.

## Software-system sequence

```mermaid
---
title: UC5 - Subscribe to contract events - software systems
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

    App->>FF: Create contract listener and durable subscription [HTTPS REST / JSON]
    FF-->>App: Listener and subscription identifiers [HTTPS REST / JSON]
    App->>FF: Start named subscription, autoack false [WebSocket / JSON over TLS]
    loop Read and confirm matching contract logs
        FF->>Ledger: Poll blocks and Changed logs [Ethereum JSON-RPC / HTTP]
        Ledger-->>FF: Blocks and matching logs [Ethereum JSON-RPC / HTTP]
    end
    FF-->>App: blockchain_event_received [WebSocket / JSON over TLS]
    App->>FF: ACK after processing [WebSocket / JSON over TLS]
    opt Connection lost before a later event is acknowledged
        App->>FF: Reconnect and start the same subscription [WebSocket / JSON over TLS]
        FF-->>App: Resume, unacknowledged event may repeat [WebSocket / JSON over TLS]
        App->>FF: ACK after duplicate-safe processing [WebSocket / JSON over TLS]
    end
```

## Container sequence

```mermaid
---
title: UC5 - Subscribe to contract events - containers
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

    App->>Core: POST /contracts/listeners, Changed filter [HTTPS REST / JSON]
    Core->>EVM: Configure listener and starting block [HTTP REST / JSON]
    EVM->>TxDB: Persist listener and stream state [PostgreSQL wire / TLS]
    EVM-->>Core: Listener registration [HTTP REST / JSON]
    Core->>DB: Persist contract listener [PostgreSQL wire / TLS]
    Core-->>App: Listener id [HTTPS REST / JSON]
    App->>Core: POST /subscriptions, durable name and filter [HTTPS REST / JSON]
    Core->>DB: Store subscription and initial offset [PostgreSQL wire / TLS]
    Core-->>App: Subscription id [HTTPS REST / JSON]
    App->>Core: Start named subscription, autoack false [WebSocket / JSON over TLS]
    loop Poll from listener checkpoint
        EVM->>Signer: Query blocks and contract logs [Ethereum JSON-RPC / HTTP]
        Signer->>Besu: Forward block and log RPCs [Ethereum JSON-RPC / HTTP]
        Besu-->>Signer: Blocks and matching Changed logs [Ethereum JSON-RPC / HTTP]
        Signer-->>EVM: Block and log results [Ethereum JSON-RPC / HTTP]
    end
    Note over EVM: Decode logs and apply configured event confirmation policy
    EVM-->>Core: Confirmed event batch [WebSocket / JSON]
    Core->>DB: Persist blockchain events and application events [PostgreSQL wire / TLS]
    Core->>EVM: ACK connector batch after ingestion [WebSocket / JSON]
    EVM->>TxDB: Advance connector checkpoint [PostgreSQL wire / TLS]
    Core-->>App: blockchain_event_received, Changed output [WebSocket / JSON over TLS]
    App->>Core: ACK after processing event [WebSocket / JSON over TLS]
    Core->>DB: Advance application subscription offset [PostgreSQL wire / TLS]
    opt Disconnect before a later application ACK
        App->>Core: Reconnect and start same subscription [WebSocket / JSON over TLS]
        Core->>DB: Read saved offset and subsequent events [PostgreSQL wire / TLS]
        DB-->>Core: Events after persisted offset [PostgreSQL wire / TLS]
        Core-->>App: Resume delivery, duplicate possible [WebSocket / JSON over TLS]
        App->>Core: ACK after duplicate-safe processing [WebSocket / JSON over TLS]
        Core->>DB: Persist new subscription offset [PostgreSQL wire / TLS]
    end
```

## Behavior and failure cases

- This subscription delivers contract logs. Use the [operation-result subscription](README.md#asynchronous-application-pattern) for invocation/deployment completion; no ordering is guaranteed between subscriptions.
- Connector ingestion and application consumption have separate acknowledgements and durable positions. An application ACK does not confirm a blockchain transaction.
- Contract-log batch replay differs from the best-effort transaction-result notifications described in the [shared guarantees](README.md#delivery-guarantees-and-result-data).
- Delivery is at least once. A crash after processing but before the ACK is persisted can replay an event; consumers should deduplicate using stable event identifiers and make business effects idempotent.
- Restart with the same durable subscription name and namespace. An ephemeral subscription or automatic acknowledgement is not a substitute for this recovery pattern.
- Creating the listener after a transaction does not lose its logs if its starting position includes the transaction and the node can supply the required history. Use a deliberate start position in a real deployment rather than assuming every application needs all history.
- A stalled ledger or inaccessible RPC endpoint delays new events. Webhooks are an alternative transport, not an additional step in this WebSocket sequence.

## Official sources

- [Ethereum smart-contract tutorial](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/tutorials/custom_contracts/ethereum.md).
- [Event bus](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/reference/events.md).
- [Subscription delivery and acknowledgements](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/reference/types/_includes/subscription_description.md).
- [Blockchain Connector Toolkit](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/architecture/blockchain_connector_framework.md).
- [Official API specification](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/swagger/swagger.yaml).

The [evidence baseline and model mapping](README.md#evidence-baseline) distinguish documented behavior from this workspace's configuration choices.
