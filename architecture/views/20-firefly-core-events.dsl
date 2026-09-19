component firefly.core "20-firefly-core-events" "Component - FireFly Core: Inbound sequencing and event delivery" {
    title "Component - FireFly Core: Inbound sequencing and event delivery"
    include firefly.core.blockchain firefly.core.dataexchange firefly.core.tokens firefly.core.aggregator firefly.core.download firefly.core.subscriptions firefly.core.dispatcher firefly.core.eventplugin firefly.core.syncasync firefly.core.database apps.client
    exclude *->*
    include firefly.core.blockchain->firefly.core.aggregator
    include firefly.core.dataexchange->firefly.core.aggregator
    include firefly.core.tokens->firefly.core.aggregator
    include firefly.core.aggregator->firefly.core.download
    include firefly.core.aggregator->firefly.core.database
    include firefly.core.aggregator->firefly.core.subscriptions
    include firefly.core.subscriptions->firefly.core.database
    include firefly.core.subscriptions->firefly.core.dispatcher
    include firefly.core.dispatcher->firefly.core.eventplugin
    include firefly.core.dispatcher->firefly.core.syncasync
    include firefly.core.eventplugin->apps.client
    autoLayout lr 360 200
}
