---
name: structurizr-dsl
description: Create and update Structurizr DSL architecture diagrams. Use when the user wants a C4-style model or views in Structurizr DSL, needs a starter workspace, or needs help fixing Structurizr DSL syntax, scoping, view selection, or styling issues.
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
   - Run `structurizr-cli validate -workspace <dsl file>`.
   - If `structurizr-cli` is not installed, skip the validation step and recommend installing it with `brew install structurizr-cli`.
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
- `include *` and `include *?` are not equivalent. `*` pulls the default full scope for the view; `*?` is the reluctant form and keeps the scoped element with directly related items only.
- Identifier scope matters. Flat scope is the default; hierarchical scope makes nested identifiers more predictable in larger models.
- `this` refers to the current parent scope, which is useful inside nested blocks but easy to misuse.
- `!include` and `workspace extends ...` can be blocked in restricted environments. Do not depend on them unless the runtime allows local or remote includes.
- Invalid nesting causes parser failures: a `component` cannot sit directly under a `softwareSystem`, and a `container` cannot sit directly under `workspace`.
- Duplicate view keys, missing identifiers, and unbalanced braces are common failure modes.

## Reuse

- Use [assets/workspace-template.dsl](assets/workspace-template.dsl) as the default starting point.
- Keep optional dynamic and deployment sections commented until the user actually needs them.
