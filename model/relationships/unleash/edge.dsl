// Named internal flows. Request/response results are documented on the initiating arrow.
// Container and component projections describe the same exchanges at different C4 levels.

unleash_edgeFeatures = unleash.edge -> unleash.server "Polls scoped feature configuration" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeFeatures"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\"]"
    }
}

unleash_edgeValidation = unleash.edge -> unleash.server "Validates tokens and refreshes their scopes" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeValidation"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\"]"
    }
}

unleash_edgeUsage = unleash.edge -> unleash.server "Forwards registration and usage batches" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeUsage"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\"]"
    }
}

unleash_edgeFileSnapshots = unleash.edge -> unleash.files "Saves and restores local recovery snapshots" "Filesystem / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeFileSnapshots"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/file.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-offline/src/hotload.rs\"]"
    }
}

unleash_edgeRedisSnapshots = unleash.edge -> unleash.redis "Saves and restores Redis recovery snapshots" "Redis protocol / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeRedisSnapshots"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/redis.rs\"]"
    }
}

unleash_edgeS3Snapshots = unleash.edge -> unleash.s3 "Saves and restores S3 recovery snapshots" "HTTPS / S3 API" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeS3Snapshots"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/s3.rs\"]"
    }
}

unleash_edgeBootstrapFiles = unleash.edge -> unleash.files "Loads and reloads offline feature JSON" "Filesystem / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeBootstrapFiles"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/file.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-offline/src/hotload.rs\"]"
    }
}

unleash_edgeClientFetch = unleash.edge -> unleash.server.clientApi "Requests full scoped feature definitions" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeClientFetch"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/client-api\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles/client-feature-toggle.controller.ts\"]"
    }
}

unleash_edgeClientMetrics = unleash.edge -> unleash.server.clientApi "Posts registration and aggregated usage" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeClientMetrics"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/client-api\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles/client-feature-toggle.controller.ts\"]"
    }
}

unleash_edgeTokenValidation = unleash.edge -> unleash.server.edgeApi "Validates token batches and receives scopes" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeTokenValidation"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/edge-api/index.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/edge-service.ts\"]"
    }
}

unleash_edgeRequestAuth = unleash.edge.http -> unleash.edge.tokens "Checks request token and resolves authorized scope" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeRequestAuth"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-auth/src/token_validator.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-appstate/src/edge_token_extractor.rs\"]"
    }
}

unleash_edgeRequestFeatures = unleash.edge.http -> unleash.edge.cache "Reads and filters full feature configurations" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeRequestFeatures"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-cache/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-filters/src/lib.rs\"]"
    }
}

unleash_edgeRequestEvaluation = unleash.edge.http -> unleash.edge.evaluation "Evaluates frontend context and returns results" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeRequestEvaluation"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-frontend-api/src/frontend.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-types/src/lib.rs\"]"
    }
}

unleash_edgeRequestUsage = unleash.edge.http -> unleash.edge.metrics "Buffers SDK registrations and usage counts" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeRequestUsage"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/register.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/metrics.rs\"]"
    }
}

unleash_edgeRequestHealth = unleash.edge.http -> unleash.edge.health "Returns health, readiness and operational metrics" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeRequestHealth"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-backstage/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-metrics/src/lib.rs\"]"
    }
}

unleash_edgeFilterScope = unleash.edge.cache -> unleash.edge.tokens "Reads authorized projects and environment" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeFilterScope"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-cache/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-filters/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-auth/src/token_validator.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-appstate/src/edge_token_extractor.rs\"]"
    }
}

unleash_edgeEvaluationScope = unleash.edge.evaluation -> unleash.edge.tokens "Reads token scope for engine selection" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeEvaluationScope"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-frontend-api/src/frontend.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-types/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-auth/src/token_validator.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-appstate/src/edge_token_extractor.rs\"]"
    }
}

unleash_edgeReadyCache = unleash.edge.health -> unleash.edge.cache "Inspects cache state for readiness" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeReadyCache"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-backstage/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-metrics/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-cache/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-filters/src/lib.rs\"]"
    }
}

unleash_edgeTokenUpstream = unleash.edge.tokens -> unleash.edge.upstream "Validates and revalidates token batches" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeTokenUpstream"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-auth/src/token_validator.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-appstate/src/edge_token_extractor.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-http-client/src/lib.rs\"]"
    }
}

unleash_edgeTokenRefresh = unleash.edge.tokens -> unleash.edge.refresh "Registers validated scopes for feature refresh" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeTokenRefresh"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-auth/src/token_validator.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-appstate/src/edge_token_extractor.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-refresh/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\"]"
    }
}

unleash_edgePoll = unleash.edge.refresh -> unleash.edge.upstream "Fetches full configuration with conditional polling" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgePoll"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-refresh/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-http-client/src/lib.rs\"]"
    }
}

