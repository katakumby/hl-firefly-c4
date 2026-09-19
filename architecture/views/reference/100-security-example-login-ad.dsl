container keycloak "100-security-example-login-ad" "Container - Example: Keycloak login with AD LDAP" {
    title "Container - Example: Keycloak login with AD LDAP"
    include business apps.client keycloak.server adDs.directory
    autoLayout lr 360 200
}
