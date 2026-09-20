// Named internal flows. Request/response results are documented on the initiating arrow.
// Container and component projections describe the same exchanges at different C4 levels.

unleash_serverDatabase = unleash.server -> unleash.database "Reads and writes Unleash records and schema" "PostgreSQL wire protocol" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.serverDatabase"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/migrations\"]"
    }
}

unleash_adminAccess = unleash.server.adminApi -> unleash.server.identity "Checks user identity and resource permissions" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.adminAccess"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/openapi\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/oss-authentication.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/session-db.ts\"]"
    }
}

unleash_adminTokens = unleash.server.adminApi -> unleash.server.tokens "Manages tokens and checks API/PAT credentials" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.adminTokens"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/openapi\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/api-token-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/apitokencache\"]"
    }
}

unleash_adminFlags = unleash.server.adminApi -> unleash.server.flags "Queries and changes flags, projects and environments" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.adminFlags"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/openapi\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-toggle\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/project\"]"
    }
}

unleash_adminTargeting = unleash.server.adminApi -> unleash.server.targeting "Queries and changes targeting definitions" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.adminTargeting"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/openapi\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/strategy-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/segment\"]"
    }
}

unleash_adminTransfer = unleash.server.adminApi -> unleash.server.importExport "Validates import and export requests" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.adminTransfer"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/openapi\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/export-import-toggles\"]"
    }
}

unleash_identityStore = unleash.server.identity -> unleash.server.persistence "Reads and writes users, permissions and sessions" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.identityStore"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/oss-authentication.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/session-db.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\"]"
    }
}

unleash_tokenStore = unleash.server.tokens -> unleash.server.persistence "Reads and writes token records and scopes" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.tokenStore"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/api-token-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/apitokencache\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\"]"
    }
}

unleash_flagStore = unleash.server.flags -> unleash.server.persistence "Reads and writes feature configuration" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.flagStore"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-toggle\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/project\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\"]"
    }
}

unleash_targetingStore = unleash.server.targeting -> unleash.server.persistence "Reads and writes targeting resources" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.targetingStore"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/strategy-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/segment\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\"]"
    }
}

unleash_flagTargeting = unleash.server.flags -> unleash.server.targeting "Validates strategy and segment references" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.flagTargeting"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-toggle\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/project\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/strategy-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/segment\"]"
    }
}

unleash_flagAudit = unleash.server.flags -> unleash.server.audit "Records configuration change events" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.flagAudit"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-toggle\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/project\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/event-announcer-service.ts\"]"
    }
}

unleash_targetingAudit = unleash.server.targeting -> unleash.server.audit "Records targeting change events" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.targetingAudit"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/strategy-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/segment\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/event-announcer-service.ts\"]"
    }
}

unleash_identityAudit = unleash.server.identity -> unleash.server.audit "Records account and authentication events" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.identityAudit"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/oss-authentication.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/session-db.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/event-announcer-service.ts\"]"
    }
}

unleash_tokenAudit = unleash.server.tokens -> unleash.server.audit "Records token lifecycle events" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.tokenAudit"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/api-token-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/apitokencache\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/event-announcer-service.ts\"]"
    }
}

unleash_transferStore = unleash.server.importExport -> unleash.server.persistence "Reads exports and persists validated imports" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.transferStore"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/export-import-toggles\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\"]"
    }
}

unleash_transferAudit = unleash.server.importExport -> unleash.server.audit "Records imported configuration events" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.transferAudit"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/export-import-toggles\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/event-announcer-service.ts\"]"
    }
}

unleash_databaseAccess = unleash.server.persistence -> unleash.database "Executes queries, transactions and migrations" "PostgreSQL wire protocol" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.databaseAccess"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/migrations\"]"
    }
}

unleash_clientTokenCheck = unleash.server.clientApi -> unleash.server.tokens "Checks backend token type and scope" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.clientTokenCheck"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/client-api\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles/client-feature-toggle.controller.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/api-token-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/apitokencache\"]"
    }
}

unleash_frontendTokenCheck = unleash.server.frontendApi -> unleash.server.tokens "Checks frontend token type and scope" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.frontendTokenCheck"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-controller.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/api-token-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/apitokencache\"]"
    }
}

