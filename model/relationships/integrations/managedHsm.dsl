managedHsm.service -> apps.client "Returns signature or wrapped data key; never the HSM private key" "HTTPS / Managed HSM REST response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

managedHsm.service.api -> apps.client "Returns signature or wrapped data key; never the HSM private key" "HTTPS / Managed HSM REST response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

managedHsm.service -> entraId.authentication "Retrieves issuer metadata and public signing keys for cached token verification" "HTTPS / OpenID metadata and JWKS" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

managedHsm.service.authentication -> entraId.authentication "Retrieves issuer metadata and public signing keys for cached token verification" "HTTPS / OpenID metadata and JWKS" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

managedHsm.service -> apps.hsmSigner "Returns signature bytes and signing key identifier; never private key material" "HTTPS / Managed HSM Sign API response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://learn.microsoft.com/en-us/rest/api/keyvault/keys/sign/sign?view=rest-keyvault-keys-2025-07-01\"]"
    }
}

managedHsm.service -> apps.hsmSigner "Returns public key parameters for sender and signature verification" "HTTPS / Managed HSM Get Key API response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://learn.microsoft.com/en-us/rest/api/keyvault/keys/get-key/get-key?view=rest-keyvault-keys-2025-07-01\"]"
    }
}

managedHsm.service -> apps.hsmSigner.hsm "Returns signature bytes and signing key identifier; never private key material" "HTTPS / Managed HSM Sign API response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/rest/api/keyvault/keys/sign/sign?view=rest-keyvault-keys-2025-07-01\"]"
    }
}

managedHsm.service -> apps.hsmSigner.hsm "Returns public key parameters for sender and signature verification" "HTTPS / Managed HSM Get Key API response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/rest/api/keyvault/keys/get-key/get-key?view=rest-keyvault-keys-2025-07-01\"]"
    }
}

managedHsm -> apps "Returns signature or wrapped key result without private key material" "HTTPS / Managed HSM REST response" "Dataflow,SecurityCatalog,KeyFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

managedHsm -> entraId "Retrieves issuer metadata and public signing keys for caller token verification" "HTTPS / OpenID metadata and JWKS" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}
