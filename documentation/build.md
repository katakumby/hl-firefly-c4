# Corporate Docker builds

Developers need an approved Docker engine; Docker Compose is optional. No host
Python, Java, Node, npm or diagram software is required. Two project images use
distinct names with no explicit version/tag (Docker resolves implicit `latest`):

| Variable | Default image | Capabilities |
|---|---|---|
| `ARCHITECTURE_TOOLS_IMAGE` | `dlt-architecture-tools-light` | Structurizr, Java, Python, PlantUML/C4, Graphviz, fonts |
| `ARCHITECTURE_BROWSER_IMAGE` | `dlt-architecture-tools-browser` | Complete toolchain plus Node, Mermaid CLI, Puppeteer, Chromium |

The lightweight image has no browser or Node runtime. Ordinary C4/PlantUML images
need Java/Graphviz; Mermaid images and native Structurizr exports need Chromium.
Installed capabilities and versions are recorded in each image. Unsupported
operations fail with the required service name, without installing dependencies.

`build-source` generates C4 text and copies authored PlantUML/Mermaid. Independent
`build-preview --renderer plantuml|mermaid` commands render that generated text.
Native exports remain explicit. Inspection findings are reported without blocking
generation; `validate` is the strict quality check. The [Dockerfile](../docker/Dockerfile),
upstream pins, npm lockfile and artifact checksums remain toolchain controls.

## Acquire approved images explicitly

Obtain both tools image names and the existing viewer reference from your platform
team. On a connected approved machine, acquire only images needed for your work:

```sh
export ARCHITECTURE_TOOLS_IMAGE='registry.example.com/architecture/dlt-architecture-tools-light'
export ARCHITECTURE_BROWSER_IMAGE='registry.example.com/architecture/dlt-architecture-tools-browser'
docker login registry.example.com
docker pull "$ARCHITECTURE_TOOLS_IMAGE"
docker pull "$ARCHITECTURE_BROWSER_IMAGE"
docker image inspect "$ARCHITECTURE_TOOLS_IMAGE"
docker image inspect "$ARCHITECTURE_BROWSER_IMAGE"
```

If you also use the interactive viewers, acquire the platform team's approved
Structurizr viewer image separately and export its reference for Compose:

```sh
export ARCHITECTURE_VIEWER_IMAGE='registry.example.com/architecture/structurizr-viewer'
docker pull "$ARCHITECTURE_VIEWER_IMAGE"
docker image inspect "$ARCHITECTURE_VIEWER_IMAGE"
```

Without this override, Compose uses the upstream `structurizr/structurizr` image
with the committed `STRUCTURIZR_VERSION` and `-noble` suffix. The approved mirror
must supply that pinned viewer version. Viewers are optional for build/export jobs.

The names above are placeholders, not published project images. Supply credentials
through Docker's approved credential store or CI secrets/service connections.
Registry CA trust, proxies, registry allowlists, signing/verification policy and
permission to access the Docker engine are managed host configuration. Do not
bypass corporate TLS or image trust controls. The execution host needs a Linux
container image compatible with its architecture.

For an offline workstation, the platform team transfers an approved archive:

```sh
docker image save --output architecture-images.tar "$ARCHITECTURE_TOOLS_IMAGE" "$ARCHITECTURE_BROWSER_IMAGE"
docker image load --input architecture-images.tar
```

For offline viewing, transfer its image too:

```sh
docker image save --output architecture-viewer.tar "$ARCHITECTURE_VIEWER_IMAGE"
docker image load --input architecture-viewer.tar
```

Archive loading retains the recorded image names; set the corresponding variables
to those names on the receiving workstation.
The team should supply and verify archive checksums through its trusted channel.
Image acquisition requires registry/archive access; generation subsequently runs
with `--network none`. Public dependencies are never downloaded at runtime.

## Run with Compose

Create build and choose a non-root UID/GID with write access. Tools mount authoring
sources read-only and build writable. Runtime networking is disabled, the container
filesystem is read-only, capabilities are dropped, and scratch space is temporary.
The normal Compose file contains no image-build instructions and never pulls images.

