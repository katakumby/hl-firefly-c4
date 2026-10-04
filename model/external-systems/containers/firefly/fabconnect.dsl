fabconnect = container "FabConnect" "Fabric transaction, identity and ledger-event connector." "Go / Fabric SDK" {
    url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b"
    properties {
        "architecture.id" "firefly.fabconnect"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b\"]"
    }
    rest = component "REST gateway and dispatch" "Routes identity, transaction and receipt requests." "Go" {
        url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest"
        properties {
            "architecture.id" "firefly.fabconnect.rest"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest\"]"
        }
    }
    auth = component "Authorization extension" "Applies configured API authorization hooks." "Go" {
        url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/auth"
        properties {
            "architecture.id" "firefly.fabconnect.auth"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/auth\"]"
        }
    }
    identity = component "Identity enrollment API" "Registers and enrolls Fabric signing identities." "Go" {
        url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest/identity"
        properties {
            "architecture.id" "firefly.fabconnect.identity"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest/identity\"]"
        }
    }
    transactions = component "Transaction processor" "Submits chaincode transactions and tracks completion." "Go" {
        url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/tx"
        properties {
            "architecture.id" "firefly.fabconnect.transactions"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/tx\"]"
        }
    }
    client = component "Fabric clients and wallet" "Uses connection profiles or discovery to access peers and ordering services." "Go" {
        url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client"
        properties {
            "architecture.id" "firefly.fabconnect.client"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client\"]"
        }
    }
    events = component "Event subscriptions and checkpoints" "Filters Fabric events and manages delivery checkpoints." "Go" {
        url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/events"
        properties {
            "architecture.id" "firefly.fabconnect.events"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/events\"]"
        }
    }
    websockets = component "WebSocket delivery" "Delivers event batches and consumes acknowledgements." "Go" {
        url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/ws"
        properties {
            "architecture.id" "firefly.fabconnect.websockets"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/ws\"]"
        }
    }
    kafka = component "Kafka bridge" "Supports optional asynchronous transaction request/reply messaging." "Go" {
        url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/kafka"
        properties {
            "architecture.id" "firefly.fabconnect.kafka"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/kafka\"]"
        }
    }
    receipts = component "Receipt persistence" "Stores transaction results in configured receipt backends." "Go" {
        url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest/receipt"
        properties {
            "architecture.id" "firefly.fabconnect.receipts"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest/receipt\"]"
        }
    }
    kv = component "Key-value persistence" "Persists connector event state in LevelDB." "Go" {
        url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/kvstore"
        properties {
            "architecture.id" "firefly.fabconnect.kv"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/kvstore\"]"
        }
    }
}
