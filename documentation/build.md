# Corporate Docker builds

Developers need an approved Docker engine; Docker Compose is optional. The tools
image contains Structurizr, Java, Python, Node, PlantUML and its C4 library, Mermaid
CLI, Chromium, Graphviz and fonts. No host language runtime, package manager or
diagram application is required. The [Dockerfile](../docker/Dockerfile), version pins, npm lock
and PlantUML checksum define the platform team's toolchain build.

## Acquire approved images explicitly

Obtain `ARCHITECTURE_TOOLS_IMAGE` and `ARCHITECTURE_VIEWER_IMAGE` from your platform
team, preferably pinned to registry digests. On a connected approved machine:

```sh
export ARCHITECTURE_TOOLS_IMAGE='registry.example.com/architecture/tools:approved'
export ARCHITECTURE_VIEWER_IMAGE='registry.example.com/architecture/viewer:approved'
docker login registry.example.com
docker pull "$ARCHITECTURE_TOOLS_IMAGE"
docker pull "$ARCHITECTURE_VIEWER_IMAGE"
docker image inspect "$ARCHITECTURE_TOOLS_IMAGE"
```

The names above are placeholders, not published project images. Supply credentials
through Docker's approved credential store or CI secrets/service connections.
Registry CA trust, proxies, registry allowlists, signing/verification policy and
permission to access the Docker engine are managed host configuration. Do not
bypass corporate TLS or image trust controls. The execution host needs a Linux
container image compatible with its architecture.

For an offline workstation, the platform team transfers an approved archive:

```sh
docker image save --output architecture-images.tar "$ARCHITECTURE_TOOLS_IMAGE" "$ARCHITECTURE_VIEWER_IMAGE"
docker image load --input architecture-images.tar
```

Archive loading retains saved tags; set image variables to the loaded references.
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
docker/run.sh export --view 01-landscape
docker/run.sh build
```

## Platform-team image maintenance

Image construction is a separate, network-enabled maintenance operation:

```sh
docker compose -f compose.yaml -f docker/compose.maintenance.yaml build tools
```

The build context is `docker/`; its `.dockerignore` includes only the Dockerfile
and renderer dependency setup. The maintenance environment needs approved access or mirrors for the pinned base
images, Ubuntu packages, npm packages and Maven artifact in `docker/Dockerfile`. Adapt
registry/package mirror and CA configuration there to corporate policy; retain
version pins, the lockfile and checksum verification. The resulting tools image
contains every dependency; repository scripts are mounted read-only at runtime.
Test it offline, scan/sign it and publish it using your platform process. Mirror
the pinned Structurizr `-noble` viewer image separately. No application pipeline
builds or publishes toolchain images.

See [Docker Compose runtime options](https://docs.docker.com/reference/cli/docker/compose/run/),
[image save](https://docs.docker.com/reference/cli/docker/image/save/) and
[image load](https://docs.docker.com/reference/cli/docker/image/load/), plus the
[CI examples](../ci/examples/README.md).
