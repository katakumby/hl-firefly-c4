container managedHsm "100-security-managedHsm-containers" "Container - Azure Managed HSM logical reference" {
    title "Container - Azure Managed HSM logical reference"
    include managedHsm.service managedHsm.keys securityAdmin apps.client entraId.authentication azureManagement
    exclude *->*
    include managedHsm.service->managedHsm.keys
    include managedHsm.keys->managedHsm.service
    include apps.client->entraId.authentication
    include entraId.authentication->apps.client
    include apps.client->managedHsm.service
    include managedHsm.service->apps.client
    include managedHsm.service->entraId.authentication
    include securityAdmin->azureManagement
    include azureManagement->managedHsm.service
    include securityAdmin->managedHsm.service
    autoLayout lr 360 200
}
