container besu "50-besu-network" "Container - reusable Besu node and RPC integration" {
    title "Container - reusable Besu node and RPC integration"
    include besu.node firefly.signer ops.prometheus
    autoLayout lr 360 200
}
