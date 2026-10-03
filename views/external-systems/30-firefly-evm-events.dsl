component firefly.evm "30-firefly-evm-events" "Component - FireFly EVMConnect: Block tracking and events" {
    title "Component - FireFly EVMConnect: Block tracking and events"
    include firefly.evm.manager firefly.evm.blocks firefly.evm.receipts firefly.evm.rpc firefly.evm.confirmations firefly.evm.streams firefly.evm.delivery firefly.evm.persistence firefly.fftmDb firefly.signer firefly.core firefly.evm.blocklistener firefly.evm.metrics
    autoLayout lr 360 200
}
