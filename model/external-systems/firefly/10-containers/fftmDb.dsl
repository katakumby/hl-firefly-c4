!element firefly {
    fftmDb = container "FFTM PostgreSQL database" "Stores EVMConnect transaction state, nonces and checkpoints in a separate logical database with separate credentials." "PostgreSQL" {
        tags "Database"
        url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence/postgres"
        properties {
            "architecture.id" "firefly.fftmDb"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence/postgres\"]"
        }
    }
}
