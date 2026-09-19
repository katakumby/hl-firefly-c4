component firefly.fabconnect "75-fabconnect-events" "Component - FabConnect: events" {
    title "Component - FabConnect: events"
    include firefly.fabconnect.rest firefly.fabconnect.transactions firefly.fabconnect.client firefly.fabconnect.events firefly.fabconnect.websockets firefly.fabconnect.kafka firefly.fabconnect.kv firefly.core fabric kafkaBroker firefly.fabricState
    exclude *->*
    include firefly.fabconnect.rest->firefly.fabconnect.transactions
    include firefly.fabconnect.rest->firefly.fabconnect.kafka
    include firefly.fabconnect.kafka->firefly.fabconnect.transactions
    include firefly.fabconnect.transactions->firefly.fabconnect.client
    include firefly.fabconnect.events->firefly.fabconnect.client
    include firefly.fabconnect.events->firefly.fabconnect.websockets
    include firefly.fabconnect.events->firefly.fabconnect.kv
    include firefly.fabconnect.client->fabric
    include firefly.fabconnect.websockets->firefly.core
    include firefly.fabconnect.client->firefly.fabricState
    include firefly.fabconnect.kv->firefly.fabricState
    include firefly.fabconnect.kafka->kafkaBroker
    include firefly.core->firefly.fabconnect.rest
    autoLayout lr 360 200
}
