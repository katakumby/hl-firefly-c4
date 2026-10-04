ops -> firefly "Routes API requests and observes health" "HTTPS + metrics" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
    }
}

ops.gateway -> firefly.core "Routes authenticated API requests" "HTTPS / REST + WebSocket" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

ops.gateway -> firefly.dx "Passes peer TLS sessions without terminating mTLS" "TCP / TLS passthrough" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src\"]"
    }
}

ops.cnpg -> firefly.pg "Reconciles database lifecycle through the hosting PostgreSQL cluster" "Kubernetes API / indirect operator reconciliation" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://cloudnative-pg.io/docs/1.28/replication/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/postgres\"]"
    }
}

ops.cnpg -> firefly.fftmDb "Reconciles database lifecycle through the hosting PostgreSQL cluster" "Kubernetes API / indirect operator reconciliation" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://cloudnative-pg.io/docs/1.28/replication/\",\"https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence/postgres\"]"
    }
}

ops.prometheus -> firefly.core "Scrapes member runtime measurements" "HTTP / Prometheus metrics" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

ops.prometheus -> besu.node "Scrapes peer, block and consensus measurements" "HTTP / Prometheus metrics" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}

ops -> besu "Observes peer and quorum health" "HTTP / metrics" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}
