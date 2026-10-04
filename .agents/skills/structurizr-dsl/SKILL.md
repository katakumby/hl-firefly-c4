---
name: structurizr-dsl
description: Create, edit, debug, and review Structurizr DSL architecture models and views, including deployment, interactions, reuse, styling, and documentation. Use for C4 work authored in Structurizr DSL and for DSL syntax, selection, validation, or export issues.
---

# Structurizr DSL

Maintain one architecture model and derive the requested views from it. For
DSL-authored models, correct the DSL and regenerate derived JSON and diagrams.
Preserve the user's scope and the target project's modeling conventions.

## Workflow

1. Read the relevant DSL workspace, included fragments, and any target-project
   instructions and tool/version configuration. Identify affected workspaces when
   changing shared fragments or an extended workspace. Keep existing view keys
   and layout intent.
2. Read only the references needed for the task from the table below. For a new
   workspace, adapt [the starter](assets/workspace-template.dsl); it illustrates
   syntax, not a prescribed technology stack or component decomposition.
3. Establish model ownership, abstraction levels, identifiers, and relationships
   before selecting views. Distinguish domain facts from assumptions; do not invent
   implementation details to fill a diagram.
4. Make the smallest coherent source change. Prefer readable selections and useful
   descriptions; use tags for shared styling. Add dynamic/deployment/documentation
   features only when they serve the requested architecture work.
5. Validate with the target project's configured tools, or the installed Structurizr
   launcher when no project workflow exists; see [tooling](references/tooling-and-review.md).
   Correct source errors and rerun affected checks. Diagnose missing tools,
   unsupported syntax, or inaccessible dependencies instead of retrying unchanged
   commands or silently upgrading the runtime.
6. Review current affected views using the requested output and the target project's
   review process, where defined. Check exported contents against the DSL; use
   parsed JSON when selection, filtering, or details omitted by an exporter need
   checking. Regenerate outputs after source corrections. A failed command leaves
   older outputs unverified. Report validation and material limitations accurately.

## Read by task

| Task | Reference |
|---|---|
| Syntax, C4 boundaries, identifiers, groups, relationships, constants | [Model and syntax](references/model-and-syntax.md) |
| View scopes, defaults, filtered/dynamic/custom/image views, animation | [Views](references/views.md) |
| Include/exclude expressions, arrow visibility, implied relationships, selection refactors | [Selections and relationships](references/selections-and-relationships.md) |
| Environments, nodes, instances, replication, infrastructure and cloud patterns | [Deployment](references/deployment.md) |
| Includes, workspace extension, bulk changes, archetypes | [Reuse](references/reuse.md) |
| Documentation/ADRs, scripts, plugins, component discovery | [Documentation and extensions](references/documentation-and-extensions.md) |
| Tags, styles, themes, groups/boundaries, perspectives, layout | [Styling](references/styling.md) |
| Validation, inspections, parser/runtime differences, exports, official commands | [Tooling and review](references/tooling-and-review.md) |
| Documentation coverage, official links, version-sensitive or incomplete upstream guidance | [Documentation map](references/documentation-map.md) |

## Essential correctness rules

- DSL is processed in order: declare before referencing. Put `{` at the end of
  its statement and `}` on its own line. Quote an entire token/expression containing
  whitespace; use `""` to skip an optional positional argument.
- Nest containers under their software system and components under their container.
  Groups organize peers; they do not change ownership or C4 abstraction levels.
- Assign explicit identifiers to referenced elements and relationships. Hierarchical
  element identifiers help large models, but relationship identifiers remain global.
  Preserve an existing identifier convention unless changing it is part of the task.
- Structurizr relationships are one-way. Model two distinct directions as two
  relationships when needed; there is no bidirectional arrow syntax. Use concise
  source-to-destination actions and transport/technology where known.
- View selections do not create missing model relationships. Implied relationship
  generation, view arrow inclusion, and deployment instance replication are separate
  mechanisms. Debug the appropriate layer.
- Give views stable, unique explicit keys. Review scopes and memberships as well as
  syntax: successful parsing alone does not prove the diagram represents the intent.
- The official website tracks current releases. Check the installed runtime before
  adopting a feature from it. Prefer the language reference over stale cookbook
  syntax; verify ambiguities against the matching parser or a minimal fixture.

## Architecture quality

Choose views for their audience and question. Make element names, responsibilities,
abstraction levels, and relevant technology understandable; keep labels compact.
Use precise relationship verbs, a clear title and scope, and consistent notation.
Check that meaningful arrows and endpoints survive filtering. A legend/key should
explain special notation; use the renderer's supported key rather than inventing a
DSL `legend` statement. Treat these as review criteria, not extra grammar rules.
