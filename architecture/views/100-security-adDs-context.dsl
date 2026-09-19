systemContext adDs "100-security-adDs-context" "System Context - Microsoft Active Directory Domain Services reference" {
    title "System Context - Microsoft Active Directory Domain Services reference"
    include adDs securityAdmin business keycloak entraId adFs
    exclude *->*
    include securityAdmin->keycloak
    include securityAdmin->entraId
    include securityAdmin->adDs
    include securityAdmin->adFs
    include business->keycloak
    include business->entraId
    include business->adFs
    include keycloak->adDs
    include adDs->keycloak
    include keycloak->entraId
    include entraId->keycloak
    include keycloak->adFs
    include adFs->keycloak
    include adFs->adDs
    include adDs->adFs
    include entraId->adDs
    include adDs->entraId
    include business->adDs
    include adDs->business
    autoLayout lr 360 200
}
