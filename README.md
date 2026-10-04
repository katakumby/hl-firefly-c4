# Modular platform architecture workspace

Solutions Architects and Technical Leads collaborate here on a shared reference
model and separate initiative proposals. Architects author static C4 in Structurizr DSL and reference UML patterns.
Technical leads primarily own behavioral/use-case and code diagrams, authored
as standalone PlantUML (`.puml`) or Mermaid (`.mmd`) files. All generated
artifacts stay under ignored `build/`.

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
├── model.dsl                     # Extendable model and styles; no authored diagrams
├── model/
│   ├── people.dsl                # Shared actors
│   ├── external-systems/         # Product catalog, internals and reference examples
│   ├── platform/                 # Approved platform definitions; currently empty of DSL
│   └── relationships/            # Explicit, ordered relationship fragments
├── views/
│   ├── external-systems/         # Shared C4 reference views
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
│   ├── select-light-run.cjs      # GitHub lookup of a matching lightweight artifact
│   └── select-azure-light-run.cjs # Azure lookup of a matching lightweight artifact
├── compose.yaml                  # Viewer services and two image-only tools services
├── .env                          # Committed toolchain version pins; no secrets
├── .gitignore                    # Generated outputs and cache exclusions
├── AGENTS.md                     # Validation and final-review instructions
├── README.md                     # Repository navigation and authoring workflow
└── build/                        # Ignored generated diagrams, reports and local settings
```

`model.dsl` assembles shared definitions and styles for reuse. `workspace.dsl`
extends it and adds the published views from `views/`. A workstream extends the
model to reuse definitions while choosing its own views; it does not need to
inherit the shared workspace's entire view catalog. Shared model fragments belong
in `model/`, never in a second "shared" directory under `workspaces/`.

Each `workspaces/<epic-id>/` normally has the following shape. The two current
workspaces follow it; blockchain-foundation also owns `deployment.dsl`,
`failure.dsl` and `styles.dsl` beside its entrypoint.

```text
workspaces/<epic-id>/
├── workspace.dsl     # Extends the shared model; includes local model and views
├── model.dsl         # Local proposals and inherited-element annotations
├── views/            # Focused C4 views; inline views in workspace.dsl are also supported
├── uml/              # Local standalone .puml/.mmd diagrams, with any nested folders
├── docs/             # Local explanations, evidence and design notes
└── README.md         # Scope, status, owners and navigation
```

Every workspace loads its own model instance. Local additions and annotations,
including `Future` tags on inherited elements, stay local; include/exclude
expressions choose what its views show. Optional nested variants extend their
parent workspace. See [variants and promotion](#variants-and-promotion) for the
reviewed move of accepted definitions, views and behavioral diagrams into shared folders.

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

### Export C4-PlantUML (default), Mermaid, SVG or PNG

Export validates fresh sources first. Omit `--workspace` for the reference
workspace and `--view` for all diagrams in that workspace. Both `export` and
`export-native` support the same selection options:

| Selection | Arguments |
|---|---|
| Every discovered workspace, including nested variants | `--all-workspaces` |
| One workspace, all its views | `--workspace <path>` |
| One view | `--workspace <path> --view <key>` |
| Several views | `--workspace <path> --view <key1> --view <key2>` |

Repeated keys are deduplicated. `--all-workspaces` cannot be combined with
`--workspace` or `--view`. Unknown keys are reported together before rendering.
Each selected workspace is validated once, and the whole request is staged before
publication: a later workspace failure preserves all previous successful exports.

```text
docker compose run --rm --pull never tools export
docker compose run --rm --pull never tools export --workspace workspaces/ignition/workspace.dsl
docker compose run --rm --pull never tools export --view 01-landscape
docker compose run --rm --pull never tools export --all-workspaces
docker compose run --rm --pull never tools export --workspace workspaces/ignition/workspace.dsl --view ignition-example-containers --view stable_key_name
```

Add `--format` to any selection to choose an output:

| Format | Native exporter | Diagram filename |
|---|---|---|
| `plantuml` (default) | [C4-PlantUML](https://docs.structurizr.com/export/c4plantuml), `plantuml/c4plantuml` | `<view-key>.puml` |
| `mermaid` | [Mermaid](https://docs.structurizr.com/export/mermaid) | `<view-key>.mmd` |
| `svg` | PlantUML rendering of the C4 export | `<view-key>.svg` |
| `png` | PlantUML rendering of the C4 export | `<view-key>.png` |

```text
docker compose run --rm --pull never tools export --format mermaid
docker compose run --rm --pull never tools export --view 01-landscape --format png
```

C4-PlantUML is the primary agent review output. Its compact definitions use the
built-in PlantUML C4 standard library, C4 styling and embedded legends; authored
export properties can customize them. Text exports preserve the native output
and need no browser or separate renderer installation.

Mermaid does not reproduce every Structurizr shape, style or layout feature.
Consumers rendering its HTML labels need `"securityLevel": "loose"`. Routine
reviews read exported text directly. C4 SVG/PNG exports render the same
C4-PlantUML definitions; their layout can differ from the native Structurizr viewer.

The pinned C4 exporter does not support Structurizr `filtered` views. An ordinary
C4 export or lightweight build containing them fails before rendering and lists
their keys. Select supported diagrams with `--view`, or use `tools-browser
export-native` for filtered views with native layout. No views are silently omitted.

A successful export updates the canonical files for its requested workspace,
selection and format. Other diagrams and formats retain their files and freshness metadata.
The command reports the file count; `build/artifacts.json` lists the exact output paths. See
[outputs and maintenance](#outputs-and-maintenance) for directories and metadata.

To refresh C4-PlantUML text for every discovered workspace:

```text
docker compose run --rm --pull never tools export --all-workspaces
```

Use the [two-stage build](#build-all-diagrams) to regenerate all ordinary diagrams,
including images and authored UML. For an intentional reset, add `--clean` to the **first export
only**. This removes all inventory-managed diagram formats and reports before validation;
the exports above then restore C4-PlantUML text only.
It preserves captured manual layouts in `build/.layouts/`, `local.env`, the writer
lock, and unrelated or historical artifacts.
A failed rebuild cannot restore explicitly cleared files. Ordinary full builds
already prune obsolete managed files after successful generation.

### On-demand Structurizr layouts and animations

Use `export-native` for images that preserve Structurizr's saved manual positions,
relationship routing and canvas size, or for animated GIFs. It uses Structurizr's
own browser renderer; ordinary `export --format svg|png` continues to render
C4-PlantUML. Normal `build` and the CI examples do not run native exports.

For manual views, omit `autoLayout`, arrange the diagram in the viewer, and
explicitly save it. The viewer writes `workspace.json` beside the DSL. Capture
that saved state before exporting:

```text
docker compose run --rm --pull never tools capture-layout --workspace workspaces/ignition/workspace.dsl
docker compose run --rm --pull never tools-browser export-native --workspace workspaces/ignition/workspace.dsl --format svg
docker compose run --rm --pull never tools-browser export-native --workspace workspaces/ignition/workspace.dsl --view ignition-example-containers --format png
docker compose run --rm --pull never tools-browser export-native --workspace workspaces/ignition/workspace.dsl --view example-container-animation --view stable_key_name --format gif
docker compose run --rm --pull never tools-browser export-native --all-workspaces --format svg
```

Capture stores the saved JSON and capture metadata in
`build/.layouts/<workspace-entrypoint>/`. Native export parses current DSL and
merges this snapshot's layout into it. Model contents, view selections and
animation definitions continue to come from DSL. Automatic views need no snapshot;
a missing required manual layout fails the request. Capture again after saving
new layout edits. Keep explicit view keys stable; native matching may recover
renamed views, but unmatched keys are reported for review.

Native formats are `svg` (default), `png` and `gif`. A workspace-wide GIF export
skips nonanimated views and reports them; explicitly selecting a nonanimated view
as GIF fails before rendering. Static animations reveal DSL animation steps;
dynamic GIFs follow relationship playback and finish with the complete overview.
The pinned renderer's dynamic batch-export limitation is handled through its
playback API. GIFs use the same bundled Gifshot encoder as the web application.
Use `--frame-duration 3` to control seconds per frame (default 3; range
0.01–655.35, rounded to hundredths). Exports use light mode, include metadata,
preserve canvas dimensions and do not crop frames.

Native files use the same mirrored folders with distinct, stable suffixes:
`<view-key>.structurizr.svg`, `.structurizr.png` or `.structurizr.gif`.
Separate native legends use `<view-key>.structurizr-key.svg` or `.png`.
The inventory records renderer versions, layout fingerprint and GIF timing.
Native reports use `export-native-status.json` and `export-native.log` in each
workspace's report directory; `.reports/export-native-status.json` summarizes
the whole request. Ordinary exports similarly have `.reports/export-status.json`.

Selected exports replace only requested views and formats. Normal builds preserve
native files still belonging to current sources/views, without refreshing their
metadata; successful builds prune obsolete destinations. Layout snapshots survive
`--clean`, but deleting the entire `build/` directory removes them. They are ignored
by Git: back them up or copy them explicitly to share manual work. See the
[capture and restore instructions](documentation/build.md#manual-layout-snapshots).

### Build all diagrams

Build in two explicit stages, using two separately named images without explicit tags:

| Service / image | Work |
|---|---|
| `tools` / `dlt-architecture-tools-light` | Validate all workspaces; export C4-PlantUML; render C4 and authored PlantUML SVG/PNG |
| `tools-browser` / `dlt-architecture-tools-browser` | Complete deferred Mermaid SVG/PNG from a matching successful light build; native exports on demand |

```text
docker compose run --rm --pull never tools build
docker compose run --rm --pull never tools-browser build-browser
```

The frequent `build` command uses no browser or Node runtime. It discovers all
shared and workspace-local UML sources and checks cross-format collisions, but
records Mermaid sources and expected image paths as deferred. Mermaid syntax is
checked when the browser stage renders it. Existing Mermaid images retain their
previous freshness metadata until browser completion.

`build-browser` verifies the light report, current source fingerprint, installed
toolchain compatibility, required artifact/report hashes and CI commit when provided.
It renders only Mermaid:
it does not reparse DSL or repeat C4/PlantUML generation. Missing or stale handoffs
fail before rendering. For incompatible installed tools, reacquire approved images
under the same image names and rerun the light stage. Each stage renders offline
and publishes its own selection atomically. Native images and GIFs remain explicit
`export-native` operations; neither ordinary stage invokes them.
Inspection errors and warnings are printed during the build and recorded in each
workspace's `validation.json` / `validation.log`, plus `build/build.json` and
`build/build.log`. Reports distinguish `inspection_passed` from the command's
`passed` result and declare the `strict` or `report-only` inspection policy.
Inspection findings keep their original severity; they do not block publication.
Explicit stable view keys and collision-free output paths are still required.
Each standalone `.puml` or `.mmd` source contains one diagram. Use `.pumlinc` for local PlantUML includes;
paths resolve relative to the including source. Remote includes require replacing
URLs with repository files or bundled PlantUML libraries. A `.puml` and `.mmd`
with the same relative stem are rejected because their image outputs would collide.

C4 outputs use the paths described below. Authored UML mirrors its source path:
`uml/patterns/example/sequence.puml` produces
`build/uml/patterns/example/sequence.svg` and `.png`; workspace-local diagrams
produce `build/workspaces/<epic-id>/uml/...` images. Mermaid and PlantUML are
independent authoring choices; there is no conversion or generated participant list.
Optional comments can record canonical model IDs. A future consistency fitness
check will warn about discrepancies; this build does not implement it.

Markdown links to the source and to relative generated SVG/PNG paths. Previews
require the corresponding successful stage; Mermaid previews require browser completion. All 14 existing FireFly–Besu sequences have standalone
sources beside their use-case README. Consumers may copy generated images or
embed this repository with both sources and build output; preserve relative paths
when copying linked Markdown. No documentation hosting service is required.

`build/build.json` records the latest stage attempt, source fingerprint, renderer
versions, sources and output paths. `passed: true` with `stage: light` means the
lightweight stage succeeded; `complete: true` requires browser completion.
`build/.reports/build-light.json` and `build-browser.json` retain each stage's
report, with adjacent `.log` diagnostics. A failed stage preserves previous
artifacts and records failure. Light builds prune obsolete C4/PlantUML outputs;
browser completion prunes obsolete Mermaid outputs after successful generation.
Individual exports also record their latest attempt in `export-status.json`.

The repository can be cloned or used as a Git submodule beneath another codebase.
Run Compose here, or use `docker compose --project-directory <checkout>
--env-file <checkout>/.env -f <checkout>/compose.yaml ...` from elsewhere. Paths passed to `--workspace` are relative to this architecture
repository, independent of the parent repository and Git metadata.

### Final architecture review

Regenerate C4-PlantUML for the affected workspace or diagrams as the final review
step. Read those fresh `.puml` exports first, then inspect relevant DSL definitions for
correctness and details the export omits. Review images only when explicitly
requested. If corrections change the DSL, regenerate affected exports before
completing the review. A failed export leaves previous successful files in place;
those files are not current review evidence. Keep generated exports untracked and
make corrections in DSL. See [AGENTS.md](AGENTS.md) for persistent agent guidance.

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

Diagram outputs mirror their source directories recursively, with formats side by side:

| Source | Generated output |
|---|---|
| `views/external-systems/01-landscape.dsl` | `build/views/external-systems/01-landscape.{puml,svg,png}` |
| `workspaces/blockchain-foundation/views/main.dsl` | `build/workspaces/blockchain-foundation/views/<view-key>.{puml,svg,png}` |
| Inline view in `workspaces/ignition/workspace.dsl` | `build/workspaces/ignition/<view-key>.{puml,svg,png}` |
| `uml/patterns/messaging/claim-check/sequence.puml` | `build/uml/patterns/messaging/claim-check/sequence.{svg,png}` |
| `workspaces/ignition/uml/payments/submit.mmd` | `build/workspaces/ignition/uml/payments/submit.{svg,png}` |

A DSL file may declare multiple views; each uses its explicit view key as the
filename. `export --view` writes the same canonical file as a complete export.
Inherited views retain their relative view folders within the consuming workspace:
`workspaces/team/variants/future/workspace.dsl` writes inherited `views/main.dsl`
views into `build/workspaces/team/variants/future/views/`. Inline views use the
workspace directory. Named noncanonical entrypoints get their own stem namespace.
Local include/extension provenance is cross-checked with native Structurizr view
keys. Ambiguous declarations, generated keys, unsafe filenames and collisions
(including case-only differences) fail before publication. Keep view keys literal
and include/extends paths local; plugin/script-generated views cannot be mapped.

The generated tree separates mirrored diagrams from reports and local execution state:

```text
build/
├── views/                        # Shared C4 files, mirroring views/
├── uml/                          # Shared UML images, mirroring uml/
├── workspaces/<epic-id>/          # Local/inherited C4 files and local UML images
├── .reports/
│   ├── workspace.dsl/            # Reports and parsed JSON for the shared workspace
│   ├── workspaces/<epic-id>/workspace.dsl/  # Reports for each workstream
│   ├── build-light.{json,log}    # Lightweight handoff status and diagnostics
│   ├── build-browser.{json,log}  # Browser completion status and diagnostics
│   └── light/<workspace-entrypoint>/     # Frozen validation evidence for handoffs
├── .layouts/<workspace-entrypoint>/  # Captured manual layouts; preserved by --clean
├── artifacts.json                # Inventory of managed files and per-format freshness
├── build.json                    # Latest stage attempt, completion state and findings
├── build.log                     # Latest stage diagnostics
├── .tools.lock                   # Persistent writer-lock file
├── .staging/                     # Temporary publication state; cleaned after completion
└── local.env                     # Optional local Compose settings; never an artifact
```

`build/.reports/<workspace-entrypoint>/` holds `workspace.json`, `validation.json`,
`validation.log`, and the latest `export-status.json` / `export.log` when exported.
For example, root validation is `build/.reports/workspace.dsl/validation.json`.
The parsed JSON remains the last successful validation if a later attempt fails.
`build/artifacts.json` inventories each diagram's source, workspace, view key,
format, source/output fingerprints, versions and generation time. A retained
format is current only when its fingerprint matches current inputs; exporting
PlantUML does not refresh older SVG metadata. Native exports also require a matching
captured-layout fingerprint. Hashes never determine filenames.

One writer lock protects `build/.staging/`. Publication updates individual files
and an on-disk journal allows the next command to recover interrupted publication.
Failures preserve previous successful diagrams and inventory; attempt reports
record failure. Completing both stages prunes removed/moved views and sources,
and removes recognized outputs from the previous `build/c4/` layout. Unrelated
historical files and local settings remain untouched. Empty generated folders
are removed. Build twice without source changes to get the same output path set.

Freshness scans architecture sources, documentation and tooling, including accepted
inputs in hidden folders and local include fragments. Generated output, Git metadata,
agent configuration and known caches are excluded; a leading dot alone does not
exclude an authoring input. Native Structurizr viewers write ignored `workspace.json`
and `.structurizr/` caches beside DSL.
Local includes must stay inside the checkout and outside those excluded directories.
DSL remains the source of truth.

Tooling lives in [scripts](scripts), with containerized tests in [tests](tests):

```text
docker compose run --rm --pull never --entrypoint python3 tools -B -m unittest discover -s tests -v
docker compose run --rm --pull never --entrypoint python3 tools-browser -B -m unittest discover -s tests -v
```

### Corporate environment and CI

See the [corporate Docker guide](documentation/build.md) for approved image
acquisition, offline image archives, plain Docker commands, permissions and
explicit platform-team image maintenance. See [CI examples](ci/examples/README.md)
for GitHub Actions and Azure DevOps Services pipelines. Push/PR jobs test and build
the lightweight outputs. Scheduled or manual browser jobs reuse an available
lightweight artifact for the exact commit and complete Mermaid rendering. Both
publish only allowlisted artifacts; failed jobs upload diagnostics only.

## Contributing an initiative

These are recommended team conventions, not custom validation gates. The initial
workflow relies on native Structurizr validation; automation of team-specific
rules is deferred until teams choose to introduce it.

1. Create `workspaces/<epic-id>/` with a README recording goal, status, architect,
   technical lead/team, and epic link. Use `TBD` for unknown values.
2. Start with the [initiative template](templates/initiative/README.md),
   extending `../../model.dsl`. Add an agreed model and focused views. The template
   uses native `model.element.noview` informational settings for inherited elements.
   Adjust inspection properties in DSL as the initiative needs. Include local
   `model.dsl` and `views/main.dsl`; keep proposals local.
3. Prefix view keys with `<epic-id>-`. Give elements stable, meaningful
   `architecture.id` values; do not duplicate shared systems.
4. Use explicit ordered includes: actors and systems first, relationships
   afterward. Label arrows with their action and protocol. Use descriptive
   relationship identifiers for partial selections between the same endpoints.
5. Add use cases when behavior is agreed. Validate your workspace and validate
   all workspaces for shared model, style or tooling changes.

Keep `architecture.id` and `evidence` on elements. Reference elements and
relationships retain `architecture.sources` as a JSON array of evidence URLs;
the element `url` is its primary source. Proposals use
`evidence "Proposed architecture"` and `architecture.status "proposed"`.
Containers/components require technology metadata.

Relationships are declared after all elements. FireFly relationships are split
by source container; cross-system relationships are split by source system,
with actor-originated relationships together. Keep the explicit ordered include
entrypoints, and define each relationship once.

Reference diagrams use the directory include `!include views/external-systems` in
`workspace.dsl`. Add a self-contained `.dsl` view fragment there;
no new entrypoint include is needed. Approved platform views are included
from `views/platform/` in the same way. Global element and relationship styles,
including the `Proposed` tag, live in `styles/styles.dsl` and are included
once by the shared model. Initiatives and variants inherit them automatically.

Use `element.parent==<identifier>` when a view should show every child of a
system or container. Relationships between included elements appear automatically;
reserve explicit relationship selections for focused flows. These expressions
also include future matching model additions, so review affected diagrams when
the model changes.

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

## Variants and promotion

Create `variants/interim/workspace.dsl` or `variants/target/workspace.dsl`
only when designs differ. Each extends `../../workspace.dsl` and includes
variant-local fragments. Use view keys such as `<epic-id>-interim-...`.
Each workspace loads an independent model instance. Local `!element` or
`!elements` annotations (for example, adding `Future` tags) do not edit the
shared definitions or affect sibling workspaces. Use include/exclude expressions
to select local alternatives. Extension inherits parent models and views;
variants are additive. Select the
desired elements in each view instead of deleting inherited definitions.
Use `<epic-id>-<variant>-` for local variant keys as a naming convention;
inherited keys stay unchanged.

After explicit approval, **move** accepted definitions into `model/platform/`
and shared relationship fragments,
preserving identifiers. Remove initiative-local definitions in the same change,
add explicit shared includes, and validate every entrypoint. Promote approved C4 views into `views/platform/` and reusable
behavioral diagrams into `uml/` with the model. Keep shared files independent of initiative folders
as an authoring convention reviewed by the team.

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
