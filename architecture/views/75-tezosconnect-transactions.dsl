component firefly.tezosconnect "75-tezosconnect-transactions" "Component - TezosConnect + FFTM: transactions" {
    title "Component - TezosConnect + FFTM: transactions"
    include firefly.tezosconnect.api firefly.tezosconnect.policy firefly.tezosconnect.adapter firefly.tezosconnect.signing firefly.tezosconnect.persistence firefly.core tezos signatory firefly.tezosState
    exclude *->*
    include firefly.tezosconnect.api->firefly.tezosconnect.policy
    include firefly.tezosconnect.policy->firefly.tezosconnect.adapter
    include firefly.tezosconnect.adapter->firefly.tezosconnect.signing
    include firefly.tezosconnect.api->firefly.tezosconnect.persistence
    include firefly.tezosconnect.adapter->tezos
    include firefly.tezosconnect.signing->signatory
    include firefly.tezosconnect.persistence->firefly.tezosState
    include firefly.core->firefly.tezosconnect.api
    autoLayout lr 360 200
}
