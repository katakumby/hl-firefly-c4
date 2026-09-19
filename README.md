# Modular platform architecture workspace

Solutions Architects and Technical Leads collaborate here on a shared reference
model and separate initiative proposals. **Edit the DSL directly.** Validation
and preview derive outputs without rewriting the model.

## Start here

- [Shared reference workspace](architecture/workspace.dsl): all 95 migrated C4 reference views.
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
| `architecture/compose.yaml` | Pinned reference viewer, parser and diagram exporter |
| `architecture/model/external-systems/` | Reference systems, each with a folder and container fragments |
| `architecture/model/modules/` | Reviewed platform systems; initially no definitions |
| `architecture/model/relationships/` | Relationships grouped by system, plus cross-system integrations |
| `architecture/views/` | Selectable reference views and shared styles |
| `architecture/documentation/` | Explanations and system boundaries |
| `architecture/use-cases/` | Shared simple flows and detailed sequences |
| `architecture/initiatives/<epic-id>/` | Goals, ownership, proposed model, focused views and use cases |
| `architecture/references/` | Evidence and clearly marked historical material |
| `architecture/scripts/` | Validation, preview and deliberate evidence refresh |
| `architecture/templates/initiative/` | Incomplete authoring templates; excluded from workspace discovery |
| `build/architecture/` | Generated artifacts; ignored by Git |

Existing application and operations examples remain reference choices, not
adopted platform modules. Security examples are independent options, not a
mandatory combined stack.

## Validate and preview

Requires Python 3.10+, PowerShell and Docker Desktop running Linux containers.
The tooling retains `structurizr/structurizr:2026.06.28-noble`; the shared pin is
in [toolchain.env](architecture/toolchain.env).

```powershell
# Shared reference workspace and every initiative/variant
./architecture/scripts/validate.ps1

# Limit independent workspace workers (default: 2)
./architecture/scripts/validate.ps1 -Jobs 1

# Selected workspace
./architecture/scripts/validate.ps1 -Workspace architecture/initiatives/ignition/workspace.dsl

# Fresh parsed preview (default workspace: architecture/workspace.dsl)
./architecture/scripts/preview.ps1 -Port 8080

# Selected initiative preview
./architecture/scripts/preview.ps1 -Workspace architecture/initiatives/ignition/workspace.dsl -Port 8080
```

Preview serves the selected JSON at `http://localhost:8080`. Rerun after
editing DSL and refresh the browser. Each port has a managed preview container;
the command replaces only the container it owns for that port. An unrelated
port conflict is an error. Stop it with
`docker stop dlt-architecture-preview-8080` (use the selected port).

Each workspace has an output directory under `build/architecture/reference/` or
`build/architecture/initiatives/<epic-id>/workspace/`. Its `status.json` atomically
selects `latest_attempt` and `last_successful`, each with a run `id`. Open
`runs/<id>/reports/validation-summary.md` for that run's report, or its
`workspace.json`, `model-catalog.json` and `coverage.csv` for derived artifacts.
The [reference status](build/architecture/reference/status.json) and
[ignition status](build/architecture/initiatives/ignition/workspace/status.json)
are available after validation. A failed run has its own directory and cannot
overwrite the last successful artifact set.

The latest five completed runs are retained, plus runs selected as the last
success or referenced by active managed previews. Preview containers receive
separate writable copies under `build/architecture/previews/`; the immutable
run is never mounted for viewer writes. Commands and the workspace description
identify the preview's run and completion time. Failed preview validation keeps
the existing container and explicitly reports it as stale.

The `build/` directory stays at the repository root. Existing outputs outside
`build/architecture/` are retained; new architecture runs write only to this subtree.
Older flat outputs and `parsed/` directories are historical and no longer
updated. Variants follow their own entrypoint path. Legacy `-StaticOnly` and
`-SkipRender` switches remain accepted; validation always checks static C4 models.

Validation performs no evidence refresh or deployment provisioning. Full
coverage and domain/security checks run against the reference workspace. Focused
initiative views need not display every shared-model element. Every local
proposal element must appear in a view, including when inherited by a variant.
Shared dependencies on initiatives, unrelated initiative dependencies, duplicate
selections and incorrect local view prefixes fail validation. Full validation
also detects independently defined duplicate identities across initiatives;
selected validation parses its shared model and ancestors for provenance.
Unexpected parser,
inspection, link and semantic failures return nonzero. Only the initial
ignition boundary is exempt from requiring connected, labeled dataflows.

