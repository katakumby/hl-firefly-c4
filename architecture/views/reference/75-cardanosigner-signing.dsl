component firefly.cardanosigner "75-cardanosigner-signing" "Component - Cardano Signer: signing" {
    title "Component - Cardano Signer: signing"
    include firefly.cardanosigner.server firefly.cardanosigner.api firefly.cardanosigner.keys firefly.cardanosigner.crypto firefly.cardanoconnect firefly.cardanoKeys
    exclude *->*
    include firefly.cardanosigner.server->firefly.cardanosigner.api
    include firefly.cardanosigner.api->firefly.cardanosigner.keys
    include firefly.cardanosigner.api->firefly.cardanosigner.crypto
    include firefly.cardanosigner.keys->firefly.cardanosigner.crypto
    include firefly.cardanosigner.keys->firefly.cardanoKeys
    include firefly.cardanoconnect->firefly.cardanosigner.api
    autoLayout lr 360 200
}
