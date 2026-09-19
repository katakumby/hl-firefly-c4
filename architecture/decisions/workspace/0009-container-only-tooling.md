# 9. Keep a small Docker-only architecture workflow

Date: 2026-09-19

## Status

Accepted. Supersedes the execution, artifact-history, evidence-refresh and
compatibility portions of [decision 8](0008-provenance-and-isolated-runs.md)
and the host command interfaces in [decision 7](0007-modular-workspaces.md).
Modular authoring remains the workspace structure. Custom validation enforcement
from those decisions is retired; identifier, ownership and other team conventions
are advisory until teams agree to progressively automate them.

## Context

The workspace will be maintained in a corporate environment using Docker.
Viewing architecture must work directly from authored DSL, without running a
script, building a custom image or generating JSON in advance.

## Decision

Mount `architecture/` directly into the pinned Structurizr container. Run
Structurizr's native `local` command with the directory containing the selected
`workspace.dsl`. The unchanged source tree provides its local includes,
workspace extensions and documentation. Do not add preparation containers,
wrapper DSL, Python startup or preprocessing.

Declare each workspace explicitly in `compose.yaml`: `global` on localhost
port 8080 and `ignition` on 8081. Reuse the common viewer settings through a YAML
anchor. Plain `docker compose up -d` starts both; a service name selects one.
Additional initiatives and variants add a named service and unused localhost
port. Keep the central Structurizr version pin in the committed `architecture/.env`,
which Compose loads automatically and Python also reads. After DSL
changes, refresh the browser. Viewing invokes Structurizr's parser; optional
validation runs Structurizr's native validator and inspector.

Native Structurizr local mode requires a writable data directory and creates
`workspace.json` and `.structurizr/` cache/log files beside the selected DSL.
These files are ignored by Git and excluded from source fingerprints.
They are native outputs, never a prerequisite for viewing. This is the explicit
exception to the earlier rule placing every generated file under `build/`.
Diagram editing and autosave remain disabled. The container filesystem is
read-only except for its mounted architecture directory and temporary storage.

Keep one Python command with `validate` and `export` subcommands, one path/discovery
module and a focused workflow test suite. These optional tools
run in a separate container with read-only sources and networking disabled.
Invoke Java directly without a Docker socket or nested Docker, using Python's
standard library only. SVG/PNG export uses the browser already included in the
pinned Playwright image. The tools write only under `build/architecture/`.

All services run as a non-root user with dropped capabilities and no privilege
escalation. The viewer publishes only a localhost port and disables
Structurizr's outbound URL loading. Corporate registries can supply approved
images. Container isolation reduces host exposure but is not an absolute
security boundary.

Validate selected workspaces sequentially, letting Structurizr resolve their
includes and extensions. Do not independently inspect ancestors or other
initiatives when a specific entrypoint is selected.
Run Structurizr's native `validate` on freshly exported JSON, followed by native
`inspect -severity error,warning` for each selected workspace. JSON validation includes the native
round-trip and theme checks without parsing DSL a second time. Record the native
commands and their output in `validation.log`.

Use native validation exclusively. Remove the custom audit, catalog normalization,
provenance/dependency validator and their policy tests. Do not enforce custom
identifiers, naming prefixes, evidence fields, diagram connectivity/coverage,
component/runtime boundaries, dependency direction, allowed view types or Markdown
destinations. Do not hard-code ignition ownership or a boundary-only DApp rule.

Honor native inspection properties without a Python allowlist. Errors and warnings
fail the command; `info` and `ignore` are non-blocking. Keep existing authored
inspection settings unchanged. Teams can adjust them in DSL. Treat authoring
conventions as review guidance and introduce custom validation progressively
when the teams have agreed requirements and ownership for maintaining it.

Remove product-specific semantic assertions,
live evidence refresh, source-file inventories, cache verification, migration
comparison commands and compatibility wrappers. Reference evidence and
historical baselines remain available; future evidence changes are reviewed
manually.

Use one validation/export output directory per workspace and a single writer
lock per checkout. Keep the latest validation report and last successful JSON.
Export validates fresh sources first, renders into a fresh directory and only
then replaces its previous result. Failed validation does not overwrite
successful exports. Do not retain or clean a custom run history.
Earlier prepared-viewer output directories remain historical and are not read.

## Consequences

The public interface is the Docker Compose commands in the
[root README](../../../README.md#docker-only-workflow). The viewer requires only
the prebuilt Structurizr image and authored sources. Validation/export require
the tools image; no host Python, Java or project shell scripts are needed.

This change does not modify any model, relationship, view selection or style.
Evidence metadata and legacy artifacts remain unchanged. CI and automated
Mermaid rendering remain outside scope.
