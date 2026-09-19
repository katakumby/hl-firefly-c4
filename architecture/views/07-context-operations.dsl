systemContext ops "07-context-operations" "System Context - Platform operations reference" {
    title "System Context - Platform operations reference"
    include ops operator firefly besu
    exclude *->*
    include firefly->besu
    include operator->firefly
    include operator->ops
    include ops->firefly
    include ops->besu
    autoLayout lr 360 200
}
