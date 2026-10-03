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
- [Ignition](workspaces/ignition/README.md): the proposed **DApp Platform** system
  boundary, with no internal architecture or integrations yet.
- [Shared model](model.dsl): reusable actors, external systems,
  relationships and styles, without authored diagrams.
- [Architecture documentation](documentation/workspace/01-logical-architecture.md)
  and [FireFly/Besu use cases](uml/use-cases/firefly-besu/README.md).
- [Architecture decisions](decisions/adr),
  [workspace decisions](decisions/workspace), and
  [boundaries and evidence](documentation/workspace/06-boundaries.md).

## Layout and ownership

| Location | Purpose |
|---|---|
| `workspace.dsl` | Reference entrypoint, alongside the extendable `model.dsl` |
| `compose.yaml` | Named `global`, `ignition` and `blockchain-foundation` viewers, plus optional Docker tools |
| `model/external-systems/` | Reference systems, each with a folder and container fragments |
| `model/platform/` | Reviewed platform systems; initially no definitions |
| `model/relationships/` | Relationships grouped by system, plus cross-system integrations |
| `views/external-systems/` | Reference view fragments, automatically included by the reference workspace |
| `styles/styles.dsl` | Global styles inherited by reference, initiative and variant workspaces |
| `documentation/` | Explanations and system boundaries |
| `uml/patterns/`, `uml/use-cases/`, `uml/code/` | Standalone reference patterns, behavioral and code diagrams |
| `views/platform/` | Approved platform C4 views |
| `workspaces/<epic-id>/` | Goals, ownership, proposed model, focused views and use cases |
| `scripts/` | Containerized validation and diagram export |
| `templates/initiative/` | Incomplete authoring templates; excluded from workspace discovery |
| `build/` | Generated artifacts; ignored by Git |

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

Install Docker with the Compose plugin. **No host Python, Java, PowerShell, Bash
scripts or pip packages are required.** Run these single-line Docker commands
from the repository root in your terminal.

The viewer uses the pinned Structurizr image directly. No scripts, custom image
build, validation command or generated JSON are required before viewing.
Python runs only when you explicitly request validation, export, builds or tooling tests.
Compose automatically reads the committed version pin in `.env`.

### Validate

```text
docker compose run --rm --build tools validate
docker compose run --rm --build tools validate --workspace workspaces/ignition/workspace.dsl
```

