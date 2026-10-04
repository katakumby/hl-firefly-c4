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
        // These are planned placements, including the illustrative recovery snapshot.
        !elements "element.type==DeploymentNode || element.type==InfrastructureNode || element.type==ContainerInstance" {
            tags "Planned"
        }
    }
    views {
        !include views/main.dsl
        // Official Azure service icons; C4 colours and shapes remain shared.
        theme ../../styles/themes/microsoft-azure-2024.07.15/icons.json
    }
}
