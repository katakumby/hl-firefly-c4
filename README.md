# FireFly ecosystem, private Besu and security catalog C4 workspace

The current review corrects and validates **C4 levels 1–3** across the documented
open-source FireFly ecosystem, using private Besu as the worked example. Every
view includes directional, labeled static dataflows. Component detail covers
FireFly and Besu, plus a documentation-backed security product reference catalog.
Proprietary security internals are explicitly logical reference abstractions.

## Current deliverables

- [Workspace](workspace.dsl): the sole canonical DSL entrypoint, containing static C4 levels 1–3 with no deployment definitions or views.
- [Model catalog](model-catalog.json): the generated logical model and exact view selections.
- [Deployment archive](archive/README.md): historical deployment-only data and DSL fragments, outside the active workspace.
- [Validation report](reports/static/validation-summary.md): fresh Docker results, accepted advisories, coverage and deferred checks.
- [Final architecture review](docs/static/workspace/05-final-review.md): corrected boundaries, duplicate assessment, grouping decisions and review limits.
- [Official source inventory](reports/static/source-inventory.md), [source coverage](reports/static/source-coverage.csv), [relationship evidence](reports/static/relationship-evidence.csv), and [element/view coverage](coverage.csv).
- [Logical architecture](docs/static/workspace/01-logical-architecture.md), [dataflows](docs/static/workspace/02-static-dataflows.md), and [decisions](docs/static/decisions).
- [Security catalog and view navigation](docs/static/workspace/03-security-catalog.md), [security example dataflows](docs/static/workspace/04-security-dataflows.md), and [security source coverage](reports/static/security-source-coverage.csv).

The security catalog adds Keycloak, Azure Managed HSM, CyberArk PAM Self-Hosted,
Conjur Enterprise, Microsoft Entra ID, AD DS and AD FS. Start at
`100-security-landscape`; all 38 added views use the `100-security-` prefix.
Examples are independent reference choices, not a mandatory combined stack.
The HSM transaction-signing adapter is a proposed custom integration, not
built-in FireFly Signer support. No runtime products are installed or configured.

Related systems have named navigation groups while retaining independent C4
boundaries. Explorer and Sandbox browser applications are separate from their
servers. Core and FFTM own separate logical PostgreSQL databases; deployment
replicas are not additional logical containers. Existing view keys are retained.

## Validate static C4 only

Requires Docker Desktop with Linux containers, Python 3.10+ and PowerShell:

```powershell
./scripts/validate.ps1
```

This generates `workspace.dsl` and one model catalog, inventories source
coverage, runs Docker `validate` and `inspect` on `workspace.dsl`, and
audits a fresh parsed workspace in `.cache`. It uses the pinned official image
`structurizr/structurizr:2026.06.28-noble`. It does not run deployment validation,
deployment layouts, rendered-diagram checks, galleries or diagram exports.
The former `-StaticOnly` and `-SkipRender` switches remain accepted for existing
callers; validation now always uses the static workflow.

Standalone inspection:

```powershell
docker compose run --rm --no-deps cli validate -workspace workspace.dsl
docker compose run --rm --no-deps cli inspect -workspace workspace.dsl
docker compose run --rm --no-deps cli inspect -workspace workspace.dsl -severity error,warning
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

Security definitions live in `scripts/security_model.py`. Refresh only their
evidence with `python -B scripts/capture_security_sources.py`; this preserves
all unrelated source entries. CyberArk direct downloads currently return 404,
so their recorded evidence is explicitly a web-reader text excerpt. A deliberate
refresh requires fresh text snapshots in `.cache/sources-security-web/` when
direct access is still unavailable. Normal generation/validation uses recorded
metadata and does not fetch documentation. Security documentation coverage is
reported separately from the existing FireFly source-code inventory.

Ordinary DSL relationships are anonymous and views select them by source and
destination. Only the two HSM workload-token arrows have descriptive names,
`hsmWorkloadTokenRequest` and `hsmWorkloadTokenResponse`, because their example
must exclude browser-login arrows between the same endpoints. The generator
does not emit hash-derived relationship variables.

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

Earlier reports outside `reports/static` and the unused deployment/layout/export
helpers are historical. The validation entrypoint invokes only the current
static pipeline. No FireFly/Besu network or cloud resources are
provisioned by this task.
