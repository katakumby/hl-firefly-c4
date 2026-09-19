component firefly.evm "31-evm-persistence-delivery" "Component - EVMConnect persistence and delivery options" {
    title "Component - EVMConnect persistence and delivery options"
    include firefly.evm.manager firefly.evm.persistence firefly.evm.postgres firefly.evm.leveldb firefly.evm.streams firefly.evm.delivery firefly.evm.webhook firefly.evm.metrics firefly.fftmDb firefly.leveldb apps.client
    exclude *->*
    include firefly.evm.manager->firefly.evm.streams
    include firefly.evm.streams->firefly.evm.delivery
    include firefly.evm.delivery->firefly.evm.streams
    include firefly.evm.streams->firefly.evm.persistence
    include firefly.evm.manager->firefly.evm.persistence
    include firefly.evm.persistence->firefly.fftmDb
    include firefly.evm.persistence->firefly.evm.postgres
    include firefly.evm.persistence->firefly.evm.leveldb
    include firefly.evm.streams->firefly.evm.webhook
    include firefly.evm.manager->firefly.evm.metrics
    include firefly.evm.streams->firefly.evm.metrics
    include firefly.evm.postgres->firefly.fftmDb
    include firefly.evm.leveldb->firefly.leveldb
    include firefly.evm.webhook->apps.client
    autoLayout lr 360 200
}
