group "Tezos ecosystem" {
    signatory = softwareSystem "Signatory" "Remote Tezos signing service; backend key management is external." {
        tags "Optional"
        url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/README.md"
        properties {
            "architecture.id" "signatory"
            "evidence" "External integration boundary"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/README.md\"]"
        }
    }
}
