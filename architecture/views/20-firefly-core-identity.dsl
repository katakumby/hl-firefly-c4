component firefly.core "20-firefly-core-identity" "Component - FireFly Core: Identity and multiparty coordination" {
    title "Component - FireFly Core: Identity and multiparty coordination"
    include firefly.core.orchestrator firefly.core.identity firefly.core.identityplugin firefly.core.networkmap firefly.core.definitions firefly.core.broadcast firefly.core.multiparty firefly.core.blockchain
    exclude *->*
    include firefly.core.orchestrator->firefly.core.identity
    include firefly.core.identity->firefly.core.identityplugin
    include firefly.core.identity->firefly.core.networkmap
    include firefly.core.networkmap->firefly.core.definitions
    include firefly.core.definitions->firefly.core.broadcast
    include firefly.core.orchestrator->firefly.core.multiparty
    include firefly.core.multiparty->firefly.core.blockchain
    include firefly.core.broadcast->firefly.core.multiparty
    autoLayout lr 360 200
}
