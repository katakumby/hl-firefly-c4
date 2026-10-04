adFs.service -> adDs.directory "Validates domain authentication and resolves account attributes" "Kerberos / protected directory interfaces" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

adFs.service.authentication -> adDs.directory "Validates domain authentication and resolves account attributes" "Kerberos / protected directory interfaces" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

adFs.service -> apps.client "Returns authenticated identity tokens or assertions through the selected protocol flow" "HTTPS / SAML 2.0 reference client" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

adFs.service.endpoints -> apps.client "Returns signed identity response through the configured browser/client flow" "HTTPS / OIDC or SAML as configured" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

adFs.service -> keycloak.server "Returns signed SAML assertion through browser POST" "HTTPS / browser-mediated SAML 2.0" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

adFs.service -> keycloak.server.broker "Returns signed SAML assertion through browser POST" "HTTPS / browser-mediated SAML 2.0" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

adFs -> apps "Returns identity tokens or assertions for application access" "HTTPS / configured identity protocol" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

adFs -> keycloak "Returns verified identity claims through the configured federation flow" "HTTPS / SAML 2.0" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

adFs -> adDs "Requests domain authentication and account attributes" "Kerberos / protected directory access" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}
