container firefly "11-firefly-state" "Container - FireFly private state and shared storage" {
    title "Container - FireFly private state and shared storage"
    include firefly.core firefly.evm firefly.signer firefly.dx firefly.ipfs firefly.pg firefly.fftmDb firefly.blobs firefly.ipfsRepo firefly.secrets peerMembers
    exclude *->*
    include firefly.core->firefly.evm
    include firefly.evm->firefly.core
    include firefly.core->firefly.dx
    include firefly.dx->firefly.core
    include firefly.evm->firefly.signer
    include firefly.core->firefly.pg
    include firefly.evm->firefly.fftmDb
    include firefly.core->firefly.ipfs
    include firefly.dx->firefly.blobs
    include firefly.ipfs->firefly.ipfsRepo
    include firefly.signer->firefly.secrets
    include firefly.dx->firefly.secrets
    include firefly.core->firefly.secrets
    include firefly.evm->firefly.secrets
    include firefly.dx->firefly.dx
    include firefly.ipfs->firefly.ipfs
    include firefly.dx->peerMembers
    include peerMembers->firefly.dx
    include firefly.ipfs->peerMembers
    autoLayout lr 360 200
}
