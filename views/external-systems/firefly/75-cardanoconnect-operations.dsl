component firefly.cardanoconnect "75-cardanoconnect-operations" "Component - CardanoConnect: operations" {
    title "Component - CardanoConnect: operations"
    include firefly.cardanoconnect.server firefly.cardanoconnect.api firefly.cardanoconnect.operations firefly.cardanoconnect.blockchain firefly.cardanoconnect.blockfrost firefly.cardanoconnect.n2c firefly.cardanoconnect.signer firefly.cardanoconnect.persistence firefly.core firefly.cardanosigner blockfrostService cardano firefly.cardanoState
    autoLayout lr 360 200
}
