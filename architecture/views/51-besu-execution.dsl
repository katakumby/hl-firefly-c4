component besu.node "51-besu-execution" "Component - Besu node: Execution, contracts and storage" {
    title "Component - Besu node: Execution, contracts and storage"
    include besu.node.rpc besu.node.blockprocessor besu.node.evm besu.node.worldstate besu.node.storage besu.node.fireflycontract besu.node.tokencontracts besu.node.businesscontracts
    exclude *->*
    include besu.node.rpc->besu.node.worldstate
    include besu.node.rpc->besu.node.blockprocessor
    include besu.node.blockprocessor->besu.node.evm
    include besu.node.evm->besu.node.worldstate
    include besu.node.worldstate->besu.node.storage
    include besu.node.blockprocessor->besu.node.storage
    include besu.node.evm->besu.node.fireflycontract
    include besu.node.evm->besu.node.tokencontracts
    include besu.node.evm->besu.node.businesscontracts
    include besu.node.fireflycontract->besu.node.worldstate
    include besu.node.tokencontracts->besu.node.worldstate
    include besu.node.businesscontracts->besu.node.worldstate
    autoLayout lr 360 200
}
