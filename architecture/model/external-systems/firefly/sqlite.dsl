sqlite = container "Core SQLite file" "Optional embedded Core database; no independent database server." "SQLite / filesystem" {
    tags "Database,Optional"
    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/sqlite3"
    properties {
        "architecture.id" "firefly.sqlite"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/sqlite3\"]"
    }
}
