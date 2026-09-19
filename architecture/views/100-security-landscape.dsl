systemLandscape "100-security-landscape" "System Landscape - Security product reference catalog" {
    title "System Landscape - Security product reference catalog"
    include keycloak managedHsm cyberarkPam conjur entraId adDs adFs securityAdmin business operator apps managedTarget azureManagement
    exclude *->*
    include business->apps
    include securityAdmin->keycloak
    include securityAdmin->managedHsm
    include securityAdmin->cyberarkPam
    include securityAdmin->conjur
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
    include operator->cyberarkPam
    include cyberarkPam->managedTarget
    include managedTarget->cyberarkPam
    include cyberarkPam->operator
    include adDs->business
    include cyberarkPam->conjur
    include conjur->cyberarkPam
    include apps->conjur
    include conjur->apps
    include apps->managedHsm
    include managedHsm->apps
    include managedHsm->entraId
    include securityAdmin->azureManagement
    include azureManagement->managedHsm
    autoLayout lr 360 200
}
