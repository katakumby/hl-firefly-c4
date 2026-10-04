edge = container "Unleash Edge (OSS, optional)" "Caches configuration and evaluates frontend requests; online polling or offline file mode." "Rust / Axum / Tokio" {
    url "https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs"
    properties {
        "architecture.id" "unleash.edge"
        "evidence" "Implementation; logical C4 grouping"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\"]"
    }

    http = component "HTTP endpoints" "Exposes Client, Frontend, Edge validation and operational routes with request middleware." "Rust / Axum" {
        url "https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs"
        properties {
            "architecture.id" "unleash.edge.http"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-frontend-api/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-edge-api/src/lib.rs\"]"
        }
    }

    tokens = component "Token validation and cache" "Validates tokens upstream or against offline configuration and caches authorized scopes." "Rust / Tokio" {
        url "https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-auth/src/token_validator.rs"
        properties {
            "architecture.id" "unleash.edge.tokens"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-auth/src/token_validator.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-appstate/src/edge_token_extractor.rs\"]"
        }
    }

    upstream = component "Upstream HTTP client" "Fetches full feature payloads, validates tokens and posts registration/metric batches." "Rust / reqwest" {
        url "https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-http-client/src/lib.rs"
        properties {
            "architecture.id" "unleash.edge.upstream"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-http-client/src/lib.rs\"]"
        }
    }

    refresh = component "Polling and refresh" "Hydrates scoped configuration and periodically refreshes features and compiled evaluation state." "Rust / Tokio" {
        url "https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-refresh/src/lib.rs"
        properties {
            "architecture.id" "unleash.edge.refresh"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-refresh/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\"]"
        }
    }

    cache = component "Feature cache and filtering" "Stores in-memory feature payloads and applies token, environment and request filters." "Rust / Tokio" {
        url "https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-cache/src/lib.rs"
        properties {
            "architecture.id" "unleash.edge.cache"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-cache/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-filters/src/lib.rs\"]"
        }
    }

    evaluation = component "Evaluation engine" "Evaluates context against compiled strategies and returns enabled flags and variants." "Rust / unleash-yggdrasil" {
        url "https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-frontend-api/src/frontend.rs"
        properties {
            "architecture.id" "unleash.edge.evaluation"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-frontend-api/src/frontend.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-types/src/lib.rs\"]"
        }
    }

    metrics = component "Registration and metrics aggregation" "Buffers SDK registrations and flag/variant counts, batches them and forwards usage upstream." "Rust / Tokio" {
        url "https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/register.rs"
        properties {
            "architecture.id" "unleash.edge.metrics"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/register.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/metrics.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-metrics/src/send_unleash_metrics.rs\"]"
        }
    }

    persistence = component "Snapshot persistence and recovery" "Saves validated tokens and feature snapshots; restores caches using a configured backend." "Rust / Tokio" {
        url "https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/lib.rs"
        properties {
            "architecture.id" "unleash.edge.persistence"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\"]"
        }
    }

    offline = component "Offline bootstrap and reload" "Loads local feature JSON and configured tokens; optionally reloads file changes without upstream calls." "Rust / Tokio" {
        url "https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/offline_builder.rs"
        properties {
            "architecture.id" "unleash.edge.offline"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/offline_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-offline/src/hotload.rs\"]"
        }
    }

    health = component "Health and operational metrics" "Exposes readiness and health, and measures requests, refresh and metric delivery." "Rust / Tokio" {
        url "https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-backstage/src/lib.rs"
        properties {
            "architecture.id" "unleash.edge.health"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-backstage/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-metrics/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-request-logger/src/lib.rs\"]"
        }
    }
}
