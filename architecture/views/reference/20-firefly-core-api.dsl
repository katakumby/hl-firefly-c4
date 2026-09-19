component firefly.core "20-firefly-core-api" "Component - FireFly Core: API and tenancy" {
    title "Component - FireFly Core: API and tenancy"
    include firefly.core.api firefly.core.auth firefly.core.namespaces firefly.core.orchestrator firefly.core.syncasync firefly.core.spievents firefly.core.eventplugin apps.client firefly.explorer firefly.core.config firefly.core.basicAuth
    exclude *->*
    include firefly.core.api->firefly.core.auth
    include firefly.core.api->firefly.core.namespaces
    include firefly.core.namespaces->firefly.core.orchestrator
    include firefly.core.api->firefly.core.orchestrator
    include firefly.core.orchestrator->firefly.core.syncasync
    include firefly.core.namespaces->firefly.core.spievents
    include firefly.core.spievents->firefly.core.eventplugin
    include firefly.explorer->firefly.core.api
    include apps.client->firefly.core.api
    include firefly.core.eventplugin->apps.client
    include firefly.core.namespaces->firefly.core.config
    include firefly.core.auth->firefly.core.basicAuth
    autoLayout lr 360 200
}
