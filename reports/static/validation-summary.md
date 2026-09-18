# Static C4 validation report

Recorded: 2026-09-18T23:02:18.201579+00:00

**Result: PASS**

Image: `structurizr/structurizr:2026.06.28-noble`

Inspected input: `workspace.dsl`, the sole canonical workspace. Legacy deployment material is archived separately and is not loaded.

## Commands

| Check | Exit | Log |
|---|---:|---|
| docker-readiness | 0 | [docker-readiness.txt](docker-readiness.txt) |
| generate | 0 | [generate.txt](generate.txt) |
| source-inventory | 0 | [source-inventory.txt](source-inventory.txt) |
| validate | 0 | [validate.txt](validate.txt) |
| inspect | 4 | [inspect.txt](inspect.txt) |
| inspect-errors-warnings | 0 | [inspect-errors-warnings.txt](inspect-errors-warnings.txt) |
| parse-json | 0 | [parse-json.txt](parse-json.txt) |
| validator-tests | 0 | [validator-tests.txt](validator-tests.txt) |
| image | 0 | [image.txt](image.txt) |

## Parsed-model checks

- 95 static views, 333 logical elements, 243 components, 696 relationships.
- 2147 assertions; 0 failures.
- Every view has visible, labeled, directed static dataflows and no disconnected boxes.
- Every component appears in its owning container's component views.
- Parsed element selections and arrow endpoints exactly match the authored model.
- Only one active DSL workspace and one generated model catalog exist; no opaque relationship identifiers are emitted.
- Archived deployment material and all historical exports pass preservation comparisons. This is not deployment validation.

## Retained scope advisories

Only `workspace.scope` is informational. All other inspection severities retain their defaults. Full inspect returns the displayed violation count (some command wrappers collapse it to 1); the separate error/warning gate must return 0.

- This workspace has no defined scope. It is recommended that the workspace scope is set to "Landscape" or "SoftwareSystem".
- This workspace describes the internal details of 12 software systems. It is recommended that a workspace contains the model, views, and documentation for a single software system only.
- System context views exist for 12 software systems. It is recommended that a workspace includes system context views for a single software system only.
- Container views exist for 12 software systems. It is recommended that a workspace includes container views for a single software system only.

## Evidence and deferred work

- [Official sources and component coverage](source-inventory.md); [source coverage CSV](source-coverage.csv); [relationship evidence](relationship-evidence.csv).
- [Parsed architecture audit](architecture-audit.json); [machine-readable run and exit codes](run.json).
- Deployment architecture, node counts, quorum sizing, zone resilience, recovery, and deployment layouts: **not validated**.
- Diagram rendering, visual-layout QA, galleries, SVG/PNG/PDF exports: **not run**.
- This validates architecture artifacts, not a running FireFly/Besu installation.
