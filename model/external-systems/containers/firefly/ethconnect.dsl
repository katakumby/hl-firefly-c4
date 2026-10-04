ethconnect = container "EthConnect (legacy option)" "Original Ethereum connector; REST/direct and optional Kafka bridge configurations." "Go" {
    tags "Optional"
    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0"
    properties {
        "architecture.id" "firefly.ethconnect"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0\"]"
    }
    rest = component "REST gateway and authorization" "Accepts requests and dispatches direct or asynchronous processing." "Go" {
        url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/rest"
        properties {
            "architecture.id" "firefly.ethconnect.rest"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/rest\"]"
        }
    }
    auth = component "Authorization extension" "Applies configured request authorization hooks." "Go" {
        url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/auth"
        properties {
            "architecture.id" "firefly.ethconnect.auth"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/auth\"]"
        }
    }
    contracts = component "Contract gateway" "Builds ABI-backed REST APIs and routes contract operations." "Go" {
        url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/contractgateway"
        properties {
            "architecture.id" "firefly.ethconnect.contracts"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/contractgateway\"]"
        }
    }
    registry = component "Contract registry and ABI metadata" "Stores deployed contract interfaces and resolves contract addresses." "Go" {
        url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/contractregistry"
        properties {
            "architecture.id" "firefly.ethconnect.registry"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/contractregistry\"]"
        }
    }
    openapi = component "OpenAPI generation" "Generates request schemas from contract ABIs." "Go" {
        url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/openapi"
        properties {
            "architecture.id" "firefly.ethconnect.openapi"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/openapi\"]"
        }
    }
    transactions = component "Transaction processor" "Allocates nonces, submits transactions and waits for receipts." "Go" {
        url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/tx"
        properties {
            "architecture.id" "firefly.ethconnect.transactions"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/tx\"]"
        }
    }
    rpc = component "Ethereum RPC and ABI binding" "Encodes transactions, calls RPC and supports external signing." "Go" {
        url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/eth"
        properties {
            "architecture.id" "firefly.ethconnect.rpc"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/eth\"]"
        }
    }
    events = component "Event subscriptions and confirmations" "Polls contract logs, confirms and batches them for delivery." "Go" {
        url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/events"
        properties {
            "architecture.id" "firefly.ethconnect.events"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/events\"]"
        }
    }
    websockets = component "WebSocket delivery" "Maintains event clients and acknowledgements." "Go" {
        url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/ws"
        properties {
            "architecture.id" "firefly.ethconnect.websockets"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/ws\"]"
        }
    }
    kafka = component "Kafka bridge" "Consumes transaction requests and publishes replies in Kafka mode." "Go" {
        url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kafka"
        properties {
            "architecture.id" "firefly.ethconnect.kafka"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kafka\"]"
        }
    }
    receipts = component "Receipt store" "Persists transaction outcomes in a configured receipt backend." "Go" {
        url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts"
        properties {
            "architecture.id" "firefly.ethconnect.receipts"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts\"]"
        }
    }
    kv = component "Embedded key-value storage" "Stores event subscriptions and registry data in LevelDB." "Go" {
        url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kvstore"
        properties {
            "architecture.id" "firefly.ethconnect.kv"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kvstore\"]"
        }
    }
}
