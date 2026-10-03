container firefly "10-firefly-runtime" "Container - FireFly orchestration and connectors" {
    title "Container - FireFly orchestration and connectors"
    include firefly.core firefly.explorer firefly.evm firefly.signer firefly.dx firefly.erc20 firefly.erc1155 firefly.ipfs firefly.pg firefly.fftmDb operator apps.client besu.node peerMembers
    autoLayout lr 360 200
}
