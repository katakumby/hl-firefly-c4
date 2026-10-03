# Official documentation map

Audit date: **2026-10-04**. These references synthesize the official DSL language
reference, its companion guides, cookbook, pattern catalog, and the relevant
workspace/parser/validation/export documentation. They are task guidance, not a
vendored manual or a guarantee about future releases. The official documentation
is authoritative for new features; the configured runtime establishes what this
repository can execute. Check only the relevant sources for ordinary work.

At audit time the website advertised binaries `2026.09.19`. This repository's
`.env` and tested Compose runtime were `2026.06.28` (Structurizr libraries `6.2.2`).
Re-read the pin/runtime rather than treating these numbers as permanent requirements.
Templates should not require an upgrade.

## Coverage by language family

Every top-level family in the [language reference](https://docs.structurizr.com/dsl/language)
is routed below. The basics page contains additional directives not listed in that
page's table of contents; these are included too.

| Language/documentation family | Local reference |
|---|---|
| `workspace`, `model`, names/descriptions, ownership, positional grammar | [Model and syntax](model-and-syntax.md) |
| `person`, `softwareSystem`, `container`, `component`, custom `element`, `group` | [Model and syntax](model-and-syntax.md), [styling](styling.md) |
| Identifiers, `this`, `!identifiers`, `!const`, `!var`, substitution, comments | [Model and syntax](model-and-syntax.md) |
| `->`, tag/tags, technology, URL, properties, perspectives | [Model and syntax](model-and-syntax.md), [styling](styling.md) |
| `!impliedRelationships`, defaults and order | [Selections and relationships](selections-and-relationships.md) |
| `archetypes`, `!include`, workspace `extends`, `!element`, `!relationship` | [Reuse](reuse.md) |
| `!elements`, `!relationships`, deprecated `!extend`/`!ref` | [Reuse](reuse.md) |
| `views`, systemLandscape/systemContext/container/component | [Views](views.md) |
| `filtered`, `dynamic`, `custom`, `image`, parallel sequences | [Views](views.md) |
| `include`, `exclude`, element/relationship expressions, `*`/`*?` | [Selections and relationships](selections-and-relationships.md) |
| `deploymentEnvironment`, `deploymentGroup`, deployment/infrastructure nodes | [Deployment](deployment.md) |
| softwareSystemInstance/containerInstance/instanceOf, healthCheck, instances, `-/>`, deployment view | [Deployment](deployment.md) |
| `default`, `animation`, `title`, view descriptions/properties, autoLayout | [Views](views.md), [styling](styling.md) |
| `styles`, `light`, `dark`, element/relationship styles, theme/themes, terminology | [Styling](styling.md) |
| `configuration`, scope, visibility, users | [Model and syntax](model-and-syntax.md) |
| `!docs`, `!adrs`, `!components`, `!script`, `!plugin` | [Documentation and extensions](documentation-and-extensions.md) |
| Runtime capabilities, portability, inspections, export and compatibility | [Tooling and review](tooling-and-review.md) |

## Official entry points for deeper work

- Grammar and examples: [DSL](https://docs.structurizr.com/dsl),
  [tutorial](https://docs.structurizr.com/dsl/tutorial),
  [basics](https://docs.structurizr.com/dsl/basics),
  [language reference](https://docs.structurizr.com/dsl/language),
  [FAQ](https://docs.structurizr.com/dsl/faq),
  [cookbook](https://docs.structurizr.com/dsl/cookbook/).
- Semantic behavior: [identifiers](https://docs.structurizr.com/dsl/identifiers),
  [defaults](https://docs.structurizr.com/dsl/defaults),
  [expressions](https://docs.structurizr.com/dsl/expressions),
  [implied relationships](https://docs.structurizr.com/dsl/implied-relationships),
  [archetypes](https://docs.structurizr.com/dsl/archetypes).
- Modularity: [includes](https://docs.structurizr.com/dsl/includes),
  [workspace extension](https://docs.structurizr.com/dsl/workspace-extension),
  [shared components](https://docs.structurizr.com/dsl/cookbook/shared-components/),
  [workspace scope](https://docs.structurizr.com/workspaces/scope),
  [recommendations](https://docs.structurizr.com/workspaces/recommendations),
  [enterprise organization](https://docs.structurizr.com/workspaces/enterprise).
- Runtime and outputs: [parser](https://docs.structurizr.com/dsl/parser),
  [commands](https://docs.structurizr.com/commands),
  [validation](https://docs.structurizr.com/validate),
  [inspections](https://docs.structurizr.com/workspaces/inspections),
  [export formats](https://docs.structurizr.com/export),
  [C4-PlantUML](https://docs.structurizr.com/export/c4plantuml),
  [PlantUML](https://docs.structurizr.com/export/plantuml),
  [Mermaid](https://docs.structurizr.com/export/mermaid).
- Modeling alternatives: the [pattern catalog](https://docs.structurizr.com/dsl/patterns/)
  covers API gateways, Docker, Kubernetes, load balancers, firewalls, hardware,
  microservices, and AWS hosting/function patterns. Read the matching entry rather
  than copying every pattern into a workspace.
- Extensibility: [documentation](https://docs.structurizr.com/dsl/docs),
  [ADRs](https://docs.structurizr.com/dsl/adrs),
  [scripts](https://docs.structurizr.com/dsl/scripts),
  [plugins](https://docs.structurizr.com/dsl/plugins),
  [Java API](https://docs.structurizr.com/java),
  [component finder](https://docs.structurizr.com/java/component).

## Known limits and how to resolve them

| Upstream issue | Handling |
|---|---|
| `-/>` has a language heading but no full public grammar there | Source-derived grammar is in [deployment](deployment.md); tested runtime `2026.06.28` rejects it |
| `!components` detailed syntax is routed to early-access documentation | Use accessible version-matched documentation or report the narrow limitation; do not invent syntax |
| Component docs/ADR attachment differs between language child lists and dedicated pages | Test that scope on the installed runtime |
| Icon format support and C4 dynamic sequence support have conflicting statements | Verify actual renderer/exporter behavior for the target version |
| Older cookbook pages mention retired products or old style syntax | Prefer current command/language documentation, while respecting the installed version |
| Filtered-view cookbook examples enable automatic layout on the base | The tested `2026.06.28` runtime rejects this combination; see [views](views.md) |
| Language page omits deployment bases for filtered views | Supported by the tested parser; C4 exporter still omits filtered views |
| Documented auto-layout defaults differ from the tested runtime | Specify spacing explicitly when it matters; see [styling](styling.md) |

Server installation, SSO, storage backends, commercial licensing, cloud account
administration, and external publication are outside a DSL authoring skill's
default workflow. For an explicit operational request, consult the corresponding
[official documentation](https://docs.structurizr.com/) and existing environment
instructions. A diagram edit does not require provisioning a server or publishing
the workspace.
