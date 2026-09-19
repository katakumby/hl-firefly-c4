container firefly "70-option-ethconnect" "Container - Optional EthConnect (legacy option)" {
    title "Container - Optional EthConnect (legacy option)"
    include firefly.ethconnect firefly.core firefly.signer besu.node firefly.ethconnectState
    autoLayout lr 360 200
}
