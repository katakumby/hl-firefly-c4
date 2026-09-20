# Architecture

For the three-AZ Azure/AKS deployment of Besu and FireFly, start with the
[blockchain foundation initiative](initiatives/blockchain-foundation/README.md).

Edit Structurizr DSL directly. Docker Compose serves the authored workspaces;
validation and export run in containers. No host Python or shell scripts are needed.

## Directory structure

```text
architecture/
├── workspace.dsl            # Reference workspace and its views
├── model.dsl                # Extendable shared model and styles; no views
├── styles.dsl               # Global styles inherited by every workspace
├── model/
│   ├── people.dsl           # Shared actors
│   ├── external-systems/     # Existing products and reference systems
│   ├── modules/              # Reviewed, accepted platform systems
│   └── relationships/        # Ordered relationship fragments
├── views/reference/         # Automatically included reference view fragments
├── initiatives/<epic-id>/    # Initiative workspace, model, views and use cases
├── templates/initiative/    # Starting point for new initiatives
├── documentation/           # Shared explanations and system-specific docs
├── use-cases/               # Shared flows and detailed sequences
├── decisions/adr/           # Architecture decisions
├── decisions/workspace/     # Authoring and tooling decisions
├── scripts/                 # Python validation/export command and path helper
├── tests/                   # Containerized tooling tests
├── compose.yaml             # global, ignition, blockchain-foundation and optional tools
└── .env                     # Pinned Structurizr version
```

Generated outputs go to `../build/architecture/` and are ignored by Git.
The native viewer also creates ignored `workspace.json` and `.structurizr/`
caches beside the DSL.

## Authoring patterns

- **Share definitions, choose views locally.** The reference workspace and
  initiatives extend `model.dsl`. Declare elements before relationships using
  explicit, ordered includes; keep relationships in separate fragments.
- **Add reference diagrams without editing the entrypoint.** Save view blocks
  as `.dsl` files in `views/reference/`; `workspace.dsl` includes that directory.
  Keep these fragments self-contained and their view keys unique.
- **Select by intent.** Use `element.parent==<identifier>` for all children of a
  system or container; relationships between included elements appear automatically.
  Keep explicit selections for focused flows. Matching new children and relationships
  will appear automatically, so review affected diagrams after model changes.
- **Style once.** Edit [styles.dsl](styles.dsl) for shared element and relationship
  styles, including the `Proposed` tag. `model.dsl` includes it once; reference,
  initiative and variant workspaces inherit it automatically.
- **Keep proposals in their initiative.** Start from the
  [template](templates/initiative/README.md), record ownership and epic links
  (`TBD` when unknown), and prefix view keys with `<epic-id>-`.
- **Preserve identity when promoting.** Move reviewed definitions into shared
  modules; retain stable identifiers and `architecture.id`. Validate all
  workspaces after shared changes.
- **Use variants only for distinct designs.** Optional
  `variants/<variant>/workspace.dsl` extends its initiative workspace. Prefix
  new view keys with `<epic-id>-<variant>-`.
- **Attach documentation where it belongs.** Shared docs and ADRs attach once
  at workspace level. System attachments contain only system-specific content.

These are team conventions. Validation uses native Structurizr `validate` and
`inspect`; DSL inspection properties control severity. There are no custom
architecture validation rules.

## Essential commands

Run these commands **from this `architecture/` directory**. Values passed to
`--workspace` remain repository-relative paths inside the tools container.

| Action | Command |
|---|---|
| View all three workspaces | `docker compose up -d` |
| Start reference viewer | `docker compose up -d global` |
| Start ignition viewer | `docker compose up -d ignition` |
| Start blockchain foundation viewer | `docker compose up -d blockchain-foundation` |
| Stop and remove viewers | `docker compose down` |
| Validate all workspaces | `docker compose run --rm --build tools validate` |
| Validate ignition | `docker compose run --rm --build tools validate --workspace architecture/initiatives/ignition/workspace.dsl` |
| Validate blockchain foundation | `docker compose run --rm --build tools validate --workspace architecture/initiatives/blockchain-foundation/workspace.dsl` |
| Export all reference diagrams as C4-PlantUML | `docker compose run --rm --build tools export` |
| Export ignition diagrams as C4-PlantUML | `docker compose run --rm --build tools export --workspace architecture/initiatives/ignition/workspace.dsl` |
| Export blockchain foundation diagrams as C4-PlantUML | `docker compose run --rm --build tools export --workspace architecture/initiatives/blockchain-foundation/workspace.dsl` |
| Export one C4-PlantUML diagram | `docker compose run --rm tools export --view 01-landscape` |
| Export optional Mermaid definitions | `docker compose run --rm tools export --format mermaid` |
| Export all reference diagrams as SVG | `docker compose run --rm tools export --format svg` |
| Export one diagram as PNG | `docker compose run --rm --build tools export --view 01-landscape --format png` |

Open [reference](http://127.0.0.1:8080), [ignition](http://127.0.0.1:8081), or
[blockchain foundation](http://127.0.0.1:8082).
Viewing reads DSL directly without preprocessing; refresh the browser after edits.
Add a named Compose service for each new initiative or variant, following the template.

Export validates first and defaults to `--format plantuml` using C4-PlantUML,
the primary agent review output. `--format mermaid` requests optional Mermaid
definitions, while `--format svg` and `--format png` request images.
Add `--workspace <workspace.dsl>` to
select any authored initiative or variant, and `--view <key>` for one diagram.
Add `--clean` to **the first export only** to clear all
`../build/architecture/` outputs before rebuilding; `local.env` and the command
lock are preserved. Without it, successful exports replace only their selected
workspace, diagram set and format. Cleaned outputs cannot be restored if the rebuild fails.

Complete exports are under `../build/architecture/workspaces/reference/exports/all/`
and `../build/architecture/workspaces/initiatives/<epic-id>/workspace/exports/all/`.
Single-view exports use `exports/view-<key-hash>/<format>/`. The default `plantuml/`
directory contains `structurizr-<view-key>.puml` and `export.json`; the command
prints its destination. See the [format table](../README.md#export-c4-plantuml-default-mermaid-svg-or-png)
and [output reference](../README.md#outputs-and-maintenance) for optional formats,
filenames, metadata and logs.

## Final review

Regenerate affected C4-PlantUML exports and review their `.puml` text first, then
check relevant DSL definitions. Read the compact C4 macros directly; routine
agent reviews need no renderer. Review images only when explicitly requested. If DSL corrections
are needed, regenerate the affected exports before completing the review. Failed
exports preserve older files; do not use those as current evidence. Generated
files stay untracked, and DSL remains the authoring source. The persistent agent
instructions are in [AGENTS.md](../AGENTS.md).

See the [repository README](../README.md) for corporate configuration and the
full contribution workflow.
