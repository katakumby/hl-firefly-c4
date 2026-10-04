# Styling, layout, and perspectives

Read when visual conventions, boundaries, themes, or layout need changing.
Sources: [notation](https://docs.structurizr.com/server/diagrams/notation),
[styles grammar](https://docs.structurizr.com/dsl/language#styles),
[themes](https://docs.structurizr.com/server/diagrams/themes),
[groups](https://docs.structurizr.com/dsl/cookbook/groups/),
[perspectives](https://docs.structurizr.com/dsl/cookbook/perspectives-static/),
[dynamic perspectives](https://docs.structurizr.com/dsl/cookbook/perspectives-dynamic/),
[viewer customization](https://docs.structurizr.com/server/diagrams/customisation).

## Tags and cascading

Define styles under `views { styles { ... } }`, keyed to **one tag per style**.
An element style's tag is not an element identifier or tag expression. Tags are
free-form strings, including spaces. Built-in tags include `Element`, `Person`,
`Software System`, `Container`, `Component`, `Deployment Node`, `Infrastructure Node`,
and `Relationship`; instances inherit their logical type plus an instance tag.

Styles apply across the workspace, not to just one view. Add general styles before
more specific overrides. Theme styles form a base; workspace styles override them.
Keep descriptive tags useful to the model, rather than adding a different tag for
every diagram. Hiding descriptions or metadata to squeeze in boxes can remove
important architecture meaning.

```dsl
styles {
    element "Element" {
        color #ffffff
        background #245580
    }
    element "Data Store" {
        shape Cylinder
    }
    relationship "Asynchronous" {
        style dashed
        color #865900
    }
}
```

The current grammar uses relationship `style solid|dashed|dotted`; older cookbook
examples use `dashed false`. Prefer current grammar that the project's parser
supports. `light { ... }` and `dark { ... }` inside `styles` define mode-specific
element/relationship styles; verify parser and renderer support before using them.

## Style properties

| Element style fields | Purpose/constraints |
|---|---|
| `shape` | Box, RoundedBox, Circle, Ellipse, Hexagon, Diamond, Cylinder, Bucket, Pipe, Person, Robot, Folder, WebBrowser, Window, Terminal, Shell, MobileDevicePortrait, MobileDeviceLandscape, Component |
| `icon` | File/URL; supported image formats depend on renderer/version |
| `width`, `height`, `fontSize` | Integer pixel dimensions |
| `background`, `color` (`colour`), `stroke` | Hex or supported named color |
| `strokeWidth` | Integer 1–10 |
| `border` | solid, dashed, dotted |
| `opacity` | Integer 0–100 |
| `metadata`, `description` | true/false display controls |
| `properties` | Renderer/exporter-specific name/value entries |

| Relationship style fields | Purpose/constraints |
|---|---|
| `thickness`, `fontSize`, `width` | Line/label dimensions; width is the label block |
| `color` (`colour`), `opacity` | Line/label color and opacity 0–100 |
| `style` | solid, dashed, dotted |
| `routing` | Direct, Orthogonal, Curved |
| `position` | Label position along the arrow, integer 0–100 |
| `jump` | true/false crossing behavior; renderer dependent |
| `properties` | Renderer/exporter-specific entries |

Do not apply every element-style field to every kind of boundary: supported fields
vary. Parser acceptance is not proof that an exporter renders a shape/icon/style.
The notation page currently contradicts itself about SVG icons (older table versus
newer icon section); validate the target renderer, or use supported PNG/JPG assets
when interoperability matters. Local/data-URI assets avoid URL/CORS dependencies.

## Groups and boundaries

`Group` styles all group boundaries; `Group:Name` targets one group. For nested
groups, define the model property `"structurizr.groupSeparator" "/"` and use the
full path, e.g. `Group:Commerce/Ordering`. Avoid that separator in individual names.
Groups do not create an identifier namespace. Their visibility depends on view
level, so a model-level group is not automatically a container boundary.

Use `Boundary`, `Boundary:SoftwareSystem`, or `Boundary:Container` to style C4
boundaries. The old enterprise boundary is deprecated; use groups for that intent.
The renderer supplies a diagram key from styles. Exporters have their own legend
options; there is no general-purpose DSL `legend` block.

## Themes, terminology, and layout

`theme name|url|file` or `themes ...` references one or several themes. Named themes
must be installed; URL themes load dynamically; file themes are inlined by parsing.
Apply the exact tags defined by a theme. Do not assume a named cloud theme exists
because an example uses it; preserve any existing pinned or local assets required
by the target project.

`terminology` overrides displayed terms for person/softwareSystem/container/
component/deploymentNode/infrastructureNode/relationship. Its `metadata` option
chooses square, round, curly, angle, double-angle, or no delimiters. These settings
do not change underlying model types or selection expressions.

`autoLayout [tb|bt|lr|rl] [rankSeparation] [nodeSeparation]` belongs inside supported
views. Default direction is top-to-bottom. The current website documents 300-pixel
separations; the tested `2026.06.28` parser instead emitted 100-pixel rank and
50-pixel node separation for omitted arguments. Specify explicit values when
spacing matters. It is not manual coordinate syntax. Preserve manual-layout intent and stable view
keys when editing source; the compiled JSON can contain layout information. Do not
enable auto-layout everywhere as an incidental syntax fix.

Viewer `properties` such as `structurizr.title`, `structurizr.description`,
`structurizr.metadata`, and `structurizr.tooltips` apply at view/viewset level;
`structurizr.groups` is view-specific. `structurizr.locale`, `structurizr.timezone`,
and `structurizr.sort` apply to the viewset. These are renderer controls, not model
facts, and do not automatically carry into text exports.

## Perspectives

Attach cross-cutting information to elements/relationships:

```dsl
perspectives {
    "Ownership" "Operated by the orders team." "Orders"
    perspective "Criticality" {
        description "Required to accept orders."
        value "High"
    }
}
```

Style with `Perspective:Criticality` or
`Perspective:Criticality[value==High]`. Dynamic perspectives use a `url` to fetch
their value; response text is the value, or HTTP status when the body is empty.
`structurizr.perspective.interval` configures polling in milliseconds (default
60000). This is a live viewer capability and a network dependency, not static
exported evidence or the same thing as a deployment instance `healthCheck`.
