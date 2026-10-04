component firefly.core "20-firefly-core-persistence" "Component - FireFly Core: Persistence and operational support" {
    title "Component - FireFly Core: Persistence and operational support"
    include firefly.core.orchestrator firefly.core.data firefly.core.download firefly.core.sharedstorage firefly.core.contracts firefly.core.operations firefly.core.txwriter firefly.core.database firefly.core.cache firefly.core.metrics firefly.pg firefly.ipfs
    autoLayout lr 360 200
}
