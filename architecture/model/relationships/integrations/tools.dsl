tools.sandbox.sdk -> firefly.core "Invokes member APIs and consumes events" "HTTPS + WebSocket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/firefly.ts\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.sandbox -> firefly.core "Exercises APIs and subscriptions" "HTTPS + WebSocket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/server/src\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.cli -> firefly.core "Registers and inspects development stacks" "HTTP / Admin API" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/README.md\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools -> firefly "Exercises the selected member API" "HTTPS + WebSocket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/key_components/tools.md\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
    }
}

tools.cli.docker -> dockerEngine "Starts and stops local stack services" "Docker Compose CLI" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/docker\"]"
    }
}

tools.cli -> dockerEngine "Manages local development stack services" "Docker Compose CLI" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/README.md\",\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/docker\"]"
    }
}

tools.cli.core -> firefly.core "Configures and inspects development members" "HTTP / REST + Admin API" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/core\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.perf -> firefly.core "Submits workloads and consumes completion events" "HTTP REST + WebSocket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/README.md\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.perf.runner -> firefly.core "Submits workloads and consumes completion events" "HTTP REST + WebSocket" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/internal/perf\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.eventAudit -> firefly.core "Retrieves namespace status and recorded blockchain events" "HTTP REST / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.eventAudit.reader -> firefly.core "Pages through status and enriched event records" "HTTP REST / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents/main.go\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.eventAudit.ordering -> developer "Reports ordering failures and checked event counts" "Console output" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents/main.go\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

tools.config.migration -> developer "Writes migrated configuration for review" "YAML / standard output" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig/migrate\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

tools.sandbox.sdkHttp -> firefly.core "Sends namespace-scoped API requests" "HTTP REST / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/http.ts\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools.sandbox.sdkEvents -> firefly.core "Subscribes to events and sends acknowledgements" "WebSocket / JSON" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/websocket.ts\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

tools -> developer "Returns audit results and migrated configuration for review" "Local process output" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/key_components/tools.md\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

tools -> dockerEngine "Creates and manages local development stack services" "Docker Compose CLI" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/key_components/tools.md\",\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/docker\"]"
    }
}
