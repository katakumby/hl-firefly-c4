!element firefly {
    signer = container "FireFly Signer" "Signs member transactions and proxies Ethereum RPC calls." "Go" {
        url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
        properties {
            "architecture.id" "firefly.signer"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver\"]"
        }
        proxy = component "JSON-RPC proxy" "Intercepts transaction requests and forwards read calls." "Go" {
            url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
            properties {
                "architecture.id" "firefly.signer.proxy"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver\"]"
            }
        }
        wallet = component "Filesystem wallet" "Loads member keystore files and resolves signing accounts." "Go" {
            url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
            properties {
                "architecture.id" "firefly.signer.wallet"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet\"]"
            }
        }
        keystore = component "Keystore V3 decoder" "Decrypts encrypted account key files." "Go" {
            url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/keystorev3"
            properties {
                "architecture.id" "firefly.signer.keystore"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/keystorev3\"]"
            }
        }
        signing = component "Ethereum signing" "Encodes and signs EIP-155 and EIP-1559 transactions." "Go" {
            url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/ethsigner"
            properties {
                "architecture.id" "firefly.signer.signing"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/ethsigner\"]"
            }
        }
        backend = component "RPC backend" "Forwards signed raw transactions to Besu." "Go" {
            url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/rpcbackend"
            properties {
                "architecture.id" "firefly.signer.backend"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/rpcbackend\"]"
            }
        }
    }
}
