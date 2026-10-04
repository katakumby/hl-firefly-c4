container adDs "100-security-adDs-containers" "Container - Microsoft Active Directory Domain Services logical reference" {
    title "Container - Microsoft Active Directory Domain Services logical reference"
    include element.parent==adDs securityAdmin business keycloak.server adFs.service entraId.agent
    autoLayout lr 360 200
}
