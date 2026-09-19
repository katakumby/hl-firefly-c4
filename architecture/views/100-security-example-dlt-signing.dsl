container apps "100-security-example-dlt-signing" "Container - Example: Proposed HSM-backed Ethereum transaction signing" {
    title "Container - Example: Proposed HSM-backed Ethereum transaction signing"
    include firefly.evm apps.hsmSigner entraId.authentication managedHsm.service besu.node
    exclude *->*
    include managedHsm.service->entraId.authentication
    include firefly.evm->apps.hsmSigner
    include apps.hsmSigner->firefly.evm
    include apps.hsmSigner->entraId.authentication
    include entraId.authentication->apps.hsmSigner
    include apps.hsmSigner->managedHsm.service
    include managedHsm.service->apps.hsmSigner
    include apps.hsmSigner->besu.node
    include besu.node->apps.hsmSigner
    autoLayout lr 360 200
}
