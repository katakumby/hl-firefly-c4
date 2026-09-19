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
| `build/architecture/` | Generated artifacts; ignored by Git |

Existing application and operations examples remain reference choices, not
adopted platform modules. Security examples are independent options, not a
mandatory combined stack.

## Validate and preview

Requires Python 3.10+, PowerShell and Docker Desktop running Linux containers.
The tooling retains `structurizr/structurizr:2026.06.28-noble`.

```powershell
# Shared reference workspace and every initiative/variant
./architecture/scripts/validate.ps1

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

Outputs are under `build/architecture/reference/` or
`build/architecture/initiatives/<epic-id>/workspace/`, with reports in `reports/`.
The `build/` directory stays at the repository root. Existing outputs outside
`build/architecture/` are retained; new architecture runs write only to this subtree.
Variants follow their own entrypoint path. Generate reports before opening
their links. Legacy `-StaticOnly` and `-SkipRender` switches remain accepted;
validation always checks static C4 models.

Validation performs no evidence refresh or deployment provisioning. Full
coverage and domain/security checks run against the reference workspace. Focused
initiative views need not display every inherited element. Unexpected parser,
inspection, link and semantic failures return nonzero. Only the initial
ignition boundary is exempt from requiring connected, labeled dataflows.

Run fault-injection and pinned-parser tests after validation:

```powershell
$env:C4_DOCKER_TESTS = '1'
python -B -m unittest discover -s architecture/scripts -p test_workspace_validation.py -v
```

The one-time migration check is `python -B architecture/scripts/verify_migration.py`.
It compares against the historical catalog and is separate from ongoing validation.

### Docker Compose

[Compose](architecture/compose.yaml) lives beside the reference workspace. Run
these commands from the repository root after validation has produced fresh JSON:

```powershell
# Validate the reference DSL with the pinned parser
docker compose -f architecture/compose.yaml run --rm cli

# Serve the parsed reference workspace on localhost:8080
docker compose -f architecture/compose.yaml up -d structurizr

# Export reference diagrams to build/architecture/reference/svg/
docker compose -f architecture/compose.yaml run --rm export
```

From `architecture/`, omit `-f architecture/compose.yaml`. Compose resolves bind
paths relative to its file: the parser/exporter mount the repository parent
read-only and write only through `../build/architecture/`; the viewer mounts
`../build/architecture/reference/`. Container workspace arguments remain relative
to the repository, such as `architecture/workspace.dsl`.
The Compose viewer and scripted preview both default to port 8080; run one there
at a time. Use `docker compose -f architecture/compose.yaml down` to stop Compose.

## Contributing an initiative

1. Create `architecture/initiatives/<epic-id>/` with a README recording goal, status, architect,
   technical lead/team, and epic link. Use `TBD` for unknown values.
2. Copy ignition's workspace pattern, extending `../../model.dsl`.
   Before including your local model, apply `model.element.noview` informational
   policy to inherited elements using `!elements element.tag==Element`, as in
   ignition. Include local `model.dsl` and `views.dsl`; keep proposals local.
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

After review, **move** accepted definitions into shared modules/relationships,
preserving identifiers. Remove initiative-local definitions in the same change,
add explicit shared includes, and validate every entrypoint. Promote reusable
use cases with the model. Shared files must not depend on initiative folders.

See [decision 7](architecture/decisions/workspace/0007-modular-workspaces.md)
for policy and [legacy material](architecture/references/legacy/README.md) for history.
