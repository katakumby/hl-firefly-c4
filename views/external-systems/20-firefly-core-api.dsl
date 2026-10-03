component firefly.core "20-firefly-core-api" "Component - FireFly Core: API and tenancy" {
    title "Component - FireFly Core: API and tenancy"
    include firefly.core.api firefly.core.auth firefly.core.namespaces firefly.core.orchestrator firefly.core.syncasync firefly.core.spievents firefly.core.eventplugin apps.client firefly.explorer firefly.core.config firefly.core.basicAuth
    autoLayout lr 360 200
}
