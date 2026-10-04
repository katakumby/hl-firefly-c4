!element firefly {
    erc20 = container "ERC-20 / ERC-721 connector" "Maps fungible and non-fungible token APIs to EVM contracts." "TypeScript / NestJS" {
        url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src"
        properties {
            "architecture.id" "firefly.erc20"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src\"]"
        }
        api = component "Token REST controller" "Accepts pool, mint, burn, transfer and approval requests." "TypeScript / NestJS" {
            url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.controller.ts"
            properties {
                "architecture.id" "firefly.erc20.api"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.controller.ts\"]"
            }
        }
        service = component "Token service" "Applies token-specific behavior and tracks pools." "TypeScript / NestJS" {
            url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.service.ts"
            properties {
                "architecture.id" "firefly.erc20.service"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.service.ts\"]"
            }
        }
        mapper = component "ABI and standard adapters" "Maps token operations to contract ABIs." "TypeScript / NestJS" {
            url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens"
            properties {
                "architecture.id" "firefly.erc20.mapper"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens\"]"
            }
        }
        blockchain = component "Blockchain connector client" "Submits contract calls through EVMConnect." "TypeScript / NestJS" {
            url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/blockchain.service.ts"
            properties {
                "architecture.id" "firefly.erc20.blockchain"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/blockchain.service.ts\"]"
            }
        }
        listener = component "Token event listener" "Interprets contract logs as standard token events." "TypeScript / NestJS" {
            url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.listener.ts"
            properties {
                "architecture.id" "firefly.erc20.listener"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.listener.ts\"]"
            }
        }
        stream = component "Connector event stream" "Receives ordered blockchain events and acknowledges batches." "TypeScript / NestJS" {
            url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/event-stream"
            properties {
                "architecture.id" "firefly.erc20.stream"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/event-stream\"]"
            }
        }
        proxy = component "Core event proxy" "Delivers token events to Core over WebSocket." "TypeScript / NestJS" {
            url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/eventstream-proxy"
            properties {
                "architecture.id" "firefly.erc20.proxy"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/eventstream-proxy\"]"
            }
        }
    }
}
