apps.client -> firefly.core "Submits member-scoped commands and queries" "HTTPS / REST" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

apps.client -> firefly.core.api "Submits API commands and queries" "HTTPS / REST" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/apiserver\"]"
    }
}

apps -> firefly "Submits member requests and consumes events" "HTTPS + WebSocket" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
    }
}

apps.client -> firefly.core.websockets "Acknowledges consumed event batches" "WebSocket / JSON" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/websockets\"]"
    }
}

apps.client -> keycloak.server "Submits authorization request via browser and configured protocol client" "HTTPS / OIDC reference client" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

apps.client -> entraId.authentication "Submits authorization request via browser and configured protocol client" "HTTPS / OIDC reference client" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

apps.client -> adFs.service "Submits authorization request via browser and configured protocol client" "HTTPS / SAML 2.0 reference client" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

apps.client -> keycloak.server.endpoints "Submits relying-party authorization request using the reference client" "HTTPS / OIDC or SAML as configured" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

apps.client -> entraId.authentication.endpoints "Submits relying-party authorization request using the reference client" "HTTPS / OIDC or SAML as configured" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

apps.client -> adFs.service.endpoints "Submits relying-party authorization request using the reference client" "HTTPS / OIDC or SAML as configured" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\"]"
    }
}

apps.client -> conjur.service "Authenticates workload and requests permitted secret variable" "HTTPS / Conjur authentication and secrets APIs" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

apps.client -> conjur.service.api "Authenticates workload and requests permitted secret variable" "HTTPS / Conjur authentication and secrets APIs" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

apps.client -> managedHsm.service "Submits bearer token, key identifier and digest or key-wrapping input" "HTTPS / Managed HSM REST API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

apps.client -> managedHsm.service.api "Submits bearer token, key identifier and digest or key-wrapping input" "HTTPS / Managed HSM REST API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

hsmWorkloadTokenRequest = apps.client -> entraId.authentication "Authenticates workload identity and requests HSM-audience access token" "HTTPS / OAuth 2.0 client credentials" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

apps.hsmSigner -> firefly.evm "Returns transaction hash or signing/submission error" "Ethereum JSON-RPC response" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go\"]"
    }
}

apps.hsmSigner -> entraId.authentication "Authenticates application identity and requests Managed HSM access token" "HTTPS / OAuth 2.0 client credentials" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

apps.hsmSigner -> managedHsm.service "Submits Ethereum digest for secp256k1 signing; compatibility must be verified" "HTTPS / Managed HSM Sign API (proposed)" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://ethereum.org/en/developers/docs/transactions/\"]"
    }
}

apps.hsmSigner -> managedHsm.service "Requests public key metadata for the selected key version" "HTTPS / Managed HSM Get Key API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/rest/api/keyvault/keys/get-key/get-key?view=rest-keyvault-keys-2025-07-01\"]"
    }
}

apps.hsmSigner.hsm -> entraId.authentication "Authenticates application identity and requests Managed HSM access token" "HTTPS / OAuth 2.0 client credentials" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

apps.hsmSigner.hsm -> managedHsm.service "Submits Ethereum digest for secp256k1 signing; compatibility must be verified" "HTTPS / Managed HSM Sign API (proposed)" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
    }
}

apps.hsmSigner.hsm -> managedHsm.service "Requests public key metadata for the selected key version" "HTTPS / Managed HSM Get Key API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/rest/api/keyvault/keys/get-key/get-key?view=rest-keyvault-keys-2025-07-01\"]"
    }
}

apps.hsmSigner -> besu.node "Submits encoded signed transaction for validation and propagation" "Ethereum JSON-RPC / eth_sendRawTransaction" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}

apps.hsmSigner.rpc -> besu.node "Submits encoded signed transaction for validation and propagation" "Ethereum JSON-RPC / eth_sendRawTransaction" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}

apps -> keycloak "Requests application sign-in and identity claims" "HTTPS / OIDC or SAML reference flow" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

apps -> entraId "Requests application sign-in and identity claims" "HTTPS / OIDC or SAML reference flow" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

apps -> adFs "Requests application sign-in and identity claims" "HTTPS / OIDC or SAML reference flow" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

apps -> besu "Submits signed transactions through the proposed custom HSM adapter" "Ethereum JSON-RPC / eth_sendRawTransaction" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}

apps -> conjur "Authenticates workload and requests permitted application secrets" "HTTPS / Conjur API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

apps -> managedHsm "Submits authorized signing or key-wrapping request" "HTTPS / Managed HSM REST API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}
