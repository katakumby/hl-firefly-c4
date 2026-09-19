---
name: structurizr-dsl
description: Create and update Structurizr DSL architecture diagrams. Use when the user wants a C4-style model or views in Structurizr DSL, needs a starter workspace, or needs help with syntax, scoping, view expressions, relationship visibility, implied relationships, or styling.
---

# Structurizr DSL

## Overview

Write Structurizr DSL that is valid first and polished second.
Prefer explicit identifiers, small models, and view definitions that match the model scope exactly.


## Workflow

1. Start from [assets/workspace-template.dsl](assets/workspace-template.dsl) unless the user already has a DSL file.
2. Define the model first:
   - `person` and `softwareSystem` belong directly in `model`
   - `container` **MUST** be nested inside a `softwareSystem`
   - `component` **MUST** be nested inside a `container`
3. Give important elements explicit identifiers with `=` and reuse those identifiers in relationships and views.
4. Add only the views the user actually needs.
5. Add styles last, using tags instead of repeating per-element styling.
6. Finish with a validation pass against the DSL file:
   - If validation fails, use the reported errors to fix the DSL and rerun validation until it passes.

## Authoring Rules

- You **SHOULD** prefer `!identifiers hierarchical` for non-trivial workspaces.
- You **SHOULD** keep relationships close to the elements they connect when that improves readability.
- You **SHOULD** use tags plus `styles` for visual consistency.
- You **SHOULD** keep notation and element positioning consistent across related views.
- You **SHOULD** keep view keys unique and stable.
- You **SHOULD** give every view a short, meaningful title that includes the diagram type.
- You **SHOULD** add a small legend when colors, shapes, or line styles carry meaning; the legend complements the diagram and must not replace explicit labels.
- You **SHOULD** start with richly labeled elements instead of minimal boxes. Each box should make the element name, abstraction level, technology, and core responsibility obvious without becoming verbose.
- In context views, elements **SHOULD** reveal whether they are a `person`, `software system`, or agent-like external actor. In container and component views, elements **SHOULD** reveal whether they are containers or components.
- Relationship labels **MUST** be action-oriented sentences from the source perspective, such as "sends trade data to" or "makes REST API calls to". Avoid vague labels like "uses" or "sends message to" unless you cannot be more precise.
- Relationships **SHOULD** be unidirectional by default. Even when interactions are naturally request/response, prefer one arrow that captures the intent of the source. Use bidirectional relationships only when the two directions represent meaningfully different workflows.
- If a transport or intermediary node would hide the real dependency between source and destination, prefer a direct relationship and capture the mechanism in the description instead of centralizing the transport as the main node.
- You **MUST** make sure every identifier referenced by a relationship, `include`, `exclude`, `animation`, or filtered view already exists.

## Diagram Scope

- System context: show the software system in its external environment, including who uses it and which external systems or domains it depends on.
- Container: a separately deployable or runnable unit that hosts code or stores data and must run for the system to work. Treat it as a runtime boundary, not specifically a Docker container. Show the system's applications and data stores plus the meaningful interactions between them.
- Component: a logical grouping of related functionality inside one container, exposed behind a clear interface. It is not separately deployable and should map back to real code structures such as modules, packages, namespaces, services, or classes.

## View Expressions

