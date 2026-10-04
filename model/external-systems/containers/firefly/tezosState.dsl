tezosState = container "TezosConnect state" "Optional PostgreSQL or LevelDB persistence for the embedded FFTM." "PostgreSQL or LevelDB" {
    tags "Database"
    url "https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/persistence"
    properties {
        "architecture.id" "firefly.tezosState"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/persistence\"]"
    }
}
