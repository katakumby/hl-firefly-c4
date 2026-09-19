besu.node -> apps.hsmSigner "Returns transaction hash or JSON-RPC rejection" "Ethereum JSON-RPC response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
    }
}

besu.node -> apps.hsmSigner.rpc "Returns transaction hash or JSON-RPC rejection" "Ethereum JSON-RPC response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\",\"https://ethereum.org/en/developers/docs/transactions/\"]"
    }
}

besu -> apps "Returns transaction hash or rejection to the proposed custom HSM adapter" "Ethereum JSON-RPC response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}
