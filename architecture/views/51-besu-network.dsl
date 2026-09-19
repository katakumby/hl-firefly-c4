component besu.node "51-besu-network" "Component - Besu node: Network and admission" {
    title "Component - Besu node: Network and admission"
    include besu.node.rpc besu.node.permissioning besu.node.discovery besu.node.p2p besu.node.txpool besu.node.sync
    exclude *->*
    include besu.node.rpc->besu.node.permissioning
    include besu.node.rpc->besu.node.txpool
    include besu.node.discovery->besu.node.p2p
    include besu.node.p2p->besu.node.permissioning
    include besu.node.p2p->besu.node.txpool
    include besu.node.p2p->besu.node.sync
    autoLayout lr 360 200
}
