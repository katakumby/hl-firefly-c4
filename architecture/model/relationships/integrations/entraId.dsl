entraId.agent -> adDs.directory "Queries selected users, groups, contacts and requested attributes" "LDAP / protected domain connection" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

entraId.agent.directory -> adDs.directory "Queries selected users, groups, contacts and requested attributes" "LDAP / protected domain connection" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

entraId.authentication -> apps.client "Returns authenticated identity tokens or assertions through the selected protocol flow" "HTTPS / OIDC reference client" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

entraId.authentication.endpoints -> apps.client "Returns signed identity response through the configured browser/client flow" "HTTPS / OIDC or SAML as configured" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

entraId.authentication -> keycloak.server "Returns authorization code through browser redirect" "HTTPS / OIDC redirect" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

entraId.authentication -> keycloak.server "Returns signed ID token and token endpoint response" "HTTPS / OAuth token response" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

entraId.authentication -> keycloak.server.broker "Returns authorization code through browser redirect" "HTTPS / OIDC redirect" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

entraId.authentication -> keycloak.server.broker "Returns signed ID token and token endpoint response" "HTTPS / OAuth token response" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

hsmWorkloadTokenResponse = entraId.authentication -> apps.client "Returns HSM-audience workload access token" "HTTPS / OAuth 2.0 token response" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

entraId.authentication -> apps.hsmSigner "Returns Managed HSM audience access token" "HTTPS / OAuth 2.0 token response" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
    }
}

entraId.authentication -> apps.hsmSigner.hsm "Returns Managed HSM audience access token" "HTTPS / OAuth 2.0 token response" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://ethereum.org/en/developers/docs/transactions/\"]"
    }
}

entraId -> apps "Returns identity tokens or assertions for application access" "HTTPS / configured identity protocol" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

entraId -> keycloak "Returns verified identity claims through the configured federation flow" "HTTPS / OIDC" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

entraId -> adDs "Queries selected directory objects through the Cloud Sync provisioning agent" "Protected LDAP / agent-established TLS service channel" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}
