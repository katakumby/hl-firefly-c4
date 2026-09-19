component firefly.cardanoconnect "75-cardanoconnect-contracts-events" "Component - CardanoConnect: contracts-events" {
    title "Component - CardanoConnect: contracts-events"
    include firefly.cardanoconnect.api firefly.cardanoconnect.operations firefly.cardanoconnect.contracts firefly.cardanoconnect.balius firefly.cardanoconnect.blockchain firefly.cardanoconnect.streams firefly.cardanoconnect.persistence firefly.core firefly.cardanoState
    exclude *->*
    include firefly.cardanoconnect.api->firefly.cardanoconnect.operations
    include firefly.cardanoconnect.api->firefly.cardanoconnect.streams
    include firefly.cardanoconnect.operations->firefly.cardanoconnect.blockchain
    include firefly.cardanoconnect.operations->firefly.cardanoconnect.contracts
    include firefly.cardanoconnect.contracts->firefly.cardanoconnect.balius
    include firefly.cardanoconnect.contracts->firefly.cardanoconnect.blockchain
    include firefly.cardanoconnect.operations->firefly.cardanoconnect.persistence
    include firefly.cardanoconnect.streams->firefly.cardanoconnect.blockchain
    include firefly.cardanoconnect.streams->firefly.cardanoconnect.contracts
    include firefly.cardanoconnect.streams->firefly.cardanoconnect.persistence
    include firefly.cardanoconnect.contracts->firefly.cardanoconnect.persistence
    include firefly.cardanoconnect.persistence->firefly.cardanoState
    include firefly.cardanoconnect.streams->firefly.core
    include firefly.core->firefly.cardanoconnect.api
    autoLayout lr 360 200
}
