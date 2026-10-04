group "EVM ledger networks" {
    besu = softwareSystem "Private Besu network" "Permissioned Ethereum network with QBFT validators, private RPC and contracts." {
        url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1"
        properties {
            "architecture.id" "besu"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
        }
        !include ../containers/besu
    }
}
