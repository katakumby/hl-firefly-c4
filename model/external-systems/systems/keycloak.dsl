group "Identity and federation" {
    keycloak = softwareSystem "Keycloak" "Identity and access management: SSO, federation, brokering and token issuance." {
        url "https://www.keycloak.org/docs/latest/server_admin/index.html"
        properties {
            "architecture.id" "keycloak"
            "evidence" "Documented product capability"
            "architecture.sources" "[\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
        }
        !include ../containers/keycloak
    }
}
