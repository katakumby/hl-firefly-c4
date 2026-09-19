container adDs "100-security-adDs-containers" "Container - Microsoft Active Directory Domain Services logical reference" {
    title "Container - Microsoft Active Directory Domain Services logical reference"
    include adDs.directory adDs.database adDs.sysvol securityAdmin business keycloak.server adFs.service entraId.agent
    exclude *->*
    include adDs.directory->adDs.database
    include adDs.directory->adDs.sysvol
    include entraId.agent->adDs.directory
    include adDs.directory->entraId.agent
    include keycloak.server->adDs.directory
    include adDs.directory->keycloak.server
    include adFs.service->adDs.directory
    include adDs.directory->adFs.service
    include business->keycloak.server
    include business->adFs.service
    include keycloak.server->adFs.service
    include adFs.service->keycloak.server
    include business->adDs.directory
    include adDs.directory->business
    include securityAdmin->keycloak.server
    include securityAdmin->adDs.directory
    include securityAdmin->adFs.service
    autoLayout lr 360 200
}
