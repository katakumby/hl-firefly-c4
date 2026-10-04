# Architecture work and review

Structurizr DSL is the C4 authoring source. PlantUML and Mermaid under shared or
workspace-local `uml/` are authored behavioral diagrams. Run validation and generation
through the approved Docker tools. Generated text under `build/source/` and images
under `build/preview/` are versioned deliverables; never edit them as authoring sources.
Saved `workspace.json` beside DSL is versioned and authoritative for manual coordinates
and routing. DSL remains authoritative for model, views and animations.

## Final review order

1. Generate fresh C4-PlantUML for affected workspaces or selected views. Shared
   model/tooling changes can affect every workspace.
2. Read fresh `.puml` text first, then relevant DSL and parsed JSON for details
   omitted by the exporter. Keep review context focused.
3. Do not render or open images for routine architecture reviews. Rendering is
   appropriate when verifying the build pipeline; do not open images unless requested.
4. After DSL corrections, regenerate affected text and repeat relevant checks.
5. Failed commands preserve previous files. Never present those files as current
   evidence; inspect the stage's latest report for successful current generation.

## Commands

```text
docker compose run --rm --pull never tools build-source
docker compose run --rm --pull never tools build-source --workspace workspaces/ignition/workspace.dsl
docker compose run --rm --pull never tools build-source --workspace workspace.dsl --view 01-landscape
docker compose run --rm --pull never tools build-source --all-workspaces
```

Source generation defaults to all workspaces and UML. Repeat `--view` for several
C4 keys; view selection without a workspace targets the root. Workspace-wide selection
includes its UML; view selection includes only C4. `--all-workspaces` conflicts with
workspace/view selection. View keys define stable filenames beneath `build/source/`.
See [selection and filtered-view limitations](README.md#build-diagram-sources).
C4 exports use ordinary native C4-PlantUML only, with no custom identity enrichment.

After tooling changes, run strict validation and both containerized test suites:

```text
docker compose run --rm --pull never tools validate
docker compose run --rm --pull never --entrypoint python3 tools -B -m unittest discover -s tests -v
docker compose run --rm --pull never --entrypoint python3 tools-browser -B -m unittest discover -s tests -v
```

Tests use container temporary checkouts, not tracked repository deliverables.
`validate` remains strict. Generation reports inspection findings without blocking;
parsing, native model validation, inspector failures, naming collisions and renderer
failures still block. Report existing Ignition findings separately from tooling failures.

## Preview and layout workflows

```text
docker compose run --rm --pull never tools build-preview --renderer plantuml
docker compose run --rm --pull never tools-browser build-preview --renderer mermaid
```

Both stages consume a successful source handoff independently. They never re-export
C4, render from authored originals, or modify source evidence. Verify fingerprints,
installed toolchain compatibility, selection coverage and CI commit/output hashes.
Use `build/source.json` and renderer-specific `build/preview-*.json` inventories;
latest attempt reports and frozen validation evidence are under ignored `build/.reports/`.
Do not treat a committed source tree alone as a runnable handoff.

`export-native` remains explicitly on demand through `tools-browser`. It merges current
DSL with adjacent saved JSON, then writes `.structurizr` / `.structurizr-key` images
directly under `build/preview/`. Normal builds never invoke it. No `capture-layout`
command or persistent `.layouts` copy remains. See the
[native workflow](README.md#on-demand-structurizr-layouts-and-animations).

`clean` explicitly wipes generated build contents while preserving the mountpoint and
writer lock. Run it only when resetting the build, before source generation or handoff
restoration. Never clean between source and preview stages. Saved JSON survives because
it lives beside DSL. Keep local settings in ignored `docker/local.env`.

The image names remain `dlt-architecture-tools-light` and
`dlt-architecture-tools-browser`, with no explicit tags. Normal commands never build
or pull images; acquire them separately. See the [Docker guide](documentation/build.md).
Browser dependencies are required only for Mermaid previews and native exports.
Source scanning includes accepted hidden authoring paths and local includes; it excludes
outputs, Git/agent configuration, caches, saved layout JSON and local overrides.
