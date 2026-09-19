# 7. Author modular DSL and isolate initiative proposals

Date: 2026-09-19

## Status

Accepted. Supersedes the generated-model and single-entrypoint portions of
[decision 5](0005-single-workspace.md) and the pipeline arrangement in
[decision 3](0003-inspection-policy.md). Relationship-selection and
inspection-quality principles remain applicable.

[Decision 8](0008-provenance-and-isolated-runs.md) strengthens provenance checks
and defines isolated artifact publication and transactional evidence refresh.

## Decision

The shared model is an extendable DSL workspace with ordered local includes
and shared styles, without authored diagrams. `architecture/workspace.dsl` selects the
full reference catalog. Initiatives inherit that model and select focused
views, while keeping proposed additions local.

DSL is the source of truth. Element and relationship properties retain source
URLs and evidence classifications. Fresh parsed JSON, catalogs, coverage,
reports and previews go into ignored `build/architecture/` paths. Validation and preview
never regenerate authored DSL.

Reference validation checks full coverage and domain/security semantics.
Initiative validation checks selected views without requiring inherited reference
elements to be visible. Only the initial `ignition-dapp-platform-context`
view may contain the unconnected proposed `dapp_platform` boundary.
Unrelated disconnected diagrams remain invalid.

Existing scope advisories remain informational. Any additional inspection
adjustment must name its exact category and apply only where needed;
unrelated findings fail validation.

Ignition sets `model.element.noview` to informational on inherited reference
elements before declaring its own model. Only `dapp_platform` sets
`model.element.disconnected` to informational. These findings remain visible
in the full inspection log and are covered by semantic validation.

## Consequences

Architects edit individual systems, relationships and views independently.
Epic view keys use the epic ID prefix. Promotion moves definitions into shared
modules and preserves identifiers. Shared changes validate all initiatives.
Interim and target variants are created only for distinct designs and extend
their epic workspace additively.

Architecture decisions belong in `decisions/adr`; authoring/tooling decisions
belong here. Routine notes belong in documentation or initiative READMEs.
Named ownership enforcement is deferred until team identities are known.
