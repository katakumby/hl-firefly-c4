cardanoKeys = container "Cardano signing keys" "Address-indexed signing key files held by the Cardano Signer." "Filesystem keystore" {
    tags "Database"
    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/keys.rs"
    properties {
        "architecture.id" "firefly.cardanoKeys"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/keys.rs\"]"
    }
}