Run fault-injection and pinned-parser tests after validation:

```powershell
$env:C4_DOCKER_TESTS = '1'
python -B -m unittest discover -s architecture/scripts -p 'test_workspace*.py' -v
```

The one-time migration check is `python -B architecture/scripts/verify_migration.py`.
It compares against the historical catalog and the pre-improvement presentation
baseline, including styles, descriptions and layout settings. It is separate
from ongoing validation so reviewed architecture changes can evolve the model.

### Docker Compose

[Compose](architecture/compose.yaml) lives beside the reference workspace. Use
the wrapper from the repository root to supply the shared version pin, resolve
the selected run and keep viewer writes separate from validation artifacts:

```powershell
# Validate the reference DSL with the pinned parser
./architecture/scripts/compose.ps1 -Action Validate

# Serve the parsed reference workspace on localhost:8080
./architecture/scripts/compose.ps1 -Action Preview -Port 8080

# Export all reference views from the latest successful run
./architecture/scripts/compose.ps1 -Action Export

# Export a selected initiative view
./architecture/scripts/compose.ps1 -Action Export -Workspace architecture/initiatives/ignition/workspace.dsl -View ignition-dapp-platform-context

# Inspect resolved Compose configuration, or stop its viewer
./architecture/scripts/compose.ps1 -Action Config
./architecture/scripts/compose.ps1 -Action Down -Port 8080
```

Validate after source changes before Compose preview/export. The wrapper refuses
a failed latest attempt or a stale source fingerprint. Exports go into the
workspace's `exports/<run-id>/svg/` directory. The parser/exporter mount the
repository read-only and write only through `build/architecture/`; the viewer
mounts its own runtime copy. The `Validate` action is the pinned parser only;
use `validate.ps1` for the complete semantic workflow.
The Compose viewer and scripted preview both default to port 8080; run one there
at a time. Compose projects are separated by checkout and port; use the same
port for `Down`. Direct Compose invocation requires the wrapper's run variables.

## Contributing an initiative

1. Create `architecture/initiatives/<epic-id>/` with a README recording goal, status, architect,
   technical lead/team, and epic link. Use `TBD` for unknown values.
2. Start with the [initiative template](architecture/templates/initiative/README.md),
   extending `../../model.dsl`. Templates are incomplete until an agreed model
   and connected views exist; they grant no disconnected-boundary exception.
   Before including your local model, apply `model.element.noview` informational
   policy to inherited elements using `!elements element.tag==Element`, as in
   ignition. The validator verifies that these elements actually originate in
   the shared model. Include local `model.dsl` and `views.dsl`; keep proposals local.
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

Shared changes are reviewed by affected architects and technical leads.
Record actual owners in initiative READMEs; CODEOWNERS enforcement is deferred
until team identities are available. Significant architecture decisions go in
`architecture/decisions/adr`; authoring/tooling decisions go in
`architecture/decisions/workspace`. Routine notes belong in READMEs.

## Variants and promotion

Create `variants/interim/workspace.dsl` or `variants/target/workspace.dsl`
only when designs differ. Each extends `../../workspace.dsl` and includes
variant-local fragments. Use view keys such as `<epic-id>-interim-...`.
Extension inherits parent models and views; variants are additive. Select the
desired elements in each view instead of deleting inherited definitions.
Local variant keys must use `<epic-id>-<variant>-`; inherited keys stay unchanged.

After review, **move** accepted definitions into shared modules/relationships,
preserving identifiers. Remove initiative-local definitions in the same change,
add explicit shared includes, and validate every entrypoint. Promote reusable
use cases with the model. Shared files must not depend on initiative folders.

Ignition currently has an explicit temporary boundary-only rule. When agreed
design introduces children or integrations, remove its disconnected inspection
override and update that rule and its tests in the same reviewed change. Shared
promotion must also update the ignition ownership restriction. Normal view
coverage and connectivity requirements remain in force.

See [decision 7](architecture/decisions/workspace/0007-modular-workspaces.md) and
[decision 8](architecture/decisions/workspace/0008-provenance-and-isolated-runs.md)
for policy, the [review implementation status](architecture/documentation/reviews/2026-09-19-workspace-review.md#implementation-status)
for the improvements, and [legacy material](architecture/references/legacy/README.md) for history.
