# Unleash reference boundary and components

This is a reusable C4 reference for Unleash **8.2.0** and optional open-source
Unleash Edge **20.5.0**. It is available through the shared model; no initiative
has adopted it or selected consumer integrations.

Containers are execution or data-store boundaries, not a list of Docker images.
The Admin UI executes in the browser even though the Unleash server serves its
assets. The server's embedded `unleash-client` evaluation library and Edge's
Yggdrasil engine are components, not separately deployed SDK services.
PostgreSQL is the server's durable system of record. Feature, token, engine and
query caches remain inside their runtime.

## Optional Edge and storage

Edge belongs to the Unleash product reference boundary. It is optional; the
server also exposes Client and Frontend APIs directly. Edge online mode polls
the server; offline mode reads feature JSON and startup-configured tokens without
an upstream connection. These modes share one container definition.

File, Redis and S3 snapshot stores are alternative Unleash-owned logical storage
boundaries. Their presence is capability coverage, not a choice to deploy all
three. A configured persistence backend supports recovery; it is not a second
authoritative configuration database. Local offline bootstrap files and online
recovery snapshots have different roles even though both use the filesystem.
Redis persistence mode, S3 access, physical hosting, replication and backup
topology are deliberately unspecified. S3 requires a build with its persistence
feature enabled (enabled by default in the pinned Edge package).

Consumer SDKs and their applications are outside the model. Their existing
protocol contracts are described in [the interface inventory](02-interfaces-and-flows.md).
Backend SDKs evaluate full configuration locally; frontend SDKs receive evaluated
results from the server or Edge. No application, identity provider, notification
recipient or monitoring system has been added.

## Edition and abstraction

Component names group cohesive runtime responsibilities; they are not a promise
that every file in a linked source directory is enabled in OSS. Shared source
also contains gated Enterprise functions. This catalog excludes Enterprise
streaming/delta synchronization, change requests, release-plan automation,
Enterprise SSO/SCIM and commercial dashboards. It models local authentication
and the OSS portions of management, reporting, targeting and evaluation.
Built-in add-on and email preparation is represented only inside Unleash.

