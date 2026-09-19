# Modular platform architecture workspace

Solutions Architects and Technical Leads collaborate here on a shared reference
model and separate initiative proposals. **Edit the DSL directly.** Validation
and preview derive outputs without rewriting the model.

## Start here

- [Shared reference workspace](architecture/workspace.dsl): shared C4 reference views.
- [Unleash reference](architecture/documentation/system/unleash/01-boundary-and-components.md):
  OSS server and optional OSS Edge, with containers, components and all internal data flows.
- [Ignition](architecture/initiatives/ignition/README.md): the proposed **DApp Platform** system
  boundary, with no internal architecture or integrations yet.
- [Shared model](architecture/model.dsl): reusable actors, external systems,
  relationships and styles, without authored diagrams.
- [Architecture documentation](architecture/documentation/workspace/01-logical-architecture.md)
  and [FireFly/Besu use cases](architecture/use-cases/firefly-besu/README.md).
- [Architecture decisions](architecture/decisions/adr),
  [workspace decisions](architecture/decisions/workspace), and
  [reference evidence](architecture/references/README.md).

## Layout and ownership

| Location | Purpose |
|---|---|
| `architecture/workspace.dsl` | Reference entrypoint, alongside the extendable `model.dsl` |
| `architecture/compose.yaml` | Named `global` and `ignition` viewers, plus optional Docker tools |
| `architecture/model/external-systems/` | Reference systems, each with a folder and container fragments |
| `architecture/model/modules/` | Reviewed platform systems; initially no definitions |
| `architecture/model/relationships/` | Relationships grouped by system, plus cross-system integrations |
| `architecture/views/reference/` | Reference view fragments, automatically included by the reference workspace |
| `architecture/styles.dsl` | Global styles inherited by reference, initiative and variant workspaces |
| `architecture/documentation/` | Explanations and system boundaries |
| `architecture/use-cases/` | Shared simple flows and detailed sequences |
| `architecture/initiatives/<epic-id>/` | Goals, ownership, proposed model, focused views and use cases |
| `architecture/references/` | Evidence and clearly marked historical material |
| `architecture/scripts/` | Containerized validation and diagram export |
| `architecture/templates/initiative/` | Incomplete authoring templates; excluded from workspace discovery |
| `build/architecture/` | Generated artifacts; ignored by Git |

Existing application and operations examples remain reference choices, not
adopted platform modules. Security examples are independent options, not a
mandatory combined stack.

Unleash is an independent, reusable product reference with no selected consumer
integrations. Its eight `110-unleash-` views cover Unleash 8.2.0 and OSS Edge
20.5.0. The [flow catalog](architecture/documentation/system/unleash/02-interfaces-and-flows.md)
documents every named relationship; [behavior and evidence](architecture/documentation/system/unleash/03-behavior-and-evidence.md)
explain optional storage, offline mode, recovery and edition boundaries.

## Docker-only workflow

Install Docker with the Compose plugin. **No host Python, Java, PowerShell, Bash
scripts or pip packages are required.** Run these single-line Docker commands
from the repository root in your terminal.

The viewer uses the pinned Structurizr image directly. No scripts, custom image
build, validation command or generated JSON are required before viewing.
Python runs only when you explicitly request validation, export or tooling tests.
Compose automatically reads the committed version pin in `architecture/.env`.

### Validate

