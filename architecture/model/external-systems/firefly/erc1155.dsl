erc1155 = container "ERC-1155 connector" "Maps multi-token operations and events to FireFly." "TypeScript / NestJS" {
    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src"
    properties {
        "architecture.id" "firefly.erc1155"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src\"]"
    }
    api = component "Token REST controller" "Accepts pool, mint, burn, transfer and approval requests." "TypeScript / NestJS" {
        url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.controller.ts"
        properties {
            "architecture.id" "firefly.erc1155.api"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.controller.ts\"]"
        }
    }
    service = component "Token service" "Applies token-specific behavior and tracks pools." "TypeScript / NestJS" {
        url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.service.ts"
        properties {
            "architecture.id" "firefly.erc1155.service"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.service.ts\"]"
        }
    }
    mapper = component "ABI and standard adapters" "Maps token operations to contract ABIs." "TypeScript / NestJS" {
        url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens"
        properties {
            "architecture.id" "firefly.erc1155.mapper"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens\"]"
        }
    }
    blockchain = component "Blockchain connector client" "Submits contract calls through EVMConnect." "TypeScript / NestJS" {
        url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/blockchain.service.ts"
        properties {
            "architecture.id" "firefly.erc1155.blockchain"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/blockchain.service.ts\"]"
        }
    }
    listener = component "Token event listener" "Interprets contract logs as standard token events." "TypeScript / NestJS" {
        url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.listener.ts"
        properties {
            "architecture.id" "firefly.erc1155.listener"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.listener.ts\"]"
        }
    }
    stream = component "Connector event stream" "Receives ordered blockchain events and acknowledges batches." "TypeScript / NestJS" {
        url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/event-stream"
        properties {
            "architecture.id" "firefly.erc1155.stream"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/event-stream\"]"
        }
    }
    proxy = component "Core event proxy" "Delivers token events to Core over WebSocket." "TypeScript / NestJS" {
        url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/eventstream-proxy"
        properties {
            "architecture.id" "firefly.erc1155.proxy"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/eventstream-proxy\"]"
        }
    }
}
