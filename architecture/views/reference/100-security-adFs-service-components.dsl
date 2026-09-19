component adFs.service "100-security-adFs-service-components" "Component - AD FS federation service: logical responsibilities" {
    title "Component - AD FS federation service: logical responsibilities"
    include element.parent==adFs.service apps.client securityAdmin adDs.directory adFs.configuration
    autoLayout lr 360 200
}
