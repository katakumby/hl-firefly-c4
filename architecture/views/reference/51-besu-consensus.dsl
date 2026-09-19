component besu.node "51-besu-consensus" "Component - Besu node: Consensus and block processing" {
    title "Component - Besu node: Consensus and block processing"
    include besu.node.p2p besu.node.txpool besu.node.qbft besu.node.keys besu.node.blockprocessor besu.node.sync besu.node.metrics
    exclude *->*
    include besu.node.p2p->besu.node.txpool
    include besu.node.p2p->besu.node.sync
    include besu.node.p2p->besu.node.qbft
    include besu.node.sync->besu.node.blockprocessor
    include besu.node.txpool->besu.node.qbft
    include besu.node.qbft->besu.node.keys
    include besu.node.qbft->besu.node.blockprocessor
    include besu.node.qbft->besu.node.metrics
    include besu.node.p2p->besu.node.metrics
    include besu.node.p2p->besu.node.keys
    autoLayout lr 360 200
}
