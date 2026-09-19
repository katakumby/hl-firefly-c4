container besu "50-besu-network" "Container - reusable Besu node and RPC integration" {
    title "Container - reusable Besu node and RPC integration"
    include besu.node firefly.signer ops.prometheus
    exclude *->*
    include besu.node->besu.node
    include firefly.signer->besu.node
    include ops.prometheus->besu.node
    autoLayout lr 360 200
}
