cardanoconnect = container "CardanoConnect" "Native Cardano connector with operation, contract and event managers." "Rust / Axum" {
    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect"
    properties {
        "architecture.id" "firefly.cardanoconnect"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect\"]"
    }
    api = component "HTTP and WebSocket API" "Routes transaction, contract, operation and stream requests." "Rust" {
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/routes"
        properties {
            "architecture.id" "firefly.cardanoconnect.api"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/routes\"]"
        }
    }
    operations = component "Operations manager" "Coordinates transaction construction, signing and submission." "Rust" {
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/operations"
        properties {
            "architecture.id" "firefly.cardanoconnect.operations"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/operations\"]"
        }
    }
    blockchain = component "Blockchain client" "Selects Blockfrost or direct node-to-client ledger access." "Rust" {
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/blockchain"
        properties {
            "architecture.id" "firefly.cardanoconnect.blockchain"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/blockchain\"]"
        }
    }
    blockfrost = component "Blockfrost adapter" "Reads chain data and submits transactions through Blockfrost." "Rust" {
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/blockchain/blockfrost"
        properties {
            "architecture.id" "firefly.cardanoconnect.blockfrost"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/blockchain/blockfrost\"]"
        }
    }
    n2c = component "Node-to-client adapter" "Reads local node state and chain synchronization through Pallas." "Rust" {
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/blockchain/n2c"
        properties {
            "architecture.id" "firefly.cardanoconnect.n2c"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/blockchain/n2c\"]"
        }
    }
    signer = component "Signer service client" "Obtains transaction witnesses from the separate signer." "Rust" {
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/signer.rs"
        properties {
            "architecture.id" "firefly.cardanoconnect.signer"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/signer.rs\"]"
        }
    }
    contracts = component "Contract manager and Balius runtime" "Runs optional application WASM workers over Cardano ledger data." "Rust" {
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/contracts"
        properties {
            "architecture.id" "firefly.cardanoconnect.contracts"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/contracts\"]"
        }
    }
    balius = component "FireFly Balius worker SDK" "Implements WASM worker logic, monitoring and contract events." "Rust" {
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-balius/src"
        properties {
            "architecture.id" "firefly.cardanoconnect.balius"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-balius/src\"]"
        }
    }
    streams = component "Stream manager and event multiplexer" "Orders operation and blockchain notifications for consumers." "Rust" {
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/streams"
        properties {
            "architecture.id" "firefly.cardanoconnect.streams"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/streams\"]"
        }
    }
    persistence = component "SQLite persistence" "Persists operations, checkpoints and contract key-value state." "Rust" {
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/persistence"
        properties {
            "architecture.id" "firefly.cardanoconnect.persistence"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/persistence\"]"
        }
    }
    server = component "Shared HTTP server and instrumentation" "Hosts routes, configuration and tracing; an embedded library." "Rust" {
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-server/src"
        properties {
            "architecture.id" "firefly.cardanoconnect.server"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-server/src\"]"
        }
    }
}
