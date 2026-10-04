# Architecture CI examples

These examples remain inactive until configured. They target GitHub.com and Azure
DevOps Services on approved Linux runners with Docker, a POSIX shell and standard
runner utilities. No host Python, Java, Node, npm or diagram software is required.
Use a non-root runner account with Docker access and writable artifact directories.

## Two stages and image names

Configure two distinct project images without explicit tags or versions:

- `ARCHITECTURE_TOOLS_IMAGE`: `registry.example.com/architecture/dlt-architecture-tools-light`.
- `ARCHITECTURE_BROWSER_IMAGE`: `registry.example.com/architecture/dlt-architecture-tools-browser`.

Docker resolves implicit `latest`; the platform team controls image publication.
Upstream bases, libraries and package versions remain pinned inside the toolchain.
Each job acquires only its selected image. Preloaded images are the default; an
explicit acquisition option enables registry authentication and pulling. Generation
and regression containers always have networking disabled. Provider artifact/API
access and explicit image acquisition use runner networking.

Push/PR runs execute the lightweight suite and `build`, then publish
`architecture-light`. This includes C4-PlantUML, C4/authored PlantUML SVG/PNG and the
lightweight handoff metadata. Mermaid images and syntax validation are deferred.
Browser-specific integration tests are explicitly skipped in the light image and
run in the browser image.

The daily **02:00 UTC** schedule runs only browser completion. Manual runs select
`light` or `browser` (default `browser`). Browser runs retrieve an earlier successful
light artifact for the exact checked-out commit and branch, then run `build-browser`
and publish `architecture-full`. They never repeat C4/PlantUML rendering or create
a replacement light build. Missing, expired, incorrect or damaged handoffs fail;
run the light job for the same commit first, then retry. Native Structurizr exports
and local layout snapshots are outside these scheduled architecture outputs.

Both stages report inspections without blocking publication. Add an explicit
`validate` step only if your CI policy requires strict inspection gates. Browser
integration tests may render temporary native fixture diagrams; they do not export
the repository's native diagrams or require its manual snapshots.

## GitHub Actions

Copy [github-actions.yaml](github-actions.yaml) to `.github/workflows/architecture.yaml`.
Configure repository/organization variables:

- `ARCHITECTURE_RUNNER_LABELS`: e.g. `["self-hosted","linux","architecture"]`.
- Both image variables above.
- `ARCHITECTURE_IMAGE_ACQUISITION`: `preloaded` or unset, or `pull`.
- `ARCHITECTURE_REGISTRY`: hostname when pulling.

For pulling, provide provider-managed `ARCHITECTURE_REGISTRY_USER` and
`ARCHITECTURE_REGISTRY_PASSWORD` secrets. Credentials use an isolated Docker
configuration directory removed after the job. Preloaded images need no credentials.

The workflow token requires `contents: read` and `actions: read`. The repository's
lookup helper selects the newest successful push/manual run of this workflow for
the exact commit/branch with an unexpired `architecture-light` artifact. It does
not accept a browser-only run or an artifact from another commit. PR merge-checkout
artifacts may differ from the branch-head commit; run a manual light job for that
branch before manual browser completion. Provider hashes and container source/file
fingerprints independently validate the downloaded package.

Artifact retention is 30 days. A long-unchanged commit can outlive its light artifact;
rerun light to refresh availability. Configure the scheduled workflow on the default
branch, and adapt `main` if necessary. Use approved runner/secret policies for PRs;
fork PRs should use preloaded images and suitably isolated runners. Review and pin
provider action revisions according to organizational policy.

## Azure DevOps

Create a pipeline from [azure-pipelines.yaml](azure-pipelines.yaml). Configure
`ARCHITECTURE_AGENT_POOL` and both image variables. The `acquireImage` parameter
(default false) controls explicit acquisition through `registryServiceConnection`.
Docker login/logout tasks use that provider-managed connection.

Successful light runs publish `architecture-light` and receive the CI build tag
`architecture-light-<commit>`. Browser runs use `DownloadPipelineArtifact@2` to
select a successful tagged build on the same branch and pipeline; failed/partial
builds are excluded. The container verifies the source revision and fingerprints
after download. An unavailable artifact fails without fallback. These are CI build
tags, not Docker image tags. Keep artifact retention with its successful run and
configure a minimum 30-day retention target in project/pipeline policy.

Azure Repos PR validation needs a branch build-validation policy; YAML `pr` applies
to supported external providers. The schedule uses `always: true` so a browser run
can complete existing lightweight artifacts even when no code changed. Set the
scheduled branch explicitly if it differs from `main`. Pipeline identity permissions
must permit reading prior pipeline artifacts.

## Packaging, local verification and server editions

`package --stage light` is the default. It includes only light outputs and matching
reports. `package --stage full` additionally requires current successful browser
completion and includes the combined ordinary outputs. The inventory inside each
package lists only its included diagrams. Settings, layout snapshots, optional native
exports, locks, staging and unrelated historical files are excluded. Failure packages
contain reports/logs only; provider logs remain available if image acquisition fails.

```sh
docker/run.sh test
docker/run.sh build
mkdir -p /tmp/architecture-light-artifacts
ARCHITECTURE_ARTIFACT_DIR=/tmp/architecture-light-artifacts docker/run.sh package --stage light
# In a second clean checkout of the same sources, restore that package into build/.
docker/run.sh build-browser
mkdir -p /tmp/architecture-full-artifacts
ARCHITECTURE_ARTIFACT_DIR=/tmp/architecture-full-artifacts docker/run.sh --browser package --stage full
```

Package destinations must be empty. Run `docker/run.sh --browser test` for the
complete regression suite, before restoring the handoff in a fresh CI checkout.
Use `--browser package --diagnostics` after a browser failure. Provider run/commit
provenance is metadata; generated paths and filenames remain stable.

GitHub Enterprise Server requires server-compatible actions/artifact APIs; the
v4+ artifact backend in this example is unsupported on GHES. Azure DevOps Server
requires build-artifact publish/download tasks instead of pipeline-artifact tasks.
Adapt cross-run selection and retain the exact-commit checks. See
[GitHub artifact downloads](https://github.com/actions/download-artifact) and
[Azure artifact downloads](https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/download-pipeline-artifact-v2?view=azure-pipelines).

Local tests cover stage behavior and provider lookup fixtures. Actual runner
registration, credentials, retention and service permissions require verification
in your configured CI service. Toolchain image publication stays a separate
platform-team maintenance operation.
