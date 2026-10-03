# Model and syntax

Read for authoring, scoping, parse failures, or choosing an abstraction.
Sources: [basics](https://docs.structurizr.com/dsl/basics),
[identifiers](https://docs.structurizr.com/dsl/identifiers),
[language](https://docs.structurizr.com/dsl/language),
[workspace scope](https://docs.structurizr.com/workspaces/scope),
[patterns](https://docs.structurizr.com/dsl/patterns/).

## Grammar and evaluation

Use one top-level `workspace [name] [description] { ... }` with a `model` and the
required `views`. `workspace extends <file|url>` is the reuse alternative. Keep
one clear model/views section in ordinary source rather than relying on parser
tolerance. Workspace-level `name`, `description`, `properties`, `configuration`,
`!docs`, and `!adrs` support metadata and supporting material.

Lines are instructions, evaluated in order, including in fragments. There is no
hoisting. Keywords ignore case; do not assume names, tags, or identifiers do.
Separate tokens with whitespace. A trailing `\` continues a line. Braces are
optional for declarations without children; opening braces follow the declaration
on the same line, closing braces occupy their own line. Comments use `//`, `#`, or
`/* ... */`. A color token such as `background #1168bd` is not a comment.

Positional signatures (`<...>` required; `[...]` optional):

```text
person <name> [description] [tags]
softwareSystem <name> [description] [tags]
container <name> [description] [technology] [tags]
component <name> [description] [technology] [tags]
element <name> [metadata] [description] [tags]
<source> -> <destination> [description] [technology] [tags]
```

For example, `store = container "Audit Store" "" "PostgreSQL"` skips description;
putting `"PostgreSQL"` immediately after the name would set the description.
Child blocks are often clearer than long positional declarations.

## Ownership and abstractions

| Model construct | Owner and meaning |
|---|---|
| `person`, `softwareSystem` | Model (possibly within a model-level group); human role or software system |
| `container` | One software system; application or data store/runtime boundary, not a Docker object |
| `component` | One container; internal code responsibility, not an independently deployed service |
| `element` | Custom concept outside C4; explicit metadata explains its type |
| `group "Name" { ... }` | Groups peers at the current level, without creating a relationship endpoint |

System and person naming must satisfy model-level uniqueness rules; container
names are unique in their software system, component names in their container,
and deployment/infrastructure node names within their parent. An identifier is
separate from the display name and from a generated model ID.

Do not turn every class into a component or every microservice into a software
system. Choose ownership and boundaries from the architecture. A service with an
API and its own data store can be a group of containers. Model hosting platforms,
pods, Docker runtimes, firewalls, and load balancers in deployment when they
represent infrastructure. A custom-built gateway with application responsibilities
can instead warrant a container. See [deployment](deployment.md) for the distinction.

Custom elements are not substitutes for ordinary C4 types. They can represent
hardware in a C4 context; a `custom` view accepts only custom elements. Thus
"context views contain only software systems and people" is too absolute, while
containers/components still do not belong in a system-context/landscape view.

## Identifiers and relationships

Assign identifiers with `id = ...`; declared identifier characters are letters,
digits, and underscores. Use fully qualified references such as `shop.api.orders`
when `!identifiers hierarchical` is active. Dots separate scopes, not characters
inside an individual declared ID. Flat scope is the default. Hierarchical mode
does not namespace relationship IDs or ordinary groups. `this` refers to the
current element; `-> destination` inside an element uses it as the source.

```dsl
shop = softwareSystem "Shop" {
    api = container "Ordering API" "Accepts orders." "Java"
    ledger = container "Ledger" "Stores accepted orders." "PostgreSQL"
    persistOrder = api -> ledger "Stores accepted orders in" "SQL"
}
```

Here `shop.api` and `shop.ledger` are hierarchical element references, but the
relationship identifier is `persistOrder`, not `shop.persistOrder`.

Parallel relationships with identical source, destination, and description are
duplicates, even if technology/tags differ. Name a relationship when a dynamic
view or an include/exclude operation must distinguish parallel interactions.
Self/ancestor relationships and permitted endpoint types are parser constrained;
do not simulate ownership using arrows. Deployment endpoint rules differ from
logical model relationships; see [deployment](deployment.md).

Elements support descriptions, tags, URLs, properties, perspectives, and outgoing
relationships as allowed by their type. `technology` is available on containers,
components, deployment nodes, and infrastructure nodes; use relationship technology
in its declaration. `tag "A"` adds one tag; `tags "A,B"` or `tags "A" "B"` adds several.
Do not expect default type tags to be removable. `properties { ... }` holds
one name/value pair per line. Perspectives are described in [styling](styling.md).

## Constants and substitutions

`!const NAME "value"` defines a constant; `!var NAME "value"` defines a reassignable
variable. `${NAME}` substitutes a constant, variable, or environment value inside
a token. Names allow letters, digits, hyphens, underscores, and dots. An unknown
name remains unsubstituted, so check resulting model text rather than assuming
validation catches it. Environment-dependent values reduce reproducibility;
do not put secrets into labels or metadata that will be exported.

## Workspace scope is a validation choice

`configuration { scope landscape|softwaresystem|none }` is schematic notation;
write the block over separate lines in actual DSL. Landscape scope rejects
containers and system-level documentation/decisions. Software-system scope allows
implementation/documentation detail for only one system. `none` is unscoped.
These constraints are separate from individual view scope. Follow the existing
workspace organization; do not split a workspace solely because one-system scope
is an official recommendation. `visibility private|public` and `users` entries
with `read|write` roles concern publishing/access; they are not view filters.
