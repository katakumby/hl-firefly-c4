systemContext besu "03-context-besu" "System Context - private Besu network" {
    title "System Context - private Besu network"
    include firefly besu ops
    exclude *->*
    include firefly->besu
    include ops->firefly
    include ops->besu
    autoLayout lr 360 200
}
