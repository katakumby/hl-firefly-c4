container firefly "12-embedded-storage-options" "Container - Optional embedded Core and EVM persistence" {
    title "Container - Optional embedded Core and EVM persistence"
    include firefly.core firefly.sqlite firefly.evm firefly.leveldb
    exclude *->*
    include firefly.core->firefly.evm
    include firefly.evm->firefly.core
    include firefly.core->firefly.sqlite
    include firefly.evm->firefly.leveldb
    autoLayout lr 360 200
}
