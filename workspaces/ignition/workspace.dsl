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


        example_system = softwareSystem "Example System" "An example software system." {
            api = container "API" "The API container for the example system."
            backend = container "Backend" "The backend container for the example system."

            api -> backend "Handles API requests and responses"
            backend -> api "Sends responses back to the API"
        }
    }
    views {
        !include views/main.dsl

        container example_system {
            include *
        }

        dynamic example_system "stable_key_name"{
            title "Browse top 20 books feature"
            example_system.api -> example_system.backend "Requests the top 20 books from"
            example_system.backend -> example_system.api "Queries the top 20 books using"
            example_system.api -> example_system.backend "Query another set of books"
            example_system.backend -> example_system.api "Sends the updated top 20 books back to the API"
        }
    }
}
