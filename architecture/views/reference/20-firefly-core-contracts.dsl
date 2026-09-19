component firefly.core "20-firefly-core-contracts" "Component - FireFly Core: Contracts, tokens and operations" {
    title "Component - FireFly Core: Contracts, tokens and operations"
    include firefly.core.orchestrator firefly.core.contracts firefly.core.assets firefly.core.tokens firefly.core.blockchain firefly.core.operations firefly.core.txhelper firefly.core.txwriter firefly.core.database firefly.evm firefly.erc20 firefly.erc1155
    exclude *->*
    include firefly.core.orchestrator->firefly.core.contracts
    include firefly.core.orchestrator->firefly.core.assets
    include firefly.core.contracts->firefly.core.blockchain
    include firefly.core.assets->firefly.core.tokens
    include firefly.core.assets->firefly.core.contracts
    include firefly.core.contracts->firefly.core.operations
    include firefly.core.assets->firefly.core.operations
    include firefly.core.operations->firefly.core.txhelper
    include firefly.core.txhelper->firefly.core.txwriter
    include firefly.core.txwriter->firefly.core.database
    include firefly.core.operations->firefly.core.database
    include firefly.erc20->firefly.evm
    include firefly.erc1155->firefly.evm
    include firefly.core.blockchain->firefly.evm
    include firefly.core.tokens->firefly.erc20
    include firefly.core.tokens->firefly.erc1155
    autoLayout lr 360 200
}
