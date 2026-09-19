systemContext adFs "100-security-adFs-context" "System Context - Microsoft Active Directory Federation Services reference" {
    title "System Context - Microsoft Active Directory Federation Services reference"
    include adFs securityAdmin business apps adDs keycloak
    exclude *->*
    include business->apps
    include securityAdmin->keycloak
    include securityAdmin->adDs
    include securityAdmin->adFs
    include apps->keycloak
    include keycloak->apps
    include business->keycloak
    include apps->adFs
    include adFs->apps
    include business->adFs
    include keycloak->adDs
    include adDs->keycloak
    include keycloak->adFs
    include adFs->keycloak
    include adFs->adDs
    include adDs->adFs
    include business->adDs
    include adDs->business
    autoLayout lr 360 200
}
