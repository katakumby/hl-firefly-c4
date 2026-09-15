workspace "Example Workspace" "Replace with the product or platform name." {
    !identifiers hierarchical

    model {
        user = person "User" "A person who interacts with the system."
        ops = person "Operations" "Maintains and observes the platform."

        platform = softwareSystem "Platform" "The system being described." {
            web = container "Web App" "Delivers the browser UI." "TypeScript"
            api = container "API" "Handles business workflows and integration." "Kotlin + Spring Boot" {
                controller = component "Controller" "Entry point for HTTP requests." "Spring MVC"
                service = component "Service" "Coordinates business logic." "Kotlin"
                repository = component "Repository" "Reads and writes persistent data." "JPA"

                controller -> service "Delegates business logic to"
                service -> repository "Reads from and writes to"
            }
            db = container "Database" "Stores transactional data." "PostgreSQL" {
                tags "Database"
            }

            web -> api "Forwards user requests to" "HTTPS/JSON"
            api -> db "Reads from and writes to" "JDBC"
        }

        auth = softwareSystem "Identity Provider" "Authenticates users."
        email = softwareSystem "Email Service" "Sends outbound notifications."

        user -> platform.web "Interacts with the system through"
        ops -> platform "Operates and monitors"
        platform.web -> auth "Authenticates with" "OIDC"
        platform.api -> email "Sends notifications to" "SMTP/API"
    }

    views {
        systemLandscape "landscape" "High-level landscape." {
            include *
            autolayout lr
        }

        systemContext platform "platform-context" "Platform in context." {
            include *
            autolayout lr
        }

        container platform "platform-containers" "Platform containers." {
            include *
            autolayout lr
        }

        component platform.api "api-components" "Key API components." {
            include *
            autolayout lr
        }

        // Uncomment only when you need a scenario flow.
        // dynamic platform "checkout-flow" "Example interaction flow." {
        //     user -> platform.web "Starts a workflow"
        //     platform.web -> platform.api "Submits command"
        //     platform.api -> platform.db "Persists state"
        //     platform.api -> email "Sends confirmation"
        //     autolayout lr
        // }

        // Uncomment only when you need deployment modeling.
        // deployment platform "Production" "prod-deployment" "Production deployment." {
        //     include *
        //     autolayout lr
        // }

        styles {
            element "Person" {
                shape person
                background #08427b
                color #ffffff
            }

            element "Software System" {
                background #1168bd
                color #ffffff
            }

            element "Container" {
                background #438dd5
                color #ffffff
            }

            element "Component" {
                background #85bbf0
                color #000000
            }

            element "Database" {
                shape cylinder
            }

            relationship "Relationship" {
                color #707070
            }
        }
    }
}
