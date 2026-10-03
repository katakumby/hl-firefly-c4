# 6. Associate private data with a contract transaction

[Use-case index and shared notation](../README.md)

Send a private business payload to selected consortium members and associate its commitment with one custom contract invocation. This is the collection's extension beyond the basic contract lifecycle.

**Prerequisites:** Members A and B have multiparty-enabled FireFly instances on the same Besu network, registered identities, HTTPS Data Exchange connectivity with mTLS, and durable message subscriptions. A compatible `CustomPin` contract and its FireFly API exist.

**Outcome:** Each authorized member's FireFly Core emits `message_confirmed` only after it has the private payload and the matching sequenced ledger pin. Contract arguments, transaction metadata, and commitments remain visible on the consortium ledger.

## API and example

The contract's final method parameter must accept the encoded batch-pin data. On Ethereum, the method calls `pinBatchData` on the configured FireFly Multiparty Contract, which emits `BatchPin` within the same transaction. The application contract and multiparty contract execute inside Besu's EVM; they are not separate C4 containers.

Invoke `POST /apis/custom-pin/invoke/sayHello`, explicitly selecting private messaging:

```json
{
  "idempotencyKey": "private-business-step-0001",
  "input": {},
  "message": {
    "header": {
      "type": "private",
      "tag": "business-step",
      "topics": ["business-process-0001"]
    },
    "group": { "members": [{ "identity": "org_B" }] },
    "data": [{ "value": { "privateEvidence": "example" } }]
  }
}
```

Replace `org_B` with the registered recipient identity. The sender is included in the group automatically. FireFly supplies the encoded pin argument; do not put the private business payload in `input`. For attached messages, omitting `header.type` defaults to **broadcast**, even if the intended use case was private.

The response is an accepted operation with `id` and `tx`; retain these for [recovery](../07-failures-and-recovery/README.md). Message confirmation remains a separate milestone.

Each member creates a durable subscription before this flow. For example, `POST /subscriptions`:

```json
{
  "name": "private-business-messages",
  "transport": "websockets",
  "filter": {
    "events": "^message_confirmed$",
    "message": { "tag": "^business-step$" },
    "topic": "^business-process-0001$"
  },
  "options": { "firstEvent": "newest", "readAhead": 1, "withData": true }
}
```

Start it with `autoack: false` using the [shared WebSocket pattern](../README.md#asynchronous-application-pattern), substituting this subscription name. `withData: true` includes the attached JSON data in the event delivery. Without it, retrieve data on demand using its references. Blob contents require separate retrieval; this example uses inline JSON only. Preserve the subscription across reconnects and ACK after durable, duplicate-safe processing.

All API paths in this document use the namespace prefix `/api/v1/namespaces/{ns}` unless stated otherwise. The diagrams abbreviate that prefix. Names and addresses are example values.

## Software-system sequence

[Mermaid source](system-sequence.mmd) · [SVG](../../../../build/uml/use-cases/firefly-besu/06-private-data-and-contract/system-sequence.svg) · [PNG](../../../../build/uml/use-cases/firefly-besu/06-private-data-and-contract/system-sequence.png)

![System sequence](../../../../build/uml/use-cases/firefly-besu/06-private-data-and-contract/system-sequence.svg)

## Container sequence

[Mermaid source](container-sequence.mmd) · [SVG](../../../../build/uml/use-cases/firefly-besu/06-private-data-and-contract/container-sequence.svg) · [PNG](../../../../build/uml/use-cases/firefly-besu/06-private-data-and-contract/container-sequence.png)

![Container sequence](../../../../build/uml/use-cases/firefly-besu/06-private-data-and-contract/container-sequence.svg)

## Behavior and failure cases

- Parallel branches progress independently. Payload and pin can arrive in either order; each member waits for its own validated payload and sequenced pin. Member A does not wait for member B to confirm. There is no atomic transaction across transport and ledger.
- Transaction-result summaries and acknowledged pin-event batches are separate notifications with no guaranteed relative arrival order. `message_confirmed` does not depend on receiving the transaction-result summary. A missed summary is reconciled separately as in use case 7.
- If the contract reverts, its state changes and pin event revert together. An off-chain payload may already have been delivered, so delivery must not be interpreted as business completion.
- If a pin exists but a recipient lacks the payload, confirmation waits. A missing message can delay later messages in the same ordering context; choose topics per business process rather than one global topic.
- Each member has separate Core and FFTM databases. Their persistence and checkpoint mechanics are shown in use cases 4 and 5 and omitted here to keep the peer exchange readable. Transfer notifications do not imply a durable queue inside Data Exchange.
- The recipient has its own connector and Signer proxy. The shared Besu lifeline represents the network's logical node container, not a requirement that all members use one physical RPC server.
- This is ordinary consortium-visible contract execution with private off-chain data. It does not provide confidential contract state. `SimpleStorage.set` alone cannot perform custom pinning; the compatible contract and multiparty address are required.

## Official sources

- [Custom-contract data pinning](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/tutorials/custom_contracts/pinning.md).
- [Private messaging](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/tutorials/private_send.md).
- [Event bus](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/reference/events.md).
- [Blockchain Connector Toolkit](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/architecture/blockchain_connector_framework.md).
- [Attached-message type selection in Core](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/contracts/manager.go).
- [Subscription data inclusion](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/reference/types/subscription.md).
- [Separate receipt and event-batch handling](https://github.com/hyperledger-firefly/firefly/blob/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain/ethereum/ethereum.go#L475-L516).
- [Best-effort transaction results](https://github.com/hyperledger-firefly/transaction-manager/blob/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/fftm/transaction_events_handler.go#L94-L120).

The [evidence baseline and model mapping](../README.md#evidence-baseline) distinguish documented behavior from this workspace's configuration choices.
