operator -> firefly.explorer "Inspects member messages, operations and network state" "Browser interaction" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5/src\"]"
    }
}

operator -> firefly.explorer.app "Selects member resources to inspect" "Browser interaction" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5/src\"]"
    }
}

firefly -> besu "Submits transactions and consumes finalized events" "Ethereum JSON-RPC + events" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}

operator -> firefly "Inspects and administers member state" "HTTPS / Explorer + Admin API" "Operational" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
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

business -> apps.client "Submits business actions" "HTTPS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

apps.client -> firefly.core "Submits member-scoped commands and queries" "HTTPS / REST" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

firefly.core -> apps.client "Delivers subscribed events and accepts ACKs" "WebSocket / webhook / HTTPS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

apps.client -> firefly.core.api "Submits API commands and queries" "HTTPS / REST" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/apiserver\"]"
    }
}

firefly.core.eventplugin -> apps.client "Delivers events through configured transports" "WebSocket / webhook / HTTPS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

apps -> firefly "Submits member requests and consumes events" "HTTPS + WebSocket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
    }
}

business -> apps "Submits consortium business actions" "HTTPS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

tools.sandbox.sdk -> firefly.core "Invokes member APIs and consumes events" "HTTPS + WebSocket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/firefly.ts\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.sandbox -> firefly.core "Exercises APIs and subscriptions" "HTTPS + WebSocket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/server/src\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.cli -> firefly.core "Registers and inspects development stacks" "HTTP / Admin API" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/README.md\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

developer -> tools "Develops and tests integrations" "CLI + HTTPS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/key_components/tools.md\"]"
    }
}

developer -> tools.cli "Creates local test stacks" "Local process invocation" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/README.md\"]"
    }
}

developer -> tools.sandboxUi "Exercises sample messages and token workflows" "Browser interaction" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/ui/src\"]"
    }
}

developer -> tools.sandboxUi.app "Selects sample messages and token actions" "Browser interaction" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/ui/src\"]"
    }
}

tools -> firefly "Exercises the selected member API" "HTTPS + WebSocket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/key_components/tools.md\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
    }
}

operator -> ops "Monitors availability and coordinates recovery" "HTTPS" "Operational" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

operator -> ops.grafana "Reviews quorum and recovery measurements" "HTTPS" "Operational" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

ops -> firefly "Routes API requests and observes health" "HTTPS + metrics" "Operational" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
    }
}

ops.gateway -> firefly.core "Routes authenticated API requests" "HTTPS / REST + WebSocket" "Operational" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

ops.gateway -> firefly.dx "Passes peer TLS sessions without terminating mTLS" "TCP / TLS passthrough" "PrivateFlow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src\"]"
    }
}

ops.cnpg -> firefly.pg "Reconciles database lifecycle through the hosting PostgreSQL cluster" "Kubernetes API / indirect operator reconciliation" "Operational" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://cloudnative-pg.io/docs/1.28/replication/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/postgres\"]"
    }
}

ops.cnpg -> firefly.fftmDb "Reconciles database lifecycle through the hosting PostgreSQL cluster" "Kubernetes API / indirect operator reconciliation" "Operational" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://cloudnative-pg.io/docs/1.28/replication/\",\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence/postgres\"]"
    }
}

ops.prometheus -> firefly.core "Scrapes member runtime measurements" "HTTP / Prometheus metrics" "Operational" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

ops.prometheus -> besu.node "Scrapes peer, block and consensus measurements" "HTTP / Prometheus metrics" "Operational" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}

ops -> besu "Observes peer and quorum health" "HTTP / metrics" "Operational" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
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

apps.client -> firefly.core.websockets "Acknowledges consumed event batches" "WebSocket / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/websockets\"]"
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

peerMembers -> firefly "Delivers peer payloads and transfer acknowledgements" "HTTPS / mTLS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/multiparty/multiparty_flow.md\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
    }
}

firefly.dx -> peerMembers "Sends private envelopes and blobs to selected peers" "HTTPS / mTLS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/multiparty/multiparty_flow.md\"]"
    }
}

