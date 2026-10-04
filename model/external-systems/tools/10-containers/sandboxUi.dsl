!element tools {
    sandboxUi = container "Sandbox browser application" "Runs the sample interface in the developer's browser and calls the Sandbox server." "React / TypeScript / browser" {
        url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/ui/src"
        properties {
            "architecture.id" "tools.sandboxUi"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/ui/src\"]"
        }
        app = component "Sandbox screens and server client" "Collects sample actions and requests their execution through the Sandbox server." "React / TypeScript" {
            url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/ui/src"
            properties {
                "architecture.id" "tools.sandboxUi.app"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/ui/src\"]"
            }
        }
    }
}
