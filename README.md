# Modular platform architecture workspace

Solutions Architects and Technical Leads collaborate here on a shared reference
model and separate initiative proposals. Architects author static C4 in Structurizr DSL and reference UML patterns.
Technical leads primarily own behavioral/use-case and code diagrams, authored
as standalone PlantUML (`.puml`) or Mermaid (`.mmd`) files. Generated text and previews are versioned under `build/source/` and `build/preview/`.
Saved `workspace.json` files beside DSL are versioned layout inputs.

## Start here

- [Shared reference workspace](workspace.dsl): shared C4 reference views.
- [Blockchain foundation](workspaces/blockchain-foundation/README.md):
  proposed three-AZ Azure/AKS deployment for Besu and one FireFly member, with
  quorum calculations, persistence, key services and explicit HA qualification gates.
- [Unleash reference](documentation/system/unleash/01-boundary-and-components.md):
  OSS server and optional OSS Edge, with containers, components and all internal data flows.
- [Ignition](workspaces/ignition/README.md): the proposed **DApp Platform** boundary
  and separate API/Backend examples for container views, animation and interactions.
- [Shared model](model.dsl): reusable actors, external systems,
  relationships and styles, without authored diagrams.
- [Architecture documentation](documentation/workspace/01-logical-architecture.md)
  and [FireFly/Besu use cases](uml/use-cases/firefly-besu/README.md).
- [Architecture decisions](decisions/adr),
  [workspace decisions](decisions/workspace), and
  [boundaries and evidence](documentation/workspace/06-boundaries.md).

## Layout and ownership

The repository root is the architecture workspace; there is no enclosing
`architecture/` source directory. The main directories are:

```text
.
├── workspace.dsl                 # Shared workspace: reusable model plus published views
├── workspace.json                # Saved manual coordinates/routing; versioned when present
├── model.dsl                     # Extendable model and styles; no authored diagrams
├── model/
│   ├── people.dsl                # Shared actors
│   ├── external-systems/<system>/ # Each product owns its definitions and internal relationships
│   │   ├── 00-system.dsl         # System boundary, metadata and optional ecosystem group
│   │   ├── 10-containers/        # Container fragments; components remain inline
│   │   └── 20-relationships/     # Relationships inside this system
│   ├── platform/                # One approved platform system; currently only a comment placeholder
│   │   └── 00-system.dsl         # Same optional 10-containers/ and 20-relationships/ convention
│   └── relationships/integrations/ # Cross-system and actor relationships, loaded last
├── views/
│   ├── external-systems/<subject>/ # Reference views grouped by product; overview/security span products
│   └── platform/                 # Approved platform views; currently a placeholder
├── styles/styles.dsl             # Shared C4 styling
├── uml/
│   ├── patterns/                 # Generic UML patterns and optional concrete examples
│   ├── use-cases/firefly-besu/    # Numbered use cases with README and .mmd sources
│   └── code/                     # Shared code diagrams
├── workspaces/
│   ├── ignition/                 # DApp proposal and independent example diagrams
│   └── blockchain-foundation/    # Besu/FireFly deployment proposal and recovery views
├── documentation/
│   ├── build.md                  # Corporate Docker setup and offline execution
│   ├── workspace/                # Shared model explanations, attached to the viewer
│   ├── system/                   # Product-specific explanations and evidence
│   └── reviews/                  # Dated review records
├── decisions/
│   ├── adr/                      # Architecture decisions
│   └── workspace/                # Authoring and tooling decisions
├── templates/initiative/         # Starter files ending in .template
├── scripts/                      # Validation, export, rendering, publication and CI packaging
├── docker/
│   ├── Dockerfile                # Independent light and browser image targets
│   ├── .dockerignore             # Image-build context allowlist
│   ├── compose.maintenance.yaml  # Explicit image-construction override
│   ├── run.sh                    # Optional plain-Docker launcher
│   └── renderers/                # Pinned dependencies, npm lockfile and browser setup
├── tests/                        # Containerized tooling regression tests
├── ci/
│   ├── examples/                 # GitHub Actions and Azure DevOps examples and setup guide
│   ├── select-source-run.cjs      # GitHub lookup of a matching source artifact
│   └── select-azure-source-run.cjs # Azure lookup of a matching source artifact
├── compose.yaml                  # Viewer services and two image-only tools services
├── .env                          # Committed toolchain version pins; no secrets
├── .gitignore                    # Transient reports, caches and local settings
├── AGENTS.md                     # Validation and final-review instructions
├── README.md                     # Repository navigation and authoring workflow
└── build/                        # Versioned source/ and preview/ trees; ignored operational reports
```

