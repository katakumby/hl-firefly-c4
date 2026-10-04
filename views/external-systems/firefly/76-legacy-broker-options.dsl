container firefly "76-legacy-broker-options" "Container - Legacy connector broker and receipt options" {
    title "Container - Legacy connector broker and receipt options"
    include firefly.ethconnect firefly.fabconnect kafkaBroker mongo
    autoLayout lr 360 200
}
