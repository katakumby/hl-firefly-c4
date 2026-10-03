evm = container "EVMConnect + FFTM" "Submits Ethereum transactions and streams confirmed events; one nonce writer." "Go" {
    url "https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go"
    properties {
        "architecture.id" "firefly.evm"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go\"]"
    }
    api = component "Connector REST API" "Accepts transaction, query and event-stream requests." "Go" {
        url "https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go"
        properties {
            "architecture.id" "firefly.evm.api"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go\"]"
        }
    }
    manager = component "Transaction manager" "Coordinates durable transaction and stream lifecycles." "Go" {
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/fftm"
        properties {
            "architecture.id" "firefly.evm.manager"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/fftm\"]"
        }
    }
    handler = component "Transaction policy handler" "Schedules signing, submission, gas and retry policy." "Go" {
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/txhandler"
        properties {
            "architecture.id" "firefly.evm.handler"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/txhandler\"]"
        }
    }
    nonce = component "Nonce allocation" "Assigns and persists ordered nonces per signing address." "Go" {
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence"
        properties {
            "architecture.id" "firefly.evm.nonce"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence\"]"
        }
    }
    abi = component "EVM API adapter" "Encodes ABIs and implements the blockchain connector API." "Go" {
        url "https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/internal/ethereum"
        properties {
            "architecture.id" "firefly.evm.abi"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/internal/ethereum\"]"
        }
    }
    rpc = component "Ethereum JSON-RPC client" "Submits calls and transactions through the signing proxy." "Go" {
        url "https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/pkg/ethrpc"
        properties {
            "architecture.id" "firefly.evm.rpc"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/pkg/ethrpc\"]"
        }
    }
    blocks = component "Block listener" "Tracks chain heads and block/filter updates." "Go" {
        url "https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/pkg/ethblocklistener"
        properties {
            "architecture.id" "firefly.evm.blocks"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/pkg/ethblocklistener\"]"
        }
    }
    receipts = component "Receipt tracking" "Polls receipt status for submitted transactions." "Go" {
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/fftm"
        properties {
            "architecture.id" "firefly.evm.receipts"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/fftm\"]"
        }
    }
    confirmations = component "Confirmation manager" "Confirms receipts and events against the observed chain." "Go" {
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/confirmations"
        properties {
            "architecture.id" "firefly.evm.confirmations"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/confirmations\"]"
        }
    }
    streams = component "Event streams" "Orders and batches confirmed listener events." "Go" {
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/events"
        properties {
            "architecture.id" "firefly.evm.streams"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/events\"]"
        }
    }
    delivery = component "WebSocket batch delivery" "Delivers WebSocket batches and accepts consumer acknowledgements." "Go" {
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/ws"
        properties {
            "architecture.id" "firefly.evm.delivery"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/ws\"]"
        }
    }
    persistence = component "Persistence adapter" "Stores transactions, nonces, streams and checkpoints." "Go" {
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence"
        properties {
            "architecture.id" "firefly.evm.persistence"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence\"]"
        }
    }
    postgres = component "PostgreSQL persistence" "Persists managed transactions and streams in SQL tables." "Go" {
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence/postgres"
        properties {
            "architecture.id" "firefly.evm.postgres"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence/postgres\"]"
        }
    }
    leveldb = component "LevelDB persistence" "Persists transactions and stream state in local key-value files." "Go" {
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence/leveldb"
        properties {
            "architecture.id" "firefly.evm.leveldb"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence/leveldb\"]"
        }
    }
    blocklistener = component "Durable block notifications" "Coordinates block updates for listeners and confirmations." "Go" {
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/blocklistener"
        properties {
            "architecture.id" "firefly.evm.blocklistener"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/blocklistener\"]"
        }
    }
    metrics = component "Transaction and stream metrics" "Records transaction and event-processing measurements." "Go" {
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/metrics"
        properties {
            "architecture.id" "firefly.evm.metrics"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/metrics\"]"
        }
    }
    webhook = component "Webhook batch delivery" "Delivers event batches using configured HTTP callbacks." "Go" {
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/events"
        properties {
            "architecture.id" "firefly.evm.webhook"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/events\"]"
        }
    }
}