peerMembers -> firefly.dx "Delivers private envelopes, blobs and transfer results" "HTTPS / mTLS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/multiparty/multiparty_flow.md\",\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src\"]"
    }
}

firefly.dx.p2p -> peerMembers "Transfers authenticated private envelopes and blobs" "HTTPS / mTLS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/p2p.ts\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/multiparty/multiparty_flow.md\"]"
    }
}

peerMembers -> firefly.dx.p2p "Transfers inbound private envelopes and blobs" "HTTPS / mTLS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/multiparty/multiparty_flow.md\",\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/p2p.ts\"]"
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

developer -> corda "Customizes the CorDapp and Core binding required by the starter" "Development toolchain" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/README.md\"]"
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

blockfrostService -> cardano "Reads the ledger and relays submitted transactions" "Cardano integration / service boundary" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/README.md\"]"
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

developer -> firefly.cordaconnect "Exercises the starter after application-specific customization" "HTTP REST + WebSocket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector\"]"
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

tools.cli.docker -> dockerEngine "Starts and stops local stack services" "Docker Compose CLI" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/docker\"]"
    }
}

tools.cli -> dockerEngine "Manages local development stack services" "Docker Compose CLI" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/README.md\",\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/docker\"]"
    }
}

tools.cli.core -> firefly.core "Configures and inspects development members" "HTTP / REST + Admin API" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/core\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

developer -> tools.perf "Runs configured performance workloads" "Local process invocation" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/README.md\"]"
    }
}

tools.perf -> firefly.core "Submits workloads and consumes completion events" "HTTP REST + WebSocket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/README.md\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.perf.runner -> firefly.core "Submits workloads and consumes completion events" "HTTP REST + WebSocket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/internal/perf\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

developer -> tools.eventAudit "Audits recorded blockchain-event ordering" "Local process invocation" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents\"]"
    }
}

tools.eventAudit -> firefly.core "Retrieves namespace status and recorded blockchain events" "HTTP REST / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.eventAudit.reader -> firefly.core "Pages through status and enriched event records" "HTTP REST / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents/main.go\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.eventAudit.ordering -> developer "Reports ordering failures and checked event counts" "Console output" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents/main.go\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

developer -> tools.config "Supplies configuration and migration versions" "CLI / file input" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig\"]"
    }
}

developer -> tools.config.commands "Supplies configuration and target version" "CLI / file input" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig/main.go\"]"
    }
}

tools.config.migration -> developer "Writes migrated configuration for review" "YAML / standard output" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig/migrate\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

tools.sandbox.sdkHttp -> firefly.core "Sends namespace-scoped API requests" "HTTP REST / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/http.ts\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.sandbox.sdkEvents -> firefly.core "Subscribes to events and sends acknowledgements" "WebSocket / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/websocket.ts\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

developer -> tools.cli.commands "Invokes development stack commands" "Local process invocation" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/cmd\"]"
    }
}

developer -> tools.perf.commands "Invokes configured workload scenarios" "Local process invocation" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/cmd\"]"
    }
}

developer -> firefly.cordaconnect.api "Exercises customized starter operations" "HTTP REST / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/controller\"]"
    }
}

firefly -> apps "Delivers subscribed business events and transaction outcomes" "WebSocket / webhook / HTTPS" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

developer -> firefly "Exercises customized Corda starter operations" "HTTP REST / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
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

tools -> developer "Returns audit results and migrated configuration for review" "Local process output" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/key_components/tools.md\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
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

tools -> dockerEngine "Creates and manages local development stack services" "Docker Compose CLI" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/key_components/tools.md\",\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/docker\"]"
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

cyberarkPam.cpm -> managedTarget "Verifies or changes the privileged target password" "SSH / target-specific password commands" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

managedTarget -> cyberarkPam.cpm "Returns password verification or change outcome" "SSH / target command response" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.cpm.target -> managedTarget "Verifies or changes the privileged target password" "SSH / target-specific password commands" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

