!element unleash {
    database = container "Unleash PostgreSQL" "Stores configuration, user/session/token records, audit history, registrations and aggregated usage." "PostgreSQL / Knex" {
        tags "Database"
        url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db"
        properties {
            "architecture.id" "unleash.database"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/migrations\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/docker-compose.yml\"]"
        }
    }
}
