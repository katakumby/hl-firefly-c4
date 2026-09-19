component firefly.signer "40-firefly-signer" "Component - FireFly transaction signing" {
    title "Component - FireFly transaction signing"
    include firefly.signer.proxy firefly.signer.wallet firefly.signer.keystore firefly.signer.signing firefly.signer.backend firefly.secrets besu.node
    exclude *->*
    include firefly.signer.proxy->firefly.signer.wallet
    include firefly.signer.wallet->firefly.signer.keystore
    include firefly.signer.proxy->firefly.signer.signing
    include firefly.signer.signing->firefly.signer.wallet
    include firefly.signer.signing->firefly.signer.backend
    include firefly.signer.proxy->firefly.signer.backend
    include firefly.signer.wallet->firefly.secrets
    include besu.node->besu.node
    include firefly.signer.backend->besu.node
    autoLayout lr 360 200
}
