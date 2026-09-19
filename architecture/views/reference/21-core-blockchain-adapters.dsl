component firefly.core "21-core-blockchain-adapters" "Component - Core blockchain adapters" {
    title "Component - Core blockchain adapters"
    include firefly.core.blockchain firefly.core.ethereum firefly.core.fabricAdapter firefly.core.tezosAdapter firefly.core.cardanoAdapter firefly.evm firefly.ethconnect firefly.fabconnect firefly.tezosconnect firefly.cardanoconnect
    exclude *->*
    include firefly.core.blockchain->firefly.evm
    include firefly.core.blockchain->firefly.core.ethereum
    include firefly.core.blockchain->firefly.core.fabricAdapter
    include firefly.core.blockchain->firefly.core.tezosAdapter
    include firefly.core.blockchain->firefly.core.cardanoAdapter
    include firefly.core.ethereum->firefly.evm
    include firefly.core.ethereum->firefly.ethconnect
    include firefly.core.fabricAdapter->firefly.fabconnect
    include firefly.core.tezosAdapter->firefly.tezosconnect
    include firefly.core.cardanoAdapter->firefly.cardanoconnect
    autoLayout lr 360 200
}