managedTarget -> cyberarkPam.cpm.target "Returns password verification or change outcome" "SSH / target command response" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.psm -> managedTarget "Opens privileged SSH session and relays administrator commands" "SSH" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

managedTarget -> cyberarkPam.psm "Returns command output and session state" "SSH" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.psm.target -> managedTarget "Opens privileged SSH session and relays administrator commands" "SSH" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

managedTarget -> cyberarkPam.psm.target "Returns command output and session state" "SSH" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

conjur.synchronizer -> cyberarkPam.vault "Reads configured Vault accounts and changed credential versions" "CyberArk Vault protocol / encrypted channel" "Dataflow,SecurityCatalog,SecretFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.vault -> conjur.synchronizer "Returns selected account metadata and credentials" "CyberArk Vault protocol / encrypted channel" "Dataflow,SecurityCatalog,SecretFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
    }
}

conjur.synchronizer.reader -> cyberarkPam.vault "Reads configured Vault accounts and changed credential versions" "CyberArk Vault protocol / encrypted channel" "Dataflow,SecurityCatalog,SecretFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.vault -> conjur.synchronizer.reader "Returns selected account metadata and credentials" "CyberArk Vault protocol / encrypted channel" "Dataflow,SecurityCatalog,SecretFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
    }
}

entraId.agent -> adDs.directory "Queries selected users, groups, contacts and requested attributes" "LDAP / protected domain connection" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

adDs.directory -> entraId.agent "Returns scoped directory object attributes and change information" "LDAP / protected domain connection" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

entraId.agent.directory -> adDs.directory "Queries selected users, groups, contacts and requested attributes" "LDAP / protected domain connection" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

adDs.directory -> entraId.agent.directory "Returns scoped directory object attributes and change information" "LDAP / protected domain connection" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

keycloak.server -> adDs.directory "Queries user attributes and validates supplied credentials by LDAP bind" "LDAPS" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

adDs.directory -> keycloak.server "Returns user attributes and bind result; does not export passwords" "LDAPS" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.ldap -> adDs.directory "Queries user attributes and validates supplied credentials by LDAP bind" "LDAPS" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

adDs.directory -> keycloak.server.ldap "Returns user attributes and bind result; does not export passwords" "LDAPS" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

adFs.service -> adDs.directory "Validates domain authentication and resolves account attributes" "Kerberos / protected directory interfaces" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

adDs.directory -> adFs.service "Returns domain authentication result and requested attributes" "Kerberos / protected directory interfaces" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

adFs.service.authentication -> adDs.directory "Validates domain authentication and resolves account attributes" "Kerberos / protected directory interfaces" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

adDs.directory -> adFs.service.authentication "Returns domain authentication result and requested attributes" "Kerberos / protected directory interfaces" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\"]"
    }
}

business -> keycloak.server "Submits sign-in interaction through the user browser" "HTTPS / browser OIDC" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

apps.client -> keycloak.server "Submits authorization request via browser and configured protocol client" "HTTPS / OIDC reference client" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server -> apps.client "Returns authenticated identity tokens or assertions through the selected protocol flow" "HTTPS / OIDC reference client" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

business -> entraId.authentication "Submits sign-in interaction through the user browser" "HTTPS / browser OIDC" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

apps.client -> entraId.authentication "Submits authorization request via browser and configured protocol client" "HTTPS / OIDC reference client" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

entraId.authentication -> apps.client "Returns authenticated identity tokens or assertions through the selected protocol flow" "HTTPS / OIDC reference client" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

business -> adFs.service "Submits sign-in interaction through the user browser" "HTTPS / browser SAML 2.0" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

apps.client -> adFs.service "Submits authorization request via browser and configured protocol client" "HTTPS / SAML 2.0 reference client" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

adFs.service -> apps.client "Returns authenticated identity tokens or assertions through the selected protocol flow" "HTTPS / SAML 2.0 reference client" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

