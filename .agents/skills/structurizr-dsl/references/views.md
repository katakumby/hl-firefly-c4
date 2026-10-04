# Views

Read when choosing diagram scope or authoring static, filtered, dynamic, custom,
or image views. Sources: [language](https://docs.structurizr.com/dsl/language#views),
[defaults](https://docs.structurizr.com/dsl/defaults),
[multi-system containers](https://docs.structurizr.com/dsl/cookbook/container-view-multiple-software-systems/),
[dynamic](https://docs.structurizr.com/dsl/cookbook/dynamic-view/),
[parallel steps](https://docs.structurizr.com/dsl/cookbook/dynamic-view-parallel/),
[filtered](https://docs.structurizr.com/dsl/cookbook/filtered-view/),
[custom](https://docs.structurizr.com/dsl/cookbook/custom-view/),
[image](https://docs.structurizr.com/dsl/cookbook/image-view/).

## Static scopes and defaults

| Declaration | Purpose and `include *` behavior |
|---|---|
| `systemLandscape [key] [description]` | People and software systems across the model |
| `systemContext systemId [key] [description]` | Scoped system plus directly connected people/systems |
| `container systemId [key] [description]` | All containers owned by the system plus people/systems directly connected to them |
| `component containerId [key] [description]` | All components owned by the container plus connected people, systems, and other containers in its system |
| `deployment *\|systemId environment [key] [description]` | Instances/infrastructure/nodes for an environment; see [deployment](deployment.md) |
| `custom [key] [title] [description]` | Custom elements only; these are outside C4 |

Use an explicit, unique, stable key even though syntax makes it optional. Generated
keys can change and lose manual layout associations. `custom` has a positional
title where most view declarations have a description: do not copy arguments
between types blindly.

Default inclusion is not the complete set of legal elements. For example, a
container view can explicitly show containers from another software system:

```dsl
container shop "shop-integration" {
    include shop.api billing.api
    autoLayout lr
}
```

Use this intentionally for integration detail. Do not claim it is illegal, or put
containers into a landscape view to work around scope. A custom hardware element
can appear in relevant C4 views; see [model and syntax](model-and-syntax.md).

No explicit views means the parser creates default views with automatic layout.
Defining even one explicit view replaces that automatic set; it does not append to
it. Prefer explicit views for repeatable architecture review.

Static/custom/deployment view bodies accept `include`, `exclude`, `autoLayout`,
`default`, `animation`, `title`, `description`, and `properties` where supported.
`default` selects the initial displayed view. An animation block adds the listed
element identifiers step by step; it is not a sequence of relationship interactions.

## Filtered views

```dsl
filtered "shop-containers" include "Current,Relationship" "shop-current"
filtered "shop-containers" exclude "Retired" "shop-active"
filtered "shop-containers" include "Element,Relationship" "shop-all"
```

The base must already exist and be a landscape, context, container, component,
or supported deployment view. Deployment bases work in the tested `2026.06.28`
parser, although the language page lists only the four static C4 bases.
The filter mode is `include` or `exclude`, and tags match **any** item in the
list. An include filter must retain relationship tags too if arrows are wanted;
matching elements alone does not imply that their relationships pass the filter.
Both endpoints must survive. The base supplies selection and layout: do not add
`include`, `exclude`, `autoLayout`, or `animation` blocks to a filtered view.

**Verified runtime constraint:** Structurizr `2026.06.28` rejects a filtered view
if its **base** has `autoLayout` enabled. Use a base without `autoLayout` and
preserve its manual layout; do not blindly copy cookbook examples combining both.
Check this behavior on another version before assuming the restriction changed.

The Structurizr UI hides the base from its diagram list once a filter is defined.
An additional filter including `Element,Relationship` restores an all-content
entry. Exporter support differs; check the actual exported view inventory rather
than assuming a filtered view was flattened correctly.

In tested `2026.06.28`, native C4-PlantUML export omits filtered views while returning
success. Inspect the filter in parsed JSON and explicitly report that the filtered
diagram has no C4 export. Recheck exporter support on the target version. If an
exported filtered diagram is required, use an explicitly selected ordinary view with
equivalent membership or a verified supporting format; do not silently drop it.

## Dynamic interactions

`dynamic *|systemId|containerId [key] [description]` describes a scenario using
instances of **existing model relationships**. `*` admits people and systems;
system scope admits its containers and external people/systems; container scope
admits its components and external people/systems/containers. Select the narrowest
scope that supports the scenario, while respecting the intended abstraction.

Body forms:

```text
[order:] source -> destination [description] [technology]
[order:] relationshipId [description]
```

A step can give an interaction-specific description without changing the static
relationship. A named relationship avoids ambiguity when the pair has parallel
relationships. Reusing one relationship for several steps is legitimate; do not
create a static arrow for every use-case sentence. Dynamic views do not accept
ordinary `include`/`exclude` or `animation` selections.

For parallel interactions, equal explicit ordering is often clearest:

```dsl
dynamic shop "submit-order" {
    1: customer -> shop.api "Submits an order to"
    2: shop.api -> stock "Reserves inventory using"
    2: shop.api -> fraud "Requests screening from"
    3: shop.api -> shop.ledger "Records the outcome in"
    autoLayout lr
}
```

All four pairs must already exist in the model. The cookbook also supports nested
brace sequences, with limited concurrency semantics. They are a special dynamic
syntax, not an exception to ordinary declaration-brace rules elsewhere. For
complex concurrency, verify resulting order fields and target exporter behavior.
Do not presume full UML sequence notation (`alt`, `loop`, etc.) is DSL grammar.

## Custom and image views

`custom` views show custom `element` objects and their relationships, not arbitrary
mixtures of C4 containers/components. Use them when the requested conceptual
diagram actually falls outside C4.

`image *|elementId [key] { ... }` associates an externally produced diagram with
the workspace or an element (for example a component's code-level diagram). Its
source can be `image file|url`, `plantuml file|url|viewKey`,
`mermaid file|url|viewKey`, or `kroki format file|url`.

An image view has title/description/properties/default metadata, not model
selection or auto-layout. There is no native `code` view keyword; an image view is
one way to attach a UML/class diagram. See [documentation and extensions](documentation-and-extensions.md)
for service URL configuration and [tooling](tooling-and-review.md) for browser
parser and export limitations. Choose source or rendered-output checks according
to the task and the target project's review process.
