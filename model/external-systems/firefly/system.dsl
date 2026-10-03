firefly = softwareSystem "Hyperledger FireFly" "Reusable supernode architecture; each consortium member deploys an isolated instance." {
    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d"
    properties {
        "architecture.id" "firefly"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
    }
    !include core.dsl
    !include evm.dsl
    !include signer.dsl
    !include dx.dsl
    !include erc20.dsl
    !include erc1155.dsl
    !include ipfs.dsl
    !include pg.dsl
    !include fftmDb.dsl
    !include blobs.dsl
    !include ipfsRepo.dsl
    !include secrets.dsl
    !include explorer.dsl
    !include sqlite.dsl
    !include leveldb.dsl
    !include ethconnect.dsl
    !include ethconnectState.dsl
    !include fabconnect.dsl
    !include fabricState.dsl
    !include tezosconnect.dsl
    !include tezosState.dsl
    !include cardanoconnect.dsl
    !include cardanosigner.dsl
    !include cardanoState.dsl
    !include cardanoKeys.dsl
    !include cordaconnect.dsl
    !include cordaState.dsl
}