apps.client -> keycloak.server.endpoints "Submits relying-party authorization request using the reference client" "HTTPS / OIDC or SAML as configured" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.endpoints -> apps.client "Returns signed identity response through the configured browser/client flow" "HTTPS / OIDC or SAML as configured" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

apps.client -> entraId.authentication.endpoints "Submits relying-party authorization request using the reference client" "HTTPS / OIDC or SAML as configured" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

entraId.authentication.endpoints -> apps.client "Returns signed identity response through the configured browser/client flow" "HTTPS / OIDC or SAML as configured" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

apps.client -> adFs.service.endpoints "Submits relying-party authorization request using the reference client" "HTTPS / OIDC or SAML as configured" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\"]"
    }
}

adFs.service.endpoints -> apps.client "Returns signed identity response through the configured browser/client flow" "HTTPS / OIDC or SAML as configured" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

keycloak.server -> entraId.authentication "Redirects browser with OIDC authorization request" "HTTPS / browser-mediated OIDC" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

entraId.authentication -> keycloak.server "Returns authorization code through browser redirect" "HTTPS / OIDC redirect" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server -> entraId.authentication "Exchanges authorization code with client authentication for tokens" "HTTPS / OAuth token endpoint" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

entraId.authentication -> keycloak.server "Returns signed ID token and token endpoint response" "HTTPS / OAuth token response" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server -> adFs.service "Redirects browser with SAML authentication request" "HTTPS / browser-mediated SAML 2.0" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

adFs.service -> keycloak.server "Returns signed SAML assertion through browser POST" "HTTPS / browser-mediated SAML 2.0" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.broker -> entraId.authentication "Redirects browser with OIDC authorization request" "HTTPS / browser-mediated OIDC" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

entraId.authentication -> keycloak.server.broker "Returns authorization code through browser redirect" "HTTPS / OIDC redirect" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.broker -> entraId.authentication "Exchanges authorization code with client authentication for tokens" "HTTPS / OAuth token endpoint" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

entraId.authentication -> keycloak.server.broker "Returns signed ID token and token endpoint response" "HTTPS / OAuth token response" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.broker -> adFs.service "Redirects browser with SAML authentication request" "HTTPS / browser-mediated SAML 2.0" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

adFs.service -> keycloak.server.broker "Returns signed SAML assertion through browser POST" "HTTPS / browser-mediated SAML 2.0" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

apps.client -> conjur.service "Authenticates workload and requests permitted secret variable" "HTTPS / Conjur authentication and secrets APIs" "Dataflow,SecurityCatalog,SecretFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

conjur.service -> apps.client "Returns short-lived access token or authorized application secret" "HTTPS / Conjur API response" "Dataflow,SecurityCatalog,SecretFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

apps.client -> conjur.service.api "Authenticates workload and requests permitted secret variable" "HTTPS / Conjur authentication and secrets APIs" "Dataflow,SecurityCatalog,SecretFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

conjur.service.api -> apps.client "Returns short-lived access token or authorized application secret" "HTTPS / Conjur API response" "Dataflow,SecurityCatalog,SecretFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

apps.client -> managedHsm.service "Submits bearer token, key identifier and digest or key-wrapping input" "HTTPS / Managed HSM REST API" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

managedHsm.service -> apps.client "Returns signature or wrapped data key; never the HSM private key" "HTTPS / Managed HSM REST response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

apps.client -> managedHsm.service.api "Submits bearer token, key identifier and digest or key-wrapping input" "HTTPS / Managed HSM REST API" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

managedHsm.service.api -> apps.client "Returns signature or wrapped data key; never the HSM private key" "HTTPS / Managed HSM REST response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

hsmWorkloadTokenRequest = apps.client -> entraId.authentication "Authenticates workload identity and requests HSM-audience access token" "HTTPS / OAuth 2.0 client credentials" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

hsmWorkloadTokenResponse = entraId.authentication -> apps.client "Returns HSM-audience workload access token" "HTTPS / OAuth 2.0 token response" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

