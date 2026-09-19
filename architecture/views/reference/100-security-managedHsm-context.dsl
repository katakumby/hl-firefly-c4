systemContext managedHsm "100-security-managedHsm-context" "System Context - Azure Managed HSM reference" {
    title "System Context - Azure Managed HSM reference"
    include managedHsm securityAdmin apps entraId azureManagement
    exclude *->*
    include securityAdmin->managedHsm
    include securityAdmin->entraId
    include apps->entraId
    include entraId->apps
    include apps->managedHsm
    include managedHsm->apps
    include managedHsm->entraId
    include securityAdmin->azureManagement
    include azureManagement->managedHsm
    autoLayout lr 360 200
}
