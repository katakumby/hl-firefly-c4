container ops "63-operations" "Container - platform operations" {
    title "Container - platform operations"
    include ops.gateway ops.cnpg ops.prometheus ops.grafana operator firefly.core firefly.dx firefly.pg firefly.fftmDb besu.node
    exclude *->*
    include firefly.core->firefly.dx
    include firefly.dx->firefly.core
    include firefly.core->firefly.pg
    include besu.node->besu.node
    include firefly.dx->firefly.dx
    include operator->ops.grafana
    include ops.grafana->ops.prometheus
    include ops.gateway->firefly.core
    include ops.gateway->firefly.dx
    include ops.cnpg->firefly.pg
    include ops.cnpg->firefly.fftmDb
    include ops.prometheus->firefly.core
    include ops.prometheus->besu.node
    autoLayout lr 360 200
}
