container keycloak "100-security-keycloak-containers" "Container - Keycloak logical reference" {
    title "Container - Keycloak logical reference"
    include keycloak.server keycloak.database securityAdmin business apps.client adDs.directory entraId.authentication adFs.service
    exclude *->*
    include business->apps.client
    include keycloak.server->keycloak.database
    include keycloak.server->adDs.directory
    include adDs.directory->keycloak.server
    include adFs.service->adDs.directory
    include adDs.directory->adFs.service
    include business->keycloak.server
    include apps.client->keycloak.server
    include keycloak.server->apps.client
    include business->entraId.authentication
    include apps.client->entraId.authentication
    include entraId.authentication->apps.client
    include business->adFs.service
    include apps.client->adFs.service
    include adFs.service->apps.client
    include keycloak.server->entraId.authentication
    include entraId.authentication->keycloak.server
    include keycloak.server->adFs.service
    include adFs.service->keycloak.server
    include business->adDs.directory
    include adDs.directory->business
    include securityAdmin->keycloak.server
    include securityAdmin->adDs.directory
    include securityAdmin->adFs.service
    autoLayout lr 360 200
}
