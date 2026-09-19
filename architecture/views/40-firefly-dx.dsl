component firefly.dx "40-firefly-dx" "Component - FireFly private data exchange" {
    title "Component - FireFly private data exchange"
    include firefly.dx.api firefly.dx.peers firefly.dx.p2p firefly.dx.messages firefly.dx.blobs firefly.dx.events firefly.blobs firefly.secrets peerMembers firefly.core
    exclude *->*
    include firefly.dx.api->firefly.dx.peers
    include firefly.dx.api->firefly.dx.messages
    include firefly.dx.api->firefly.dx.blobs
    include firefly.dx.messages->firefly.dx.peers
    include firefly.dx.messages->firefly.dx.p2p
    include firefly.dx.blobs->firefly.dx.p2p
    include firefly.dx.p2p->firefly.dx.messages
    include firefly.dx.p2p->firefly.dx.blobs
    include firefly.dx.messages->firefly.dx.events
    include firefly.dx.blobs->firefly.dx.events
    include firefly.dx.events->firefly.dx.api
    include firefly.core->firefly.secrets
    include firefly.dx.blobs->firefly.blobs
    include firefly.dx.peers->firefly.blobs
    include firefly.dx.p2p->firefly.secrets
    include firefly.dx.p2p->peerMembers
    include peerMembers->firefly.dx.p2p
    include firefly.dx.events->firefly.core
    include firefly.core->firefly.dx.events
    autoLayout lr 360 200
}
