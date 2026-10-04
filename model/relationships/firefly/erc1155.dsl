firefly.erc1155.api -> firefly.erc1155.service "Submits standard token operations" "In-process calls / TypeScript" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.controller.ts\",\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.service.ts\"]"
    }
}

firefly.erc1155.service -> firefly.erc1155.mapper "Encodes token contract calls" "In-process calls / TypeScript" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.service.ts\",\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens\"]"
    }
}

firefly.erc1155.mapper -> firefly.erc1155.blockchain "Passes encoded contract requests" "In-process calls / TypeScript" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens\",\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/blockchain.service.ts\"]"
    }
}

firefly.erc1155.blockchain -> firefly.erc1155.stream "Registers contract event listeners" "In-process calls / TypeScript" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/blockchain.service.ts\",\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/event-stream\"]"
    }
}

firefly.erc1155.stream -> firefly.erc1155.listener "Delivers token contract logs" "In-process calls / TypeScript" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/event-stream\",\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.listener.ts\"]"
    }
}

firefly.erc1155.listener -> firefly.erc1155.service "Updates token pool state" "In-process calls / TypeScript" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.listener.ts\",\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.service.ts\"]"
    }
}

firefly.erc1155.listener -> firefly.erc1155.proxy "Publishes normalized token events" "In-process calls / TypeScript" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.listener.ts\",\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/eventstream-proxy\"]"
    }
}

firefly.erc1155.proxy -> firefly.erc1155.stream "Acknowledges consumed event batches" "In-process calls / TypeScript" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/eventstream-proxy\",\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/event-stream\"]"
    }
}

firefly.erc1155 -> firefly.core "Delivers normalized token events" "WebSocket / JSON" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

firefly.erc1155 -> firefly.evm "Submits contract calls and consumes event streams" "HTTP REST + WebSocket" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src\",\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go\"]"
    }
}

firefly.erc1155.blockchain -> firefly.evm "Submits contract calls and listeners" "HTTP REST / JSON" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/blockchain.service.ts\",\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go\"]"
    }
}

firefly.erc1155.proxy -> firefly.core "Delivers token events and receives ACKs" "WebSocket / JSON" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/eventstream-proxy\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}