managedHsm.service -> entraId.authentication "Retrieves issuer metadata and public signing keys for cached token verification" "HTTPS / OpenID metadata and JWKS" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

managedHsm.service.authentication -> entraId.authentication "Retrieves issuer metadata and public signing keys for cached token verification" "HTTPS / OpenID metadata and JWKS" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

operator -> cyberarkPam.pvwa "Requests approved privileged-account access or recorded target session" "HTTPS / PAM web portal" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

operator -> cyberarkPam.pvwa.portal "Requests approved privileged-account access or recorded target session" "HTTPS / PAM web portal" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

operator -> cyberarkPam.psm "Connects authorized session client and submits administrative input" "PSM-supported session client / encrypted connection" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.psm -> operator "Returns brokered session output and completion status" "PSM-supported session client / encrypted connection" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

operator -> cyberarkPam.psm.broker "Connects authorized session client and submits administrative input" "PSM-supported session client / encrypted connection" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.psm.broker -> operator "Returns brokered session output and completion status" "PSM-supported session client / encrypted connection" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

business -> adDs.directory "Requests domain sign-in and service tickets through the domain client" "Kerberos / domain client" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

adDs.directory -> business "Returns Kerberos ticket response to the domain client" "Kerberos / domain client" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

business -> adDs.directory.kdc "Requests domain sign-in and service tickets through the domain client" "Kerberos / domain client" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

adDs.directory.kdc -> business "Returns Kerberos ticket response to the domain client" "Kerberos / domain client" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
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

apps.hsmSigner -> firefly.evm "Returns transaction hash or signing/submission error" "Ethereum JSON-RPC response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go\"]"
    }
}

apps.hsmSigner -> entraId.authentication "Authenticates application identity and requests Managed HSM access token" "HTTPS / OAuth 2.0 client credentials" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

entraId.authentication -> apps.hsmSigner "Returns Managed HSM audience access token" "HTTPS / OAuth 2.0 token response" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
    }
}

apps.hsmSigner -> managedHsm.service "Submits Ethereum digest for secp256k1 signing; compatibility must be verified" "HTTPS / Managed HSM Sign API (proposed)" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://ethereum.org/en/developers/docs/transactions/\"]"
    }
}

managedHsm.service -> apps.hsmSigner "Returns signature bytes and signing key identifier; never private key material" "HTTPS / Managed HSM Sign API response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://learn.microsoft.com/en-us/rest/api/keyvault/keys/sign/sign?view=rest-keyvault-keys-2025-07-01\"]"
    }
}

apps.hsmSigner -> managedHsm.service "Requests public key metadata for the selected key version" "HTTPS / Managed HSM Get Key API" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/rest/api/keyvault/keys/get-key/get-key?view=rest-keyvault-keys-2025-07-01\"]"
    }
}

managedHsm.service -> apps.hsmSigner "Returns public key parameters for sender and signature verification" "HTTPS / Managed HSM Get Key API response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://learn.microsoft.com/en-us/rest/api/keyvault/keys/get-key/get-key?view=rest-keyvault-keys-2025-07-01\"]"
    }
}

apps.hsmSigner.hsm -> entraId.authentication "Authenticates application identity and requests Managed HSM access token" "HTTPS / OAuth 2.0 client credentials" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

entraId.authentication -> apps.hsmSigner.hsm "Returns Managed HSM audience access token" "HTTPS / OAuth 2.0 token response" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://ethereum.org/en/developers/docs/transactions/\"]"
    }
}

apps.hsmSigner.hsm -> managedHsm.service "Submits Ethereum digest for secp256k1 signing; compatibility must be verified" "HTTPS / Managed HSM Sign API (proposed)" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
    }
}

managedHsm.service -> apps.hsmSigner.hsm "Returns signature bytes and signing key identifier; never private key material" "HTTPS / Managed HSM Sign API response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/rest/api/keyvault/keys/sign/sign?view=rest-keyvault-keys-2025-07-01\"]"
    }
}