unleash_edgeRefreshCache = unleash.edge.refresh -> unleash.edge.cache "Updates scoped feature definitions" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeRefreshCache"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-refresh/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-cache/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-filters/src/lib.rs\"]"
    }
}

unleash_edgeRefreshEngine = unleash.edge.refresh -> unleash.edge.evaluation "Rebuilds evaluation state from refreshed features" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeRefreshEngine"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-refresh/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-frontend-api/src/frontend.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-types/src/lib.rs\"]"
    }
}

unleash_edgeSendUsage = unleash.edge.metrics -> unleash.edge.upstream "Sends aggregated registrations and usage batches" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeSendUsage"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/register.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/metrics.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-http-client/src/lib.rs\"]"
    }
}

unleash_edgeUpstreamFeatures = unleash.edge.upstream -> unleash.server "Calls the Client API for feature configuration" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeUpstreamFeatures"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-http-client/src/lib.rs\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\"]"
    }
}

unleash_edgeUpstreamTokens = unleash.edge.upstream -> unleash.server "Calls the Edge API to validate tokens" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeUpstreamTokens"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-http-client/src/lib.rs\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\"]"
    }
}

unleash_edgeUpstreamUsage = unleash.edge.upstream -> unleash.server "Posts SDK registration and usage batches" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeUpstreamUsage"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-http-client/src/lib.rs\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\"]"
    }
}

unleash_edgeTokenSnapshot = unleash.edge.tokens -> unleash.edge.persistence "Persists newly validated token metadata" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeTokenSnapshot"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-auth/src/token_validator.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-appstate/src/edge_token_extractor.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\"]"
    }
}

unleash_edgeSnapshotTokens = unleash.edge.persistence -> unleash.edge.tokens "Reads and restores validated-token snapshots" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeSnapshotTokens"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-auth/src/token_validator.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-appstate/src/edge_token_extractor.rs\"]"
    }
}

unleash_edgeSnapshotFeatures = unleash.edge.persistence -> unleash.edge.cache "Reads and restores feature snapshots" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeSnapshotFeatures"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-cache/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-filters/src/lib.rs\"]"
    }
}

unleash_edgeRecoveredEngine = unleash.edge.persistence -> unleash.edge.evaluation "Rebuilds engine state from recovered features" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeRecoveredEngine"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-frontend-api/src/frontend.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-types/src/lib.rs\"]"
    }
}

unleash_edgePersistenceFiles = unleash.edge.persistence -> unleash.files "Writes and reads local token/feature snapshots" "Filesystem / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgePersistenceFiles"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/file.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-offline/src/hotload.rs\"]"
    }
}

unleash_edgePersistenceRedis = unleash.edge.persistence -> unleash.redis "Writes and reads Redis token/feature snapshots" "Redis protocol / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgePersistenceRedis"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/redis.rs\"]"
    }
}

unleash_edgePersistenceS3 = unleash.edge.persistence -> unleash.s3 "Writes and reads S3 token/feature snapshots" "HTTPS / S3 API" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgePersistenceS3"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/s3.rs\"]"
    }
}

unleash_edgeOfflineFiles = unleash.edge.offline -> unleash.files "Reads and reloads offline bootstrap JSON" "Filesystem / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeOfflineFiles"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/offline_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-offline/src/hotload.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/file.rs\"]"
    }
}

unleash_edgeOfflineTokens = unleash.edge.offline -> unleash.edge.tokens "Seeds allowed offline tokens from configuration" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeOfflineTokens"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/offline_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-offline/src/hotload.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-auth/src/token_validator.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-appstate/src/edge_token_extractor.rs\"]"
    }
}

unleash_edgeOfflineCache = unleash.edge.offline -> unleash.edge.cache "Loads offline feature definitions into memory" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeOfflineCache"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/offline_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-offline/src/hotload.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-cache/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-filters/src/lib.rs\"]"
    }
}

unleash_edgeOfflineEngine = unleash.edge.offline -> unleash.edge.evaluation "Compiles offline feature evaluation state" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeOfflineEngine"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/offline_builder.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-offline/src/hotload.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-frontend-api/src/frontend.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-types/src/lib.rs\"]"
    }
}

unleash_edgeReadyTokens = unleash.edge.health -> unleash.edge.tokens "Inspects token state for readiness and diagnostics" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeReadyTokens"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-backstage/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-metrics/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-auth/src/token_validator.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-appstate/src/edge_token_extractor.rs\"]"
    }
}

unleash_edgeHealthMetrics = unleash.edge.health -> unleash.edge.metrics "Reads buffered usage diagnostics" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeHealthMetrics"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-backstage/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-metrics/src/lib.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/register.rs\",\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/metrics.rs\"]"
    }
}
