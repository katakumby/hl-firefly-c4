container firefly "70-option-ethconnect" "Container - Optional EthConnect (legacy option)" {
    title "Container - Optional EthConnect (legacy option)"
    include firefly.ethconnect firefly.core firefly.signer besu.node firefly.ethconnectState
    exclude *->*
    include besu.node->besu.node
    include firefly.signer->besu.node
    include firefly.core->firefly.ethconnect
    include firefly.ethconnect->firefly.signer
    include firefly.ethconnect->firefly.core
    include firefly.ethconnect->firefly.ethconnectState
    autoLayout lr 360 200
}
