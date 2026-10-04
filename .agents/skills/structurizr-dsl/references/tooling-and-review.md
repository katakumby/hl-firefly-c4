# Tooling, compatibility, and review

Read for validation/export work, parser differences, and reproducible reviews.
Sources: [commands](https://docs.structurizr.com/commands),
[validate](https://docs.structurizr.com/validate),
[inspect](https://docs.structurizr.com/inspect),
[inspection rules](https://docs.structurizr.com/workspaces/inspections),
[parser capabilities](https://docs.structurizr.com/dsl/parser),
[file types](https://docs.structurizr.com/workspaces/file-types),
[export](https://docs.structurizr.com/export),
[product transition](https://docs.structurizr.com/eol).

## Choose the installed execution context

Check the target project's instructions, tool configuration, and existing scripts
before choosing commands. If no project workflow exists, use the installed
Structurizr launcher and identify its version and supported commands. Do not assume
a container service, wrapper script, or output directory exists. If no suitable
runtime is available, report what remains unverified.

Official docs now describe consolidated `local`, `server`, `export`, `validate`,
and other commands; the old standalone CLI/Lite/on-premises products are listed as
end of life. Do not prescribe `brew install structurizr-cli` or upgrade a working
toolchain as part of a diagram edit.

The site's current release can be newer than the installed parser. Isolate an
unfamiliar feature in a small temporary workspace and run the installed parser.
Keep existing syntax if it is supported; new features can need a version-matched
alternative rather than a toolchain upgrade. Check runtime and exporter separately.

| Capability | Local/command parser | Browser DSL editor |
|---|---|---|
| Core models/views | Supported | Supported |
| `!include`, `extends` | Local/remote resources, subject to runtime policy | HTTP(S) references only |
| `!docs`, `!adrs` | Supported importers | Unsupported |
| `!script`, `!plugin` | Available with engines/classes | Unsupported |
| Image sources and icons | Local files or supported URLs/data | HTTP(S) with CORS or data URIs |
| Deprecation warnings | Available | Not shown |

Do not "repair" valid local DSL merely because a restricted editor cannot load
its fragments/plugins. Conversely, make a portable variant only when requested.
`structurizr.dsl` can hold encoded source; `structurizr.dsl.source false` discards
it. Local includes/assets, scripts/plugins, importers, and other dependencies can
make source non-portable. A JSON workspace containing diagrams does not prove the
original source and all dependencies can be reconstructed elsewhere.

## Validation is layered

1. Parse/validate: grammar, legal model relationships, view scope, references,
   uniqueness, and configured workspace constraints.
2. Inspect: quality rules such as descriptions, technology, documentation/decisions,
   disconnected elements, elements absent from views, and layout.
3. Review semantics: intended ownership, abstractions, dependencies, labels,
   scenario order, instance connectivity, and diagram selection.
4. Check the target export: feature support and emitted contents.

These are **official Structurizr subcommand arguments**, appended to the installed
launcher; replace the example input and output paths for the task:

```text
validate -workspace file.dsl
inspect -workspace file.dsl -severity error,warning
export -workspace file.dsl -format json -output directory
```

Project wrappers may expose a different command interface; follow their documented
options when present. Inspect's exit code reflects the number of reported violations;
it is not necessarily a parse error. Read diagnostics before selecting a fix.

Inspection severity is configurable with `structurizr.inspection.<type>` properties
at relevant scopes; specific rules and wildcards can override defaults. Respect
existing policy. Do not globally suppress all inspections just to make a template
or changed workspace pass; explain a justified narrow exception when necessary.

Use parsed JSON for view membership, deployment replication, filters, properties,
perspectives, docs, and dynamic ordering that exports may omit. For a DSL-authored
model, make source corrections in DSL and regenerate the JSON. For selection
equivalence use the checks in [selections and relationships](selections-and-relationships.md).

## Export differences that change decisions

| Official format | Important distinction |
|---|---|
| `plantuml` / `plantuml/structurizr` | Structurizr-style PlantUML, including custom views; not native C4 macros |
| `plantuml/c4plantuml` | Native C4 macros; usual C4 static/dynamic/deployment views |
| `mermaid` | Different shape/style/layout capabilities; dynamic collaboration/sequence options |
| `websequencediagrams` | Dynamic views |
| `static` | Static HTML workspace presentation |
| `png`, `svg` | Structurizr browser renderer in official tooling |
| `json`, `theme` | Compiled workspace or reusable style theme |
| Fully qualified exporter class | Requires a compatible installed custom exporter |

Do not promise identical rendering across formats. Filtered/image/custom views,
icons, perspectives, animations, and styling require checking the selected
exporter's support. The output inventory matters as much as a successful exit.

Verified on `2026.06.28`: native C4 export omits filtered views while returning
success. Inspect filtered-view JSON and report the missing diagram export;
see [views](views.md) for an equivalent-view alternative or use a verified
supporting format. Recheck support on the target version.

[C4-PlantUML options](https://docs.structurizr.com/export/c4plantuml) include
`c4plantuml.tags` (default false), `c4plantuml.legend` (true),
`c4plantuml.stereotypes` (false), element/relationship property inclusion (false),
and `c4plantuml.stdlib` (true). Keep stdlib/local resources for an offline pipeline;
false references the latest GitHub library. `c4plantuml.tags true` enables the
exporter's Structurizr style/tag mapping; it is not identical to every C4-PlantUML
tag convention.

PlantUML exporters support title/include/skinparam/animation settings. The C4 page
lists a sequence option while describing its dynamic support as collaboration-only;
verify the installed exporter before promising a sequence diagram.
[Structurizr-style PlantUML](https://docs.structurizr.com/export/plantuml) and
[Mermaid](https://docs.structurizr.com/export/mermaid) document sequence output via
`plantuml.sequenceDiagram` and `mermaid.sequenceDiagram`. Exporter properties are
usually view/viewset `properties`, not new DSL keywords. Resolve contradictory or
obsolete examples using the version-matched runtime and actual output.
