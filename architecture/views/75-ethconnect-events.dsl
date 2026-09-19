component firefly.ethconnect "75-ethconnect-events" "Component - EthConnect (legacy option): events" {
    title "Component - EthConnect (legacy option): events"
    include firefly.ethconnect.rest firefly.ethconnect.transactions firefly.ethconnect.rpc firefly.ethconnect.events firefly.ethconnect.websockets firefly.ethconnect.kafka firefly.ethconnect.kv firefly.core firefly.signer kafkaBroker firefly.ethconnectState
    exclude *->*
    include firefly.ethconnect.rest->firefly.ethconnect.transactions
    include firefly.ethconnect.rest->firefly.ethconnect.kafka
    include firefly.ethconnect.kafka->firefly.ethconnect.transactions
    include firefly.ethconnect.transactions->firefly.ethconnect.rpc
    include firefly.ethconnect.events->firefly.ethconnect.rpc
    include firefly.ethconnect.events->firefly.ethconnect.websockets
    include firefly.ethconnect.events->firefly.ethconnect.kv
    include firefly.ethconnect.rpc->firefly.signer
    include firefly.ethconnect.websockets->firefly.core
    include firefly.ethconnect.kv->firefly.ethconnectState
    include firefly.ethconnect.kafka->kafkaBroker
    include firefly.core->firefly.ethconnect.rest
    autoLayout lr 360 200
}
