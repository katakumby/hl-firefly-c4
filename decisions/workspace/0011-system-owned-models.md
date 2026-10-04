# 11. Keep shared definitions and internal relationships with their system

Date: 2026-10-04

## Status

Accepted. Supersedes the directory-layout portion of
[decision 10](0010-scoped-folder-includes.md), retaining native folder imports and
declaration-before-reference ordering. Build tooling and CI behavior are unchanged.

## Context

Separating all system declarations from all container folders simplified native
imports but scattered a product's model across several trees. Architects primarily
work on the platform, while external product references remain useful for dependency
analysis and audit. Both need predictable navigation without generated import lists.

## Decision

Each external product owns `model/external-systems/<system>/00-system.dsl`, optional
`10-containers/` fragments and optional `20-relationships/` fragments. The system
file declares its boundary, metadata and ecosystem group. Each container fragment
uses `!element <system>` at model scope; components remain inside the container.
Internal relationships use fully qualified identifiers after their endpoints exist.

`model/platform/` uses those same phases directly: the platform is one software
system, not a collection of system folders. Until the platform definition is
approved, `00-system.dsl` contains comments only. Ignition's proposal stays local.

The root model includes people, external systems, the platform, then shared
`model/relationships/integrations/`. Numbered product phases preserve ordering;
fragments within a phase must be independent of sibling order. Recursive imports
read every file, so imported trees contain DSL only and do not re-include their
own descendants. Documentation stays outside these trees.

Shared platform C4 views stay under `views/platform/`. External-reference views
are grouped under `views/external-systems/` by scoped product; `overview` and
`security` hold cross-product diagrams. Moving files preserves view keys and bodies.
Generated paths follow the existing source-mirroring behavior.

Initiatives extend the shared model and may keep local definitions and views inline.
The starter defaults to that arrangement; extracting fragments is optional.
Existing workspace organization and documentation attachments remain unchanged.

Explicit references protect a view's required dependencies through native validation.
Generic big-picture views may use wildcards or selectors and intentionally change
membership. Humans review those artifact changes. Coordinated element and view
removal is valid; no new membership validator or merge policy is introduced.

## Consequences

Adding a shared product, container or relationship fragment requires no per-file
import changes. Approved promotion preserves identities and removes the corresponding
local definition in the same reviewed change. Catalog membership still does not
imply adoption by the platform.

Changing declaration order can change generated numeric IDs. Verify canonical
identities, hierarchy, relationships, views, styles and animation order against a
fresh baseline. Preserve saved snapshots and verify native layout merging without
rewriting them. Run containerized regressions and review fresh C4-PlantUML text
before the relevant DSL. Existing unrelated inspection findings remain separate.
