# Validation summary

Recorded: 2026-09-15T20:54:12.865587+00:00

## Results

- 86 diagrams, 360 components, 58 deployment container instances.
- Docker validate succeeded for workspace.dsl and exports/workspace.json.
- Docker inspect ran on both DSL and JSON. Zero errors/warnings; four intentional workspace.scope informational findings retained in each full report.
- 3,165 parsed-model and SVG assertions passed.
- Every modeled component appears in a component view. Every view contains visible, labeled static relationships with protocol metadata.
- Member database, signing-key and private-storage relationships are isolated. Dedicated PostgreSQL/Besu volumes, WAL paths, RPC/discovery placement and validator quorum checks passed.
- A loss of any one zone leaves four of six validators. Additional unavailable-validator headroom: zero.
- Source audit: 11 official repositories, 34 captured source documents, 11 official documentation pages; no unmapped top-level FireFly Core runtime packages.
- All 86 SVGs and 86 notation keys were exported by the pinned official Playwright image.

## Rendered geometry

| Check | Findings |
|---|---|
| clipped nodes | 0 |
| node collisions | 0 |
| text overflow | 0 |
| label node overlaps | 0 |
| label label overlaps | 0 |
| edge node crossings | 0 |

Diagram review uses the SVG exports and PNG contact sheets. The full deployment is a zoomable reference map; focused deployment views separate member state, blockchain and operations. Geometry checks measure labels and protocols, exclude intentionally enclosing C4 boundaries, and retain detailed per-view results.

## Reports

- [Complete DSL inspection](inspect-dsl.txt)
- [Complete JSON inspection](inspect.txt)
- [Error/warning gate](inspect-errors-warnings.txt)
- [Parsed-model audit](architecture-audit.json)
- [Source audit](source-audit.json)
- [Rendered geometry](visual-geometry.json)
- [Pinned Docker image metadata](docker-images.json)

## Availability scope

This validates the architecture artifacts, not an AKS installation. Single-active recovery requires fencing, retained state, safe volume reattachment, checkpoint recovery and notification reconciliation. Recovery times and automation remain design objectives requiring deployment failure tests.
