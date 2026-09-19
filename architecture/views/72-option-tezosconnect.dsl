container firefly "72-option-tezosconnect" "Container - Optional TezosConnect + FFTM" {
    title "Container - Optional TezosConnect + FFTM"
    include firefly.tezosconnect firefly.core tezos signatory firefly.tezosState
    exclude *->*
    include firefly.core->firefly.tezosconnect
    include firefly.tezosconnect->tezos
    include firefly.tezosconnect->signatory
    include firefly.tezosconnect->firefly.tezosState
    include firefly.tezosconnect->firefly.core
    autoLayout lr 360 200
}
