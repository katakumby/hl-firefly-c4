component firefly.signer "40-firefly-signer" "Component - FireFly transaction signing" {
    title "Component - FireFly transaction signing"
    include element.parent==firefly.signer firefly.secrets besu.node
    autoLayout lr 360 200
}
