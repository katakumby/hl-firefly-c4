component adFs.service "100-security-adFs-service-components" "Component - AD FS federation service: logical responsibilities" {
    title "Component - AD FS federation service: logical responsibilities"
    include adFs.service.endpoints adFs.service.authentication adFs.service.claims adFs.service.tokens adFs.service.configuration adFs.service.audit apps.client securityAdmin adDs.directory adFs.configuration
    exclude *->*
    include adFs.service.endpoints->adFs.service.authentication
    include adFs.service.authentication->adFs.service.claims
    include adFs.service.claims->adFs.service.tokens
    include adFs.service.tokens->adFs.service.endpoints
    include adFs.service.claims->adFs.service.configuration
    include adFs.service.tokens->adFs.service.configuration
    include adFs.service.endpoints->adFs.service.audit
    include adFs.service.configuration->adFs.configuration
    include adFs.service.authentication->adDs.directory
    include adDs.directory->adFs.service.authentication
    include apps.client->adFs.service.endpoints
    include adFs.service.endpoints->apps.client
    include securityAdmin->adDs.directory
    include securityAdmin->adFs.service.configuration
    autoLayout lr 360 200
}
