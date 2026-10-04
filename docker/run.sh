#!/bin/sh
# Optional POSIX convenience wrapper; equivalent plain Docker commands are documented.
set -eu
architecture_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
architecture_browser=false
if [ "${1:-}" = --browser ]; then
    architecture_browser=true
    shift
fi
case "${1:-}" in build-browser|export-native) architecture_browser=true ;; esac
if [ "$architecture_browser" = true ]; then
    architecture_image=${ARCHITECTURE_BROWSER_IMAGE:-dlt-architecture-tools-browser}
else
    architecture_image=${ARCHITECTURE_TOOLS_IMAGE:-dlt-architecture-tools-light}
fi
if ! docker image inspect "$architecture_image" >/dev/null 2>&1; then
    echo "Approved tools image is not loaded: $architecture_image" >&2
    echo 'Acquire it explicitly with docker pull or docker load; see documentation/build.md.' >&2
    exit 1
fi
architecture_uid=${ARCHITECTURE_UID:-$(id -u)}
architecture_gid=${ARCHITECTURE_GID:-$(id -g)}
if [ "$architecture_uid" = 0 ]; then
    echo 'Choose a non-root ARCHITECTURE_UID and a writable build directory.' >&2
    exit 1
fi
mkdir -p "$architecture_root/build"
architecture_entrypoint=python3
if [ "${1:-}" = test ]; then
    shift
    set -- -B -m unittest discover -s tests -v "$@"
elif [ "${1:-}" = package ]; then
    shift
    set -- -B /workspace/scripts/ci_artifacts.py "$@"
else
    set -- -B /workspace/scripts/architecture.py "$@"
fi
if [ -n "${ARCHITECTURE_ARTIFACT_DIR:-}" ]; then
    set -- --mount "type=bind,src=$ARCHITECTURE_ARTIFACT_DIR,dst=/artifacts" "$architecture_image" "$@"
else
    set -- "$architecture_image" "$@"
fi
exec docker run --rm --pull never --network none --read-only --init \
    --env ARCHITECTURE_SOURCE_REVISION --env ARCHITECTURE_CI_RUN \
    --user "$architecture_uid:$architecture_gid" \
    --cap-drop ALL --security-opt no-new-privileges:true --shm-size 256m \
    --tmpfs /tmp:rw,exec,nosuid,nodev,size=1g,mode=1777 \
    --mount "type=bind,src=$architecture_root,dst=/workspace,readonly" \
    --mount "type=bind,src=$architecture_root/build,dst=/workspace/build" \
    --entrypoint "$architecture_entrypoint" "$@"
