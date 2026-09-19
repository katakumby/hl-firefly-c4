component firefly.core "20-firefly-core-events" "Component - FireFly Core: Inbound sequencing and event delivery" {
    title "Component - FireFly Core: Inbound sequencing and event delivery"
    include firefly.core.blockchain firefly.core.dataexchange firefly.core.tokens firefly.core.aggregator firefly.core.download firefly.core.subscriptions firefly.core.dispatcher firefly.core.eventplugin firefly.core.syncasync firefly.core.database apps.client
    autoLayout lr 360 200
}
