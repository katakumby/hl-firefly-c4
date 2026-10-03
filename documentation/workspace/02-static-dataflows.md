# Static dataflow scenarios

For ordered runtime interactions, see the [FireFly–Besu smart-contract use cases](../../uml/use-cases/firefly-besu/README.md), with a system-level and a container-level Mermaid sequence for each scenario.

1. **Private Besu transaction:** an application calls Core; the contract or
   multiparty manager uses the Ethereum adapter; EVMConnect's embedded FFTM
   manages transaction state and nonce policy; FireFly Signer resolves the
   account, signs and forwards the raw transaction to a Besu RPC node. Besu
   admits it to its pool, gossips it, applies QBFT consensus on validator nodes,
   executes the EVM and persists state and receipts. Node/validator keys are
   distinct from application transaction signing keys.
2. **Receipt and event return:** connector RPC polling and block listeners feed
   receipt tracking, confirmation and event streams. Core correlates ledger
   events with operations and payloads, persists ordered events, and delivers
   subscription batches. WebSocket acknowledgements advance consumed offsets;
   configured webhook delivery is a separate transport.
3. **Private messaging:** Core selects recipient identities and sends envelopes
   and blobs through HTTPS Data Exchange. Peer mTLS endpoints exchange payloads;
   connector notifications and acknowledgements return to Core. Optional ledger
   pins contain commitments, not the private payload. Data Exchange notification
   queues are in memory; this model does not claim durable queue recovery.
4. **Broadcast/shared content:** Core publishes batches/blobs through its IPFS
   adapter and Kubo, and sequences commitments through the multiparty contract.
   Receiving members retrieve content by CID and correlate it with ledger pins.
5. **Tokens:** Core's asset manager and token adapter call the ERC-20/ERC-721 or
   ERC-1155 service. Token services submit contract operations through EVMConnect
   and translate returned logs into standard token events.
6. **Alternatives:** FabConnect uses Fabric client identities, chaincode and
   ledger events; TezosConnect embeds its own FFTM and requests Signatory
   signatures; CardanoConnect uses a separate Rust signer and either Blockfrost
   or direct node-to-client access, with optional Balius contract workers.
   Legacy Kafka/MongoDB modes are isolated in optional views. The Corda starter
   talks to customized CorDapps through Corda RPC.

Besu is a private, permissioned QBFT example. Permissioning restricts admission;
it does not encrypt ordinary ledger transactions from other consortium nodes.
FireFly's off-chain private data exchange supplies the separate private-payload
path. Consensus configuration and multi-zone deployment resilience are deferred.

Application smart contracts are tagged as deployed responsibilities hosted by
the EVM. They are not presented as Java packages implemented by Besu.

The separate [security examples](04-security-dataflows.md) cover identity
federation, directory synchronization, PAM sessions and rotation, Conjur secret
delivery, HSM operations and a proposed custom Ethereum signing adapter. Those
examples do not replace the existing FireFly authentication or filesystem-wallet
implementation described above.
