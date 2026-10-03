firefly.ethconnect.rest -> firefly.ethconnect.auth "Checks configured authorization hooks" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/rest\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/auth\"]"
    }
}

firefly.ethconnect.rest -> firefly.ethconnect.contracts "Routes ABI-backed contract requests" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/rest\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/contractgateway\"]"
    }
}

firefly.ethconnect.contracts -> firefly.ethconnect.registry "Resolves contract addresses and interfaces" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/contractgateway\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/contractregistry\"]"
    }
}

firefly.ethconnect.contracts -> firefly.ethconnect.openapi "Generates contract request schemas" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/contractgateway\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/openapi\"]"
    }
}

firefly.ethconnect.contracts -> firefly.ethconnect.transactions "Dispatches transaction requests" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/contractgateway\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/tx\"]"
    }
}

firefly.ethconnect.rest -> firefly.ethconnect.transactions "Dispatches direct transaction requests" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/rest\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/tx\"]"
    }
}

firefly.ethconnect.rest -> firefly.ethconnect.kafka "Publishes requests in Kafka bridge mode" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/rest\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kafka\"]"
    }
}

firefly.ethconnect.kafka -> firefly.ethconnect.transactions "Dispatches consumed transaction requests" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kafka\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/tx\"]"
    }
}

firefly.ethconnect.transactions -> firefly.ethconnect.rpc "Encodes and submits Ethereum transactions" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/tx\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/eth\"]"
    }
}

firefly.ethconnect.transactions -> firefly.ethconnect.receipts "Persists completed transaction outcomes" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/tx\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts\"]"
    }
}

firefly.ethconnect.events -> firefly.ethconnect.rpc "Polls blocks and contract logs" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/events\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/eth\"]"
    }
}

firefly.ethconnect.events -> firefly.ethconnect.websockets "Delivers confirmed event batches" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/events\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/ws\"]"
    }
}

firefly.ethconnect.events -> firefly.ethconnect.kv "Persists subscriptions and checkpoints" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/events\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kvstore\"]"
    }
}

firefly.ethconnect.registry -> firefly.ethconnect.kv "Persists contract metadata" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/contractregistry\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kvstore\"]"
    }
}

firefly.ethconnect -> firefly.signer "Submits unsigned transactions and read requests" "HTTP JSON-RPC" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0\",\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver\"]"
    }
}

firefly.ethconnect.rpc -> firefly.signer "Requests Ethereum transaction signing and RPC forwarding" "HTTP JSON-RPC" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/eth\",\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver\"]"
    }
}

firefly.ethconnect -> firefly.core "Delivers confirmed contract events and transaction results" "WebSocket / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

firefly.ethconnect.websockets -> firefly.core "Delivers confirmed contract event batches" "WebSocket / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/ws\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

firefly.ethconnect -> firefly.ethconnectState "Persists connector state in local files" "LevelDB / filesystem" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kvstore\"]"
    }
}

firefly.ethconnect.kv -> firefly.ethconnectState "Reads and writes event and registry records" "LevelDB API / filesystem" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kvstore\"]"
    }
}

firefly.ethconnect.receipts -> firefly.ethconnectState "Persists receipts when LevelDB is selected" "LevelDB API / filesystem" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts\",\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kvstore\"]"
    }
}
