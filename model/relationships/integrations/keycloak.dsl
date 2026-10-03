keycloak.server -> adDs.directory "Queries user attributes and validates supplied credentials by LDAP bind" "LDAPS" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

keycloak.server.ldap -> adDs.directory "Queries user attributes and validates supplied credentials by LDAP bind" "LDAPS" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

keycloak.server -> apps.client "Returns authenticated identity tokens or assertions through the selected protocol flow" "HTTPS / OIDC reference client" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

keycloak.server.endpoints -> apps.client "Returns signed identity response through the configured browser/client flow" "HTTPS / OIDC or SAML as configured" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

keycloak.server -> entraId.authentication "Redirects browser with OIDC authorization request" "HTTPS / browser-mediated OIDC" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

keycloak.server -> entraId.authentication "Exchanges authorization code with client authentication for tokens" "HTTPS / OAuth token endpoint" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

keycloak.server -> adFs.service "Redirects browser with SAML authentication request" "HTTPS / browser-mediated SAML 2.0" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

keycloak.server.broker -> entraId.authentication "Redirects browser with OIDC authorization request" "HTTPS / browser-mediated OIDC" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

keycloak.server.broker -> entraId.authentication "Exchanges authorization code with client authentication for tokens" "HTTPS / OAuth token endpoint" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

keycloak.server.broker -> adFs.service "Redirects browser with SAML authentication request" "HTTPS / browser-mediated SAML 2.0" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

keycloak -> apps "Returns identity tokens or assertions for application access" "HTTPS / configured identity protocol" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

keycloak -> adDs "Requests LDAP user attributes and credential validation" "LDAPS" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

keycloak -> entraId "Delegates login through browser-mediated OIDC federation" "HTTPS / OIDC" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

keycloak -> adFs "Delegates login through browser-mediated SAML 2.0 federation" "HTTPS / SAML 2.0" "Dataflow,SecurityCatalog,IdentityFlow,ReferenceIntegration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}
