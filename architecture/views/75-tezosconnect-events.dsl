component firefly.tezosconnect "75-tezosconnect-events" "Component - TezosConnect + FFTM: events" {
    title "Component - TezosConnect + FFTM: events"
    include firefly.tezosconnect.api firefly.tezosconnect.blocks firefly.tezosconnect.events firefly.tezosconnect.streams firefly.tezosconnect.persistence tezos firefly.core firefly.tezosState
    exclude *->*
    include firefly.tezosconnect.blocks->firefly.tezosconnect.events
    include firefly.tezosconnect.events->firefly.tezosconnect.streams
    include firefly.tezosconnect.api->firefly.tezosconnect.streams
    include firefly.tezosconnect.api->firefly.tezosconnect.persistence
    include firefly.tezosconnect.streams->firefly.tezosconnect.persistence
    include firefly.tezosconnect.blocks->tezos
    include firefly.tezosconnect.persistence->firefly.tezosState
    include firefly.tezosconnect.streams->firefly.core
    include firefly.core->firefly.tezosconnect.api
    autoLayout lr 360 200
}
