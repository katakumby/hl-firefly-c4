group "Legacy connector infrastructure" {
    kafkaBroker = softwareSystem "Apache Kafka" "Optional transaction request/reply broker for legacy connector configurations." {
        tags "Optional"
        url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kafka"
        properties {
            "architecture.id" "kafkaBroker"
            "evidence" "External integration boundary"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kafka\"]"
        }
    }
}
