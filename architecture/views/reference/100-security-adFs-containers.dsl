container adFs "100-security-adFs-containers" "Container - Microsoft Active Directory Federation Services logical reference" {
    title "Container - Microsoft Active Directory Federation Services logical reference"
    include adFs.service adFs.configuration securityAdmin business apps.client adDs.directory keycloak.server
    autoLayout lr 360 200
}
