!element keycloak {
    server = container "Keycloak server" "Hosts login, administration, federation and protocol services; cache is embedded." "Java / Keycloak" {
        url "https://www.keycloak.org/docs/latest/server_admin/index.html"
        properties {
            "architecture.id" "keycloak.server"
            "evidence" "Documented product capability"
            "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
        }
        endpoints = component "OIDC and SAML endpoints" "Accepts authorization, token and federation requests and returns protocol responses." "Java / Keycloak" {
            url "https://www.keycloak.org/docs/latest/server_admin/index.html"
            properties {
                "architecture.id" "keycloak.server.endpoints"
                "evidence" "Documented product capability"
                "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
            }
        }
        authentication = component "Authentication flows" "Evaluates configured authenticators and required authentication steps." "Java / Keycloak" {
            url "https://www.keycloak.org/docs/latest/server_admin/index.html"
            properties {
                "architecture.id" "keycloak.server.authentication"
                "evidence" "Documented product capability"
                "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
            }
        }
        broker = component "Identity broker" "Delegates login to an external OIDC or SAML identity provider through the browser." "Java / Keycloak" {
            url "https://www.keycloak.org/docs/latest/server_admin/index.html"
            properties {
                "architecture.id" "keycloak.server.broker"
                "evidence" "Documented product capability"
                "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
            }
        }
        ldap = component "LDAP user federation" "Queries AD user attributes and validates credentials by LDAP bind; never imports AD passwords." "Java / Keycloak" {
            url "https://www.keycloak.org/docs/latest/server_admin/index.html"
            properties {
                "architecture.id" "keycloak.server.ldap"
                "evidence" "Documented product capability"
                "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
            }
        }
        tokens = component "Token and claim mapping" "Builds and signs tokens or assertions with mapped roles and attributes." "Java / Keycloak" {
            url "https://www.keycloak.org/docs/latest/server_admin/index.html"
            properties {
                "architecture.id" "keycloak.server.tokens"
                "evidence" "Documented product capability"
                "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
            }
        }
        admin = component "Administration" "Manages realms, clients, users, roles and identity-provider configuration." "Java / Keycloak" {
            url "https://www.keycloak.org/docs/latest/server_admin/index.html"
            properties {
                "architecture.id" "keycloak.server.admin"
                "evidence" "Documented product capability"
                "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
            }
        }
        sessions = component "Session and embedded cache management" "Tracks login sessions and cached realm or user data in the server runtime." "Java / Keycloak" {
            url "https://www.keycloak.org/docs/latest/server_admin/index.html"
            properties {
                "architecture.id" "keycloak.server.sessions"
                "evidence" "Documented product capability"
                "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
            }
        }
        persistence = component "Persistence adapter" "Reads and writes realm, user and persistent session records." "Java / Keycloak" {
            url "https://www.keycloak.org/docs/latest/server_admin/index.html"
            properties {
                "architecture.id" "keycloak.server.persistence"
                "evidence" "Documented product capability"
                "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
            }
        }
    }
}
