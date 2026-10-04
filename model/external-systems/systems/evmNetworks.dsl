group "EVM ledger networks" {
    evmNetworks = softwareSystem "Other EVM networks" "Optional public or permissioned EVM-compatible networks; share the Ethereum adapter implementation." {
        tags "Optional"
        url "https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/README.md"
        properties {
            "architecture.id" "evmNetworks"
            "evidence" "External integration boundary"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/README.md\"]"
        }
    }
}
