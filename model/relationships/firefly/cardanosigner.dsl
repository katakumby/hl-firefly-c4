firefly.cardanosigner.server -> firefly.cardanosigner.api "Hosts signing API requests" "In-process calls / Rust" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-server/src\",\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/routes.rs\"]"
    }
}

firefly.cardanosigner.api -> firefly.cardanosigner.keys "Looks up the requested address key" "In-process calls / Rust" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/routes.rs\",\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/keys.rs\"]"
    }
}

firefly.cardanosigner.api -> firefly.cardanosigner.crypto "Signs the transaction-body hash" "In-process calls / Rust" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/routes.rs\",\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/private_key.rs\"]"
    }
}

firefly.cardanosigner.keys -> firefly.cardanosigner.crypto "Supplies the resolved private key" "In-process calls / Rust" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/keys.rs\",\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/private_key.rs\"]"
    }
}

firefly.cardanosigner -> firefly.cardanoKeys "Loads Cardano signing keys" "Filesystem I/O" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner\",\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/keys.rs\"]"
    }
}

firefly.cardanosigner.keys -> firefly.cardanoKeys "Loads address-indexed signing key files" "Filesystem I/O" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/keys.rs\"]"
    }
}
