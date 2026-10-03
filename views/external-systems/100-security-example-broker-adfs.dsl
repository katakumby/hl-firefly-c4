container keycloak "100-security-example-broker-adfs" "Container - Example: Browser-mediated Keycloak and AD FS SAML" {
    title "Container - Example: Browser-mediated Keycloak and AD FS SAML"
    include business apps.client keycloak.server adFs.service adDs.directory
    exclude *->*
    include business->apps.client
    include adFs.service->adDs.directory
    include adDs.directory->adFs.service
    include business->keycloak.server
    include apps.client->keycloak.server
    include keycloak.server->apps.client
    include business->adFs.service
    include keycloak.server->adFs.service
    include adFs.service->keycloak.server
    include business->adDs.directory
    include adDs.directory->business
    autoLayout lr 360 200
}
