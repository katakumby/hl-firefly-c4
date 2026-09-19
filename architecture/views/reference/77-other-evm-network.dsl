container firefly "77-other-evm-network" "Container - Optional external EVM network" {
    title "Container - Optional external EVM network"
    include firefly.core firefly.evm evmNetworks
    exclude *->*
    include firefly.core->firefly.evm
    include firefly.evm->firefly.core
    include firefly.evm->evmNetworks
    autoLayout lr 360 200
}
