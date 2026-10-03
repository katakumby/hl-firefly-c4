firefly.signer.proxy -> firefly.signer.wallet "Resolves requested signing accounts" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver\",\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet\"]"
    }
}

firefly.signer.wallet -> firefly.signer.keystore "Decrypts selected key material" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet\",\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/keystorev3\"]"
    }
}

firefly.signer.proxy -> firefly.signer.signing "Submits transactions for signing" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver\",\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/ethsigner\"]"
    }
}

firefly.signer.signing -> firefly.signer.wallet "Retrieves the selected signing key" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/ethsigner\",\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet\"]"
    }
}

firefly.signer.signing -> firefly.signer.backend "Submits signed raw transactions" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/ethsigner\",\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/rpcbackend\"]"
    }
}

firefly.signer.proxy -> firefly.signer.backend "Forwards unmodified RPC read requests" "In-process calls / Go" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver\",\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/rpcbackend\"]"
    }
}

firefly.signer -> firefly.secrets "Loads member signing keystore files" "Read-only projected files" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver\",\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet\"]"
    }
}

firefly.signer.wallet -> firefly.secrets "Loads encrypted account keystores" "Read-only projected files" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet\"]"
    }
}
