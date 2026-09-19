component besu.node "51-besu-consensus" "Component - Besu node: Consensus and block processing" {
    title "Component - Besu node: Consensus and block processing"
    include besu.node.p2p besu.node.txpool besu.node.qbft besu.node.keys besu.node.blockprocessor besu.node.sync besu.node.metrics
    autoLayout lr 360 200
}
