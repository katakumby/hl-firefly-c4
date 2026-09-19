component firefly.fabconnect "75-fabconnect-events" "Component - FabConnect: events" {
    title "Component - FabConnect: events"
    include firefly.fabconnect.rest firefly.fabconnect.transactions firefly.fabconnect.client firefly.fabconnect.events firefly.fabconnect.websockets firefly.fabconnect.kafka firefly.fabconnect.kv firefly.core fabric kafkaBroker firefly.fabricState
    autoLayout lr 360 200
}
