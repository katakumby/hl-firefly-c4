adDs.directory -> entraId.agent "Returns scoped directory object attributes and change information" "LDAP / protected domain connection" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

adDs.directory -> entraId.agent.directory "Returns scoped directory object attributes and change information" "LDAP / protected domain connection" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

adDs.directory -> keycloak.server "Returns user attributes and bind result; does not export passwords" "LDAPS" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

adDs.directory -> keycloak.server.ldap "Returns user attributes and bind result; does not export passwords" "LDAPS" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

adDs.directory -> adFs.service "Returns domain authentication result and requested attributes" "Kerberos / protected directory interfaces" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

adDs.directory -> adFs.service.authentication "Returns domain authentication result and requested attributes" "Kerberos / protected directory interfaces" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\"]"
    }
}

adDs.directory -> business "Returns Kerberos ticket response to the domain client" "Kerberos / domain client" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

adDs.directory.kdc -> business "Returns Kerberos ticket response to the domain client" "Kerberos / domain client" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

adDs -> keycloak "Returns user attributes and credential validation outcome" "LDAPS" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

adDs -> adFs "Returns domain authentication result and account attributes" "Kerberos / protected directory access" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

adDs -> entraId "Returns selected identity attributes for Cloud Sync provisioning" "Protected LDAP / agent-established TLS service channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

adDs -> business "Returns Kerberos ticket response to the domain client" "Kerberos" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}
