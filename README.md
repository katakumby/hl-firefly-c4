# FireFly ecosystem + private Besu C4 workspace

The current review corrects and validates **C4 levels 1–3** across the documented
open-source FireFly ecosystem, using private Besu as the worked example. Every
view includes directional, labeled static dataflows. Component detail covers
FireFly and Besu; other infrastructure stops at its integration boundary.

## Current deliverables

- [Static workspace](workspace-static.dsl): the validated entrypoint, with no deployment definitions or views.
- [Full workspace](workspace.dsl): the same corrected logical model plus preserved deployment definitions for the next review.
- [Validation report](reports/static/validation-summary.md): fresh Docker results, accepted advisories, coverage and deferred checks.
- [Official source inventory](reports/static/source-inventory.md), [source coverage](reports/static/source-coverage.csv), [relationship evidence](reports/static/relationship-evidence.csv), and [element/view coverage](coverage.csv).
- [Logical architecture](docs/static/workspace/01-logical-architecture.md), [dataflows](docs/static/workspace/02-static-dataflows.md), and [decisions](docs/static/decisions).

## Validate static C4 only

Requires Docker Desktop with Linux containers, Python 3.10+ and PowerShell:

```powershell
./scripts/validate.ps1 -StaticOnly
```

This generates both DSL entrypoints from one logical model, inventories source
coverage, runs Docker `validate` and `inspect` on `workspace-static.dsl`, and
audits a fresh parsed workspace in `.cache`. It uses the pinned official image
`structurizr/structurizr:2026.06.28-noble`. It does not run deployment validation,
deployment layouts, rendered-diagram checks, galleries or diagram exports.

Standalone inspection:

```powershell
docker compose run --rm --no-deps cli validate -workspace workspace-static.dsl
docker compose run --rm --no-deps cli inspect -workspace workspace-static.dsl
docker compose run --rm --no-deps cli inspect -workspace workspace-static.dsl -severity error,warning
```

The full inspection retains informational `workspace.scope` advisories because
this requested ecosystem model contains details of multiple systems. Its exit
code records displayed findings (Compose can collapse a positive code to 1).
The error/warning gate must return zero. Other categories are not suppressed.

## Sources and maintenance

Edit the model generators and component definitions in `scripts`; regenerate
with static validation. Do not hand-edit generated DSL or catalogs. Sources
include the official FireFly head documentation, official FireFly repositories,
Besu documentation and Structurizr documentation. Commit SHAs, retrieval times,
content fingerprints and selected embedded dependency versions are recorded in
`sources.json`.

To deliberately refresh the evidence, run `python scripts/capture_static_sources.py`
and then `python scripts/capture_component_sources.py`. These fetch official
source snapshots; normal validation uses the recorded inventory without network
source refreshes. Source changes can require model updates.

After validation, run fault-injection checks with:

```powershell
python -B -m unittest discover -s scripts -p test_static_validation.py
```

## Deferred work

Deployment diagrams, AKS placement, validator counts, quorum sizing, recovery
and availability are **not validated in this pass**. Existing exports are kept
byte-for-byte unchanged and describe the earlier model. The Compose viewer
still serves those historical exports; it is not a preview of this new static
workspace. Rendering and visual-layout QA are deferred.

Earlier reports outside `reports/static` are historical. The original full
validation pipeline is retained for later deployment/export work; use
`-StaticOnly` for this phase. No FireFly/Besu network or cloud resources are
provisioned by this task.