apps.hsmSigner.hsm -> managedHsm.service "Requests public key metadata for the selected key version" "HTTPS / Managed HSM Get Key API" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/rest/api/keyvault/keys/get-key/get-key?view=rest-keyvault-keys-2025-07-01\"]"
    }
}

managedHsm.service -> apps.hsmSigner.hsm "Returns public key parameters for sender and signature verification" "HTTPS / Managed HSM Get Key API response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/rest/api/keyvault/keys/get-key/get-key?view=rest-keyvault-keys-2025-07-01\"]"
    }
}

apps.hsmSigner -> besu.node "Submits encoded signed transaction for validation and propagation" "Ethereum JSON-RPC / eth_sendRawTransaction" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}

besu.node -> apps.hsmSigner "Returns transaction hash or JSON-RPC rejection" "Ethereum JSON-RPC response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
    }
}

apps.hsmSigner.rpc -> besu.node "Submits encoded signed transaction for validation and propagation" "Ethereum JSON-RPC / eth_sendRawTransaction" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}

besu.node -> apps.hsmSigner.rpc "Returns transaction hash or JSON-RPC rejection" "Ethereum JSON-RPC response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\",\"https://ethereum.org/en/developers/docs/transactions/\"]"
    }
}

securityAdmin -> keycloak "Configures Keycloak access policy and reviews administrative outcomes" "HTTPS / product administration interface" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

securityAdmin -> managedHsm "Configures Azure Managed HSM access policy and reviews administrative outcomes" "HTTPS / product administration interface" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

securityAdmin -> cyberarkPam "Configures CyberArk PAM Self-Hosted access policy and reviews administrative outcomes" "HTTPS / product administration interface" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

securityAdmin -> conjur "Configures CyberArk Conjur Enterprise access policy and reviews administrative outcomes" "HTTPS / product administration interface" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

securityAdmin -> entraId "Configures Microsoft Entra ID access policy and reviews administrative outcomes" "HTTPS / product administration interface" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

securityAdmin -> adDs "Configures Microsoft Active Directory Domain Services access policy and reviews administrative outcomes" "Protected LDAP / directory administration" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

securityAdmin -> adFs "Configures Microsoft Active Directory Federation Services access policy and reviews administrative outcomes" "AD FS administration / PowerShell" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

apps -> keycloak "Requests application sign-in and identity claims" "HTTPS / OIDC or SAML reference flow" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak -> apps "Returns identity tokens or assertions for application access" "HTTPS / configured identity protocol" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

business -> keycloak "Completes user sign-in through browser-mediated authentication" "HTTPS / user browser" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

apps -> entraId "Requests application sign-in and identity claims" "HTTPS / OIDC or SAML reference flow" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

entraId -> apps "Returns identity tokens or assertions for application access" "HTTPS / configured identity protocol" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

business -> entraId "Completes user sign-in through browser-mediated authentication" "HTTPS / user browser" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

apps -> adFs "Requests application sign-in and identity claims" "HTTPS / OIDC or SAML reference flow" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

adFs -> apps "Returns identity tokens or assertions for application access" "HTTPS / configured identity protocol" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

business -> adFs "Completes user sign-in through browser-mediated authentication" "HTTPS / user browser" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

keycloak -> adDs "Requests LDAP user attributes and credential validation" "LDAPS" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

adDs -> keycloak "Returns user attributes and credential validation outcome" "LDAPS" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak -> entraId "Delegates login through browser-mediated OIDC federation" "HTTPS / OIDC" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

entraId -> keycloak "Returns verified identity claims through the configured federation flow" "HTTPS / OIDC" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak -> adFs "Delegates login through browser-mediated SAML 2.0 federation" "HTTPS / SAML 2.0" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

adFs -> keycloak "Returns verified identity claims through the configured federation flow" "HTTPS / SAML 2.0" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

adFs -> adDs "Requests domain authentication and account attributes" "Kerberos / protected directory access" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

adDs -> adFs "Returns domain authentication result and account attributes" "Kerberos / protected directory access" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

