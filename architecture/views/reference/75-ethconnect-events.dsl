component firefly.ethconnect "75-ethconnect-events" "Component - EthConnect (legacy option): events" {
    title "Component - EthConnect (legacy option): events"
    include firefly.ethconnect.rest firefly.ethconnect.transactions firefly.ethconnect.rpc firefly.ethconnect.events firefly.ethconnect.websockets firefly.ethconnect.kafka firefly.ethconnect.kv firefly.core firefly.signer kafkaBroker firefly.ethconnectState
    autoLayout lr 360 200
}