unleash_edgeTokenLookup = unleash.server.edgeApi -> unleash.server.tokens "Resolves valid tokens and authorized metadata" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.edgeTokenLookup"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/edge-api/index.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/edge-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/api-token-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/apitokencache\"]"
    }
}

unleash_clientProjection = unleash.server.clientApi -> unleash.server.configuration "Builds scoped client configuration responses" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.clientProjection"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/client-api\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles/client-feature-toggle.controller.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/global-frontend-api-cache.ts\"]"
    }
}

unleash_projectionStore = unleash.server.configuration -> unleash.server.persistence "Reads feature payloads, segments and revisions" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.projectionStore"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/global-frontend-api-cache.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\"]"
    }
}

unleash_frontendEvaluate = unleash.server.frontendApi -> unleash.server.evaluation "Evaluates context and returns enabled flags" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.frontendEvaluate"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-controller.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-repository.ts\"]"
    }
}

unleash_evaluationConfiguration = unleash.server.evaluation -> unleash.server.configuration "Reads token-scoped definitions and segments" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.evaluationConfiguration"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-repository.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/global-frontend-api-cache.ts\"]"
    }
}

unleash_clientUsage = unleash.server.clientApi -> unleash.server.metrics "Registers SDKs and accepts usage buckets" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.clientUsage"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/client-api\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles/client-feature-toggle.controller.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/instance\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/client-metrics\"]"
    }
}

unleash_frontendUsage = unleash.server.frontendApi -> unleash.server.metrics "Records frontend SDK usage and registration" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.frontendUsage"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-controller.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/instance\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/client-metrics\"]"
    }
}

unleash_metricsStore = unleash.server.metrics -> unleash.server.persistence "Persists registrations and aggregated usage" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.metricsStore"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/instance\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/client-metrics\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\"]"
    }
}

unleash_adminHistory = unleash.server.adminApi -> unleash.server.audit "Queries audit history" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.adminHistory"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/openapi\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/event-announcer-service.ts\"]"
    }
}

unleash_adminInsights = unleash.server.adminApi -> unleash.server.insights "Queries reports and changes lifecycle completion" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.adminInsights"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-lifecycle/feature-lifecycle-controller.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-lifecycle/feature-lifecycle-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/project-insights/project-insights-controller.ts\"]"
    }
}

unleash_adminUsage = unleash.server.adminApi -> unleash.server.metrics "Queries applications and usage summaries" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.adminUsage"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/openapi\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/instance\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/client-metrics\"]"
    }
}

unleash_adminPlayground = unleash.server.adminApi -> unleash.server.evaluation "Submits playground context for evaluation" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.adminPlayground"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/openapi\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-repository.ts\"]"
    }
}

unleash_playgroundFlags = unleash.server.evaluation -> unleash.server.flags "Loads playground feature definitions" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.playgroundFlags"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-repository.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-toggle\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/project\"]"
    }
}

unleash_playgroundSegments = unleash.server.evaluation -> unleash.server.persistence "Reads playground segments and project access" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.playgroundSegments"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-repository.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\"]"
    }
}

unleash_adminAddons = unleash.server.adminApi -> unleash.server.addons "Manages add-on configuration and notification actions" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.adminAddons"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/openapi\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/addon-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/addons\"]"
    }
}

unleash_adminSettings = unleash.server.adminApi -> unleash.server.jobs "Reads and updates instance settings" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.adminSettings"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/openapi\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler\"]"
    }
}

unleash_insightsStore = unleash.server.insights -> unleash.server.persistence "Reads reporting data and persists lifecycle state" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.insightsStore"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-lifecycle/feature-lifecycle-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-lifecycle/feature-lifecycle-store.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/project-health-service.ts\"]"
    }
}

unleash_auditStore = unleash.server.audit -> unleash.server.persistence "Stores events and reads publication state" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.auditStore"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/event-announcer-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\"]"
    }
}

unleash_auditAddons = unleash.server.audit -> unleash.server.addons "Publishes recorded events to configured handlers" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.auditAddons"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/event-announcer-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/addon-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/addons\"]"
    }
}

unleash_addonStore = unleash.server.addons -> unleash.server.persistence "Reads handler configuration and records outcomes" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.addonStore"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/addon-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/addons\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\"]"
    }
}

