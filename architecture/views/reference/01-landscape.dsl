systemLandscape "01-landscape" "System Landscape - FireFly consortium architecture" {
    title "System Landscape - FireFly consortium architecture"
    include business developer operator apps tools firefly besu ops peerMembers
    exclude *->*
    include firefly->besu
    include operator->firefly
    include apps->firefly
    include business->apps
    include developer->tools
    include tools->firefly
    include operator->ops
    include ops->firefly
    include ops->besu
    include firefly->peerMembers
    include peerMembers->firefly
    include firefly->apps
    include developer->firefly
    include firefly->developer
    include tools->developer
    autoLayout lr 360 200
}
