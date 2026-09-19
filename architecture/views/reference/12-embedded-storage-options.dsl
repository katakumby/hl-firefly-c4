container firefly "12-embedded-storage-options" "Container - Optional embedded Core and EVM persistence" {
    title "Container - Optional embedded Core and EVM persistence"
    include firefly.core firefly.sqlite firefly.evm firefly.leveldb
    autoLayout lr 360 200
}
