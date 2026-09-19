firefly -> besu "Submits transactions and consumes finalized events" "Ethereum JSON-RPC + events" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}

firefly.signer -> besu.node "Submits signed transactions and queries RPC nodes" "HTTP JSON-RPC" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}

firefly.signer.backend -> besu.node "Submits raw transactions and reads to RPC nodes" "HTTP JSON-RPC" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/rpcbackend\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}

firefly.core -> apps.client "Delivers subscribed events and accepts ACKs" "WebSocket / webhook / HTTPS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

firefly.core.eventplugin -> apps.client "Delivers events through configured transports" "WebSocket / webhook / HTTPS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

firefly.core.websockets -> apps.client "Delivers subscribed event batches" "WebSocket / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/websockets\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

firefly.core.webhooks -> apps.client "Delivers subscribed event batches" "HTTP POST / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/webhooks\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

firefly.evm.webhook -> apps.client "Posts configured blockchain event batches" "HTTP POST / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/events\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

firefly -> peerMembers "Exchanges private payloads and shared content references" "HTTPS / mTLS + IPFS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/multiparty/multiparty_flow.md\"]"
    }
}

firefly.dx -> peerMembers "Sends private envelopes and blobs to selected peers" "HTTPS / mTLS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/multiparty/multiparty_flow.md\"]"
    }
}

firefly.dx.p2p -> peerMembers "Transfers authenticated private envelopes and blobs" "HTTPS / mTLS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/p2p.ts\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/multiparty/multiparty_flow.md\"]"
    }
}

firefly.ipfs -> peerMembers "Fetches and serves shared content blocks by CID" "IPFS / libp2p" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://docs.ipfs.tech/concepts/how-ipfs-works/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/multiparty/multiparty_flow.md\"]"
    }
}

firefly -> evmNetworks "Submits ledger operations and consumes events when configured" "Ethereum JSON-RPC" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/README.md\"]"
    }
}

firefly -> fabric "Submits ledger operations and consumes events when configured" "Fabric connector API" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/README.md\"]"
    }
}

firefly -> tezos "Submits ledger operations and consumes events when configured" "Tezos connector API" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/README.md\"]"
    }
}

firefly -> cardano "Submits ledger operations and consumes events when configured" "Cardano connector API" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/README.md\"]"
    }
}

firefly.evm -> evmNetworks "Submits transactions and polls an alternative EVM network" "HTTP JSON-RPC" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go\",\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/README.md\"]"
    }
}

firefly.ethconnect.receipts -> mongo "Stores receipts when MongoDB is selected" "MongoDB wire protocol" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts/mongoreceipts.go\"]"
    }
}

firefly.ethconnect -> kafkaBroker "Publishes requests and consumes transaction work in Kafka mode" "Kafka protocol" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kafka\"]"
    }
}

firefly.ethconnect.kafka -> kafkaBroker "Consumes transaction requests and publishes replies" "Kafka protocol" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kafka\"]"
    }
}

firefly.fabconnect -> fabric "Submits endorsed transactions and receives ledger events" "Fabric SDK / gRPC + TLS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/README.md\"]"
    }
}

firefly.fabconnect.client -> fabric "Invokes chaincode and consumes peer ledger events" "Fabric SDK / gRPC + TLS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/README.md\"]"
    }
}

firefly.fabconnect.client -> fabricCA "Registers and enrolls Fabric identities" "Fabric CA / HTTPS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client/identity.go\"]"
    }
}

firefly.fabconnect -> fabricCA "Registers and enrolls client identities" "Fabric CA / HTTPS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client/identity.go\"]"
    }
}

firefly.fabconnect.receipts -> mongo "Persists receipts when MongoDB is selected" "MongoDB wire protocol" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest/receipt\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts/mongoreceipts.go\"]"
    }
}

firefly.fabconnect.kafka -> kafkaBroker "Consumes transaction requests and publishes replies" "Kafka protocol" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/kafka\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kafka\"]"
    }
}

firefly.fabconnect -> kafkaBroker "Processes requests through the optional Kafka bridge" "Kafka protocol" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kafka\"]"
    }
}

