# Architecture work and review

Structurizr DSL is the authoring source. Run validation and export through the
Docker Compose tools service; generated files under `build/architecture/` stay
ignored by Git and must not be edited as source.

## Final review order

1. Regenerate C4-PlantUML for every affected workspace or selected diagram before
   final architecture review. Shared changes may affect multiple workspaces.
2. Read the fresh `.puml` exports first, then inspect relevant DSL definitions for
   correctness and details omitted by the exporter. Focus on affected diagrams
   and definitions to keep review context small.
3. Review images only when the user explicitly requests it. Do not render or open
   images for routine architecture reviews.
4. If review corrections change DSL, regenerate the affected exports and repeat
   the relevant checks before completing the review.
5. A failed validation or export can leave older successful artifacts in place.
   Report the failure and do not present those older files as current evidence.
   Use only exports from a successful command against the current sources.

## Commands from the repository root

```text
docker compose -f architecture/compose.yaml run --rm --build tools export
docker compose -f architecture/compose.yaml run --rm tools export --workspace architecture/initiatives/ignition/workspace.dsl
docker compose -f architecture/compose.yaml run --rm tools export --workspace architecture/workspace.dsl --view 01-landscape
```

C4-PlantUML is the primary agent review output and the default export format.
Read its compact C4 macro definitions as text. Omit `--workspace` for the reference
workspace; omit `--view` for all diagrams in the selected workspace.

Both plain `export` and explicit `--format plantuml` use native C4-PlantUML.
Find `structurizr-<view-key>.puml` in the printed output directory. See the
[format table](README.md#export-c4-plantuml-default-mermaid-svg-or-png) and
[output reference](README.md#outputs-and-maintenance) for optional Mermaid,
SVG/PNG, paths and freshness metadata. Routine text review needs no renderer.

After tooling changes, validate all workspaces and run the containerized tests:

```text
docker compose -f architecture/compose.yaml run --rm tools validate
docker compose -f architecture/compose.yaml run --rm --entrypoint python3 tools -B -m unittest discover -s architecture/tests -v
```

Use `--clean` only when explicitly rebuilding all generated architecture output:
it clears every workspace and format under `build/architecture/` before export,
preserving only `local.env` and the writer lock. Routine reviews do not need it.
