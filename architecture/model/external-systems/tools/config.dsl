config = container "FireFly configuration migrator" "Migrates configuration files between supported FireFly versions." "Go / CLI" {
    tags "Optional"
    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig"
    properties {
        "architecture.id" "tools.config"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig\"]"
    }
    commands = component "Configuration CLI" "Reads input configuration and requested versions." "Go" {
        url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig/main.go"
        properties {
            "architecture.id" "tools.config.commands"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig/main.go\"]"
        }
    }
    migration = component "Configuration migrations" "Transforms configuration to the selected schema version." "Go" {
        url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig/migrate"
        properties {
            "architecture.id" "tools.config.migration"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig/migrate\"]"
        }
    }
}
