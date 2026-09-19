container adFs "100-security-adFs-containers" "Container - Microsoft Active Directory Federation Services logical reference" {
    title "Container - Microsoft Active Directory Federation Services logical reference"
    include adFs.service adFs.configuration securityAdmin business apps.client adDs.directory keycloak.server
    exclude *->*
    include business->apps.client
    include keycloak.server->adDs.directory
    include adDs.directory->keycloak.server
    include adFs.service->adFs.configuration
    include adFs.service->adDs.directory
    include adDs.directory->adFs.service
    include business->keycloak.server
    include apps.client->keycloak.server
    include keycloak.server->apps.client
    include business->adFs.service
    include apps.client->adFs.service
    include adFs.service->apps.client
    include keycloak.server->adFs.service
    include adFs.service->keycloak.server
    include business->adDs.directory
    include adDs.directory->business
    include securityAdmin->keycloak.server
    include securityAdmin->adDs.directory
    include securityAdmin->adFs.service
    autoLayout lr 360 200
}