entraId -> adDs "Queries selected directory objects through the Cloud Sync provisioning agent" "Protected LDAP / agent-established TLS service channel" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

adDs -> entraId "Returns selected identity attributes for Cloud Sync provisioning" "Protected LDAP / agent-established TLS service channel" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

business -> adDs "Requests domain sign-in and service tickets through the domain client" "Kerberos" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

operator -> cyberarkPam "Requests approved privileged access and submits session commands" "HTTPS / PAM portal and encrypted session client" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam -> managedTarget "Rotates target credentials and brokers recorded privileged sessions" "SSH / target-specific password commands" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

managedTarget -> cyberarkPam "Returns password-operation outcomes and privileged session output" "SSH / target command response" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam -> operator "Returns brokered session output and completion status" "Encrypted session client" "Dataflow,SecurityCatalog,PrivilegedFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

adDs -> business "Returns Kerberos ticket response to the domain client" "Kerberos" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

cyberarkPam -> conjur "Supplies selected Vault credentials through Vault Synchronizer" "CyberArk Vault protocol + HTTPS / Conjur API" "Dataflow,SecurityCatalog,SecretFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
    }
}

conjur -> cyberarkPam "Requests selected Vault accounts and changed credentials through Vault Synchronizer" "CyberArk Vault protocol / encrypted channel" "Dataflow,SecurityCatalog,SecretFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
    }
}

apps -> besu "Submits signed transactions through the proposed custom HSM adapter" "Ethereum JSON-RPC / eth_sendRawTransaction" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}

besu -> apps "Returns transaction hash or rejection to the proposed custom HSM adapter" "Ethereum JSON-RPC response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

apps -> conjur "Authenticates workload and requests permitted application secrets" "HTTPS / Conjur API" "Dataflow,SecurityCatalog,SecretFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

conjur -> apps "Returns short-lived token or authorized application secret" "HTTPS / Conjur API response" "Dataflow,SecurityCatalog,SecretFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

apps -> managedHsm "Submits authorized signing or key-wrapping request" "HTTPS / Managed HSM REST API" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

managedHsm -> apps "Returns signature or wrapped key result without private key material" "HTTPS / Managed HSM REST response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

managedHsm -> entraId "Retrieves issuer metadata and public signing keys for caller token verification" "HTTPS / OpenID metadata and JWKS" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

securityAdmin -> azureManagement "Submits Managed HSM resource administration request" "HTTPS / Azure Resource Manager API" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

azureManagement -> managedHsm "Applies resource-management changes authorized by Azure RBAC; does not grant key access" "Azure management-plane interface" "Dataflow,SecurityCatalog,SecurityAdminFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

azureManagement -> managedHsm.service "Applies resource-management changes; key access still requires local RBAC" "Azure management-plane interface (logical)" "Dataflow,SecurityCatalog,SecurityAdminFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

securityAdmin -> keycloak.server "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

securityAdmin -> keycloak.server.admin "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

securityAdmin -> managedHsm.service "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

securityAdmin -> managedHsm.service.lifecycle "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

securityAdmin -> cyberarkPam.pvwa "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

securityAdmin -> cyberarkPam.pvwa.portal "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

securityAdmin -> conjur.service "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

securityAdmin -> conjur.service.api "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

securityAdmin -> entraId.directory "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

securityAdmin -> entraId.directory.api "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

securityAdmin -> adDs.directory "Submits authorized configuration or access-policy changes" "Protected LDAP / directory administration" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

securityAdmin -> adDs.directory.ldap "Submits authorized configuration or access-policy changes" "Protected LDAP / directory administration" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

securityAdmin -> adFs.service "Submits authorized configuration or access-policy changes" "AD FS administration / PowerShell configuration interface" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

securityAdmin -> adFs.service.configuration "Submits authorized configuration or access-policy changes" "AD FS administration / PowerShell configuration interface" "Dataflow,SecurityCatalog,SecurityAdminFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\"]"
    }
}
