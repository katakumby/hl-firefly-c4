# Architecture CI examples

These examples are inactive until configured. Use an approved Linux Docker runner;
no host Python, Java, npm or diagram software is required. The toolchain images are
acquired explicitly and generation runs offline. Provider lookup and artifact transfer
are separate network-enabled operations.

## Stages and artifacts

- Push/PR: regressions and `build-source`, publishing `architecture-source`.
- Daily **02:00 UTC**: independent PlantUML and Mermaid preview jobs.
- Manual: `source`, `plantuml`, `mermaid` or `previews` (default: both previews).
- Preview jobs restore the newest successful, available source artifact for the exact
  commit and branch. Missing/expired artifacts fail; run the source job first.

Each job cleans before generating or restoring sources, never after restoration.
Preview jobs do not depend on one another or regenerate source text. Their artifacts
are `architecture-preview-plantuml` and `architecture-preview-mermaid`; unique inventories
and reports allow packages from the same source handoff to be combined. Output filenames
remain stable and mirror the source tree. Run IDs belong in provider metadata, not paths.

Use a **30-day retention target**. An unchanged commit may outlive its source artifact;
rerun source generation to renew availability. Native repository exports remain manual.
Browser tests render temporary native fixtures without changing repository layouts.
CI never commits generated files. Failures publish diagnostics only, not old diagrams.

## Required configuration

Set approved image references with distinct names and no explicit tag:

- `ARCHITECTURE_TOOLS_IMAGE`: `registry.example.com/architecture/dlt-architecture-tools-light`
- `ARCHITECTURE_BROWSER_IMAGE`: `registry.example.com/architecture/dlt-architecture-tools-browser`

Source and PlantUML jobs acquire only the light image. Mermaid jobs acquire only the
browser image. Azure's separate provider lookup job also needs the browser image for
its installed Node runtime. Installed toolchain identities must match repository pins;
matching image names alone are insufficient. See the [Docker guide](../../documentation/build.md).

Runners need Docker access, writable checkout/build directories, compatible Linux images,
registry trust, and approved network access for acquisition and provider APIs. The wrapper
uses runner UID/GID for generated files. Credentials come from provider secrets or service
connections. Package staging directories must be fresh and empty.

## GitHub Actions

Copy [github-actions.yaml](github-actions.yaml) to `.github/workflows/architecture.yaml`.
Set `ARCHITECTURE_RUNNER_LABELS` to a JSON label array for an approved runner, for example
`["self-hosted","linux","architecture"]`. Set both image variables above and
`ARCHITECTURE_IMAGE_ACQUISITION` to `preloaded` or `pull`. For pull mode configure
`ARCHITECTURE_REGISTRY`, plus `ARCHITECTURE_REGISTRY_USER` and
`ARCHITECTURE_REGISTRY_PASSWORD` secrets. Preloaded mode needs no registry credentials.

The workflow has `contents: read` and `actions: read`. Its lookup script
[select-source-run.cjs](../select-source-run.cjs) paginates completed successful runs
of the configured workflow and selects an unexpired `architecture-source` artifact
with the exact SHA and branch. Preview-only and failed runs cannot substitute for a
source artifact. Cross-run download uses the selected run and artifact IDs.

PR merge commits differ from branch-head commits: a scheduled or manual preview of
the branch head needs a matching push or manual source artifact. No fallback to the
PR merge artifact occurs. Scheduled workflows use the default branch. Configure repository
artifact retention to permit the requested 30 days, and runners compatible with the
pinned action versions. [Cross-run artifact download](https://github.com/actions/download-artifact#download-artifacts-from-other-workflow-runs-or-repositories)
requires the supplied token and run identity.

## Azure DevOps Services

Activate [azure-pipelines.yaml](azure-pipelines.yaml) with the adjacent
[azure-stage.yaml](azure-stage.yaml) job template. Keep their relative paths together.
Set `ARCHITECTURE_AGENT_POOL` and both image variables. Use `acquireImage: false` for
preloaded images or configure the `registryServiceConnection` parameter for explicit
pulls. Set pipeline retention to retain builds and artifacts for at least 30 days.

Successful source runs publish `architecture-source` and add the CI build tag
`architecture-source-<commit>`. These are provider build tags, not Docker image tags.
The separate lookup job runs [select-azure-source-run.cjs](../select-azure-source-run.cjs)
with the approved browser image and networking enabled. It validates pipeline, exact
commit, branch, successful completion, build tag and artifact availability across pages.
Unavailable artifacts are skipped; authentication/API errors fail explicitly.

The job token requires read access to prior builds and pipeline artifacts. Lookup exposes
the selected build ID as a job output; both offline preview jobs download that specific
build using `DownloadPipelineArtifact@2`. The containers independently verify commit,
source fingerprints, toolchain and output hashes. Provider variable wiring follows
[Azure output-variable guidance](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/set-variables-scripts?view=azure-devops&tabs=bash).

Azure Repos PR validation requires a branch build-validation policy; YAML `pr` supports
applicable external repository providers. The UTC schedule uses `always: true` so it
can render an unchanged commit from an existing source artifact.

## Packaging and local verification

```sh
docker/run.sh clean
docker/run.sh build-source
mkdir -p /tmp/architecture-source-artifacts
ARCHITECTURE_ARTIFACT_DIR=/tmp/architecture-source-artifacts docker/run.sh package --stage source
# In a second checkout: clean first, then restore that package into build/.
docker/run.sh build-preview --renderer plantuml
mkdir -p /tmp/architecture-plantuml-artifacts
ARCHITECTURE_ARTIFACT_DIR=/tmp/architecture-plantuml-artifacts docker/run.sh package --stage preview --renderer plantuml
```

A separate checkout can restore the same source package and render/package Mermaid.
Source packaging is the default and contains text, dependencies, a filtered inventory,
frozen parsed workspace/validation evidence, renderer identity and CI provenance.
Previews require that complete handoff; committed text alone is insufficient.
Set `ARCHITECTURE_SOURCE_REVISION` and `ARCHITECTURE_CI_RUN` to reproduce CI provenance
checks locally, or omit both for fingerprint-based operation without Git metadata.

Successful packages exclude native exports, saved layouts, local overrides, locks,
staging and unrelated build contents. `package --diagnostics` includes only reports/logs.
Never upload the entire checkout or unfiltered build directory. The preview packages
contain only the requested renderer's successful selection; a partial selection does
not certify all diagrams.

## Server editions

Examples target GitHub.com and Azure DevOps Services. GitHub Enterprise Server needs
supported artifact actions/API behavior for that server release; current v4+ artifact
actions are not supported there. Azure DevOps Server requires supported Build Artifact
publish/download tasks rather than Pipeline Artifact tasks, with corresponding lookup
resource-type changes. Preserve exact-commit selection, availability checks and offline
container verification when adapting either example.
