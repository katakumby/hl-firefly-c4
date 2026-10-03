container keycloak "100-security-example-broker-entra" "Container - Example: Browser-mediated Keycloak and Entra OIDC" {
    title "Container - Example: Browser-mediated Keycloak and Entra OIDC"
    include business apps.client keycloak.server entraId.authentication
    exclude *->*
    include business->apps.client
    include business->keycloak.server
    include apps.client->keycloak.server
    include keycloak.server->apps.client
    include business->entraId.authentication
    include keycloak.server->entraId.authentication
    include entraId.authentication->keycloak.server
    autoLayout lr 360 200
}
