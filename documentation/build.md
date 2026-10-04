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

`build` generates C4 and authored PlantUML resources; `build-browser` completes
Mermaid images from a matching successful lightweight handoff. Neither invokes
native exports. Inspection findings remain nonblocking; `validate` is the strict
quality check. The [Dockerfile](../docker/Dockerfile), upstream version pins, npm
lockfile and PlantUML checksum remain the platform team's toolchain controls.

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

Create `build/` before execution and ensure your chosen non-root UID/GID can write
it. On Linux/macOS with a POSIX shell:

```sh
mkdir -p build
export ARCHITECTURE_UID=$(id -u)
export ARCHITECTURE_GID=$(id -g)
docker compose run --rm --pull never tools validate
docker compose run --rm --pull never --entrypoint python3 tools -B -m unittest discover -s tests -v
docker compose run --rm --pull never tools export --workspace workspaces/ignition/workspace.dsl --view ignition-dapp-platform-context
docker compose run --rm --pull never tools build
docker compose run --rm --pull never tools-browser build-browser
```

Use an approved nonzero UID; defaults are `1000:1000`. Do not use `sudo` to run
these commands as UID 0. Windows users can use Compose with Docker Desktop and
its bind-mount permissions, keeping the default container UID/GID. A missing
image fails rather than pulling or building it: acquire it explicitly above.
The optional `docker/run.sh` wrapper also prints acquisition instructions.

Normal `compose.yaml` has `pull_policy: never` and no `build` section. Source mounts
are read-only for tools; only `build/` is writable. The container filesystem is
read-only, capabilities are dropped, and networking is disabled. Temporary
storage permits browser execution. Viewers use the same preloaded-image policy;
`docker compose up -d` preserves the existing three service names and localhost
ports. Viewer source mounts remain writable for Structurizr's native ignored cache.

For persistent local settings, put image references, UID/GID and optional ports
in ignored `build/local.env`. Invoke Compose with
`--env-file .env --env-file build/local.env`. Do not commit credentials.
For example:

```text
docker compose --env-file .env --env-file build/local.env run --rm --pull never tools build
```

For a checkout nested beneath another repository, use its explicit paths:

```text
docker compose --project-directory <architecture-checkout> --env-file <architecture-checkout>/.env -f <architecture-checkout>/compose.yaml run --rm --pull never tools build
```

This does not depend on the parent repository's `.env`, Compose configuration,
current directory or Git metadata.

## Run with plain Docker

The following commands use POSIX shell expansion and the same isolation controls
as Compose. Set `ARCHITECTURE_TOOLS_IMAGE` above and run from this checkout.
The image already supplies the architecture entrypoint and `/workspace` working
directory. Only the tests override the entrypoint.

```sh
mkdir -p build
docker run --rm --pull never --network none --read-only --init --user "$(id -u):$(id -g)" --cap-drop ALL --security-opt no-new-privileges:true --shm-size 256m --tmpfs /tmp:rw,exec,nosuid,nodev,size=1g,mode=1777 --mount "type=bind,src=$PWD,dst=/workspace,readonly" --mount "type=bind,src=$PWD/build,dst=/workspace/build" "$ARCHITECTURE_TOOLS_IMAGE" validate
docker run --rm --pull never --network none --read-only --init --user "$(id -u):$(id -g)" --cap-drop ALL --security-opt no-new-privileges:true --shm-size 256m --tmpfs /tmp:rw,exec,nosuid,nodev,size=1g,mode=1777 --mount "type=bind,src=$PWD,dst=/workspace,readonly" --mount "type=bind,src=$PWD/build,dst=/workspace/build" --entrypoint python3 "$ARCHITECTURE_TOOLS_IMAGE" -B -m unittest discover -s tests -v
docker run --rm --pull never --network none --read-only --init --user "$(id -u):$(id -g)" --cap-drop ALL --security-opt no-new-privileges:true --shm-size 256m --tmpfs /tmp:rw,exec,nosuid,nodev,size=1g,mode=1777 --mount "type=bind,src=$PWD,dst=/workspace,readonly" --mount "type=bind,src=$PWD/build,dst=/workspace/build" "$ARCHITECTURE_TOOLS_IMAGE" export --view 01-landscape
docker run --rm --pull never --network none --read-only --init --user "$(id -u):$(id -g)" --cap-drop ALL --security-opt no-new-privileges:true --shm-size 256m --tmpfs /tmp:rw,exec,nosuid,nodev,size=1g,mode=1777 --mount "type=bind,src=$PWD,dst=/workspace,readonly" --mount "type=bind,src=$PWD/build,dst=/workspace/build" "$ARCHITECTURE_TOOLS_IMAGE" build
```

On an approved Linux/macOS shell the optional convenience wrapper supplies those
same flags, resolves paths relative to itself, and checks that the image is loaded:

```sh
docker/run.sh validate
docker/run.sh test
docker/run.sh --browser test
docker/run.sh export --view 01-landscape
docker/run.sh export --all-workspaces
docker/run.sh export-native --workspace workspaces/ignition/workspace.dsl --view example-container-animation --view stable_key_name --format gif
docker/run.sh build
docker/run.sh build-browser
```

The wrapper reads exported environment variables; it does not load `.env` or
`build/local.env` as shell settings. Export the required image variable and any UID/GID overrides before using it.
`build-browser` and `export-native` automatically choose the browser image; use
`--browser` before `test` or `package` to select it explicitly. The Python tooling still reads the committed
version pins from `.env` inside the mounted checkout.

## Lightweight handoffs and completion

