apps.hsmSigner.transactions -> apps.hsmSigner.hsm "Passes Ethereum digest, key version and required signing algorithm" "In-process logical interface" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\"]"
    }
}

apps.hsmSigner.hsm -> apps.hsmSigner.signature "Returns HSM signature, public key and original signing digest" "In-process logical interface" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\"]"
    }
}

apps.hsmSigner.signature -> apps.hsmSigner.rpc "Supplies verified and encoded signed Ethereum transaction" "In-process logical interface" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\"]"
    }
}

apps.hsmSigner.rpc -> apps.hsmSigner.transactions "Returns submitted transaction hash or RPC error" "In-process logical interface" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\"]"
    }
}
