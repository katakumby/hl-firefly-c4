component firefly.erc1155 "40-firefly-erc1155" "Component - FireFly ERC-1155" {
    title "Component - FireFly ERC-1155"
    include firefly.erc1155.api firefly.erc1155.service firefly.erc1155.mapper firefly.erc1155.blockchain firefly.erc1155.listener firefly.erc1155.stream firefly.erc1155.proxy firefly.core firefly.evm
    exclude *->*
    include firefly.erc1155.api->firefly.erc1155.service
    include firefly.erc1155.service->firefly.erc1155.mapper
    include firefly.erc1155.mapper->firefly.erc1155.blockchain
    include firefly.erc1155.blockchain->firefly.erc1155.stream
    include firefly.erc1155.stream->firefly.erc1155.listener
    include firefly.erc1155.listener->firefly.erc1155.service
    include firefly.erc1155.listener->firefly.erc1155.proxy
    include firefly.erc1155.proxy->firefly.erc1155.stream
    include firefly.core->firefly.evm
    include firefly.evm->firefly.core
    include firefly.erc1155.blockchain->firefly.evm
    include firefly.evm->firefly.erc1155.stream
    include firefly.erc1155.proxy->firefly.core
    autoLayout lr 360 200
}
