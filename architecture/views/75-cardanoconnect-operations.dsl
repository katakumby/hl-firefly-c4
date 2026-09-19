component firefly.cardanoconnect "75-cardanoconnect-operations" "Component - CardanoConnect: operations" {
    title "Component - CardanoConnect: operations"
    include firefly.cardanoconnect.server firefly.cardanoconnect.api firefly.cardanoconnect.operations firefly.cardanoconnect.blockchain firefly.cardanoconnect.blockfrost firefly.cardanoconnect.n2c firefly.cardanoconnect.signer firefly.cardanoconnect.persistence firefly.core firefly.cardanosigner blockfrostService cardano firefly.cardanoState
    exclude *->*
    include firefly.cardanoconnect.server->firefly.cardanoconnect.api
    include firefly.cardanoconnect.api->firefly.cardanoconnect.operations
    include firefly.cardanoconnect.operations->firefly.cardanoconnect.blockchain
    include firefly.cardanoconnect.blockchain->firefly.cardanoconnect.blockfrost
    include firefly.cardanoconnect.blockchain->firefly.cardanoconnect.n2c
    include firefly.cardanoconnect.operations->firefly.cardanoconnect.signer
    include firefly.cardanoconnect.operations->firefly.cardanoconnect.persistence
    include firefly.cardanoconnect.signer->firefly.cardanosigner
    include firefly.cardanoconnect.blockfrost->blockfrostService
    include blockfrostService->cardano
    include firefly.cardanoconnect.n2c->cardano
    include firefly.cardanoconnect.persistence->firefly.cardanoState
    include firefly.core->firefly.cardanoconnect.api
    autoLayout lr 360 200
}
