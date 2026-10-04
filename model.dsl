workspace "Shared architecture model" "Reusable external reference systems; accepted platform modules are added separately." {
    !identifiers hierarchical
    !impliedRelationships false
    properties {
        "structurizr.inspection.workspace.scope" "info"
        // Add system-specific documentation and decisions when meaningful content exists.
        "structurizr.inspection.model.softwaresystem.documentation" "info"
        "structurizr.inspection.model.softwaresystem.decisions" "info"
    }
    model {
        !include model/people.dsl
        !include model/external-systems/systems
        !include model/relationships
    }
    views {
        !include styles/styles.dsl
        properties {
            "structurizr.sort" "key"
        }
    }
    configuration {
        scope none
    }
}
