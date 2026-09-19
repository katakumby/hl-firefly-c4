mongo = softwareSystem "MongoDB receipt service" "Optional receipt persistence for legacy Ethereum and Fabric connectors." {
    tags "Optional"
    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts/mongoreceipts.go"
    properties {
        "architecture.id" "mongo"
        "evidence" "External integration boundary"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts/mongoreceipts.go\"]"
    }
}
