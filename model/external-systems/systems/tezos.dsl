group "Tezos ecosystem" {
    tezos = softwareSystem "Tezos network" "External Tezos node RPC and chain-monitoring endpoints." {
        tags "Optional"
        url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/README.md"
        properties {
            "architecture.id" "tezos"
            "evidence" "External integration boundary"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/README.md\"]"
        }
    }
}
