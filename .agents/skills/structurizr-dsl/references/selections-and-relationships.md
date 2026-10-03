# Selections and relationships

Read when an arrow is missing, a diagram is crowded, or selections are refactored.
Sources: [expressions](https://docs.structurizr.com/dsl/expressions),
[include/exclude](https://docs.structurizr.com/dsl/language#include),
[implied relationships](https://docs.structurizr.com/dsl/implied-relationships),
[worked implied relationships](https://docs.structurizr.com/dsl/cookbook/implied-relationships/).

## Keep three mechanisms separate

1. Logical relationships are declared in the model; implied relationships may add
   parent-level summaries as declarations are processed.
2. A static view chooses existing elements and relationships. Including elements
   also includes relationships between them. Exclusion only affects that view.
3. Deployment instances replicate logical relationships; deployment groups can
   restrict that replication. See [deployment](deployment.md).

`!impliedRelationships false` affects the first mechanism, not view arrow inclusion.
It cannot be used to hide arrows between elements already selected by a view.

## Expressions

These apply to view selections (not dynamic steps) and to bulk model operations
with `!elements`/`!relationships`. Quote the whole expression when it contains
spaces: `include "element.tag==External system"`, not
`include element.tag=="External system"`.

| Intent | Expression |
|---|---|
| Children of a parent | `element.parent==shop.api` |
| Type and parent | `"element.type==Container && element.parent==shop"` |
| Every required tag | `element.tag==Backend,Stateful` |
| Not all of these tags | `element.tag!=Backend,Stateful` |
| Technology | `element.technology==Java` / `element.technology!=Java` |
| Property value | `element.properties[status]==proposed` |
| Named group | `"element.group==Customer services"` |
| Element plus incoming neighbors | `->shop.api` |
| Element plus outgoing neighbors | `shop.api->` |
| Element plus both sets | `->shop.api->` |
| All relationships | `*->*` or `relationship==*` |
| Outgoing/incoming relationships | `shop.api->*` / `*->shop.api` |
| A particular pair | `relationship==shop.api->shop.ledger` |
| Relationship tags or properties | `relationship.tag==Critical` / `relationship.properties[channel]==async` |
| Source/destination | `relationship.source==shop.api` / `relationship.destination==shop.ledger` |

Type values include `Person`, `SoftwareSystem`, `Container`, `Component`,
`DeploymentNode`, `InfrastructureNode`, `SoftwareSystemInstance`,
`ContainerInstance`, and `Custom`. Type names are not always the default tag text:
`SoftwareSystem` versus `Software System`.

Coupling expressions also accept expressions as operands; the documented
`element==->id`, `element==id->`, and `element==->id->` forms are aliases.
Relationship aliases include `relationship==*->*`, `relationship==id->*`, and
`relationship==*->id`. Prefer the clearest form. The documented boolean grammar
combines **two** expressions using `&&` or `||`; do not assume SQL-like nesting,
parentheses, arbitrary chaining, or regex support. Use multiple clear operations
or a verified script for more complex selection needs.

Tag expressions with comma-separated tags require **all** listed tags. This is
different from a filtered view's list of tags, which matches **any** listed tag.

## Inclusion and exclusion order

`include id1 id2` selects endpoints and their existing connecting arrows.
`include relationshipId` or a relationship expression requires the endpoints
already in the view; it does not pull them into the diagram. A relationship
exclusion such as `exclude "shop.api -> shop.ledger"` removes all matching
interactions for that pair; use the relationship's ID for just one.

Use `exclude *->*` followed by explicit relationship inclusions only for a diagram
that intentionally presents a curated subset of interactions. Broad element
inclusions later in the block can add relationships again; review final parsed
membership. Avoid a needless exclude-and-rebuild pattern for ordinary views.

`include *` selects a type-specific default set, not every descendant in the model.
For context/container/component views, `include *?` keeps those same default
elements but restricts arrows to those touching respectively the scoped system,
its containers, or the scoped container's components. It is useful for suppressing
connections entirely between external neighbors. It does not narrow the element
set. See [views](views.md) for default element sets.

## Implied relationship policy

The default `!impliedRelationships true` uses
`CreateImpliedRelationshipsUnlessAnyRelationshipExistsStrategy`. A relationship
to a container/component can produce valid relationships between ancestor pairs,
but a pair that already has a relationship is skipped. The first detailed
interaction can therefore determine the summary label.

Declare deliberate high-level summaries **before** detailed interactions when
they should take precedence. With `!impliedRelationships false`, explicitly
declare each required summary relationship: selecting a person and system in a
context view cannot create their absent connection. Set the policy before the
relationships it is intended to affect; it is not a retrospective cleanup command.

`!impliedRelationships <fully-qualified-class-name>` selects a Java strategy;
for example, the `UnlessSameRelationshipExists` variant allows more summaries
than `UnlessAnyRelationshipExists`. Use a custom strategy only when its semantics
are wanted and its class is present. Do not change global model policy just to
declutter one diagram.

## Verify a selection refactor

Capture parsed JSON before and after using the same parser/version. Compare the
elements and relationships **in each affected view**, plus labels, keys, scope,
layout, animations, and filters. If numeric model IDs change, map by element
ownership/name and relationship endpoints/description instead of treating raw ID
changes as semantic changes. Filtered views reference a base view and filter;
absence of their own expanded element list is not an empty diagram.

A selector such as `element.parent==shop` intentionally includes future children;
an explicit list preserves a curated subset. Keep the user's intended behavior.
