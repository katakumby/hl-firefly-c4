!element firefly {
    pg = container "Core PostgreSQL database" "Stores Core resources and offsets in its own logical database; server placement and replication are outside this model." "PostgreSQL" {
        tags "Database"
        url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/postgres"
        properties {
            "architecture.id" "firefly.pg"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/postgres\"]"
        }
    }
}
