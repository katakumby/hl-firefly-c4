component firefly.evm "30-firefly-evm-events" "Component - FireFly EVMConnect: Block tracking and events" {
    title "Component - FireFly EVMConnect: Block tracking and events"
    include firefly.evm.manager firefly.evm.blocks firefly.evm.receipts firefly.evm.rpc firefly.evm.confirmations firefly.evm.streams firefly.evm.delivery firefly.evm.persistence firefly.fftmDb firefly.signer firefly.core firefly.evm.blocklistener firefly.evm.metrics
    exclude *->*
    include firefly.evm.receipts->firefly.evm.rpc
    include firefly.evm.rpc->firefly.evm.blocks
    include firefly.evm.blocks->firefly.evm.confirmations
    include firefly.evm.receipts->firefly.evm.confirmations
    include firefly.evm.confirmations->firefly.evm.streams
    include firefly.evm.manager->firefly.evm.streams
    include firefly.evm.streams->firefly.evm.delivery
    include firefly.evm.delivery->firefly.evm.streams
    include firefly.evm.streams->firefly.evm.persistence
    include firefly.evm.manager->firefly.evm.persistence
    include firefly.evm.delivery->firefly.core
    include firefly.evm.persistence->firefly.fftmDb
    include firefly.evm.rpc->firefly.signer
    include firefly.evm.blocks->firefly.evm.blocklistener
    include firefly.evm.blocklistener->firefly.evm.confirmations
    include firefly.evm.manager->firefly.evm.metrics
    include firefly.evm.streams->firefly.evm.metrics
    autoLayout lr 360 200
}
