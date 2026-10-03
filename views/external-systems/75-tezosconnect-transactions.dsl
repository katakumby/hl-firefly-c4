component firefly.tezosconnect "75-tezosconnect-transactions" "Component - TezosConnect + FFTM: transactions" {
    title "Component - TezosConnect + FFTM: transactions"
    include firefly.tezosconnect.api firefly.tezosconnect.policy firefly.tezosconnect.adapter firefly.tezosconnect.signing firefly.tezosconnect.persistence firefly.core tezos signatory firefly.tezosState
    autoLayout lr 360 200
}