```text
docker compose -f architecture/compose.yaml run --rm --build tools validate
docker compose -f architecture/compose.yaml run --rm --build tools validate --workspace architecture/initiatives/ignition/workspace.dsl
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

### Export SVG or PNG

Exports validate the selected workspace first. Omit `--workspace` for the
reference workspace, and omit `--view` to export all its diagrams.

```text
docker compose -f architecture/compose.yaml run --rm --build tools export --format svg
docker compose -f architecture/compose.yaml run --rm --build tools export --format png --view 01-landscape
docker compose -f architecture/compose.yaml run --rm --build tools export --workspace architecture/initiatives/ignition/workspace.dsl --view ignition-dapp-platform-context --format svg
```

For a clean rebuild, add `--clean` to the first export command. This removes
existing generated files under `build/architecture/`, including old exports
and historical build folders, before validating and exporting. It preserves
`local.env` and the command lock. Authored sources, reference history and
evidence caches outside this directory are unaffected.

To rebuild both workspaces, clean once and then export the initiative:

```text
docker compose -f architecture/compose.yaml run --rm --build tools export --clean --format svg
docker compose -f architecture/compose.yaml run --rm tools export --workspace architecture/initiatives/ignition/workspace.dsl --format svg
```

Without `--clean`, each successful export replaces its selected diagram set,
including removal of obsolete images. Use `--clean` only on the first command
when exporting multiple workspaces or formats; it clears all architecture build
outputs, and a subsequent failure cannot restore those explicitly cleared files.

### View architecture directly from DSL

Start **both workspaces** from the repository root:

```text
docker compose -f architecture/compose.yaml up -d
```

Or, from inside `architecture/`, simply run `docker compose up -d`.
Only the native viewers start; the optional tools service is excluded by its profile.

| Compose service | Authored entrypoint | Open |
|---|---|---|
| `global` | `architecture/workspace.dsl` | [Global reference workspace](http://127.0.0.1:8080) |
| `ignition` | `architecture/initiatives/ignition/workspace.dsl` | [Ignition](http://127.0.0.1:8081) |

To start just one service, choose its name:

```text
docker compose -f architecture/compose.yaml up -d global
docker compose -f architecture/compose.yaml up -d ignition
```

Compose mounts `architecture/` directly at `/usr/local/structurizr`.
Structurizr's native `local` command takes the **directory containing**
`workspace.dsl`: the global viewer uses `/usr/local/structurizr`, and ignition
uses `/usr/local/structurizr/initiatives/ignition`. The original directory tree
is intact, so local includes and workspace extensions resolve normally.
There is no wrapper DSL, preparation container, Python startup or preprocessing.

Edit the DSL and refresh the browser. No export or restart is needed for DSL
changes. Structurizr performs its own parsing; the optional `tools validate`
command runs the native validator and inspector and saves their results.

For another initiative or variant, add a named service in `architecture/compose.yaml`
using the shared `viewer` anchor, its workspace directory and an unused localhost
port. The [initiative template](architecture/templates/initiative/README.md) shows
the service definition. All workspace choices are visible in one Compose file.

Stop one viewer, or stop and remove both:

```text
docker compose -f architecture/compose.yaml stop ignition
docker compose -f architecture/compose.yaml down
```

### Outputs and maintenance

Current outputs live in `build/architecture/workspaces/reference/` or
`build/architecture/workspaces/initiatives/<epic-id>/workspace/`:

- `workspace.json`: last successfully validated model.
- `validation.json` and `validation.log`: latest validation result, including failures.
- `exports/all/svg/` or `exports/all/png/`: complete exported diagram sets.
- `exports/view-<key-hash>/<format>/`: individual view exports.

Failed validation does not overwrite successful validation JSON or exports.
The native viewer reads DSL independently of validation results.
Exports replace their selection only after successful rendering; removed views
do not leave old images behind. Tools run sequentially with one writer per checkout.
There is no run-history retention service. Older outputs outside these paths
are historical and are not used; `export --clean` removes them. Everything generated remains under
ignored `build/architecture/` for the Python tools. Native Structurizr local mode
requires its mounted data directory to be writable and creates `workspace.json`
and `.structurizr/` cache/log files beside the selected DSL. These native files
are ignored by Git; they are outputs, not preprocessing inputs. DSL remains the
source of truth. Older prepared-viewer directories under `build/architecture/`
are historical and no longer used.

Only [architecture.py](architecture/scripts/architecture.py) is a command.
One small supporting module, [workspace_paths.py](architecture/scripts/workspace_paths.py),
handles paths, workspace discovery and the shared version pin. The test suite lives in
[architecture/tests](architecture/tests). After changing tooling, validate and run:

```text
docker compose -f architecture/compose.yaml run --rm --entrypoint python3 tools -B -m unittest discover -s architecture/tests -v
```

### Corporate environment

The image uses Structurizr **2026.06.28**, centrally selected in
[architecture/.env](architecture/.env), and Ubuntu's Python standard library.
Building needs access to the approved image/package repositories. Afterwards,
validation and export run with networking disabled; the browser renderer is
already in the image. The viewer publishes its port only on localhost using
Docker's bridge network and disables Structurizr's outbound URL loading.

All services run as a non-root user with a read-only container filesystem,
dropped capabilities and no Docker socket. Tools receive read-only architecture
sources and write only to `build/architecture/`. The viewer mounts architecture
writable because native local mode keeps its cache beside the DSL; diagram editing
and autosave are disabled. Temporary files remain inside the container. The
tools container's temporary filesystem permits execution because Playwright
extracts its bundled driver there.

For a managed environment, have the platform team build, scan and publish the
tools image to an approved registry, then set `ARCHITECTURE_TOOLS_IMAGE` to its
approved image digest and omit `--build` from the commands. The base viewer image can likewise be mirrored using a
Compose override. Container isolation reduces host exposure; it does not
guarantee that arbitrary code is safe.

Defaults use UID/GID 1000. On Linux, ensure the selected architecture directory
and `build/architecture/` are writable
by that user or set `ARCHITECTURE_UID` and `ARCHITECTURE_GID` to your approved
local IDs. Docker Desktop handles the mounted Windows directory. Optional
settings, including `STRUCTURIZR_GLOBAL_PORT` and `STRUCTURIZR_IGNITION_PORT`, can
be placed in an ignored `build/architecture/local.env` file. For local overrides,
add `--env-file architecture/.env --env-file build/architecture/local.env` before
`-f` in the commands above. No shell script is needed.

## Contributing an initiative

These are recommended team conventions, not custom validation gates. The initial
workflow relies on native Structurizr validation; automation of team-specific
rules is deferred until teams choose to introduce it.

1. Create `architecture/initiatives/<epic-id>/` with a README recording goal, status, architect,
   technical lead/team, and epic link. Use `TBD` for unknown values.
2. Start with the [initiative template](architecture/templates/initiative/README.md),
   extending `../../model.dsl`. Add an agreed model and focused views. The template
   uses native `model.element.noview` informational settings for inherited elements.
   Adjust inspection properties in DSL as the initiative needs. Include local
   `model.dsl` and `views.dsl`; keep proposals local.
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

Reference diagrams use the directory include `!include views/reference` in
`architecture/workspace.dsl`. Add a self-contained `.dsl` view fragment there;
no new entrypoint include is needed. Global element and relationship styles,
including the `Proposed` tag, live in `architecture/styles.dsl` and are included
once by the shared model. Initiatives and variants inherit them automatically.

Shared changes are reviewed by affected architects and technical leads.
Record actual owners in initiative READMEs; CODEOWNERS enforcement is deferred
until team identities are available. Significant architecture decisions go in
`architecture/decisions/adr`; authoring/tooling decisions go in
`architecture/decisions/workspace`. Routine notes belong in READMEs.

Attach shared documentation and ADRs once at workspace level. The reference
workspace imports `architecture/documentation/workspace/` (including the
[shared boundary explanation](architecture/documentation/workspace/06-boundaries.md))
and both decision directories. Attach `!docs` or `!adrs` to a software system
only when it has documentation or decisions specifically about that system;
do not attach the shared directories to every system or create placeholder
documents to satisfy inspection checks.
Store system-specific documentation under
`architecture/documentation/system/<system-id>/`.

## Variants and promotion

Create `variants/interim/workspace.dsl` or `variants/target/workspace.dsl`
only when designs differ. Each extends `../../workspace.dsl` and includes
variant-local fragments. Use view keys such as `<epic-id>-interim-...`.
Extension inherits parent models and views; variants are additive. Select the
desired elements in each view instead of deleting inherited definitions.
Use `<epic-id>-<variant>-` for local variant keys as a naming convention;
inherited keys stay unchanged.

After review, **move** accepted definitions into shared modules/relationships,
preserving identifiers. Remove initiative-local definitions in the same change,
add explicit shared includes, and validate every entrypoint. Promote reusable
use cases with the model. Keep shared files independent of initiative folders
as an authoring convention reviewed by the team.

Ignition currently contains only the proposed DApp boundary. Its disconnected
inspection is informational through a native DSL property. Review that setting
when the design introduces children or integrations. There is no custom rule
preventing the proposal from evolving.

See [decision 7](architecture/decisions/workspace/0007-modular-workspaces.md) and
[decision 9](architecture/decisions/workspace/0009-container-only-tooling.md)
for policy, the [review implementation status](architecture/documentation/reviews/2026-09-19-workspace-review.md#implementation-status)
for the improvements, and [legacy material](architecture/references/legacy/README.md) for history.
