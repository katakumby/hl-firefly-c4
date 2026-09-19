container firefly "10-firefly-runtime" "Container - FireFly orchestration and connectors" {
    title "Container - FireFly orchestration and connectors"
    include firefly.core firefly.explorer firefly.evm firefly.signer firefly.dx firefly.erc20 firefly.erc1155 firefly.ipfs firefly.pg firefly.fftmDb operator apps.client besu.node peerMembers
    exclude *->*
    include operator->firefly.explorer
    include firefly.explorer->firefly.core
    include firefly.core->firefly.evm
    include firefly.evm->firefly.core
    include firefly.core->firefly.dx
    include firefly.dx->firefly.core
    include firefly.core->firefly.erc20
    include firefly.core->firefly.erc1155
    include firefly.erc20->firefly.core
    include firefly.erc1155->firefly.core
    include firefly.erc20->firefly.evm
    include firefly.erc1155->firefly.evm
    include firefly.evm->firefly.signer
    include firefly.core->firefly.pg
    include firefly.evm->firefly.fftmDb
    include firefly.core->firefly.ipfs
    include besu.node->besu.node
    include firefly.signer->besu.node
    include firefly.dx->firefly.dx
    include firefly.ipfs->firefly.ipfs
    include apps.client->firefly.core
    include firefly.core->apps.client
    include firefly.dx->peerMembers
    include peerMembers->firefly.dx
    include firefly.ipfs->peerMembers
    autoLayout lr 360 200
}
