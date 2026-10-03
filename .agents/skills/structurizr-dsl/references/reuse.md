# Reuse and model extension

Read for shared fragments, workspace inheritance, archetypes, or bulk edits.
Sources: [includes](https://docs.structurizr.com/dsl/includes),
[extension example](https://docs.structurizr.com/dsl/cookbook/workspace-extension/),
[archetypes](https://docs.structurizr.com/dsl/archetypes),
[shared components](https://docs.structurizr.com/dsl/cookbook/shared-components/),
[bulk operations](https://docs.structurizr.com/dsl/cookbook/bulk-operations-elements),
[language](https://docs.structurizr.com/dsl/language#element-1).

## Fragments versus workspace extension

`!include file|directory|url` inlines DSL at that exact point. Included content must
be legal in the receiving scope. A fragment intended inside a container can define
components, but should not contain another `workspace` wrapper. Files must be
included in dependency order; prefer explicit files when order matters instead of
assuming directory enumeration is an intentional dependency graph.

Official documentation describes local paths relative to the containing DSL file,
in that directory or below it, and HTTPS URLs. Actual parser sandbox/path policy
can differ. Preserve working repository includes, including any supported parent
paths, and validate from the configured working directory; do not rewrite them
solely to match an illustrative path. Online includes also depend on network policy.

`workspace extends file|url { ... }` starts from a complete DSL or JSON workspace.
DSL identifiers from the base remain available in the child. Extend existing
elements instead of redeclaring names:

```dsl
workspace extends "landscape.dsl" {
    model {
        !element shop {
            api = container "Ordering API" "Accepts orders." "Java"
        }
    }
    views {
        container shop "shop-containers" {
            include *
            autoLayout lr
        }
    }
}
```

Inherited views and shared definitions can also be affected. Inspect all consumers
before changing a base, and validate/export affected workspaces after the edit.
Do not overwrite a base view's key unintentionally.

For larger organizations, the official [enterprise pattern](https://docs.structurizr.com/workspaces/enterprise)
shares a catalog of system-level definitions and lets team workspaces extend
their own internals. This avoids a single workspace that imports every team's
containers, code-extraction dependencies, and failure modes. A central landscape
can be derived from compiled team workspaces with the official
`generate system-landscape` workflow when needed. Treat this as an organization
option, not a reason to restructure or publish an existing repository.

When extending JSON, source-level identifiers may not be available. Bind an
element/relationship by its **canonical name**, using
`id = !element "canonical name" { ... }` or
`id = !relationship "canonical name" { ... }`. Determine the canonical name from
the model/API, not a guessed display name or generated numeric ID.

## Targeted and bulk changes

`!element id { ... }` reopens an element to add supported children/metadata;
`!relationship id { ... }` reopens a relationship. `!extend` and `!ref` are deprecated
aliases: prefer the specific constructs for new code, and migrate existing uses
only within the requested scope.

`!elements expression { ... }` operates on already-created matches. Its body can
add tags, URLs, properties, perspectives, and relationships using `this`.
`!relationships expression { ... }` supports tags, URLs, properties, and
perspectives. Do not assume bulk blocks support every single-element declaration
child or change items declared later.

```dsl
!elements "element.type==Container && element.parent==shop" {
    this -> observability "Sends operational events to" "HTTPS"
}
```

Declare `observability` and the selected containers before this block. Check both
the detailed and implied relationships created by a bulk operation.

For shared library components, include the same component fragment under each
container using hierarchical element identifiers. This creates separate component
elements for each container's use of the library; it does not give one element
multiple owners. Relationship IDs remain global even in such repeated fragments.

## Archetypes

Use archetypes when repeated domain vocabulary/defaults make source clearer.
Define them in `model { archetypes { ... } }` before use; verify runtime support.
An archetype preserves the underlying C4 type and valid nesting.

```dsl
archetypes {
    service = container {
        technology "Java"
        tag "Service"
    }
    datastore = container {
        technology "PostgreSQL"
        tag "Data Store"
    }
    request = -> {
        technology "HTTPS"
        tags "Synchronous"
    }
}
shop = softwareSystem "Shop" {
    api = service "Ordering API"
    db = datastore "Order Store"
    api -> db "Stores orders in" "SQL"
}
partner = softwareSystem "Partner"
shop.api --request-> partner "Requests availability from"
```

Element archetypes cover person, software system, container, component,
deployment node, infrastructure node, group, and custom element. They can supply
descriptions/tags/properties/perspectives; technology defaults are documented for
containers/components, metadata for custom elements. Archetypes may extend other
archetypes. Relationship archetypes use `name = -> { ... }`, can extend with
`child = --name-> { ... }`, and are invoked as `source --child-> destination`.
They can supply description, technology, tags, properties, and perspectives.

Readability, parser compatibility, and actual reuse should justify adopting an
archetype. Do not convert a small existing model just to demonstrate the feature.
