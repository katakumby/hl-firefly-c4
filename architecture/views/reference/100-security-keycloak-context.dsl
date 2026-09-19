systemContext keycloak "100-security-keycloak-context" "System Context - Keycloak reference" {
    title "System Context - Keycloak reference"
    include keycloak securityAdmin business apps adDs entraId adFs
    exclude *->*
    include business->apps
    include securityAdmin->keycloak
    include securityAdmin->entraId
    include securityAdmin->adDs
    include securityAdmin->adFs
    include apps->keycloak
    include keycloak->apps
    include business->keycloak
    include apps->entraId
    include entraId->apps
    include business->entraId
    include apps->adFs
    include adFs->apps
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
