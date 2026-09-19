component firefly.cardanosigner "75-cardanosigner-signing" "Component - Cardano Signer: signing" {
    title "Component - Cardano Signer: signing"
    include element.parent==firefly.cardanosigner firefly.cardanoconnect firefly.cardanoKeys
    autoLayout lr 360 200
}
