!element firefly {
    cardanosigner = container "Cardano Signer" "Signs CBOR transaction bodies using separately stored Cardano keys." "Rust / Axum" {
        url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner"
        properties {
            "architecture.id" "firefly.cardanosigner"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner\"]"
        }
        api = component "Signing HTTP API" "Accepts signing requests and returns CBOR witness sets." "Rust" {
            url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/routes.rs"
            properties {
                "architecture.id" "firefly.cardanosigner.api"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/routes.rs\"]"
            }
        }
        keys = component "Address-indexed key store" "Loads configured key files and resolves signing addresses." "Rust" {
            url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/keys.rs"
            properties {
                "architecture.id" "firefly.cardanosigner.keys"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/keys.rs\"]"
            }
        }
        crypto = component "Ed25519 signing" "Signs Cardano transaction-body hashes." "Rust" {
            url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/private_key.rs"
            properties {
                "architecture.id" "firefly.cardanosigner.crypto"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/private_key.rs\"]"
            }
        }
        server = component "Shared HTTP server" "Hosts signer routes and instrumentation." "Rust" {
            url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-server/src"
            properties {
                "architecture.id" "firefly.cardanosigner.server"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-server/src\"]"
            }
        }
    }
}
