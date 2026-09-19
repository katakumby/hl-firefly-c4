# 8. Validate provenance and publish isolated runs

Date: 2026-09-19

## Status

Accepted. Refines [decision 7](0007-modular-workspaces.md) without changing the
reference architecture or ignition's initial proposal.

## Decision

Derive identity origins from freshly parsed workspace ancestry. Only shared
elements may use the missing-view informational policy. Every initiative-local
element remains subject to view coverage in its initiative and variants.
Validate local view prefixes and duplicate selections in all workspaces.
Independent definitions of the same identity across initiatives fail full
validation; inheritance of one definition remains valid. Shared-to-initiative
and unrelated initiative dependencies are forbidden.

The DApp disconnected-boundary exception belongs only to its ignition origin
and inherited variants. Remove the exception and evolve its assertions in the
same reviewed change that introduces actual design or shared promotion.

Every validation attempt owns a separate `runs/<run-id>/` artifact directory.
An atomically replaced `status.json` selects the latest attempt and last
success. Complete each run before publishing its selector; never overwrite
successful artifacts with failed-run reports. Preview uses a separate writable
runtime copy, labelled with its run. Compose resolves artifacts through the
wrapper and rejects stale inputs.

Parse DSL once and inspect the resulting JSON. Run shared checks once per
invocation and independent workspaces with bounded concurrency. Retain five
completed runs plus the last success and runs held by active managed previews.
Only completed runs owned by this store are eligible for retention cleanup.

Evidence refresh is explicit and transactional. Immutable document objects and
revision-specific archive snapshots precede inventory publication. Refresh
affected runtime/library bindings together and preserve unaffected records.
Validate fingerprints when caches are present, but allow absent ignored caches
on a clean checkout. Never refresh remote evidence during ordinary validation.

Keep presentation regression comparison separate from the semantic migration
catalog. Its baseline records the source revision and preserves style ordering,
layout settings, descriptions and authored properties. Normal validation does
not freeze legitimate future architecture decisions to this historical baseline.

## Consequences

Existing validation and preview interfaces remain available. Generated paths
change to isolated runs; old flat outputs remain historical. The Structurizr
pin has one source in `toolchain.env`. Relationship fragments are divided by
source ownership while their include entrypoints and semantics remain stable.

CI, new documentation validation and Mermaid rendering automation are outside
this change by user decision. Named ownership enforcement remains deferred.
