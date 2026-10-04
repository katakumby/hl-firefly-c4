firefly.fabconnect.rest -> firefly.fabconnect.auth "Checks configured authorization hooks" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/auth\"]"
    }
}

firefly.fabconnect.rest -> firefly.fabconnect.identity "Routes identity enrollment requests" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest/identity\"]"
    }
}

firefly.fabconnect.identity -> firefly.fabconnect.client "Registers and enrolls signing identities" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest/identity\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client\"]"
    }
}

firefly.fabconnect.rest -> firefly.fabconnect.transactions "Dispatches chaincode transaction requests" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/tx\"]"
    }
}

firefly.fabconnect.rest -> firefly.fabconnect.kafka "Publishes requests in asynchronous Kafka mode" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/kafka\"]"
    }
}

firefly.fabconnect.kafka -> firefly.fabconnect.transactions "Dispatches consumed transaction requests" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/kafka\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/tx\"]"
    }
}

firefly.fabconnect.transactions -> firefly.fabconnect.client "Submits chaincode invocations" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/tx\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client\"]"
    }
}

firefly.fabconnect.transactions -> firefly.fabconnect.receipts "Persists transaction results" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/tx\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest/receipt\"]"
    }
}

firefly.fabconnect.events -> firefly.fabconnect.client "Subscribes to Fabric ledger events" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/events\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client\"]"
    }
}

firefly.fabconnect.events -> firefly.fabconnect.websockets "Delivers filtered ledger event batches" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/events\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/ws\"]"
    }
}

firefly.fabconnect.events -> firefly.fabconnect.kv "Persists subscriptions and checkpoints" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/events\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/kvstore\"]"
    }
}

firefly.fabconnect.websockets -> firefly.core "Delivers acknowledged Fabric event batches" "WebSocket / JSON" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/ws\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

firefly.fabconnect -> firefly.core "Delivers Fabric events and transaction results" "WebSocket / JSON" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

firefly.fabconnect -> firefly.fabricState "Persists wallet and event state" "Filesystem / LevelDB" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client/store.go\"]"
    }
}

firefly.fabconnect.client -> firefly.fabricState "Reads and writes wallet identities" "Filesystem I/O" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client/store.go\"]"
    }
}

firefly.fabconnect.kv -> firefly.fabricState "Persists event checkpoints" "LevelDB API / filesystem" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/kvstore\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client/store.go\"]"
    }
}

firefly.fabconnect.receipts -> firefly.fabricState "Persists receipts when LevelDB is selected" "LevelDB API / filesystem" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest/receipt\",\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client/store.go\"]"
    }
}