firefly.tezosconnect -> tezos "Queries chain state and injects signed operations" "Tezos HTTP RPC" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b\",\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/README.md\"]"
    }
}

firefly.tezosconnect.adapter -> tezos "Queries state and injects signed operations" "Tezos HTTP RPC" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos\",\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/README.md\"]"
    }
}

firefly.tezosconnect.blocks -> tezos "Monitors chain heads and retrieves blocks" "Tezos HTTP RPC / streaming" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/blocklistener.go\",\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/README.md\"]"
    }
}

firefly.tezosconnect -> signatory "Requests signatures for encoded operations" "HTTP / Signatory API" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b\",\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/README.md\"]"
    }
}

firefly.tezosconnect.signing -> signatory "Requests an operation signature for a Tezos address" "HTTP / Signatory API" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/send_transaction.go\",\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/README.md\"]"
    }
}

firefly.cardanoconnect -> blockfrostService "Queries ledger data and submits transactions in Blockfrost mode" "HTTPS / Blockfrost API" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect\",\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/README.md\"]"
    }
}

firefly.cardanoconnect.blockfrost -> blockfrostService "Queries blocks and submits signed transactions" "HTTPS / Blockfrost API" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/blockchain/blockfrost\",\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/README.md\"]"
    }
}

firefly.cardanoconnect -> cardano "Synchronizes ledger state in direct-node mode" "Cardano node-to-client / local socket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect\",\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/README.md\"]"
    }
}

firefly.cardanoconnect.n2c -> cardano "Synchronizes chain and queries ledger state" "Cardano node-to-client / local socket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/blockchain/n2c\",\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/README.md\"]"
    }
}

firefly.cordaconnect -> corda "Invokes custom CorDapps and consumes vault updates" "Corda RPC" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector\",\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/README.md\"]"
    }
}

firefly.cordaconnect.flows -> corda "Invokes custom flows and subscribes to vault updates" "Corda RPC" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/rpc\",\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/README.md\"]"
    }
}

firefly.cordaconnect.websockets -> developer "Delivers starter event batches to an integration developer" "WebSocket / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/ws\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

firefly -> apps "Delivers subscribed business events and transaction outcomes" "WebSocket / webhook / HTTPS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

firefly -> developer "Returns customized starter event batches" "WebSocket / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

firefly -> corda "Invokes custom CorDapps and consumes vault updates through the optional starter" "Corda RPC" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/README.md\"]"
    }
}

firefly -> signatory "Requests Tezos operation signatures in the optional configuration" "HTTP / Signatory API" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/README.md\"]"
    }
}

firefly -> blockfrostService "Queries Cardano data and submits transactions in Blockfrost mode" "HTTPS / Blockfrost API" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/README.md\"]"
    }
}

firefly -> fabricCA "Registers and enrolls signing identities through FabConnect" "Fabric CA / HTTPS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client/identity.go\"]"
    }
}

firefly -> kafkaBroker "Exchanges legacy connector transaction requests and replies" "Kafka protocol" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kafka\"]"
    }
}

firefly -> mongo "Persists legacy connector receipts when configured" "MongoDB wire protocol" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts/mongoreceipts.go\"]"
    }
}

firefly.ethconnect -> mongo "Stores receipts in the optional MongoDB backend" "MongoDB wire protocol" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts/mongoreceipts.go\"]"
    }
}

firefly.fabconnect -> mongo "Stores receipts in the optional MongoDB backend" "MongoDB wire protocol" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts/mongoreceipts.go\"]"
    }
}

firefly.evm -> apps.hsmSigner "Submits unsigned transaction to the proposed alternative signing proxy" "Ethereum JSON-RPC / HTTPS (reference)" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
    }
}

firefly.evm -> apps.hsmSigner.transactions "Submits unsigned Ethereum transaction fields" "Ethereum JSON-RPC / HTTPS (reference)" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go\",\"https://ethereum.org/en/developers/docs/transactions/\"]"
    }
}