Use expressions when they describe the intended selection more clearly than a
list of identifiers. `include` selects diagram contents; `!include` loads files.
Expressions apply to static view selections, not dynamic interaction steps.
Quote the entire expression when it contains spaces, including combined expressions.
See the official [expression documentation](https://docs.structurizr.com/dsl/expressions).

| Selection intent | Example inside a view |
|---|---|
| Children of one parent | `include element.parent==platform.api` |
| Containers owned by a system | `include "element.type==Container && element.parent==platform"` |
| Elements carrying both tags | `include element.tag==Backend,Stateful` |
| Property-based selection | `include element.properties[architecture.status]==proposed` |
| A group with a spaced name | `include "element.group==External systems"` |
| An element and its incoming/outgoing neighbors | `include ->platform.api->` |
| Outgoing relationships only | `include platform.api->*` |
| Relationships with a specific tag | `include relationship.tag==KeyFlow` |

`->id` follows incoming connections; `id->` follows outgoing connections.
These select elements, whereas `id->*` selects relationships. Combine two
expressions with `&&` or `||` when appropriate.

Use parent selectors for complete child sets and explicit identifiers for focused
subsets. Reuse meaningful tags/properties rather than adding diagram-specific
metadata solely to shorten a list. Broad selectors intentionally admit future
matching model additions; preserve a curated selection when that is the intent.

## Relationship Visibility

Including elements in a static view also selects existing relationships between
them. Relationship expressions operate only on endpoints already in that view;
they do not bring missing endpoints into it. View exclusions hide content without
deleting model relationships. See the [include/exclude reference](https://docs.structurizr.com/dsl/language#include).

- Avoid `exclude *->*` followed by re-including every existing arrow. Keep that
  pattern when a view deliberately shows only selected interactions. Use a named
  relationship identifier when only one of several parallel relationships belongs
  in the diagram.
- `include *` uses defaults specific to the view type. For context, container and
  component views, `include *?` selects the same default elements but restricts
  relationships to those touching the scoped system, its containers, or the scoped
  container's components respectively. It suppresses links solely between external
  neighbors; it does not mean "fewer elements".
- When simplifying existing views, compare parsed element and relationship IDs
  per view key before and after. Also preserve descriptions, layout settings and
  styles. Native validation alone does not establish selection equivalence. Use
  temporary comparison fixtures without adding permanent project policy checks.

## Implied Relationships

Implied relationships create additional **model relationships** across abstraction
levels. They are separate from automatically showing existing arrows between
included elements. See [implied relationships](https://docs.structurizr.com/dsl/implied-relationships)
and the [worked examples](https://docs.structurizr.com/dsl/cookbook/implied-relationships/).

- By default, a relationship such as `customer -> platform.web` can also produce
  `customer -> platform`. The default strategy skips a parent pair that already
  has a relationship, so multiple detailed interactions need not produce multiple
  summary arrows. Declaration order can determine which summary is created.
- `!impliedRelationships false` disables this generation; it does not disable
  automatic visibility of existing relationships in views. Set the policy before
  declaring relationships. `true` uses the default strategy; a fully qualified
  Java strategy class is an advanced option, not a routine fix for diagram clutter.
- With generation disabled, declare `customer -> platform` explicitly if the
  context diagram needs that connection. Showing `customer` and `platform` cannot
  invent an absent relationship. Define deliberate summary labels and parallel
  high-level interactions explicitly when needed.


## Quick Checklist

- Title present, short, and includes the diagram type.
- Scope is obvious from the chosen view and included elements.
- Every element has a clear name, type/abstraction level, technology where relevant, and a concise responsibility.
- Acronyms, abbreviations, colors, and shapes are understandable.
- Every relationship is directional and labeled with a precise action sentence.
- A legend is present when visual conventions need explanation.

## Caveats

- A DSL file **MUST** contain only one `workspace` block. In practice, keep only one `model` block and one `views` block too.
- `systemLandscape` views only support people and software systems. Do not try to surface containers or components there.
- `systemContext` views do not support components.
- `filtered` views **MUST** be based on an existing static view and the mode **MUST** be `include` or `exclude`.
- Identifier scope matters. Flat scope is the default; hierarchical scope makes nested identifiers more predictable in larger models.
- `this` refers to the current parent scope, which is useful inside nested blocks but easy to misuse.
- `!include` and `workspace extends ...` can be blocked in restricted environments. Do not depend on them unless the runtime allows local or remote includes.
- Invalid nesting causes parser failures: a `component` cannot sit directly under a `softwareSystem`, and a `container` cannot sit directly under `workspace`.
- Duplicate view keys, missing identifiers, and unbalanced braces are common failure modes.

## Reuse

- Use [assets/workspace-template.dsl](assets/workspace-template.dsl) as the default starting point.
- Keep optional dynamic and deployment sections commented until the user actually needs them.