`model.dsl` assembles shared definitions and styles for reuse. `workspace.dsl`
extends it and adds the published views from `views/`. A workstream extends the
model to reuse definitions while choosing its own views; it does not need to
inherit the shared workspace's entire view catalog. Shared model fragments belong
in `model/`, never in a second "shared" directory under `workspaces/`.

Each `workspaces/<epic-id>/` starts with a workspace extending the shared model.
Local definitions and C4 views can stay inline for convenient editing and
autocomplete; model/view fragments are optional. The two existing workspaces
retain their current arrangements. Blockchain-foundation also owns `deployment.dsl`
and `failure.dsl` beside its entrypoint and uses the shared Azure icons theme.

```text
workspaces/<epic-id>/
├── workspace.dsl     # Extends the shared model; may contain local model and views inline
├── model.dsl         # Optional extracted local proposals and annotations
├── views/            # Optional extracted C4 views
├── uml/              # Local standalone .puml/.mmd diagrams, with any nested folders
├── docs/             # Local explanations, evidence and design notes
└── README.md         # Scope, status, owners and navigation
```

Every workspace loads its own model instance. Local additions and annotations,
including `Planned` tags on inherited elements, stay local; include/exclude
expressions choose what its views show. Optional nested variants extend their
parent workspace. See [variants and promotion](#variants-and-promotion) for the
reviewed move of accepted definitions, views and behavioral diagrams into shared folders.

Shared platform views belong in `views/platform/`. External-reference views stay
separate under `views/external-systems/<subject>/`, using product identifiers such
as `firefly`, `besu` and `unleash`; `overview` and `security` hold cross-product views.
C4 view definitions belong in these view trees or their workspace, while documentation
contains explanations and diagram references.

Architects own shared C4 definitions and reference patterns. Technical leads
primarily own use-case and code diagrams. Generic patterns go in `uml/patterns/`;
existing product-specific C4 reference examples stay in `views/external-systems/`.
PlantUML and Mermaid sources can be nested freely under shared or workspace-local
`uml/`. Keep explanations in Markdown beside diagrams or in the appropriate
`documentation/` / workspace `docs/` directory. The build does not extract diagrams
from Markdown fences. [Output paths](#outputs-and-maintenance) mirror these source folders.

Existing application and operations examples remain reference choices, not
adopted platform systems. Catalog membership records available or potential
integrations; it does not imply adoption. Preserve product internals, evidence
and pinned reference revisions for audit and capability-gap analysis. Security examples are independent options, not a
mandatory combined stack.

Unleash is an independent, reusable product reference with no selected consumer
integrations. Its eight `110-unleash-` views cover Unleash 8.2.0 and OSS Edge
20.5.0. The [flow catalog](documentation/system/unleash/02-interfaces-and-flows.md)
documents every named relationship; [behavior and evidence](documentation/system/unleash/03-behavior-and-evidence.md)
explain optional storage, offline mode, recovery and edition boundaries.

## Docker-only workflow

Use your approved Docker installation; Compose is optional with plain Docker.
**No host Python, Java, Node, npm or diagram software is required.** Acquire the
approved tools and viewer images first using the [corporate build guide](documentation/build.md).
Normal commands use preloaded images and never install packages, pull images or
build the toolchain. Run these commands from the repository root.

The viewer uses the pinned Structurizr image directly. No scripts, custom image
build, validation command or generated JSON are required before viewing.
Python runs only when you explicitly request validation, export, builds or tooling tests.
Compose automatically reads the committed version pin in `.env`.

### Validate

```text
docker compose run --rm --pull never tools validate
docker compose run --rm --pull never tools validate --workspace workspaces/ignition/workspace.dsl
```

Without `--workspace`, validation discovers the reference workspace and every
initiative/variant named `workspace.dsl`. With `--workspace`, only the selected
entrypoint is checked. Structurizr resolves its includes and extensions, exports
fresh JSON, and runs native [`validate`](https://docs.structurizr.com/validate)
and [`inspect -severity error,warning`](https://docs.structurizr.com/inspect).

**There are no custom architecture validation rules.** The standalone `validate`
command is a strict quality check: native inspection errors and warnings fail it.
Build stages and exports report those findings and continue generating diagrams.
DSL parsing, native model validation, inspector execution failures and rendering
errors still block generation. Teams control inspection severity using Structurizr's
[`structurizr.inspection.*` properties](https://docs.structurizr.com/workspaces/inspections);
findings configured as `info` or `ignore` do not block validation. Existing DSL
settings for shared-reference coverage, workspace scope and the initial DApp
boundary remain in place, with no Python exceptions or allowlist. Missing
software-system documentation and ADRs are informational (`info`) findings,
configured in the shared model and inherited by initiatives.

Naming, evidence, ownership, diagram and dependency conventions below are
guidance for authors and reviewers. Custom enforcement can be introduced
progressively as teams agree on rules worth maintaining. The build also requires explicit portable view keys and unambiguous local source
paths so generated files have deterministic destinations.

### Build diagram sources

Generate distribution text without rendering images:

```text
docker compose run --rm --pull never tools clean
docker compose run --rm --pull never tools build-source
```

`clean` is an explicit reset chosen by the operator. It clears generated output and
old reports, including legacy output layouts. Never clean between source generation
(or handoff restoration) and previews. Saved adjacent `workspace.json` files remain
outside build and survive cleanup. Keep optional machine settings in ignored
`docker/local.env`, not inside build.

`build-source` validates the selected C4 workspaces and uses Structurizr's native
C4-PlantUML exporter. Authored `.puml` and `.mmd` files are copied unchanged with
relative local text includes. Include fragments are copied but not independently
rendered. PlantUML and Mermaid are alternative authoring formats; there is no
translation or automatic participant generation. Authored syntax is checked during
preview rendering. C4 exports remain compact native macros without added ID tables.

Both build commands accept the following selection:

| Selection | Arguments |
|---|---|
| All workspaces and owned UML (default) | No selection, or `--all-workspaces` |
| One workspace and its UML | `--workspace workspaces/ignition/workspace.dsl` |
| Root workspace and shared UML | `--workspace workspace.dsl` |
| Selected C4 views only | `--workspace <path> --view <key> --view <another-key>` |

A view selection without `--workspace` targets the root. Repeated keys are
deduplicated; unknown keys are reported together. `--all-workspaces` cannot be
combined with workspace/view selection. A selected source handoff certifies only
that selection; run a full source build before requesting all previews.

```text
docker compose run --rm --pull never tools build-source --workspace workspace.dsl --view 01-landscape
docker compose run --rm --pull never tools build-source --workspace workspaces/ignition/workspace.dsl
```

<a id="filtered-view-export-limitations"></a>

**Filtered-view export limitations:** the pinned C4-PlantUML exporter cannot export
Structurizr filtered views. Affected keys produce an actionable error before
publication. Select supported views or explicitly use native exports for filtered
views. No view is silently omitted.

### Build previews independently

Both preview stages consume the same successful source handoff and produce SVG and
PNG. They can run in either order or in separate checkouts:

```text
docker compose run --rm --pull never tools build-preview --renderer plantuml
docker compose run --rm --pull never tools-browser build-preview --renderer mermaid
```

PlantUML previews use the browser-free `dlt-architecture-tools-light` image.
Mermaid previews use `dlt-architecture-tools-browser`. Both project image names
have no explicit tag. Neither preview stage regenerates C4, reparses DSL, or renders
from authored originals. They read generated text under `build/source/`.

PlantUML PNG previews default to 192 DPI (2× resolution) for sharper text on
high-density displays. SVG previews remain vector output and scale without losing
quality. The higher-resolution PNGs have larger file sizes.

PlantUML previews support C4 view selection. Mermaid previews support workspace
selection and reject `--view`, since C4 source output is PlantUML only.
Source hashes, installed toolchain compatibility, handoff coverage, and CI commit
provenance are checked before rendering. Missing, changed or incompatible handoffs
fail with guidance to rerun source generation. Local execution needs no Git metadata.

### On-demand Structurizr layouts and animations

Use native exports explicitly for saved manual positions, relationship routing,
styles and animation. Arrange views without `autoLayout`, then **save in the viewer**.
The adjacent, versioned `workspace.json` is the authoritative saved layout. Current
DSL supplies model contents, views and animation definitions. There is no capture
command or persistent layout copy under build.

```text
docker compose run --rm --pull never tools-browser export-native --workspace workspaces/ignition/workspace.dsl --format svg
docker compose run --rm --pull never tools-browser export-native --workspace workspaces/ignition/workspace.dsl --view ignition-example-containers --format png
docker compose run --rm --pull never tools-browser export-native --workspace workspaces/ignition/workspace.dsl --view example-container-animation --view stable_key_name --format gif --frame-duration 3
docker compose run --rm --pull never tools-browser export-native --all-workspaces --format svg
```

Native export defaults to the root workspace, all its views, and SVG. It accepts
repeatable `--view`. Workspace-wide GIF export reports skipped nonanimated views;
explicitly requesting a nonanimated GIF is an error. GIF timing defaults to three
seconds per frame (accepted range 0.01–655.35 seconds).

Native images go directly into the mirrored `build/preview/` tree with
`.structurizr` or `.structurizr-key` suffixes. Rendering uses light mode, includes
metadata, preserves canvas dimensions, and requires no running viewer. Saved JSON
is frozen temporarily for merging and rechecked before publication. Missing manual
coordinates, concurrent saves, or rendering failures prevent publication.

Normal builds and CI never generate native exports. Ordinary stages leave their
files and freshness metadata intact. Layout-only edits do not invalidate ordinary
source or preview stages. See [saved layouts](documentation/build.md#saved-layouts)
for version-control and viewer restoration instructions.

### Final architecture review

Regenerate C4-PlantUML for the affected workspace or diagrams as the final review
step. Read those fresh `.puml` exports first, then inspect relevant DSL definitions for
correctness and details the export omits. Review images only when explicitly
requested. If corrections change the DSL, regenerate affected exports before
completing the review. A failed export leaves previous successful files in place;
those files are not current review evidence. Commit generated deliverables, but make corrections in DSL or authored UML,
then regenerate. Never edit generated files as authoring sources. See [AGENTS.md](AGENTS.md) for persistent agent guidance.

### View architecture directly from DSL

Start **all workspaces** from the repository root:

```text
docker compose up -d
```

Only the native viewers start; both tools services are excluded by their profile.

| Compose service | Authored entrypoint | Open |
|---|---|---|
| `global` | `workspace.dsl` | [Global reference workspace](http://127.0.0.1:8080) |
| `ignition` | `workspaces/ignition/workspace.dsl` | [Ignition](http://127.0.0.1:8081) |
| `blockchain-foundation` | `workspaces/blockchain-foundation/workspace.dsl` | [Blockchain foundation](http://127.0.0.1:8082) |

To start just one service, choose its name:

```text
docker compose up -d global
docker compose up -d ignition
```

Compose mounts the repository root directly at `/usr/local/structurizr`.
Structurizr's native `local` command takes the **directory containing**
`workspace.dsl`: the global viewer uses `/usr/local/structurizr`, and ignition
uses `/usr/local/structurizr/workspaces/ignition`. The original directory tree
is intact, so local includes and workspace extensions resolve normally.
There is no wrapper DSL, preparation container, Python startup or preprocessing.

Edit the DSL and refresh the browser. No export or restart is needed for DSL
changes. Structurizr performs its own parsing; the optional `tools validate`
command runs the native validator and inspector and saves their results.

For another initiative or variant, add a named service in `compose.yaml`
using the shared `viewer` anchor, its workspace directory and an unused localhost
port. The [initiative template](templates/initiative/README.md) shows
the service definition. All workspace choices are visible in one Compose file.

Stop one viewer, or stop and remove all viewers:

```text
docker compose stop ignition
docker compose down
```

### Outputs and maintenance

The same relative tree appears in separate source and preview directories:

| Authoring input | Generated source | Ordinary preview |
|---|---|---|
| `views/external-systems/overview/01-landscape.dsl` | `build/source/views/external-systems/overview/01-landscape.puml` | `build/preview/views/external-systems/overview/01-landscape.{svg,png}` |
| `workspaces/blockchain-foundation/views/main.dsl` | `build/source/workspaces/blockchain-foundation/views/<view-key>.puml` | `build/preview/workspaces/blockchain-foundation/views/<view-key>.{svg,png}` |
| Inline workspace view | `build/source/workspaces/<name>/<view-key>.puml` | `build/preview/workspaces/<name>/<view-key>.{svg,png}` |
| `uml/patterns/messaging/sequence.puml` | `build/source/uml/patterns/messaging/sequence.puml` | `build/preview/uml/patterns/messaging/sequence.{svg,png}` |
| Workspace-local `uml/payments/submit.mmd` | `build/source/workspaces/<name>/uml/payments/submit.mmd` | `build/preview/workspaces/<name>/uml/payments/submit.{svg,png}` |

C4 filenames use explicit view keys, including multiple views in one DSL file.
Inherited views remain inside the consuming workspace's namespace. Standalone
UML retains its basename. Selected operations use the same destinations as full
operations; hashes never appear in filenames. Ambiguous mappings, unsafe names,
and case-insensitive output collisions fail before publication.

Versioned `source.json`, `preview-plantuml.json`, `preview-mermaid.json`, and
`preview-native.json` under build inventory each stage's managed files. They contain
source paths, workspace/view identity, hashes and relevant renderer/layout evidence;
no per-run timestamps. Native inventory appears after the first native export.

Ignored `.reports/<stage>.{json,log}` records the latest attempt, selection, timestamps,
installed toolchain and CI provenance. `.reports/<workspace-entrypoint>/` holds
validation results and parsed JSON. `.reports/source/<workspace-entrypoint>/`
freezes validation evidence for the source handoff independently of later validation
or native exports. A failed attempt leaves old files in place but does not certify
those files as current. Committed diagrams alone are not an executable handoff.

One writer lock protects staging and journaled, file-level publication. Each stage
prunes moved/deleted outputs only after its successful regeneration, within its
selection and ownership. Source generation preserves previous previews without
refreshing their metadata. Preview stages preserve source files and other renderers'
outputs. Format changes cannot cause one renderer to delete another's new output.

Freshness includes architecture inputs, documentation and tooling, accepted hidden
folders and local includes. It excludes generated output, Git metadata, agent
configuration, named caches, local settings and saved layout JSON. Layout JSON is
fingerprinted separately for native rendering. Relative local includes must stay
inside the repository; standard libraries come from the approved tools image.

Copy `build/source/` for developer-repository text consumption and AI-assisted
reviews; keep local include paths together. Copy images from `build/preview/` for
an internal wiki. Rendering libraries are not distributed with the source tree.
Consumers who render text in an IDE supply their own supported plugins/libraries.

### Corporate environment and CI

The [Docker guide](documentation/build.md) covers image acquisition, offline archive
transfer, plain Docker commands, non-root permissions and platform-team maintenance.
The [CI examples](ci/examples/README.md) publish source handoffs on push/PR, then
render independent previews on a daily 02:00 UTC schedule or manually. Artifacts
must match the exact commit. Successful jobs publish only verified stage outputs;
failed jobs publish diagnostics. CI does not commit generated files.

Containerized regressions:

```text
docker compose run --rm --pull never --entrypoint python3 tools -B -m unittest discover -s tests -v
docker compose run --rm --pull never --entrypoint python3 tools-browser -B -m unittest discover -s tests -v
```

The previous `build`, `build-browser`, ordinary `export`, `capture-layout`, and
`--clean` interfaces have been removed. Run explicit `clean`, then `build-source`,
then the desired preview commands. Old handoffs are incompatible and must be
regenerated. The existing approved images remain usable; scripts are mounted from
this checkout. Sources, previews, inventories and saved layouts are versioned;
reports, locks, staging, viewer caches and local overrides are ignored.

## Contributing an initiative

These are recommended team conventions, not custom validation gates. The initial
workflow relies on native Structurizr validation; automation of team-specific
rules is deferred until teams choose to introduce it.

1. Create `workspaces/<epic-id>/` with a README recording goal, status, architect,
   technical lead/team, and epic link. Use `TBD` for unknown values.
2. Start with the [initiative template](templates/initiative/README.md),
   extending `../../model.dsl`. Add an agreed model and focused views. The template
   uses native `model.element.noview` informational settings for inherited elements.
   Adjust inspection properties in DSL as the initiative needs. Keep local model
   definitions and views inline, or extract optional fragments when useful.
3. Prefix view keys with `<epic-id>-`. Give elements stable, meaningful
   `architecture.id` values; do not duplicate shared systems.
4. Keep explicit declaration phases: actors and systems first, relationships
   afterward. Use folder includes for independent fragments valid in the same
   DSL scope. Label arrows with their action and protocol. Use descriptive
   relationship identifiers for partial selections between the same endpoints.
5. Add use cases when behavior is agreed. Validate your workspace and validate
   all workspaces for shared model, style or tooling changes.

Keep `architecture.id` and `evidence` on elements. Reference elements and
relationships retain `architecture.sources` as a JSON array of evidence URLs;
the element `url` is its primary source. Proposals use
`evidence "Proposed architecture"`, `architecture.status "planned"`, and the `Planned` tag.
Containers/components require technology metadata.

Internal relationships follow their owning system's containers. Cross-system
relationships follow every system, with actor-originated relationships together.
The shared model loads these fixed phases:

```dsl
model {
    !include model/people.dsl
    !include model/external-systems
    !include model/platform
    !include model/relationships/integrations
}
```

Add a reference system as `model/external-systems/<system>/00-system.dsl`,
preserving its stable identifier and any ecosystem `group` wrapper. Use the same
group name in separate system files to retain one shared boundary. Each container
fragment in the product's `10-containers/` directory reopens its system at model scope:

```dsl
!element firefly {
    core = container "FireFly Core" "Orchestrates member operations." "Go" {
        // Components stay inside their owning container.
    }
}
```

Put internal relationship fragments in the product's `20-relationships/`, using
fully qualified element identifiers. FireFly retains its fragments by source
container. Put relationships crossing system boundaries in
`model/relationships/integrations/`, after both external and platform definitions.
The numbered phases load the system, containers, then internal relationships.
Adding a product, container or relationship fragment needs no per-file import list.
Create only directories that contain actual fragments.

`model/platform/` represents **one platform software system**, with the same
`00-system.dsl`, `10-containers/` and `20-relationships/` phases directly beneath it.
It currently contains only a comment placeholder: Ignition's `dapp_platform` remains
a proposal until reviewed promotion. FireFly, Besu, security, operations and
application examples remain references and do not define the platform's ownership.

Directory includes are recursive and read **every file**, regardless of extension;
`*.dsl` and `**/*.dsl` paths are not supported. Keep imported folders free of
README files, backups, and other non-DSL content. Do not place an include wrapper
beside or above fragments it includes: recursive traversal would load them twice.
Every fragment in an imported model tree must be valid at model scope. Keep the
numbered phase names; fragments within each phase must not depend on sibling
discovery order. Do not add local includes for files already found recursively.
See [decision 11](decisions/workspace/0011-system-owned-models.md).

Reference diagrams use the directory include `!include views/external-systems` in
`workspace.dsl`. Add a self-contained `.dsl` view fragment in its subject subfolder;
no new entrypoint include is needed. Approved platform views are included
from `views/platform/` in the same way. Global element and relationship styles,
including the `Planned` and `Available` tags, live in `styles/styles.dsl` and are included
once by the shared model. Initiatives and variants inherit them automatically.

Native exports and the web UI share the classic C4 palette: dark-blue people,
blue software systems, medium-blue containers and light-blue components.
Boxes use rounded corners; people retain the person shape.
`Database` changes only the shape to a cylinder. `External` changes only the
colours to grey/white, preserving the element's shape; it denotes an explicit
external integration/ownership boundary, not every reference in the catalogue.
The external-systems directory alone is not a styling rule. Parent software-system
tags do not automatically tag its containers/components; classify those explicitly
when their ownership needs to be shown. Deployment instances inherit their logical
element's notation, with instance tags used for a different deployment status.

`Available` means confirmed deployed in at least one environment; `Planned` means
a planned deployment. Use exactly one status when known, and leave unconfirmed
reference deployments untagged. `Planned` adds a dashed border; `Available` uses a
solid border. An untagged solid border makes no deployment claim. Optional product
features are described in text, independently of deployment status. Relationships
use one neutral style; their labels and protocols explain their purpose.

Azure deployment elements use official Microsoft Azure 2024.07.15 icons only,
with shared colours and shapes. The locally embedded theme and provenance are in
`styles/themes/microsoft-azure-2024.07.15/`; apply its service tags only to deployment
nodes/infrastructure. Elements without a matching service icon keep the shared
notation. Product-specific sizing, domain palettes and flow tags are not used.
The shared styles use Structurizr's default element dimensions and font size.
Compare the UI in light mode with native exports, which use light mode.

C4-PlantUML exports intentionally retain their compact default macros and palette;
`c4plantuml.tags` stays disabled. Use native exports for visual fidelity. Level-4
PlantUML/Mermaid authoring remains independent of these Structurizr styles.

Use `element.parent==<identifier>` when a view should show every child of a
system or container. Relationships between included elements appear automatically;
reserve explicit relationship selections for focused flows. These expressions
also include future matching model additions, so review affected diagrams when
the model changes.

Published views should explicitly name elements whose removal must fail native
validation. Generic landscape/context views may intentionally use `include *`
or selection expressions, allowing elements to appear or disappear with the model;
review those changes in generated artifacts. Removing an element and updating all
its explicit view references in the same reviewed change is valid. These conventions
add no membership snapshots or custom build rules. Inspection findings remain
report-only during builds and exports; missing explicit references remain fatal.

Shared changes are reviewed by affected architects and technical leads.
Record actual owners in initiative READMEs; CODEOWNERS enforcement is deferred
until team identities are available. Significant architecture decisions go in
`decisions/adr`; authoring/tooling decisions go in
`decisions/workspace`. Routine notes belong in READMEs.

Attach shared documentation and ADRs once at workspace level. The reference
workspace imports `documentation/workspace/` (including the
[shared boundary explanation](documentation/workspace/06-boundaries.md))
and both decision directories. Attach `!docs` or `!adrs` to a software system
only when it has documentation or decisions specifically about that system;
do not attach the shared directories to every system or create placeholder
documents to satisfy inspection checks.
Store system-specific documentation under
`documentation/system/<system-id>/`.

The initiative template and Ignition use `!docs .` to attach their root README.
Blockchain-foundation uses `!docs docs` to publish its design notes. Authors can
choose the appropriate attachment when substantive documentation is ready; keeping
a local `docs/` directory does not automatically attach it to the viewer.

## Variants and promotion

Create `variants/interim/workspace.dsl` or `variants/target/workspace.dsl`
only when designs differ. Each extends `../../workspace.dsl` and includes
variant-local fragments. Use view keys such as `<epic-id>-interim-...`.
Each workspace loads an independent model instance. Local `!element` or
`!elements` annotations (for example, adding `Planned` tags) do not edit the
shared definitions or affect sibling workspaces. Use include/exclude expressions
to select local alternatives. Extension inherits parent models and views;
variants are additive. Select the
desired elements in each view instead of deleting inherited definitions.
Use `<epic-id>-<variant>-` for local variant keys as a naming convention;
inherited keys stay unchanged.

After explicit approval, **move** the platform system definition into
`model/platform/00-system.dsl`, its containers into `10-containers/` and its internal
relationships into `20-relationships/`. Extend the existing platform boundary for
later promotions; do not create a platform-per-system subfolder. Move cross-system
relationships into the shared integrations directory. Preserve identifiers, remove
the initiative-local definitions in the same change, and validate every entrypoint.
The fixed folder imports discover approved definitions automatically. Promote C4
views into `views/platform/` and reusable behavioral diagrams into `uml/`.
Keep shared files independent of initiative folders as an authoring convention
reviewed by the team.

Ignition's DApp proposal still contains only a system boundary; its separate
Example System adds API/Backend container, animation and dynamic-view experiments.
The DApp boundary's disconnected inspection is informational through a native DSL
property. Review that setting when the DApp design introduces children or
integrations. Other local examples keep their own inspection findings.

See [decision 7](decisions/workspace/0007-modular-workspaces.md) and
[decision 9](decisions/workspace/0009-container-only-tooling.md)
for the original authoring decisions, and the
[review implementation status](documentation/reviews/2026-09-19-workspace-review.md#implementation-status)
for historical findings. Dated decisions and reviews retain former directory names,
commands and evidence paths; this README and the [build guide](documentation/build.md)
describe the current workflow. Removed scripts and evidence inventories remain in Git history.
