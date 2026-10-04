ethconnectState = container "EthConnect local state" "Optional LevelDB receipts, subscriptions and contract metadata." "LevelDB / filesystem" {
    tags "Database"
    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kvstore"
    properties {
        "architecture.id" "firefly.ethconnectState"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kvstore\"]"
    }
}
