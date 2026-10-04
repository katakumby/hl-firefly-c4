group "Cardano ecosystem" {
    blockfrostService = softwareSystem "Blockfrost API" "Hosted or self-managed Cardano ledger API; alternative to direct node access." {
        tags "External"
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/README.md"
        properties {
            "architecture.id" "blockfrostService"
            "evidence" "External integration boundary"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/README.md\"]"
        }
    }
}
