# Architecture CI examples

These examples are inactive until configured. They target GitHub.com and Azure
DevOps Services on approved Linux runners with Docker, a POSIX shell and standard
runner utilities. They require no host Python, Java, Node or diagram software.
Container processes use the runner's non-root UID/GID. Select an approved non-root
runner account with access to Docker and enough memory for Chromium/Java rendering.

Both pipelines check out an isolated clean directory, acquire an approved image
or use a preloaded image, run all regression tests, and run `build` (which validates
all workspaces before rendering and reports inspection findings without blocking).
Use an explicit `validate` step only if your CI policy requires strict inspection
gates. Registry acquisition and provider artifact uploads
use the runner network. Diagram/test containers have networking disabled. The
approved image contains the toolchain; neither example builds or publishes images.

## GitHub Actions

Copy [github-actions.yaml](github-actions.yaml) to `.github/workflows/architecture.yaml`.
Set repository/organization variables:

- `ARCHITECTURE_RUNNER_LABELS`: JSON label array, e.g. `["self-hosted","linux","architecture"]`.
- `ARCHITECTURE_TOOLS_IMAGE`: approved tools image, preferably an immutable digest.
- `ARCHITECTURE_IMAGE_ACQUISITION`: `preloaded` (or unset), or `pull`.
- `ARCHITECTURE_REGISTRY`: registry hostname when using `pull`.

For `pull`, provide provider-managed secrets `ARCHITECTURE_REGISTRY_USER` and
`ARCHITECTURE_REGISTRY_PASSWORD`. The job uses a temporary Docker credential directory
and deletes it afterward. Preloaded runners need no registry credentials.
Protect runner and secret access according to your organization's pull-request
policy; fork PRs should use preloaded images on runners approved for that trust level.
Review and pin action revisions according to your organization's policy.

## Azure DevOps

Create a pipeline using [azure-pipelines.yaml](azure-pipelines.yaml), or copy it to
an approved pipeline path. Set `ARCHITECTURE_AGENT_POOL` and
`ARCHITECTURE_TOOLS_IMAGE` as pipeline/library variables. Default `acquireImage: false`
uses a preloaded image. To acquire from the internal registry, set it to `true`
and select your Docker registry service connection through `registryServiceConnection`.
The Docker login/logout tasks manage authentication. Azure Repos PR validation
requires a branch build-validation policy; the YAML `pr` trigger applies to supported
external repository providers. Configure the branch name if your default is not `main`.

## Published content and server editions

The containerized `scripts/ci_artifacts.py` copies only inventory-managed outputs
from the current successful full build, plus reports. It verifies source and output
fingerprints before packaging. Optional exports with older freshness are excluded.
The package retains folders such as `views/`, `uml/`, `workspaces/` and `.reports/`;
local settings, writer locks, staging files and historical artifacts are excluded.
Run IDs appear only in provider artifact labels and isolated CI staging paths.
Failure packages contain `.reports/`, `build.json` and `build.log` when available.
Tests retain their log in `.reports/tests.log`. If the image cannot be acquired,
provider job logs are the available diagnostic; there are no diagram outputs.

To exercise the same container commands locally:

```sh
docker/run.sh test
docker/run.sh build
mkdir -p /tmp/architecture-artifacts
ARCHITECTURE_ARTIFACT_DIR=/tmp/architecture-artifacts docker/run.sh package
```

The artifact directory must be empty. Use `package --diagnostics` for a failure
package. It is mounted separately at `/artifacts`; sources remain read-only.

GitHub Enterprise Server needs server-compatible checkout/upload actions and
approved mirrors. The v4+ artifact backend used by this GitHub.com example is not
supported on GHES; select the server-supported action instead. See
[upload-artifact compatibility](https://github.com/actions/upload-artifact).
Azure DevOps Server requires `PublishBuildArtifacts@1` instead of
`PublishPipelineArtifact@1`; adjust artifact download tasks accordingly. See
[Microsoft's pipeline artifact task documentation](https://learn.microsoft.com/en-us/azure/devops/pipelines/tasks/reference/publish-pipeline-artifact-v1?view=azure-pipelines).

Provider YAML execution still needs verification in your own configured CI service;
local container checks cannot verify runner registration, credentials or service connections.
