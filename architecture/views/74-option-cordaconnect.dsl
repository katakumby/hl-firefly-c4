container firefly "74-option-cordaconnect" "Container - Optional Corda connector starter" {
    title "Container - Optional Corda connector starter"
    include firefly.cordaconnect developer corda firefly.cordaState
    exclude *->*
    include developer->corda
    include developer->firefly.cordaconnect
    include firefly.cordaconnect->corda
    include firefly.cordaconnect->firefly.cordaState
    autoLayout lr 360 200
}
