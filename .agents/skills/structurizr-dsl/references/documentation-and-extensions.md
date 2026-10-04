# Documentation and executable extensions

Read for documentation/decisions, image services, plugins, scripts, or component
discovery. Sources: [docs](https://docs.structurizr.com/dsl/docs),
[ADRs](https://docs.structurizr.com/dsl/adrs),
[scripts](https://docs.structurizr.com/dsl/scripts),
[plugins](https://docs.structurizr.com/dsl/plugins),
[parser capabilities](https://docs.structurizr.com/dsl/parser),
[DSL and code](https://docs.structurizr.com/dsl/cookbook/dsl-and-code/).

## Attach documentation and decisions

```dsl
!docs documentation
!adrs decisions
```

Place these at workspace, software-system, or container scope as appropriate.
The language reference's component child list also includes them, while the
dedicated documentation pages describe only the other three scopes; validate
component attachment against the actual runtime when needed. A minimal fixture
confirmed both documentation and ADR import under a component in `2026.06.28`.

Paths are documented as relative to the containing DSL file, in that directory
or below. Keep the files with the architecture source. The default docs importer
reads Markdown/AsciiDoc files in filename order and includes images from the
directory and its subdirectories. Use sortable filenames for intentional section
order. The renderer supplies the top-level heading and section numbers: `#`/`=`
headings are hidden in the content, `##`/`==` start numbered sections, and the next
level starts subsections. See [headings and sections](https://docs.structurizr.com/server/documentation/headings).
Attached docs are compiled into the workspace; successful
DSL parsing does not alone prove all intended sections/images were imported.

`!docs path fully.qualified.Importer` selects a custom documentation importer.
`!adrs path [adrtools|madr|log4brains|fully.qualified.Importer]` selects a decision
importer. The default is `adrtools`: ordinary prose Markdown is not automatically
a correctly formatted ADR. Preserve the existing ADR convention and inspect
imported ID, title, date, status, and content. A custom importer must be on the
parser classpath or in the adjacent `plugins` directory.

Documentation embeds existing views with Markdown `![](embed:orders-context)` or
AsciiDoc `image::embed:orders-context[]`. Optional parameters include
`{type=graph}` or `{perspective=Security}` after the key. Preserve stable keys and
verify references with inspections. Ordinary image syntax requires an imported
image or an accessible hosted URL. Fenced PlantUML/Mermaid is not rendered
automatically; use the plugins below or an existing preprocessing pipeline.
See [diagram embedding](https://docs.structurizr.com/server/documentation/diagrams)
and [documentation images](https://docs.structurizr.com/server/documentation/images).

## Scripts and plugins

Use these for genuine gaps in DSL expressiveness or supported code extraction,
not as the first fix for an ordinary include/exclude problem. They execute code
while parsing and need the configured runtime and trusted dependencies. Inspect
existing script/plugin behavior before running a workspace that uses them.

`!script groovy|kotlin|ruby|javascript { ... }` executes inline code.
`!script file.groovy|file.kts|file.rb|file.js` executes an external script, optionally
with a parameter block of name/value pairs. Language engine availability depends
on the distribution/JVM; a documented language name does not ensure its engine is
installed. Inline scripts cannot contain an internal line consisting solely of
`}` because that closes the DSL block; use an external script for complex code.

Script bindings are `context`, `workspace`, and (when in scope) `element`,
`relationship`, or `view`. Use the matching Structurizr Java API rather than
assuming arbitrary setters/removal APIs exist. In particular, older cookbook
claims that the model is entirely append-only can conflict with newer features.

`!plugin fully.qualified.Class { name value }` is schematic: put parameters on
separate lines. Implement `com.structurizr.dsl.StructurizrDslPlugin` with
`run(StructurizrDslPluginContext context)` and retrieve parameters using
`context.getParameter(name)`. Plugin and dependency JARs are placed in `plugins`
next to the DSL file. Preserve the repository's installation and runtime policy;
do not download executable dependencies as an incidental diagram edit.

The parser can also be used from Java: create `StructurizrDslParser`, parse the
file, then obtain `parser.getWorkspace()` and extend it through the Java API.
For another language, a JSON export can be an interchange input. For a DSL-authored
model, make architecture corrections in the DSL and regenerate derived JSON rather
than maintaining conflicting source and generated models.

## Image sources and documentation diagram plugins

An image view can point to a local/remote PNG or SVG, or derive an image from
PlantUML, Mermaid, or Kroki input. Configure applicable properties under `views`:

```dsl
properties {
    "plantuml.url" "http://localhost:7777"
    "plantuml.format" "svg"
}
```

The analogous keys are `mermaid.url`, `mermaid.format`, `kroki.url`, and
`kroki.format`; format is `png` or `svg`. These example ports do not provision a
renderer. Use an existing approved endpoint/local pipeline. A public URL can
transmit diagram contents and requires suitable CORS behavior; do not introduce
one silently into a private/offline architecture workflow.

The built-in `com.structurizr.dsl.plugin.documentation.PlantUML` and
`com.structurizr.dsl.plugin.documentation.Mermaid` plugins transform code blocks
in imported docs/ADRs into image references. Invoke them **after** all docs, ADRs,
and views have been defined. Configure their corresponding URL/format properties.
Mermaid also supports `mermaid.compress false` to disable default pako compression.
These plugins are different from exporting C4 views as PlantUML/Mermaid text.
See the [PlantUML plugin](https://docs.structurizr.com/dsl/plugins/plantuml) and
[Mermaid plugin](https://docs.structurizr.com/dsl/plugins/mermaid) for supported
fenced Markdown and AsciiDoc block forms.

## Component discovery

`!components` inside a container wraps the Java component finder. It is not a
generic source-code scanner for every language. The public language page routes
its detailed DSL documentation to early-access material; do not fabricate a
configuration block. Use the version-matched
[component finder documentation](https://docs.structurizr.com/java/component),
available parser help/[source](https://github.com/structurizr/structurizr/blob/main/structurizr-dsl/src/main/java/com/structurizr/dsl/ComponentFinderParser.java),
and the repository's compiled artifacts if the user
requests this feature. If those are unavailable, identify that specific limitation
and model supported, evidenced components explicitly.
