# 10. Load independent DSL fragments through scoped folder includes

Date: 2026-10-04

## Status

Accepted. Refines the ordered-include authoring guidance in
[decision 7](0007-modular-workspaces.md). DSL remains the authoring source, and
initiative proposals remain isolated from the shared model.

[Decision 11](0011-system-owned-models.md) supersedes the systems/containers
directory split below with system-owned model folders. Native recursive includes
and explicit declaration phases remain in use. The original decision text is retained.

## Context

The shared model had 43 includes, with more lists inside systems and relationship
entrypoints. Adding an independent fragment required maintaining those lists.
The installed Structurizr 2026.06.28 parser supports recursive directory includes,
reads files of every extension, and does not expand wildcard paths. Importing the
old mixed trees would load container fragments at model scope or relationships
twice through both a wrapper and directory traversal.

## Decision

Keep the root model's declaration phases explicit: people, the external system
catalog, then relationships. Styles retain their separate views-scope include.

Organize product references into two sibling directories by DSL scope:
`model/external-systems/systems/<system>.dsl` holds system declarations, and
`model/external-systems/containers/<system>/` holds their container fragments.
This makes system entrypoints easy to find without mixing a catalog directory
among product directories. Keep each system's ecosystem group wrapper in its
definition; repeating the same group name preserves its shared boundary.
Each system with containers includes `../containers/<system>` inside its
software-system block. Components stay inline in their containers. Systems
without containers omit the include and have no empty container folder.

Include the relationship tree once, recursively, after every element exists.
Remove the FireFly, integrations and Unleash wrappers; their leaf fragments remain
the relationship source. Preserve DSL identifiers, metadata, group membership,
view keys, selection rules, dynamic sequences and animation steps.

Imported directories contain only DSL fragments valid in their receiving scope.
Keep README files and backups elsewhere, and keep wrappers outside any subtree
they import. Independent fragments must not rely on sibling enumeration order.
Order-sensitive initiative model, deployment and failure phases stay explicit.

View provenance and source fingerprints follow the same recursive local include
expansion, without filtering suffixes. Traversal retains repeated files so duplicate
view declarations remain errors. It rejects dependencies outside the checkout,
excluded generated/cache/agent directories, and directory cycles. Existing DSL
include/extension cycle checks remain in force.

## Consequences

The root has four includes. New reference system, container and relationship
fragments are picked up without editing a per-file list. Adding a system's first
container requires introducing its directory include. Approved platform modules
remain an explicit addition in the systems phase; proposals are not auto-promoted.

Moving to directory discovery can change generated numeric IDs and unordered
export ordering. Verify model and view equivalence by semantic identity, and
preserve dynamic and animation order. Keep captured layouts untouched. Validate
every workspace, run both containerized test suites after traversal changes,
and regenerate C4-PlantUML for text review. Existing unrelated inspection findings
must be reported separately from regressions.
