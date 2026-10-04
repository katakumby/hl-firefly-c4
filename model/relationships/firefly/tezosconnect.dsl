firefly.tezosconnect.api -> firefly.tezosconnect.policy "Schedules durable operation submission" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/pkg/fftm\",\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/pkg/txhandler\"]"
    }
}

firefly.tezosconnect.policy -> firefly.tezosconnect.adapter "Prepares and submits Tezos operations" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/pkg/txhandler\",\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos\"]"
    }
}

firefly.tezosconnect.adapter -> firefly.tezosconnect.signing "Requests a signature for encoded operations" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos\",\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/send_transaction.go\"]"
    }
}

firefly.tezosconnect.blocks -> firefly.tezosconnect.events "Supplies observed Tezos blocks" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/blocklistener.go\",\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/event_stream.go\"]"
    }
}

firefly.tezosconnect.events -> firefly.tezosconnect.streams "Supplies decoded contract events" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/event_stream.go\",\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/events\"]"
    }
}

firefly.tezosconnect.api -> firefly.tezosconnect.streams "Configures event streams" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/pkg/fftm\",\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/events\"]"
    }
}

firefly.tezosconnect.api -> firefly.tezosconnect.persistence "Persists managed transaction state" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/pkg/fftm\",\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/persistence\"]"
    }
}

firefly.tezosconnect.streams -> firefly.tezosconnect.persistence "Persists acknowledged checkpoints" "In-process calls / Go" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/events\",\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/persistence\"]"
    }
}

firefly.tezosconnect -> firefly.tezosState "Persists transaction and stream state" "PostgreSQL wire or LevelDB API" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b\",\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/persistence\"]"
    }
}

firefly.tezosconnect.persistence -> firefly.tezosState "Reads and writes managed state" "PostgreSQL wire or LevelDB API" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/persistence\"]"
    }
}

firefly.tezosconnect -> firefly.core "Delivers confirmed Tezos events" "WebSocket / JSON" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

firefly.tezosconnect.streams -> firefly.core "Delivers confirmed event batches" "WebSocket / JSON" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/events\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}
