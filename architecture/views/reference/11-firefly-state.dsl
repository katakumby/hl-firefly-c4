container firefly "11-firefly-state" "Container - FireFly private state and shared storage" {
    title "Container - FireFly private state and shared storage"
    include firefly.core firefly.evm firefly.signer firefly.dx firefly.ipfs firefly.pg firefly.fftmDb firefly.blobs firefly.ipfsRepo firefly.secrets peerMembers
    autoLayout lr 360 200
}
