container keycloak "100-security-keycloak-containers" "Container - Keycloak logical reference" {
    title "Container - Keycloak logical reference"
    include keycloak.server keycloak.database securityAdmin business apps.client adDs.directory entraId.authentication adFs.service
    autoLayout lr 360 200
}
