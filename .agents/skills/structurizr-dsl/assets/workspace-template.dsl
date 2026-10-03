// Adapt names, responsibilities, and technologies to the actual architecture.
// Add component, dynamic, and deployment views only when they are needed.
workspace "Orders Example" "A minimal system and its supporting views." {
    !identifiers hierarchical

    model {
        customer = person "Customer" "Places and tracks orders."
        orders = softwareSystem "Orders" "Accepts and tracks customer orders." {
            web = container "Order Web App" "Presents order forms and order status." "TypeScript"
            api = container "Order API" "Validates and records orders." "Java"
            store = container "Order Store" "Persists orders and their status." "PostgreSQL" {
                tags "Data Store"
            }
        }
        // Define the deliberate summary before detailed relationships.
        customer -> orders "Places and tracks orders using" "HTTPS"
        customer -> orders.web "Submits orders through" "HTTPS"
        orders.web -> orders.api "Submits and retrieves orders from" "HTTPS/JSON"
        orders.api -> orders.store "Reads and writes order records in" "SQL"
    }

    views {
        systemLandscape "orders-landscape" {
            include *
            autoLayout lr
            title "Orders - System Landscape"
        }
        systemContext orders "orders-context" {
            include *
            autoLayout lr
            title "Orders - System Context"
        }
        container orders "orders-containers" {
            include *
            autoLayout lr
            title "Orders - Containers"
        }
        styles {
            element "Element" {
                background #1168bd
                color #ffffff
            }
            element "Person" {
                shape Person
                background #08427b
            }
            element "Container" {
                background #438dd5
            }
            element "Data Store" {
                shape Cylinder
            }
        }
    }
    configuration {
        scope softwaresystem
    }
}
