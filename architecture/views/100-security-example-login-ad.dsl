container keycloak "100-security-example-login-ad" "Container - Example: Keycloak login with AD LDAP" {
    title "Container - Example: Keycloak login with AD LDAP"
    include business apps.client keycloak.server adDs.directory
    exclude *->*
    include business->apps.client
    include keycloak.server->adDs.directory
    include adDs.directory->keycloak.server
    include business->keycloak.server
    include apps.client->keycloak.server
    include keycloak.server->apps.client
    include business->adDs.directory
    include adDs.directory->business
    autoLayout lr 360 200
}
