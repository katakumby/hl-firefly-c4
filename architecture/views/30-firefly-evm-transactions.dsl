component firefly.evm "30-firefly-evm-transactions" "Component - FireFly EVMConnect: Transaction submission" {
    title "Component - FireFly EVMConnect: Transaction submission"
    include firefly.evm.api firefly.evm.manager firefly.evm.handler firefly.evm.nonce firefly.evm.abi firefly.evm.rpc firefly.evm.persistence firefly.fftmDb firefly.signer firefly.evm.receipts
    exclude *->*
    include firefly.evm.api->firefly.evm.manager
    include firefly.evm.manager->firefly.evm.handler
    include firefly.evm.handler->firefly.evm.nonce
    include firefly.evm.nonce->firefly.evm.persistence
    include firefly.evm.handler->firefly.evm.abi
    include firefly.evm.abi->firefly.evm.rpc
    include firefly.evm.handler->firefly.evm.receipts
    include firefly.evm.receipts->firefly.evm.rpc
    include firefly.evm.manager->firefly.evm.persistence
    include firefly.evm.persistence->firefly.fftmDb
    include firefly.evm.rpc->firefly.signer
    autoLayout lr 360 200
}
