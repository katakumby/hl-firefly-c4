# FireFly + Besu architecture workspace

A source-backed Structurizr workspace with C4 levels 1–3 and a three-member, three-zone AKS reference.

## Open the diagrams

    docker compose up -d structurizr

Open [Structurizr on localhost](http://localhost:8080). The viewer binds only to 127.0.0.1:8080 and serves the exported JSON, including deployment layouts and embedded documentation.

Start with **01-landscape**, reusable FireFly **10/11** container views, focused **20–51** component views, and finally **80–82** deployment details and **99-deployment-complete**. The complete map is intended for zooming; detail views isolate readable dataflows.

FireFly and Besu's node implementation are each defined once. Members A, B and C reuse the FireFly containers through deployment instances; member deployment groups isolate their databases, keys and private storage. Besu instance roles select validators or RPC/discovery nodes. Scoped `-> destination` relationships stay beside their source elements, and views select endpoints without numbered relationship aliases.

## Files

- [workspace.dsl](workspace.dsl): complete generated DSL; no remote includes or runtime plugins.
- [Exported workspace](exports/workspace.json): parsed model, embedded documentation and deployment layouts.
- [SVG gallery](exports/index.html): offline diagram browsing; each diagram has a separate notation key.
- [Architecture](docs/workspace/01-overview.md), [dataflows](docs/workspace/02-dataflows.md), [deployment and recovery](docs/workspace/03-deployment.md), [official sources](docs/workspace/04-sources.md).
- [Decisions](decisions): runtime boundaries, Besu, recovery and validation.
- [Coverage](coverage.csv), [source revisions](sources.json), [model catalog](model-catalog.json).
- [Validation summary](reports/validation-summary.md), [architecture audit](reports/architecture-audit.json) and [complete inspect report](reports/inspect.txt).

## Rebuild and verify

Requires Docker Desktop with Linux containers, Docker Compose, Python 3.10+ and PowerShell.

    ./scripts/validate.ps1
    docker compose up -d structurizr

The script generates the model, audits source coverage, validates DSL, exports JSON, applies deployment layouts, runs inspect, checks component coverage/member isolation/quorum and exports SVGs. Use -SkipRender for model-only checks.

Standalone inspection:

    docker compose run --rm cli validate -workspace workspace.dsl
    docker compose run --rm cli inspect -workspace workspace.dsl
    docker compose run --rm cli inspect -workspace exports/workspace.json
    docker compose run --rm cli inspect -workspace exports/workspace.json -severity error,warning

The full inspect command returns a nonzero status for four retained informational scope findings. Structurizr recommends one system per workspace; this requested deliverable includes the whole consortium. Only workspace.scope is classified informational. The error/warning gate returns **0**. No blanket suppression is used.

Edit scripts/model_data.py for reusable components and flows, and scripts/build_workspace.py for systems, deployment and views. Run validation to regenerate artifacts. scripts/capture_sources.py refreshes official snapshots deliberately; normal rebuilds use the captured revisions.

## Reference design limits

Application runtimes, databases and signing services are on AKS. Azure's managed control plane, load balancer and CSI-backed storage remain infrastructure dependencies. No cloud resources or live FireFly/Besu network are provisioned.

Six validators are distributed two per zone; losing one zone leaves the four required for quorum. Stateful member services recover as single writers. Safe fencing and volume reattachment are prerequisites, and Data Exchange's in-memory notifications require reconciliation. These design objectives are distinguished from proven automatic failover or measured recovery times.


## Visual review

SVGs retain vector text and arrows at full zoom. The complete deployment is a large reference map; use its detail views to trace individual flows. Browser zoom and the offline gallery both preserve SVG detail.

    python scripts/visual_audit.py

This checks rendered node clipping, shape/text fit, node collisions and relationship-label collisions (including protocols). To recreate preview PNGs/contact sheets, install Sharp for Node and Pillow for Python, then run:

    node scripts/render_previews.cjs
    python scripts/visual_audit.py --contact-sheets

Set SHARP_MODULE to an existing Sharp module path if it is not installed locally. The previews are disposable review artifacts in .cache; the deliverables are the SVGs and their notation keys.
