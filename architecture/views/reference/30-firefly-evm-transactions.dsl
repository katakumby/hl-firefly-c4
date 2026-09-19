component firefly.evm "30-firefly-evm-transactions" "Component - FireFly EVMConnect: Transaction submission" {
    title "Component - FireFly EVMConnect: Transaction submission"
    include firefly.evm.api firefly.evm.manager firefly.evm.handler firefly.evm.nonce firefly.evm.abi firefly.evm.rpc firefly.evm.persistence firefly.fftmDb firefly.signer firefly.evm.receipts
    autoLayout lr 360 200
}
