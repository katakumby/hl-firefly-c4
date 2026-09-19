container firefly "73-option-cardanoconnect" "Container - Optional CardanoConnect" {
    title "Container - Optional CardanoConnect"
    include firefly.cardanoconnect firefly.core firefly.cardanosigner firefly.cardanoState firefly.cardanoKeys cardano blockfrostService
    exclude *->*
    include firefly.core->firefly.cardanoconnect
    include firefly.cardanoconnect->firefly.cardanosigner
    include firefly.cardanoconnect->blockfrostService
    include blockfrostService->cardano
    include firefly.cardanoconnect->cardano
    include firefly.cardanoconnect->firefly.cardanoState
    include firefly.cardanosigner->firefly.cardanoKeys
    include firefly.cardanoconnect->firefly.core
    autoLayout lr 360 200
}
