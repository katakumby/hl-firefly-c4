container tools "61-tools" "Container - developer tooling" {
    title "Container - developer tooling"
    include tools.cli tools.sandbox tools.sandboxUi developer firefly.core tools.perf tools.eventAudit tools.config dockerEngine
    exclude *->*
    include tools.sandboxUi->tools.sandbox
    include tools.sandbox->firefly.core
    include tools.cli->firefly.core
    include developer->tools.cli
    include developer->tools.sandboxUi
    include tools.cli->dockerEngine
    include developer->tools.perf
    include tools.perf->firefly.core
    include developer->tools.eventAudit
    include tools.eventAudit->firefly.core
    include developer->tools.config
    autoLayout lr 360 200
}
