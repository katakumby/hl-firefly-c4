container firefly "72-option-tezosconnect" "Container - Optional TezosConnect + FFTM" {
    title "Container - Optional TezosConnect + FFTM"
    include firefly.tezosconnect firefly.core tezos signatory firefly.tezosState
    autoLayout lr 360 200
}