Open-source Edge is in long-term maintenance with announced end-of-life on
**December 31, 2026**. This is evidence metadata, not a recommendation to adopt or
replace it. See [feature availability](https://docs.getunleash.io/support/availability)
and the [pinned Edge README](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/README.md).

All relationships are explicit because the shared model disables implied
relationships. The isolated system boundary has the same narrowly scoped
informational disconnected-element inspection policy used for an intentionally
unconnected reference. A system-only informational no-view setting covers the
absence of a context/landscape node: Unleash is rendered as the boundary of the
container views. Its internal containers/components remain fully connected and
must appear in views.
No deployment view or deployment definition is included.

## Container inventory

| Stable identifier | Container | Technology | Responsibility |
|---|---|---|---|
| `unleash.ui` | Admin UI | React / TypeScript / browser | Runs management screens in the browser; the server distributes its static assets. |
| `unleash.server` | Unleash server | Node.js / TypeScript / Express | Hosts OSS administration, configuration delivery, evaluation and background services. |
| `unleash.database` | Unleash PostgreSQL | PostgreSQL / Knex | Stores configuration, user/session/token records, audit history, registrations and aggregated usage. |
| `unleash.edge` | Unleash Edge (OSS, optional) | Rust / Axum / Tokio | Caches configuration and evaluates frontend requests; online polling or offline file mode. |
| `unleash.files` | Edge files (optional) | Filesystem / JSON | Stores local feature/token snapshots or offline bootstrap JSON; these are distinct file roles. |
| `unleash.redis` | Edge Redis storage (optional) | Redis / serialized JSON | Stores feature/token recovery snapshots; an alternative to file or S3 persistence. |
| `unleash.s3` | Edge S3 storage (optional) | Amazon S3 API / JSON objects | Stores feature/token recovery snapshots; an alternative to file or Redis persistence. |

## Component-to-source map

All links below use immutable commits. Stores/read models owned by domain
services are grouped under persistence; they are not invented PostgreSQL internals.
The domain services call them directly in code; no new runtime persistence service
or network hop is implied.

### Admin UI

| Identifier | Component and responsibility | Implementation evidence |
|---|---|---|
| `unleash.ui.shell` | **Application shell and session.** Routes screens and shares authenticated user, permissions and UI configuration. | [frontend/src/ApplicationRoot.tsx](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/ApplicationRoot.tsx); [frontend/src/component/App.tsx](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/App.tsx); [frontend/src/contexts](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/contexts); [frontend/src/component/providers](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/providers) |
| `unleash.ui.flags` | **Flag and project screens.** Edits flags, strategies, variants, segments, context fields, projects and environments. | [frontend/src/component/feature](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/feature); [frontend/src/component/project](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/project); [frontend/src/component/segments](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/segments); [frontend/src/component/context](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/context); [frontend/src/component/strategies](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/strategies); [frontend/src/component/environments](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/environments) |
| `unleash.ui.admin` | **Administration screens.** Manages OSS user, token, settings, import/export and add-on configuration. | [frontend/src/component/admin](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/admin); [frontend/src/component/user](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/user); [frontend/src/component/integrations](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/integrations) |
| `unleash.ui.reports` | **Reporting and playground screens.** Displays audit history, SDK usage and lifecycle insights; submits evaluation experiments. | [frontend/src/component/events](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/events); [frontend/src/component/application](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/application); [frontend/src/component/insights](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/insights); [frontend/src/component/playground](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/playground); [frontend/src/component/personalDashboard](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/personalDashboard) |
| `unleash.ui.api` | **API clients and query cache.** Sends authenticated requests and caches or invalidates resource queries after mutations. | [frontend/src/hooks/api](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/hooks/api); [frontend/src/openapi](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/openapi); [frontend/src/hooks/useClearSWRCache.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/hooks/useClearSWRCache.ts) |

### Unleash server

| Identifier | Component and responsibility | Implementation evidence |
|---|---|---|
| `unleash.server.assets` | **Static asset hosting.** Serves the Admin UI entry document and bundled browser assets. | [src/lib/app.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts); [frontend/index.js](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/index.js) |
| `unleash.server.adminApi` | **Admin API.** Validates management and reporting requests and routes them to domain services. | [src/lib/routes/admin-api](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api); [src/lib/openapi](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/openapi) |
| `unleash.server.clientApi` | **Client API.** Serves full feature configurations and accepts SDK registration and usage metrics. | [src/lib/routes/client-api](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/client-api); [src/lib/features/client-feature-toggles/client-feature-toggle.controller.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles/client-feature-toggle.controller.ts) |
| `unleash.server.frontendApi` | **Frontend API.** Accepts evaluation context and returns evaluated enabled flags and variants; accepts usage metrics. | [src/lib/features/frontend-api/frontend-api-controller.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-controller.ts) |
| `unleash.server.edgeApi` | **Edge API.** Validates SDK tokens for Edge and returns authorized token metadata. | [src/lib/routes/edge-api/index.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/edge-api/index.ts); [src/lib/services/edge-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/edge-service.ts) |
| `unleash.server.identity` | **Users, sessions and access.** Authenticates local users and applies OSS permissions; manages sessions and user records. | [src/lib/middleware/oss-authentication.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/oss-authentication.ts); [src/lib/middleware/session-db.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/session-db.ts); [src/lib/middleware/rbac-middleware.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/rbac-middleware.ts); [src/lib/services/user-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/user-service.ts); [src/lib/services/access-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/access-service.ts); [src/lib/services/account-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/account-service.ts) |
| `unleash.server.tokens` | **API-token management.** Creates and validates API tokens and caches their environment and project scopes. | [src/lib/services/api-token-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/api-token-service.ts); [src/lib/features/apitokencache](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/apitokencache); [src/lib/features/apitokensv2](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/apitokensv2); [src/lib/middleware/api-token-middleware.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/api-token-middleware.ts); [src/lib/features/pat](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/pat) |
| `unleash.server.flags` | **Flags, projects and environments.** Manages flag state, variants, dependencies, metadata and project/environment configuration. | [src/lib/features/feature-toggle](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-toggle); [src/lib/features/project](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/project); [src/lib/features/project-environments](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/project-environments); [src/lib/features/dependent-features](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/dependent-features); [src/lib/services/tag-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/tag-service.ts) |
| `unleash.server.targeting` | **Targeting configuration.** Manages strategy definitions, segments, context fields and constraints used by flag strategies. | [src/lib/services/strategy-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/strategy-service.ts); [src/lib/features/segment](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/segment); [src/lib/features/context](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/context); [src/lib/features/constraints](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/constraints) |
| `unleash.server.configuration` | **Configuration projection and cache.** Builds scoped client payloads; tracks revisions and caches frontend configuration in memory. | [src/lib/features/client-feature-toggles](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/client-feature-toggles); [src/lib/features/frontend-api/global-frontend-api-cache.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/global-frontend-api-cache.ts); [src/lib/features/feature-toggle/configuration-revision-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-toggle/configuration-revision-service.ts) |
| `unleash.server.evaluation` | **Frontend and playground evaluation.** Evaluates strategy and variant rules using embedded unleash-client and playground logic. | [src/lib/features/frontend-api/frontend-api-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-service.ts); [src/lib/features/frontend-api/frontend-api-repository.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/frontend-api/frontend-api-repository.ts); [src/lib/features/playground/playground-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/playground/playground-service.ts) |
| `unleash.server.metrics` | **SDK registration and metrics.** Tracks applications and instances; buffers, aggregates and stores flag and variant usage. | [src/lib/features/metrics/instance](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/instance); [src/lib/features/metrics/client-metrics](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/client-metrics); [src/lib/features/metrics/last-seen](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/last-seen); [src/lib/features/metrics/unknown-flags](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/metrics/unknown-flags) |
| `unleash.server.insights` | **Lifecycle and insights.** Reads flag lifecycle, usage and project health data for OSS dashboards and stale-flag insights. | [src/lib/features/feature-lifecycle](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-lifecycle); [src/lib/features/project-insights](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/project-insights); [src/lib/features/personal-dashboard](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/personal-dashboard); [src/lib/services/project-health-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/project-health-service.ts) |
| `unleash.server.audit` | **Audit events and publication.** Stores audit history and publishes recorded events to in-process subscribers. | [src/lib/features/events](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events); [src/lib/services/event-announcer-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/event-announcer-service.ts) |
| `unleash.server.importExport` | **Import and export.** Validates and transfers supported flag, strategy, segment and project configuration. | [src/lib/features/export-import-toggles](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/export-import-toggles) |
| `unleash.server.addons` | **Add-ons and notifications.** Filters audit events for configured handlers and prepares notifications; recipients are outside this model. | [src/lib/services/addon-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/addon-service.ts); [src/lib/addons](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/addons); [src/lib/services/email-service.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/services/email-service.ts); [src/lib/features/integration-events](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/integration-events) |
| `unleash.server.jobs` | **Settings and background jobs.** Loads settings and schedules cache refresh, event publication, aggregation and maintenance. | [src/lib/features/settings](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/settings); [src/lib/features/scheduler](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/scheduler); [src/lib/features/maintenance](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/maintenance); [src/lib/create-config.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/create-config.ts) |
| `unleash.server.health` | **Health and operational metrics.** Reports process/database readiness and gathers HTTP, database and scheduler measurements. | [src/lib/routes/health-check.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/health-check.ts); [src/lib/routes/ready-check.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/ready-check.ts); [src/lib/metrics.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/metrics.ts); [src/lib/routes/backstage.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/backstage.ts) |
| `unleash.server.persistence` | **Persistence and migrations.** Groups Knex stores, read models, sessions and schema migration access to PostgreSQL. | [src/lib/db](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db); [src/lib/features/events/event-store.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/events/event-store.ts); [src/lib/features/feature-toggle/feature-toggle-store.ts](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/features/feature-toggle/feature-toggle-store.ts); [src/migrations](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/migrations) |

### Unleash PostgreSQL

This is a data-store container with no application components. Evidence: [src/lib/db](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/db), [src/migrations](https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/migrations), [docker-compose.yml](https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/docker-compose.yml).

### Unleash Edge (OSS, optional)

| Identifier | Component and responsibility | Implementation evidence |
|---|---|---|
| `unleash.edge.http` | **HTTP endpoints.** Exposes Client, Frontend, Edge validation and operational routes with request middleware. | [crates/oss/unleash-edge/src/lib.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/lib.rs); [crates/oss/unleash-edge-client-api/src/lib.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/lib.rs); [crates/oss/unleash-edge-frontend-api/src/lib.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-frontend-api/src/lib.rs); [crates/oss/unleash-edge-edge-api/src/lib.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-edge-api/src/lib.rs) |
| `unleash.edge.tokens` | **Token validation and cache.** Validates tokens upstream or against offline configuration and caches authorized scopes. | [crates/oss/unleash-edge-auth/src/token_validator.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-auth/src/token_validator.rs); [crates/oss/unleash-edge-appstate/src/edge_token_extractor.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-appstate/src/edge_token_extractor.rs) |
| `unleash.edge.upstream` | **Upstream HTTP client.** Fetches full feature payloads, validates tokens and posts registration/metric batches. | [crates/oss/unleash-edge-http-client/src/lib.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-http-client/src/lib.rs) |
| `unleash.edge.refresh` | **Polling and refresh.** Hydrates scoped configuration and periodically refreshes features and compiled evaluation state. | [crates/oss/unleash-edge-feature-refresh/src/lib.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-refresh/src/lib.rs); [crates/oss/unleash-edge/src/edge_builder.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs) |
| `unleash.edge.cache` | **Feature cache and filtering.** Stores in-memory feature payloads and applies token, environment and request filters. | [crates/oss/unleash-edge-feature-cache/src/lib.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-cache/src/lib.rs); [crates/oss/unleash-edge-feature-filters/src/lib.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-feature-filters/src/lib.rs) |
| `unleash.edge.evaluation` | **Evaluation engine.** Evaluates context against compiled strategies and returns enabled flags and variants. | [crates/oss/unleash-edge-frontend-api/src/frontend.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-frontend-api/src/frontend.rs); [crates/oss/unleash-edge-types/src/lib.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-types/src/lib.rs) |
| `unleash.edge.metrics` | **Registration and metrics aggregation.** Buffers SDK registrations and flag/variant counts, batches them and forwards usage upstream. | [crates/oss/unleash-edge-client-api/src/register.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/register.rs); [crates/oss/unleash-edge-client-api/src/metrics.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-client-api/src/metrics.rs); [crates/oss/unleash-edge-metrics/src/send_unleash_metrics.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-metrics/src/send_unleash_metrics.rs) |
| `unleash.edge.persistence` | **Snapshot persistence and recovery.** Saves validated tokens and feature snapshots; restores caches using a configured backend. | [crates/oss/unleash-edge-persistence/src/lib.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/lib.rs); [crates/oss/unleash-edge/src/edge_builder.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/edge_builder.rs) |
| `unleash.edge.offline` | **Offline bootstrap and reload.** Loads local feature JSON and configured tokens; optionally reloads file changes without upstream calls. | [crates/oss/unleash-edge/src/offline_builder.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge/src/offline_builder.rs); [crates/oss/unleash-edge-offline/src/hotload.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-offline/src/hotload.rs) |
| `unleash.edge.health` | **Health and operational metrics.** Exposes readiness and health, and measures requests, refresh and metric delivery. | [crates/oss/unleash-edge-backstage/src/lib.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-backstage/src/lib.rs); [crates/oss/unleash-edge-metrics/src/lib.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-metrics/src/lib.rs); [crates/oss/unleash-edge-request-logger/src/lib.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-request-logger/src/lib.rs) |

### Edge files (optional)

This is a data-store container with no application components. Evidence: [crates/oss/unleash-edge-persistence/src/file.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/file.rs), [crates/oss/unleash-edge-offline/src/hotload.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-offline/src/hotload.rs).

### Edge Redis storage (optional)

This is a data-store container with no application components. Evidence: [crates/oss/unleash-edge-persistence/src/redis.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/redis.rs).

### Edge S3 storage (optional)

This is a data-store container with no application components. Evidence: [crates/oss/unleash-edge-persistence/src/s3.rs](https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/s3.rs).

## Reference views

- `110-unleash-containers`: Unleash: core and optional Edge.
- `110-unleash-storage-alternatives`: Unleash Edge: storage alternatives.
- `110-unleash-ui-components`: Unleash Admin UI.
- `110-unleash-server-administration`: Unleash server: administration.
- `110-unleash-server-configuration-delivery`: Unleash server: configuration delivery.
- `110-unleash-server-supporting-services`: Unleash server: supporting services.
- `110-unleash-edge-request-processing`: Unleash Edge: request processing.
- `110-unleash-edge-synchronization-recovery`: Unleash Edge: synchronization and recovery.

See [interfaces and all named flows](02-interfaces-and-flows.md) and
[behavior, failure modes and evidence](03-behavior-and-evidence.md).
