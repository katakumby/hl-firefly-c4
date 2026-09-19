eventAudit = container "FireFly event auditor" "Audits recorded blockchain-event ordering through the Core API." "Go / CLI" {
    tags "Optional"
    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents"
    properties {
        "architecture.id" "tools.eventAudit"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents\"]"
    }
    reader = component "Event API reader" "Pages through recorded blockchain events." "Go" {
        url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents/main.go"
        properties {
            "architecture.id" "tools.eventAudit.reader"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents/main.go\"]"
        }
    }
    ordering = component "Ordering auditor" "Checks increasing protocol identifiers and reports inconsistencies." "Go" {
        url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents/main.go"
        properties {
            "architecture.id" "tools.eventAudit.ordering"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents/main.go\"]"
        }
    }
}
