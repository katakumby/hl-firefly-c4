keycloak = softwareSystem "Keycloak" "Identity and access management: SSO, federation, brokering and token issuance." {
    tags "SecurityCatalog"
    url "https://www.keycloak.org/docs/latest/server_admin/index.html"
    properties {
        "architecture.id" "keycloak"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
    !include server.dsl
    !include database.dsl
}
