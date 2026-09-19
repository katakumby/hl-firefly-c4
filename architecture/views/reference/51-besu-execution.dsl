component besu.node "51-besu-execution" "Component - Besu node: Execution, contracts and storage" {
    title "Component - Besu node: Execution, contracts and storage"
    include besu.node.rpc besu.node.blockprocessor besu.node.evm besu.node.worldstate besu.node.storage besu.node.fireflycontract besu.node.tokencontracts besu.node.businesscontracts
    autoLayout lr 360 200
}
