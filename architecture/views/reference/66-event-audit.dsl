component tools.eventAudit "66-event-audit" "Component - FireFly event auditor" {
    title "Component - FireFly event auditor"
    include tools.eventAudit.reader tools.eventAudit.ordering developer firefly.core
    exclude *->*
    include tools.eventAudit.reader->firefly.core
    include tools.eventAudit.reader->tools.eventAudit.ordering
    include tools.eventAudit.ordering->developer
    autoLayout lr 360 200
}
