!element firefly {
    cardanoState = container "CardanoConnect SQLite files" "Operation, checkpoint and optional contract worker state." "SQLite / filesystem" {
        tags "Database"
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/persistence"
        properties {
            "architecture.id" "firefly.cardanoState"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/persistence\"]"
        }
    }
}
