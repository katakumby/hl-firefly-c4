container firefly "73-option-cardanoconnect" "Container - Optional CardanoConnect" {
    title "Container - Optional CardanoConnect"
    include firefly.cardanoconnect firefly.core firefly.cardanosigner firefly.cardanoState firefly.cardanoKeys cardano blockfrostService
    autoLayout lr 360 200
}
