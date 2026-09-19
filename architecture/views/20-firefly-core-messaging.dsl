component firefly.core "20-firefly-core-messaging" "Component - FireFly Core: Payloads and outbound messaging" {
    title "Component - FireFly Core: Payloads and outbound messaging"
    include firefly.core.orchestrator firefly.core.data firefly.core.schema firefly.core.batch firefly.core.batchprocessor firefly.core.broadcast firefly.core.private firefly.core.dataexchange firefly.core.sharedstorage firefly.core.multiparty firefly.dx firefly.ipfs firefly.core.identity
    exclude *->*
    include firefly.core.orchestrator->firefly.core.identity
    include firefly.core.orchestrator->firefly.core.multiparty
    include firefly.core.orchestrator->firefly.core.data
    include firefly.core.data->firefly.core.schema
    include firefly.core.orchestrator->firefly.core.batch
    include firefly.core.batch->firefly.core.batchprocessor
    include firefly.core.batchprocessor->firefly.core.data
    include firefly.core.batchprocessor->firefly.core.broadcast
    include firefly.core.batchprocessor->firefly.core.private
    include firefly.core.broadcast->firefly.core.sharedstorage
    include firefly.core.broadcast->firefly.core.multiparty
    include firefly.core.private->firefly.core.dataexchange
    include firefly.core.private->firefly.core.multiparty
    include firefly.core.private->firefly.core.identity
    include firefly.core.dataexchange->firefly.dx
    include firefly.core.sharedstorage->firefly.ipfs
    include firefly.dx->firefly.dx
    include firefly.ipfs->firefly.ipfs
    autoLayout lr 360 200
}
