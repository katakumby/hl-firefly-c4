!element firefly {
    tezosconnect = container "TezosConnect + FFTM" "Tezos connector with its dependency-pinned embedded transaction manager." "Go" {
        url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b"
        properties {
            "architecture.id" "firefly.tezosconnect"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b\"]"
        }
        api = component "Connector API and transaction manager" "Accepts and manages durable transaction and stream requests." "Go" {
            url "https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/pkg/fftm"
            properties {
                "architecture.id" "firefly.tezosconnect.api"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/pkg/fftm\"]"
            }
        }
        policy = component "Transaction policy and nonce management" "Schedules Tezos operation submission, retries and counter allocation." "Go" {
            url "https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/pkg/txhandler"
            properties {
                "architecture.id" "firefly.tezosconnect.policy"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/pkg/txhandler\"]"
            }
        }
        adapter = component "Tezos operation adapter" "Prepares, queries, estimates and submits Tezos operations." "Go" {
            url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos"
            properties {
                "architecture.id" "firefly.tezosconnect.adapter"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos\"]"
            }
        }
        signing = component "Remote signing client" "Requests operation signatures from Signatory." "Go" {
            url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/send_transaction.go"
            properties {
                "architecture.id" "firefly.tezosconnect.signing"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/send_transaction.go\"]"
            }
        }
        blocks = component "Tezos block listener" "Monitors chain heads for events and receipts." "Go" {
            url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/blocklistener.go"
            properties {
                "architecture.id" "firefly.tezosconnect.blocks"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/blocklistener.go\"]"
            }
        }
        events = component "Event listener and stream adapter" "Converts Tezos contract events to connector events." "Go" {
            url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/event_stream.go"
            properties {
                "architecture.id" "firefly.tezosconnect.events"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/event_stream.go\"]"
            }
        }
        streams = component "FFTM confirmations and event delivery" "Confirms and delivers checkpointed event batches." "Go" {
            url "https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/events"
            properties {
                "architecture.id" "firefly.tezosconnect.streams"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/events\"]"
            }
        }
        persistence = component "FFTM persistence" "Stores managed transactions and event checkpoints." "Go" {
            url "https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/persistence"
            properties {
                "architecture.id" "firefly.tezosconnect.persistence"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/persistence\"]"
            }
        }
    }
}
