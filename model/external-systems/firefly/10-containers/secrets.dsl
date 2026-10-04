!element firefly {
    secrets = container "Member keys and configuration" "Stores signing keystores, mTLS material and configuration; Kubernetes projection belongs to the deferred deployment reference." "Configuration and key files" {
        tags "Database"
        url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
        properties {
            "architecture.id" "firefly.secrets"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet\"]"
        }
    }
}