Without `--workspace`, validation discovers the reference workspace and every
initiative/variant named `workspace.dsl`. With `--workspace`, only the selected
entrypoint is checked. Structurizr resolves its includes and extensions, exports
fresh JSON, and runs native [`validate`](https://docs.structurizr.com/validate)
and [`inspect -severity error,warning`](https://docs.structurizr.com/inspect).

**There are no custom architecture validation rules.** Native errors and warnings
fail the command. Teams control inspection severity using Structurizr's
[`structurizr.inspection.*` properties](https://docs.structurizr.com/workspaces/inspections);
findings configured as `info` or `ignore` do not block validation. Existing DSL
settings for shared-reference coverage, workspace scope and the initial DApp
boundary remain in place, with no Python exceptions or allowlist. Missing
software-system documentation and ADRs are informational (`info`) findings,
configured in the shared model and inherited by initiatives.

Naming, evidence, ownership, diagram and dependency conventions below are
guidance for authors and reviewers. Custom enforcement can be introduced
progressively as teams agree on rules worth maintaining. Python currently only
selects workspaces, runs native commands and manages generated files.

### Export C4-PlantUML (default), Mermaid, SVG or PNG

Export validates fresh sources first. Omit `--workspace` for the reference
workspace and `--view` for all diagrams in that workspace:

```text
docker compose run --rm --build tools export
docker compose run --rm tools export --workspace workspaces/ignition/workspace.dsl
docker compose run --rm tools export --view 01-landscape
```

Add `--format` to any selection to choose an output:

| Format | Native exporter | Diagram filename |
|---|---|---|
| `plantuml` (default) | [C4-PlantUML](https://docs.structurizr.com/export/c4plantuml), `plantuml/c4plantuml` | `structurizr-<view-key>.puml` |
| `mermaid` | [Mermaid](https://docs.structurizr.com/export/mermaid) | `structurizr-<view-key>.mmd` |
| `svg` | PlantUML rendering of the C4 export | `<view-key>.svg` |
| `png` | PlantUML rendering of the C4 export | `<view-key>.png` |

```text
docker compose run --rm tools export --format mermaid
docker compose run --rm tools export --view 01-landscape --format png
```

C4-PlantUML is the primary agent review output. Its compact definitions use the
built-in PlantUML C4 standard library, C4 styling and embedded legends; authored
export properties can customize them. Text exports preserve the native output
and need no browser or separate renderer installation.

Mermaid does not reproduce every Structurizr shape, style or layout feature.
Consumers rendering its HTML labels need `"securityLevel": "loose"`. Routine
reviews read exported text directly. C4 SVG/PNG exports render the same
C4-PlantUML definitions; their layout can differ from the native Structurizr viewer.

A successful export replaces only its workspace, selection and format, removing
obsolete files from that destination. The command prints the output path; see
[outputs and maintenance](#outputs-and-maintenance) for directories and metadata.

For an intentional full rebuild of all three workspaces, add `--clean` to the
**first export only**:

```text
docker compose run --rm --build tools export --clean
docker compose run --rm tools export --workspace workspaces/ignition/workspace.dsl
docker compose run --rm tools export --workspace workspaces/blockchain-foundation/workspace.dsl
```

`--clean` clears `build/c4/`, `build/uml/`, `build/workspaces/`, and the full-build
reports before validation. It preserves `local.env`, the writer lock, and
historical or unrelated build directories. A failed rebuild cannot restore cleared files.

### Build all diagrams

```text
docker compose run --rm --build tools build
```

This validates every workspace once, exports its C4-PlantUML definitions, renders
those definitions to SVG and PNG, and renders every standalone `.puml`/`.mmd`
under shared `uml/` and workspace-local `uml/` directories. Rendering runs offline.
Each source contains one diagram. Use `.pumlinc` for local PlantUML includes;
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
require a successful build. All 14 existing FireFly–Besu sequences have standalone
sources beside their use-case README. Consumers may copy generated images or
embed this repository with both sources and build output; preserve relative paths
when copying linked Markdown. No documentation hosting service is required.

`build/build.json` records the latest attempt, source fingerprint, renderer
versions, sources and output paths. `build/build.log` records tool diagnostics.
A failed build preserves the previous images and exports, records `passed: false`,
and does not claim those artifacts are current. The complete build stages all
outputs before publication; successful builds remove obsolete authored UML outputs.
Individual exports also record their latest attempt in `export-status.json`.

The repository can be cloned or used as a Git submodule beneath another codebase.
Run Compose here, or use `docker compose -f <checkout>/compose.yaml ...` from
elsewhere. Paths passed to `--workspace` are relative to this architecture
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

Only the native viewers start; the optional tools service is excluded by its profile.

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

Current outputs live in `build/c4/reference/` or
`build/c4/workspaces/<epic-id>/`:

- `workspace.json`: last successfully validated model.
- `validation.json` and `validation.log`: latest validation result, including failures.
- `exports/all/plantuml/`: default C4-PlantUML definitions (`structurizr-<view-key>.puml`) with embedded legends; the primary agent review output.
- `exports/all/mermaid/`: optional Mermaid definitions, named `structurizr-<view-key>.mmd`.
- `exports/all/svg/` or `exports/all/png/`: optional complete image sets.
- `exports/view-<key-hash>/<format>/`: individual view exports; the hash is the first 12 hex characters of the view key's SHA-256.
- Each export directory contains `export.json` with its workspace, public format, native exporter format, selected view and source fingerprint; `export.log` records the latest export command output for that workspace.

Failed validation preserves the last successful `workspace.json` and exports;
`validation.json` and `validation.log` record the latest attempt.
The native viewer reads DSL independently of validation results.
Exports replace their selection only after successful export and output checks;
removed views do not leave old files in that selection. Tools run sequentially
with one writer per checkout.
Tools keep the latest results rather than a run history. Previous build layouts
are unused and preserved by current commands, including `export --clean`. Native Structurizr local
mode creates ignored `workspace.json` and `.structurizr/` caches beside the DSL;
these are viewer outputs. DSL remains the source of truth.

Only [architecture.py](scripts/architecture.py) is a command.
[workspace_paths.py](scripts/workspace_paths.py) handles root-relative paths,
workspace discovery and the shared version pin.
[diagram_renderers.py](scripts/diagram_renderers.py) handles offline rendering. The test suite lives in
[tests](tests). After changing tooling, validate and run:

```text
docker compose run --rm --entrypoint python3 tools -B -m unittest discover -s tests -v
```

### Corporate environment

The image uses Structurizr **2026.06.28**, centrally selected in
[.env](.env), and Ubuntu's Python standard library.
Building needs access to the approved image/package repositories. Afterwards,
validation, export and full builds run with networking disabled. PlantUML, its
C4 library, Graphviz, fonts, Mermaid CLI and Chromium are installed in the image.
Renderer versions and dependency-lock hashes are recorded in build metadata. The viewer publishes its port only on localhost using
Docker's bridge network and disables Structurizr's outbound URL loading.

All services run as a non-root user with a read-only container filesystem,
dropped capabilities and no Docker socket. Tools receive read-only architecture
sources and write only to `build/`. The viewer mounts architecture
writable because native local mode keeps its cache beside the DSL; diagram editing
and autosave are disabled. Temporary files remain inside the container. The
tools container's temporary filesystem permits execution for browser runtime compatibility.

For a managed environment, have the platform team build, scan and publish the
tools image to an approved registry, then set `ARCHITECTURE_TOOLS_IMAGE` to its
approved image digest and omit `--build` from the commands. The base viewer image can likewise be mirrored using a
Compose override. Container isolation reduces host exposure; it does not
guarantee that arbitrary code is safe.

Defaults use UID/GID 1000. On Linux, ensure the selected architecture directory
and `build/` are writable
by that user or set `ARCHITECTURE_UID` and `ARCHITECTURE_GID` to your approved
local IDs. Docker Desktop handles the mounted Windows directory. Optional
settings, including `STRUCTURIZR_GLOBAL_PORT` and `STRUCTURIZR_IGNITION_PORT`, can
be placed in an ignored `build/local.env` file. For local overrides,
add `--env-file .env --env-file build/local.env` immediately after `docker compose` in the commands above. No shell script is needed.

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

Ignition currently contains only the proposed DApp boundary. Its disconnected
inspection is informational through a native DSL property. Review that setting
when the design introduces children or integrations. There is no custom rule
preventing the proposal from evolving.

See [decision 7](decisions/workspace/0007-modular-workspaces.md) and
[decision 9](decisions/workspace/0009-container-only-tooling.md)
for policy, the [review implementation status](documentation/reviews/2026-09-19-workspace-review.md#implementation-status)
for historical findings. Removed scripts and evidence inventories remain in Git history.
