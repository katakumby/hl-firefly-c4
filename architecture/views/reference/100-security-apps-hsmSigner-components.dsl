component apps.hsmSigner "100-security-apps-hsmSigner-components" "Component - Proposed HSM signing adapter: proposed integration" {
    title "Component - Proposed HSM signing adapter: proposed integration"
    include element.parent==apps.hsmSigner firefly.evm managedHsm.service entraId.authentication besu.node
    exclude *->*
    include managedHsm.service->entraId.authentication
    include apps.hsmSigner.transactions->apps.hsmSigner.hsm
    include apps.hsmSigner.hsm->apps.hsmSigner.signature
    include apps.hsmSigner.signature->apps.hsmSigner.rpc
    include apps.hsmSigner.rpc->apps.hsmSigner.transactions
    include firefly.evm->apps.hsmSigner.transactions
    include apps.hsmSigner.hsm->entraId.authentication
    include entraId.authentication->apps.hsmSigner.hsm
    include apps.hsmSigner.hsm->managedHsm.service
    include managedHsm.service->apps.hsmSigner.hsm
    include apps.hsmSigner.rpc->besu.node
    include besu.node->apps.hsmSigner.rpc
    autoLayout lr 360 200
}
