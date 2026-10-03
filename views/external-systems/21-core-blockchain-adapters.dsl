component firefly.core "21-core-blockchain-adapters" "Component - Core blockchain adapters" {
    title "Component - Core blockchain adapters"
    include firefly.core.blockchain firefly.core.ethereum firefly.core.fabricAdapter firefly.core.tezosAdapter firefly.core.cardanoAdapter firefly.evm firefly.ethconnect firefly.fabconnect firefly.tezosconnect firefly.cardanoconnect
    autoLayout lr 360 200
}
