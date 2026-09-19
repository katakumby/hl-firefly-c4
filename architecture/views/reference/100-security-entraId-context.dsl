systemContext entraId "100-security-entraId-context" "System Context - Microsoft Entra ID reference" {
    title "System Context - Microsoft Entra ID reference"
    include entraId securityAdmin apps business adDs keycloak managedHsm
    exclude *->*
    include business->apps
    include securityAdmin->keycloak
    include securityAdmin->managedHsm
    include securityAdmin->entraId
    include securityAdmin->adDs
    include apps->keycloak
    include keycloak->apps
    include business->keycloak
    include apps->entraId
    include entraId->apps
    include business->entraId
    include keycloak->adDs
    include adDs->keycloak
    include keycloak->entraId
    include entraId->keycloak
    include entraId->adDs
    include adDs->entraId
    include business->adDs
    include adDs->business
    include apps->managedHsm
    include managedHsm->apps
    include managedHsm->entraId
    autoLayout lr 360 200
}
