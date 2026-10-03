keycloak.server.endpoints -> keycloak.server.authentication "Passes authorization request and authentication context" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.authentication -> keycloak.server.broker "Delegates selected external-provider login" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.authentication -> keycloak.server.ldap "Passes directory lookup and credential validation requests" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.ldap -> keycloak.server.authentication "Returns user attributes and credential validation outcome" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.broker -> keycloak.server.authentication "Returns verified external identity claims" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.authentication -> keycloak.server.sessions "Creates or resolves authenticated user session" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.sessions -> keycloak.server.tokens "Supplies session identity and client scope" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.tokens -> keycloak.server.endpoints "Returns signed tokens or SAML assertions" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.admin -> keycloak.server.persistence "Writes realm, client and federation settings" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.authentication -> keycloak.server.persistence "Reads local credentials and realm authentication settings" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server.sessions -> keycloak.server.persistence "Reads and writes persistent session records" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

keycloak.server -> keycloak.database "Reads and writes realm, user and session records" "PostgreSQL / TLS" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://www.keycloak.org/server/db\"]"
    }
}

keycloak.server.persistence -> keycloak.database "Reads and writes realm, user and session records" "PostgreSQL / TLS" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\",\"https://www.keycloak.org/server/db\"]"
    }
}
