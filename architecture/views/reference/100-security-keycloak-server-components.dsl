component keycloak.server "100-security-keycloak-server-components" "Component - Keycloak server: logical responsibilities" {
    title "Component - Keycloak server: logical responsibilities"
    include keycloak.server.endpoints keycloak.server.authentication keycloak.server.broker keycloak.server.ldap keycloak.server.tokens keycloak.server.admin keycloak.server.sessions keycloak.server.persistence apps.client securityAdmin keycloak.database adDs.directory entraId.authentication adFs.service
    exclude *->*
    include keycloak.server.endpoints->keycloak.server.authentication
    include keycloak.server.authentication->keycloak.server.broker
    include keycloak.server.authentication->keycloak.server.ldap
    include keycloak.server.ldap->keycloak.server.authentication
    include keycloak.server.broker->keycloak.server.authentication
    include keycloak.server.authentication->keycloak.server.sessions
    include keycloak.server.sessions->keycloak.server.tokens
    include keycloak.server.tokens->keycloak.server.endpoints
    include keycloak.server.admin->keycloak.server.persistence
    include keycloak.server.authentication->keycloak.server.persistence
    include keycloak.server.sessions->keycloak.server.persistence
    include keycloak.server.persistence->keycloak.database
    include keycloak.server.ldap->adDs.directory
    include adDs.directory->keycloak.server.ldap
    include adFs.service->adDs.directory
    include adDs.directory->adFs.service
    include apps.client->entraId.authentication
    include entraId.authentication->apps.client
    include apps.client->adFs.service
    include adFs.service->apps.client
    include apps.client->keycloak.server.endpoints
    include keycloak.server.endpoints->apps.client
    include keycloak.server.broker->entraId.authentication
    include entraId.authentication->keycloak.server.broker
    include keycloak.server.broker->adFs.service
    include adFs.service->keycloak.server.broker
    include securityAdmin->keycloak.server.admin
    include securityAdmin->adDs.directory
    include securityAdmin->adFs.service
    autoLayout lr 360 200
}
