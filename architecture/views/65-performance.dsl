component tools.perf "65-performance" "Component - FireFly Performance CLI" {
    title "Component - FireFly Performance CLI"
    include tools.perf.commands tools.perf.runner tools.perf.server tools.perf.report developer firefly.core
    exclude *->*
    include tools.perf.commands->tools.perf.runner
    include tools.perf.server->tools.perf.runner
    include tools.perf.runner->tools.perf.report
    include tools.perf.runner->firefly.core
    include developer->tools.perf.commands
    autoLayout lr 360 200
}
