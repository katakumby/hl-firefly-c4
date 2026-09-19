container firefly "71-option-fabconnect" "Container - Optional FabConnect" {
    title "Container - Optional FabConnect"
    include firefly.fabconnect firefly.core fabric fabricCA firefly.fabricState
    exclude *->*
    include firefly.core->firefly.fabconnect
    include firefly.fabconnect->fabric
    include firefly.fabconnect->fabricCA
    include firefly.fabconnect->firefly.core
    include firefly.fabconnect->firefly.fabricState
    autoLayout lr 360 200
}
