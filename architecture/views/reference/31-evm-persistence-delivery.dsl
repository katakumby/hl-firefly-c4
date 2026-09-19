component firefly.evm "31-evm-persistence-delivery" "Component - EVMConnect persistence and delivery options" {
    title "Component - EVMConnect persistence and delivery options"
    include firefly.evm.manager firefly.evm.persistence firefly.evm.postgres firefly.evm.leveldb firefly.evm.streams firefly.evm.delivery firefly.evm.webhook firefly.evm.metrics firefly.fftmDb firefly.leveldb apps.client
    autoLayout lr 360 200
}