unleash_addonAudit = unleash.server.addons -> unleash.server.audit "Records add-on configuration changes" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.addonAudit"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/addon-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/addons\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/event-announcer-service.ts\"]"
    }
}

unleash_identityNotification = unleash.server.identity -> unleash.server.addons "Prepares account and password-reset notifications" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.identityNotification"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/oss-authentication.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/session-db.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/addon-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/addons\"]"
    }
}

unleash_settingsStore = unleash.server.jobs -> unleash.server.persistence "Reads settings and performs maintenance writes" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.settingsStore"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\"]"
    }
}

unleash_jobRevision = unleash.server.jobs -> unleash.server.configuration "Schedules revision checks and cache refresh" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.jobRevision"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/global-frontend-api-cache.ts\"]"
    }
}

unleash_jobPublication = unleash.server.jobs -> unleash.server.audit "Schedules unannounced-event publication" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.jobPublication"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/event-announcer-service.ts\"]"
    }
}

unleash_jobMetrics = unleash.server.jobs -> unleash.server.metrics "Schedules metric flush, aggregation and retention" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.jobMetrics"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/instance\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/client-metrics\"]"
    }
}

unleash_jobInsights = unleash.server.jobs -> unleash.server.insights "Schedules project health calculations" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.jobInsights"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler/schedule-services.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/project-health-service.ts\"]"
    }
}

unleash_jobTokens = unleash.server.jobs -> unleash.server.tokens "Refreshes token caches and expires token data" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.jobTokens"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/api-token-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/apitokencache\"]"
    }
}

unleash_jobIdentity = unleash.server.jobs -> unleash.server.identity "Schedules account activity updates" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.jobIdentity"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/oss-authentication.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/session-db.ts\"]"
    }
}

unleash_healthStore = unleash.server.health -> unleash.server.persistence "Checks database readiness and observes SQL metrics" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.healthStore"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/health-check.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/ready-check.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\"]"
    }
}

unleash_jobMeasurements = unleash.server.jobs -> unleash.server.health "Publishes job execution measurements" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.jobMeasurements"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/health-check.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/ready-check.ts\"]"
    }
}

unleash_jobFlagMaintenance = unleash.server.jobs -> unleash.server.flags "Updates stale flags and project status" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.jobFlagMaintenance"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-toggle\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/project\"]"
    }
}

unleash_jobFrontendSettings = unleash.server.jobs -> unleash.server.evaluation "Refreshes cached frontend evaluation settings" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.jobFrontendSettings"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-repository.ts\"]"
    }
}

unleash_evaluationSettings = unleash.server.evaluation -> unleash.server.jobs "Reads frontend evaluation settings" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.evaluationSettings"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-repository.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler\"]"
    }
}

unleash_jobAddonCleanup = unleash.server.jobs -> unleash.server.addons "Schedules handler-outcome retention cleanup" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.jobAddonCleanup"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/addon-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/addons\"]"
    }
}

unleash_healthEvaluation = unleash.server.health -> unleash.server.evaluation "Checks frontend configuration-cache readiness" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.healthEvaluation"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/health-check.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/ready-check.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-repository.ts\"]"
    }
}

unleash_metricsLifecycle = unleash.server.metrics -> unleash.server.insights "Publishes persisted usage for lifecycle transitions" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.metricsLifecycle"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/client-metrics/metrics-service-v2.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-lifecycle/feature-lifecycle-service.ts\"]"
    }
}

unleash_auditLifecycle = unleash.server.audit -> unleash.server.insights "Publishes flag events for lifecycle transitions" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.auditLifecycle"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-lifecycle/feature-lifecycle-service.ts\"]"
    }
}

unleash_lifecycleAudit = unleash.server.insights -> unleash.server.audit "Records flag completion and reversal events" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.lifecycleAudit"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-lifecycle/feature-lifecycle-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-lifecycle/feature-lifecycle-controller.ts\"]"
    }
}

unleash_lifecycleMeasurements = unleash.server.insights -> unleash.server.health "Publishes lifecycle stage-entry measurements" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.lifecycleMeasurements"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-lifecycle/feature-lifecycle-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/metrics.ts\"]"
    }
}
