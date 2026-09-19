component keycloak.server "100-security-keycloak-server-components" "Component - Keycloak server: logical responsibilities" {
    title "Component - Keycloak server: logical responsibilities"
    include element.parent==keycloak.server apps.client securityAdmin keycloak.database adDs.directory entraId.authentication adFs.service
    autoLayout lr 360 200
}
