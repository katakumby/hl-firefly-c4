# Unleash behavior, failure modes and evidence

## Configuration changes and audit publication

The browser's query layer submits authenticated Admin API commands. The API
applies permission checks and delegates to flag/project/environment or targeting
services. Those services validate resources and use stores/read models to access
PostgreSQL. Audit events record the actor and change.

Mutations and event writes share a transaction where the pinned service does so;
the model does not claim that every multi-step operation or import is one atomic
transaction. The event announcer periodically publishes persisted unannounced
events to in-process subscribers. Add-on handlers filter them using configured
event, project and environment selectors. Handler preparation and outcome
records are included; no recipient, SMTP provider, webhook target or other system
is selected. In-process publication is not a durable message broker.

Relevant flows: `adminFlags`, `adminTargeting`, `flagStore`,
`targetingStore`, `flagAudit`, `targetingAudit`, `auditStore`,
`jobPublication`, `auditAddons`, `addonStore`.

## Configuration distribution and evaluation

The server's revision service reads persisted event revision IDs. Scheduled
revision updates cause its frontend configuration cache to reload feature and
segment read models. The frontend evaluator uses an embedded `unleash-client`
repository backed by this cache. Client API requests return full configuration
scoped by token, environment and project; they do not evaluate end-user context.

Frontend API requests supply context to the server evaluator and return evaluated
enabled flags/variants. The playground is a separate administrative evaluation
path inside the same logical evaluation component: it loads feature definitions,
active segments and accessible projects, evaluates supplied context, and does
not change live configuration. It is not represented as a call through the
public Frontend API.

Relevant flows: `jobRevision`, `projectionStore`, `clientProjection`,
`frontendEvaluate`, `evaluationConfiguration`, `adminPlayground`,
`playgroundFlags`, `playgroundSegments`, `evaluationSettings`.

Online OSS Edge validates tokens with `/edge/validate` and polls
`/api/client/features` with backend tokens. Full responses hydrate its feature
cache and rebuild Yggdrasil engine state; conditional responses can leave existing
data unchanged. Edge Client API requests read filtered full configuration.
Frontend requests evaluate context locally in Edge and return results. That
context is not forwarded to the upstream Unleash server for evaluation.

The pinned OSS entrypoint explicitly sets both streaming and delta flags to
false. Shared source files and route definitions are not evidence that these
Enterprise modes are active. No SSE, streaming or delta synchronization
relationship is modeled.

Relevant flows: `edgeTokenUpstream`, `edgeTokenRefresh`, `edgePoll`,
`edgeRefreshCache`, `edgeRefreshEngine`, `edgeRequestFeatures`,
`edgeRequestEvaluation`, `edgeUpstreamFeatures`.

## Registration and usage

Server and Edge APIs accept application/instance registrations and aggregate
flag/variant counters. Edge groups data for upstream submission; the server
buffers and persists usage, maintains last-seen data, and calculates summaries.
UI reports therefore need not immediately reflect a just-accepted metric.

Metrics buffers are volatile. Edge's pinned sender retries network failures and
reinserts eligible batches on transient errors; invalid, unauthorized or
oversized batches can be dropped. Neither this model nor the snapshot stores
provide a durable metrics queue, exactly-once delivery or unlimited retention.
Recovery snapshots preserve configuration and validated tokens, not unsent
metric buffers. Offline mode has no upstream forwarding task.

Relevant flows: `edgeRequestUsage`, `edgeSendUsage`, `edgeUpstreamUsage`,
`clientUsage`, `frontendUsage`, `metricsStore`, `jobMetrics`,
`adminUsage`, `insightsStore`.

## Outages, recovery and readiness

- **Warm Edge, transient upstream failure:** Edge can continue serving its last
  successfully loaded configuration. Polling retries/backoff mean freshness
  degrades during the outage. Explicit authorization denial is different:
  refresh tokens can be removed and related feature/engine state cleared.
- **New or revoked tokens:** Cached authorized tokens and unknown tokens are
  different cases. Upstream unavailability does not authorize an unknown token.
  Revalidation can change or revoke cached scope; offline allowlists are an
  explicit startup configuration, not a fallback around online authorization.
- **Restart with configured snapshots:** The selected persistence adapter loads
  stored validated tokens and feature payloads into memory and rebuilds engine
  state. Successful recovery requires usable snapshot data. An empty, corrupt
  or inaccessible snapshot cannot guarantee operation during a simultaneous
  upstream outage.
- **No persistence:** A warm in-memory cache provides no guarantee after restart.
  File, Redis and S3 alternatives do not imply automatic fallback between
  backends, database replication, or a disaster-recovery design.
- **Offline startup/reload:** Tokens come from explicit configuration and feature
  definitions from local JSON. The bootstrap loader updates the feature and
  engine caches; configured reloads reread the file. Missing/invalid data is an
  error, not a successfully applied configuration. Offline bootstrap input is
  distinct from automatic online snapshot recovery.
- **Database outage:** Server writes and uncached reads can fail. The server
  `/ready` checks frontend-cache readiness and can also check PostgreSQL when
  `checkDbOnReady` is configured. Warm Edge behavior is separate from server
  database availability.
- **Edge readiness:** The pinned backstage handler inspects token and feature
  caches; specifically, nonempty token state with an empty feature cache is
  unready. This is a local check, not proof of upstream availability, fresh
  configuration or successful metric delivery.

Relevant flows: `edgeSnapshotTokens`, `edgeSnapshotFeatures`,
`edgeRecoveredEngine`, `edgePersistenceFiles`, `edgePersistenceRedis`,
`edgePersistenceS3`, `edgeOfflineFiles`, `edgeOfflineTokens`,
`edgeOfflineCache`, `edgeOfflineEngine`, `healthStore`,
`healthEvaluation`, `edgeReadyCache`, `edgeReadyTokens`.

## Evidence baseline

| Product | Release | Immutable revision |
|---|---|---|
| Unleash OSS | [8.2.0](https://github.com/Unleash/unleash/releases/tag/v8.2.0) | [`66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0`](https://github.com/Unleash/unleash/commit/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0) |
| Unleash Edge OSS | [20.5.0](https://github.com/Unleash/unleash-edge/releases/tag/unleash-edge-v20.5.0) | [`c947878de70214235c79eeb5ebe5f35b77ecc075`](https://github.com/Unleash/unleash-edge/commit/c947878de70214235c79eeb5ebe5f35b77ecc075) |

The [reference source inventory](../../../references/sources.json) records these
revisions and retrieval metadata. Element URLs and `architecture.sources`
provide module-level evidence; relationships retain their own evidence URLs.
The [component map](01-boundary-and-components.md) links every component to source.
The [flow catalog](02-interfaces-and-flows.md) documents every named relationship.

C4 grouping and flow aggregation are architectural interpretations of the pinned
implementation, not upstream declarations of these exact component boundaries.
No source-module-per-class inventory, generic database internals, external
integration proposal or hosting design is implied.

When updating this reference, review edition gates as well as source paths.
Validate all workspace entrypoints, export all eight `110-unleash-` views,
check component/relationship coverage and compare existing views against their
previous definitions. Generated JSON and rendered exports remain build artifacts.