```sh
mkdir -p build
export ARCHITECTURE_UID=$(id -u)
export ARCHITECTURE_GID=$(id -g)
docker compose config --quiet
docker compose run --rm --pull never tools clean
docker compose run --rm --pull never tools build-source
docker compose run --rm --pull never tools build-preview --renderer plantuml
docker compose run --rm --pull never tools-browser build-preview --renderer mermaid
```

The two preview commands can run in either order. Clean only before generating or
restoring sources; cleaning afterward deletes their input. Preview commands never
rebuild missing text. Use `validate` for strict standalone validation, or select a
workspace/view with `build-source` and PlantUML previews:

```sh
docker compose run --rm --pull never tools build-source --workspace workspaces/ignition/workspace.dsl --view ignition-dapp-platform-context
docker compose run --rm --pull never tools build-preview --renderer plantuml --workspace workspaces/ignition/workspace.dsl --view ignition-dapp-platform-context
```

Inspection findings remain nonblocking during generation. Parsing/model validation,
inspector failures, collisions and renderer errors remain failures. Selection defaults
and native exports are described in the [README](../README.md#build-diagram-sources).

Use exported environment variables or ignored `docker/local.env` for machine-specific
image names, UID/GID and port overrides. Do not place credentials in committed files.
Move an existing `build/local.env` outside build before invoking clean.

```sh
docker compose --env-file .env --env-file docker/local.env run --rm --pull never tools build-source
```

The launcher below uses exported variables, not Compose env files. From a parent
codebase, pass this checkout's project directory, env file and Compose file explicitly:

```text
docker compose --project-directory <checkout> --env-file <checkout>/.env -f <checkout>/compose.yaml run --rm --pull never tools build-source
```

Repository-relative paths and freshness do not require parent configuration or Git metadata.

## Run with plain Docker

No host Python, Java or Node is needed. The optional POSIX wrapper provides the same
mounts and restrictions as Compose, finds this repository from its own location, and
checks that the image is already loaded:

```sh
docker/run.sh clean
docker/run.sh build-source
docker/run.sh build-source --workspace workspace.dsl --view 01-landscape
docker/run.sh build-preview --renderer plantuml
docker/run.sh build-preview --renderer mermaid
docker/run.sh export-native --workspace workspaces/ignition/workspace.dsl --view example-container-animation --format gif
docker/run.sh test
docker/run.sh --browser test
```

Mermaid previews/packages and native exports automatically select the browser image.
Use `--browser` for browser-image tests or cleanup when only that image is preloaded.
The default image is lightweight; missing images fail with acquisition instructions.

For environments that prefer direct Docker calls, this is the complete source command:

```sh
docker run --rm --pull never --network none --read-only --init \
  --user "$(id -u):$(id -g)" --cap-drop ALL --security-opt no-new-privileges:true \
  --shm-size 256m --tmpfs /tmp:rw,exec,nosuid,nodev,size=1g,mode=1777 \
  --mount "type=bind,src=$PWD,dst=/workspace,readonly" \
  --mount "type=bind,src=$PWD/build,dst=/workspace/build" \
  "$ARCHITECTURE_TOOLS_IMAGE" build-source
```

Keep the same runtime options and substitute `clean`, `validate`,
`build-source --workspace workspace.dsl --view 01-landscape`, or
`build-preview --renderer plantuml`. For `build-preview --renderer mermaid` and
`export-native`, substitute `$ARCHITECTURE_BROWSER_IMAGE`.
For tests, add `--entrypoint python3` before the image name and pass
`-B -m unittest discover -s tests -v` after it.

## Source handoffs and independent previews

`build-source` produces text, a deterministic `build/source.json` inventory, and
ignored `.reports/source.json` / `.log` with frozen per-workspace validation evidence
under `.reports/source/`. Neither preview stage requires the other renderer's output.
A source artifact must include that evidence, not merely the committed diagrams.

```sh
mkdir -p /tmp/architecture-source-artifacts
ARCHITECTURE_ARTIFACT_DIR=/tmp/architecture-source-artifacts docker/run.sh package --stage source
# In another checkout of the same sources: clean, then restore the package into build/.
docker/run.sh build-preview --renderer plantuml
mkdir -p /tmp/architecture-plantuml-artifacts
ARCHITECTURE_ARTIFACT_DIR=/tmp/architecture-plantuml-artifacts docker/run.sh package --stage preview --renderer plantuml
```

Package destinations must be empty. Use another checkout restored from the same
source package to run `build-preview --renderer mermaid` and
`package --stage preview --renderer mermaid`. Their inventories and report names are
distinct, so same-handoff preview packages can be combined without overwriting evidence.
Native files, local settings, saved layouts, locks and staging are excluded. Use
`package --diagnostics` after failure; it includes reports and logs, never diagrams.

The receiver checks source fingerprints, output/report hashes, selection coverage,
installed toolchain compatibility, and `ARCHITECTURE_SOURCE_REVISION` when set by CI.
`ARCHITECTURE_CI_RUN` records provenance without changing output names. Wrong commits,
partial or stale handoffs, corrupted files and incompatible images fail before rendering.
There is no fallback to another commit or automatic source regeneration.

Shared toolchain components must match across images; browser capabilities may be
additional. Image names alone do not establish compatibility. Reacquire approved
images under the same names when needed, then create a fresh source handoff. Older
light/full handoffs are intentionally unsupported.

Source, PlantUML, Mermaid and native inventories are versioned. Operational reports
and timestamps remain ignored. Files from a failed stage remain available as previous
artifacts but cannot be packaged as current success. Publishing uses one writer lock,
bounded staging and a rollback journal; another command recovers interrupted publication.

## Saved layouts

Explicitly save manual diagrams in the viewer. The adjacent `workspace.json` is the
versioned golden source for coordinates and routing; DSL supplies current model,
views and animation definitions. Automatic layouts do not require saved coordinates.
There is no capture command or persistent `.layouts` copy.

```text
docker compose run --rm --pull never tools-browser export-native --workspace workspaces/ignition/workspace.dsl --format png
```

The native merge reads saved JSON into temporary staging, checks that the original
has not changed before publication, and leaves it unmodified. Export needs no running
viewer. Temporary static pages and animation frames use container-local storage and
are discarded. An internal loopback server works with Docker networking disabled.
External browser resources are rejected; use available embedded/local themes, icons
and fonts. SVG/PNG/GIF outputs live directly under mirrored `build/preview/` paths.

To restore an earlier layout, stop the relevant viewer, review and restore the desired
version of its adjacent JSON using Git, then restart the viewer. Keep newer local
changes safe before restoring. Native parsing merges that saved layout with current DSL.
View-key or model changes may require adjusting and saving positions again.

Clean removes generated previews and old snapshots, not these adjacent saved JSON files.
Both ordinary preview stages preserve native outputs and their freshness metadata;
only another explicit native export refreshes them. CI does not export repository
native images, although browser regression tests render isolated temporary fixtures.

## Platform-team image maintenance

Image construction is a separate, network-enabled maintenance operation:

```sh
docker compose -f compose.yaml -f docker/compose.maintenance.yaml build tools
docker compose -f compose.yaml -f docker/compose.maintenance.yaml build tools-browser
```

The build context is `docker/`; its `.dockerignore` includes only the Dockerfile
and renderer dependency setup. The maintenance environment needs approved access or mirrors for the pinned base
images, Ubuntu packages, npm packages and Maven artifact in `docker/Dockerfile`. Adapt
registry/package mirror and CA configuration there to corporate policy; retain
version pins, the lockfile and checksum verification. The `light` target never depends on the Node/npm or Playwright stages. The
`browser` target includes the complete runtime; both keep pinned dependencies and
checksum verification. Each target produces its own image name; repository scripts are mounted read-only at runtime.
Test each image offline, scan/sign it and publish it using your platform process. Mirror
the pinned Structurizr `-noble` viewer image separately. No application pipeline
builds or publishes toolchain images.

See [Docker Compose runtime options](https://docs.docker.com/reference/cli/docker/compose/run/),
[image save](https://docs.docker.com/reference/cli/docker/image/save/) and
[image load](https://docs.docker.com/reference/cli/docker/image/load/), plus the
[CI examples](../ci/examples/README.md).
