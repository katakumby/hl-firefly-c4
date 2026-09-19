component managedHsm.service "100-security-managedHsm-service-components" "Component - Managed HSM data-plane service: logical responsibilities" {
    title "Component - Managed HSM data-plane service: logical responsibilities"
    include managedHsm.service.api managedHsm.service.authentication managedHsm.service.authorization managedHsm.service.lifecycle managedHsm.service.crypto managedHsm.service.audit apps.client securityAdmin managedHsm.keys entraId.authentication
    exclude *->*
    include managedHsm.service.api->managedHsm.service.authentication
    include managedHsm.service.authentication->managedHsm.service.authorization
    include managedHsm.service.authorization->managedHsm.service.lifecycle
    include managedHsm.service.authorization->managedHsm.service.crypto
    include managedHsm.service.crypto->managedHsm.service.api
    include managedHsm.service.lifecycle->managedHsm.service.api
    include managedHsm.service.api->managedHsm.service.audit
    include managedHsm.service.lifecycle->managedHsm.keys
    include managedHsm.service.crypto->managedHsm.keys
    include managedHsm.keys->managedHsm.service.crypto
    include apps.client->entraId.authentication
    include entraId.authentication->apps.client
    include apps.client->managedHsm.service.api
    include managedHsm.service.api->apps.client
    include managedHsm.service.authentication->entraId.authentication
    include securityAdmin->managedHsm.service.lifecycle
    autoLayout lr 360 200
}
