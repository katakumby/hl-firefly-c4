component managedHsm.service "100-security-managedHsm-service-components" "Component - Managed HSM data-plane service: logical responsibilities" {
    title "Component - Managed HSM data-plane service: logical responsibilities"
    include element.parent==managedHsm.service apps.client securityAdmin managedHsm.keys entraId.authentication
    autoLayout lr 360 200
}
