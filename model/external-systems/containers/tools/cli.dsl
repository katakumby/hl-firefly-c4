cli = container "FireFly CLI" "Creates local stacks and performs development administration." "Go / CLI" {
    url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/README.md"
    properties {
        "architecture.id" "tools.cli"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/README.md\"]"
    }
    commands = component "CLI commands" "Accepts stack creation, start, stop and administration commands." "Go" {
        url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/cmd"
        properties {
            "architecture.id" "tools.cli.commands"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/cmd\"]"
        }
    }
    stacks = component "Stack configuration and manifests" "Assembles member stack configuration and state." "Go" {
        url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/stacks"
        properties {
            "architecture.id" "tools.cli.stacks"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/stacks\"]"
        }
    }
    docker = component "Docker integration" "Invokes Docker Compose to manage local development runtimes." "Go" {
        url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/docker"
        properties {
            "architecture.id" "tools.cli.docker"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/docker\"]"
        }
    }
    blockchains = component "Blockchain setup adapters" "Configures selected Ethereum, Fabric, Tezos or Cardano backends." "Go" {
        url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/blockchain"
        properties {
            "architecture.id" "tools.cli.blockchains"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/blockchain\"]"
        }
    }
    tokens = component "Token setup adapters" "Configures optional ERC token connectors." "Go" {
        url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/tokens"
        properties {
            "architecture.id" "tools.cli.tokens"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/tokens\"]"
        }
    }
    core = component "Core administration client" "Registers identities and configures Core namespaces." "Go" {
        url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/core"
        properties {
            "architecture.id" "tools.cli.core"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/core\"]"
        }
    }
}
