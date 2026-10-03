workspace extends ../../model.dsl {
    name "Blockchain foundation - Azure three-zone HA"
    description "Proposed Besu and FireFly infrastructure for one member; survives one AZ outage subject to explicit HSM and failover qualification gates."
    !identifiers hierarchical
    !impliedRelationships false
    !docs docs
    model {
        !elements element.tag==Element {
            properties {
                "structurizr.inspection.model.element.noview" "info"
            }
        }
        !include model.dsl
        !include deployment.dsl
        !include failure.dsl
    }
    views {
        !include views/main.dsl
        !include styles.dsl
    }
}
