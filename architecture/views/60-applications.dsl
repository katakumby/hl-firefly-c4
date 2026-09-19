container apps "60-applications" "Container - member business applications" {
    title "Container - member business applications"
    include apps.client business firefly.core
    exclude *->*
    include business->apps.client
    include apps.client->firefly.core
    include firefly.core->apps.client
    autoLayout lr 360 200
}
