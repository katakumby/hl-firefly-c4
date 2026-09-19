systemContext managedHsm "100-security-managedHsm-context" "System Context - Azure Managed HSM reference" {
    title "System Context - Azure Managed HSM reference"
    include managedHsm securityAdmin apps entraId azureManagement
    autoLayout lr 360 200
}
