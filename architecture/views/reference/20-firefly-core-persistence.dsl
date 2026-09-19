component firefly.core "20-firefly-core-persistence" "Component - FireFly Core: Persistence and operational support" {
    title "Component - FireFly Core: Persistence and operational support"
    include firefly.core.orchestrator firefly.core.data firefly.core.download firefly.core.sharedstorage firefly.core.contracts firefly.core.operations firefly.core.txwriter firefly.core.database firefly.core.cache firefly.core.metrics firefly.pg firefly.ipfs
    exclude *->*
    include firefly.core.orchestrator->firefly.core.data
    include firefly.core.data->firefly.core.database
    include firefly.core.orchestrator->firefly.core.contracts
    include firefly.core.contracts->firefly.core.operations
    include firefly.core.txwriter->firefly.core.database
    include firefly.core.operations->firefly.core.database
    include firefly.core.download->firefly.core.sharedstorage
    include firefly.core.download->firefly.core.data
    include firefly.core.data->firefly.core.cache
    include firefly.core.contracts->firefly.core.cache
    include firefly.core.orchestrator->firefly.core.metrics
    include firefly.core.operations->firefly.core.metrics
    include firefly.core.database->firefly.pg
    include firefly.core.sharedstorage->firefly.ipfs
    include firefly.ipfs->firefly.ipfs
    autoLayout lr 360 200
}
