!element unleash {
    server = container "Unleash server" "Hosts OSS administration, configuration delivery, evaluation and background services." "Node.js / TypeScript / Express" {
        url "https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts"
        properties {
            "architecture.id" "unleash.server"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\"]"
        }

        assets = component "Static asset hosting" "Serves the Admin UI entry document and bundled browser assets." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts"
            properties {
                "architecture.id" "unleash.server.assets"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/index.js\"]"
            }
        }

        adminApi = component "Admin API" "Validates management and reporting requests and routes them to domain services." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api"
            properties {
                "architecture.id" "unleash.server.adminApi"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/openapi\"]"
            }
        }

        clientApi = component "Client API" "Serves full feature configurations and accepts SDK registration and usage metrics." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/client-api"
            properties {
                "architecture.id" "unleash.server.clientApi"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/client-api\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles/client-feature-toggle.controller.ts\"]"
            }
        }

        frontendApi = component "Frontend API" "Accepts evaluation context and returns evaluated enabled flags and variants; accepts usage metrics." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-controller.ts"
            properties {
                "architecture.id" "unleash.server.frontendApi"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-controller.ts\"]"
            }
        }

        edgeApi = component "Edge API" "Validates SDK tokens for Edge and returns authorized token metadata." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/edge-api/index.ts"
            properties {
                "architecture.id" "unleash.server.edgeApi"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/edge-api/index.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/edge-service.ts\"]"
            }
        }

        identity = component "Users, sessions and access" "Authenticates local users and applies OSS permissions; manages sessions and user records." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/oss-authentication.ts"
            properties {
                "architecture.id" "unleash.server.identity"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/oss-authentication.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/session-db.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/rbac-middleware.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/user-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/access-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/account-service.ts\"]"
            }
        }

        tokens = component "API-token management" "Creates and validates API tokens and caches their environment and project scopes." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/api-token-service.ts"
            properties {
                "architecture.id" "unleash.server.tokens"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/api-token-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/apitokencache\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/apitokensv2\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/api-token-middleware.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/pat\"]"
            }
        }

        flags = component "Flags, projects and environments" "Manages flag state, variants, metadata and project/environment configuration." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-toggle"
            properties {
                "architecture.id" "unleash.server.flags"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-toggle\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/project\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/project-environments\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/tag-service.ts\"]"
            }
        }

        targeting = component "Targeting configuration" "Manages strategy definitions, segments, context fields and constraints used by flag strategies." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/strategy-service.ts"
            properties {
                "architecture.id" "unleash.server.targeting"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/strategy-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/segment\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/context\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/constraints\"]"
            }
        }

        configuration = component "Configuration projection and cache" "Builds scoped client payloads; tracks revisions and caches frontend configuration in memory." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles"
            properties {
                "architecture.id" "unleash.server.configuration"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/global-frontend-api-cache.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-toggle/configuration-revision-service.ts\"]"
            }
        }

        evaluation = component "Frontend and playground evaluation" "Evaluates strategy and variant rules using embedded unleash-client and playground logic." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-service.ts"
            properties {
                "architecture.id" "unleash.server.evaluation"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-service.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-repository.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/playground/playground-service.ts\"]"
            }
        }

        metrics = component "SDK registration and metrics" "Tracks applications and instances; buffers, aggregates and stores flag and variant usage." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/instance"
            properties {
                "architecture.id" "unleash.server.metrics"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/instance\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/client-metrics\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/last-seen\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/unknown-flags\"]"
            }
        }

        insights = component "Lifecycle and insights" "Updates flag lifecycle from metrics and audit events; supplies OSS usage and project health reports." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-lifecycle"
            properties {
                "architecture.id" "unleash.server.insights"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-lifecycle\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/project-insights\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/personal-dashboard\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/project-health-service.ts\"]"
            }
        }

        audit = component "Audit events and publication" "Stores audit history and publishes recorded events to in-process subscribers." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events"
            properties {
                "architecture.id" "unleash.server.audit"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/event-announcer-service.ts\"]"
            }
        }

        importExport = component "Import and export" "Transfers flag configuration and validates references to existing segments and custom strategies." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/export-import-toggles"
            properties {
                "architecture.id" "unleash.server.importExport"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/export-import-toggles\"]"
            }
        }

        addons = component "Add-ons and notifications" "Filters audit events for configured handlers and prepares notifications; recipients are outside this model." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/addon-service.ts"
            properties {
                "architecture.id" "unleash.server.addons"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/addon-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/addons\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/email-service.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/integration-events\"]"
            }
        }

        jobs = component "Settings and background jobs" "Loads settings and schedules cache refresh, event publication, aggregation and maintenance." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings"
            properties {
                "architecture.id" "unleash.server.jobs"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/maintenance\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/create-config.ts\"]"
            }
        }

        health = component "Health and operational metrics" "Reports process/database readiness and gathers HTTP, database and scheduler measurements." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/health-check.ts"
            properties {
                "architecture.id" "unleash.server.health"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/health-check.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/ready-check.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/metrics.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/backstage.ts\"]"
            }
        }

        persistence = component "Persistence and migrations" "Groups Knex stores, read models, sessions and schema migration access to PostgreSQL." "TypeScript / Node.js" {
            url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db"
            properties {
                "architecture.id" "unleash.server.persistence"
                "evidence" "Implementation; logical C4 grouping"
                "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-toggle/feature-toggle-store.ts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/migrations\"]"
            }
        }
    }
}
