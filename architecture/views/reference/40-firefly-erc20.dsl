component firefly.erc20 "40-firefly-erc20" "Component - FireFly ERC-20 / ERC-721" {
    title "Component - FireFly ERC-20 / ERC-721"
    include firefly.erc20.api firefly.erc20.service firefly.erc20.mapper firefly.erc20.blockchain firefly.erc20.listener firefly.erc20.stream firefly.erc20.proxy firefly.core firefly.evm
    exclude *->*
    include firefly.erc20.api->firefly.erc20.service
    include firefly.erc20.service->firefly.erc20.mapper
    include firefly.erc20.mapper->firefly.erc20.blockchain
    include firefly.erc20.blockchain->firefly.erc20.stream
    include firefly.erc20.stream->firefly.erc20.listener
    include firefly.erc20.listener->firefly.erc20.service
    include firefly.erc20.listener->firefly.erc20.proxy
    include firefly.erc20.proxy->firefly.erc20.stream
    include firefly.core->firefly.evm
    include firefly.evm->firefly.core
    include firefly.erc20.blockchain->firefly.evm
    include firefly.evm->firefly.erc20.stream
    include firefly.erc20.proxy->firefly.core
    autoLayout lr 360 200
}
