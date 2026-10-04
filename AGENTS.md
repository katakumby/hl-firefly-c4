# Architecture work and review

Structurizr DSL is the authoring source. Run validation and export through the
Docker Compose tools service; generated files under `build/` stay
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
docker compose run --rm --pull never tools export
docker compose run --rm --pull never tools export --workspace workspaces/ignition/workspace.dsl
docker compose run --rm --pull never tools export --workspace workspace.dsl --view 01-landscape
docker compose run --rm --pull never tools export --all-workspaces
```

C4-PlantUML is the primary agent review output and the default export format.
Read its compact C4 macro definitions as text. Omit `--workspace` for the reference
workspace; omit `--view` for all diagrams in the selected workspace.
Repeat `--view` to select several keys. `--all-workspaces` cannot be combined
with workspace or view selection. A selected batch publishes as one transaction.

Both plain `export` and explicit `--format plantuml` use native C4-PlantUML.
Find `<view-key>.puml` in the source-mirrored folder listed in `build/artifacts.json`. See the
[format table](README.md#export-c4-plantuml-default-mermaid-svg-or-png) and
[output reference](README.md#outputs-and-maintenance) for optional Mermaid,
SVG/PNG, paths and freshness metadata. Routine text review needs no renderer.

After tooling changes, validate all workspaces and run the containerized tests:

```text
docker compose run --rm --pull never tools validate
docker compose run --rm --pull never --entrypoint python3 tools -B -m unittest discover -s tests -v
docker compose run --rm --pull never --entrypoint python3 tools-browser -B -m unittest discover -s tests -v
```

Use `--clean` only when explicitly rebuilding all generated architecture output:
it clears inventory-managed C4/UML outputs and build reports before export, preserving
`build/.layouts/` manual snapshots, `local.env`, the writer lock, and historical or
unrelated build directories. Routine reviews do not need it.

The lightweight `docker compose run --rm --pull never tools build` command renders
C4 and standalone `.puml` sources to SVG and PNG. Complete Mermaid images with
`docker compose run --rm --pull never tools-browser build-browser`, which requires
a matching successful lightweight build and does not repeat its rendering. Rendering is appropriate when
verifying this build pipeline; routine architecture reviews still use text only.

Acquire approved images before running commands; normal Compose execution never
builds or pulls them. See [corporate Docker instructions](documentation/build.md).

`build`, `build-browser`, `export` and `export-native` report inspection errors/warnings without blocking output.
The standalone `validate` command remains strict. Parsing, native model validation,
inspector execution failures, output naming errors and rendering failures still block.

`capture-layout` and `export-native` are explicit on-demand operations; normal
builds and CI do not invoke them. Native SVG/PNG/GIF exports reuse captured manual
layouts and use `.structurizr` filename suffixes. Read the
[native export workflow](README.md#on-demand-structurizr-layouts-and-animations)
before handling layout snapshots. Do not treat captured JSON as model source.

The separately named project images are `dlt-architecture-tools-light` and
`dlt-architecture-tools-browser`, without explicit tags. Use `tools-browser` for
`export-native`; keep `capture-layout`, ordinary exports and validation on `tools`.
`build.json` distinguishes light-stage success from `complete: true`. Preserve
stage reports and per-artifact freshness when handling browser handoffs.
