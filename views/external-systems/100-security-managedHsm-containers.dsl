container managedHsm "100-security-managedHsm-containers" "Container - Azure Managed HSM logical reference" {
    title "Container - Azure Managed HSM logical reference"
    include managedHsm.service managedHsm.keys securityAdmin apps.client entraId.authentication azureManagement
    autoLayout lr 360 200
}
