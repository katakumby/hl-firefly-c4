workspace extends ../../model.dsl {
    name "Ignition - DApp Platform"
    description "Initial proposal for the first software system on the new platform."
    !identifiers hierarchical
    !impliedRelationships false
    !docs .
    model {
        // Only inherited reference elements may be absent from these focused views.
        !elements element.tag==Element {
            properties {
                "structurizr.inspection.model.element.noview" "info"
            }
        }
        !include model.dsl
    }
    views {
        !include views/main.dsl
    }
}