`build` now produces only C4/PlantUML outputs. This is a deliberate change from
the previous single-image full build. Run `build-browser` afterward to complete
Mermaid previews. The browser stage reads current Mermaid sources and verifies
the previous light build; it does not repeat DSL parsing or C4 rendering.

Reports use `build/.reports/build-light.json` and `build-browser.json`, with
adjacent logs. The root `build.json` describes the latest stage attempt.
Light success is `passed: true`, `stage: light`, `complete: false`; ordinary build
completion is recorded only after a successful browser stage. Existing deferred
Mermaid files retain their previous freshness. Deleted/moved Mermaid outputs are
pruned only after browser completion succeeds.

To transfer the light result to another checkout of the same sources:

```sh
mkdir -p /tmp/architecture-light-artifacts
ARCHITECTURE_ARTIFACT_DIR=/tmp/architecture-light-artifacts docker/run.sh package --stage light
```

Use an empty destination. Copy that package's contents into the other checkout's
`build/` directory, then run `docker/run.sh build-browser`. CI performs this restore
in an isolated checkout. Do not mix packages from different runs. The package
contains generated light files, filtered inventory, parsed workspace reports,
source fingerprints, deferred paths and provenance. It excludes old browser/native
images, snapshots, local settings, locks and staging. Missing/changed inputs,
required reports or output hashes fail before rendering; no automatic rebuild or
fallback to an older commit occurs.

Compatibility checks use installed toolchain evidence, not image names alone.
The browser image must match the lightweight stage's shared Structurizr/PlantUML,
Graphviz and font dependencies, and its browser renderers must match the committed
pins and lockfile. Reacquire approved images under the same two names when an
installed toolchain is incompatible, then rerun light. Project image tags or
versions do not need to be introduced.

CI supplies `ARCHITECTURE_SOURCE_REVISION` (the exact checked-out commit) and
`ARCHITECTURE_CI_RUN`; these are metadata, never directory names. Browser completion
checks the expected revision in addition to source fingerprints. Local operation
needs no Git metadata. Full packages require both stages:

```sh
mkdir -p /tmp/architecture-full-artifacts
ARCHITECTURE_ARTIFACT_DIR=/tmp/architecture-full-artifacts docker/run.sh --browser package --stage full
```

`package --diagnostics` excludes diagram files. Light packages remain available
when browser completion fails; full packaging refuses failed or stale completion.
Changing sources or lightweight artifacts requires a new lightweight build.
Frozen validation evidence under `build/.reports/light/` stays independent of
the latest ad-hoc export diagnostics, so native exports do not invalidate it.
Fingerprints cover architecture sources, documentation and tooling, including
accepted hidden source folders and local includes. Generated output, Git and agent
configuration, and known caches are excluded; hidden authoring inputs are not
automatically excluded.

When migrating, acquire the two new images, update image variables and rerun the
light stage. Older single-image manifests cannot serve as lightweight handoffs.
The old image and historical output are not automatically deleted.

## Manual layout snapshots

Manual positions belong to saved Structurizr JSON. In the viewer, arrange views
that have no `autoLayout` and explicitly save; then capture the result:

```text
docker compose run --rm --pull never tools capture-layout --workspace workspaces/ignition/workspace.dsl
docker compose run --rm --pull never tools-browser export-native --workspace workspaces/ignition/workspace.dsl --format png
```

The equivalent plain-Docker launcher is `docker/run.sh capture-layout ...` or
`docker/run.sh export-native ...`. Both export commands accept `--all-workspaces`,
one `--workspace`, and repeatable `--view` within a selected workspace. See the
[selection examples](../README.md#export-c4-plantuml-default-mermaid-svg-or-png).

The captured file is
`build/.layouts/workspaces/ignition/workspace.dsl/workspace.json`, with adjacent
`capture.json` metadata. Root-workspace snapshots use
`build/.layouts/workspace.dsl/workspace.json`. The snapshot is a full saved JSON
workspace for compatibility with native merging, but only its layout is reused;
current DSL supplies architecture and animation content.

Snapshots stay ignored by Git and survive ordinary builds and `--clean`. Copy the
snapshot directory to back it up or transfer it to another checkout at the same
relative path. A fresh clone cannot reproduce a manual layout without this state.
Deleting all of `build/` deletes it too.

To restore a captured layout to the viewer, stop that viewer, back up any newer
local `workspace.json`, then copy the captured file beside its `workspace.dsl`.
For Ignition on a POSIX shell:

```sh
docker compose stop ignition
cp build/.layouts/workspaces/ignition/workspace.dsl/workspace.json workspaces/ignition/workspace.json
docker compose up -d ignition
```

Refresh the browser. The viewer reparses DSL and merges saved layout information.
Keep explicit view keys stable; renames and substantial model changes can require
manual adjustment. Capture again after saving those adjustments.

Native export needs no running viewer: it serves temporary static assets on
container loopback, with Docker networking still disabled. External browser
resources are rejected; supply local/embedded icons, themes and fonts. Temporary
pages and animation frames are removed afterward. Sources remain read-only and
only `build/` is writable. The entire selected batch publishes atomically, using
the existing writer lock and recovery journal.

Use `--format svg|png|gif` and optional GIF `--frame-duration <seconds>`.
Native images have `.structurizr` filename suffixes; they coexist with ordinary
exports. Inspection findings remain report-only. Rendering errors or missing
required layouts fail the batch while retaining earlier successful artifacts.
Normal CI builds do not generate or package these optional native images; export
and collect them explicitly when needed.

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
