systemContext firefly "02-context-firefly" "System Context - Hyperledger FireFly" {
    title "System Context - Hyperledger FireFly"
    include firefly apps operator besu ops tools peerMembers
    exclude *->*
    include firefly->besu
    include operator->firefly
    include apps->firefly
    include tools->firefly
    include operator->ops
    include ops->firefly
    include ops->besu
    include firefly->peerMembers
    include peerMembers->firefly
    include firefly->apps
    autoLayout lr 360 200
}
