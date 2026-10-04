container managedHsm "100-security-example-key-protection" "Container - Example: Entra-authenticated HSM signing and key wrapping" {
    title "Container - Example: Entra-authenticated HSM signing and key wrapping"
    include apps.client entraId.authentication managedHsm.service managedHsm.keys
    exclude *->*
    include managedHsm.service->managedHsm.keys
    include managedHsm.keys->managedHsm.service
    include hsmWorkloadTokenRequest
    include hsmWorkloadTokenResponse
    include apps.client->managedHsm.service
    include managedHsm.service->apps.client
    include managedHsm.service->entraId.authentication
    autoLayout lr 360 200
}
