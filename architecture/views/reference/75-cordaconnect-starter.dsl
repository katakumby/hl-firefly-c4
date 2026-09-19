component firefly.cordaconnect "75-cordaconnect-starter" "Component - Corda connector starter: starter" {
    title "Component - Corda connector starter: starter"
    include firefly.cordaconnect.api firefly.cordaconnect.flows firefly.cordaconnect.events firefly.cordaconnect.websockets firefly.cordaconnect.persistence developer corda firefly.cordaState
    exclude *->*
    include developer->corda
    include firefly.cordaconnect.api->firefly.cordaconnect.flows
    include firefly.cordaconnect.api->firefly.cordaconnect.events
    include firefly.cordaconnect.flows->firefly.cordaconnect.events
    include firefly.cordaconnect.events->firefly.cordaconnect.websockets
    include firefly.cordaconnect.events->firefly.cordaconnect.persistence
    include firefly.cordaconnect.flows->corda
    include firefly.cordaconnect.persistence->firefly.cordaState
    include firefly.cordaconnect.websockets->developer
    include developer->firefly.cordaconnect.api
    autoLayout lr 360 200
}
