firefly.erc20.api -> firefly.erc20.service "Submits standard token operations" "In-process calls / TypeScript" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.controller.ts\",\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.service.ts\"]"
    }
}

firefly.erc20.service -> firefly.erc20.mapper "Encodes token contract calls" "In-process calls / TypeScript" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.service.ts\",\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens\"]"
    }
}

firefly.erc20.mapper -> firefly.erc20.blockchain "Passes encoded contract requests" "In-process calls / TypeScript" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens\",\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/blockchain.service.ts\"]"
    }
}

firefly.erc20.blockchain -> firefly.erc20.stream "Registers contract event listeners" "In-process calls / TypeScript" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/blockchain.service.ts\",\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/event-stream\"]"
    }
}

firefly.erc20.stream -> firefly.erc20.listener "Delivers token contract logs" "In-process calls / TypeScript" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/event-stream\",\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.listener.ts\"]"
    }
}

firefly.erc20.listener -> firefly.erc20.service "Updates token pool state" "In-process calls / TypeScript" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.listener.ts\",\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.service.ts\"]"
    }
}

firefly.erc20.listener -> firefly.erc20.proxy "Publishes normalized token events" "In-process calls / TypeScript" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.listener.ts\",\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/eventstream-proxy\"]"
    }
}

firefly.erc20.proxy -> firefly.erc20.stream "Acknowledges consumed event batches" "In-process calls / TypeScript" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/eventstream-proxy\",\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/event-stream\"]"
    }
}

firefly.erc20 -> firefly.core "Delivers normalized token events" "WebSocket / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

firefly.erc20 -> firefly.evm "Submits contract calls and consumes event streams" "HTTP REST + WebSocket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src\",\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go\"]"
    }
}

firefly.erc20.blockchain -> firefly.evm "Submits contract calls and listeners" "HTTP REST / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/blockchain.service.ts\",\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go\"]"
    }
}

firefly.erc20.proxy -> firefly.core "Delivers token events and receives ACKs" "WebSocket / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/eventstream-proxy\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}
