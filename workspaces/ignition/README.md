# Ignition

Establish the first proposed software system of the new platform: **DApp Platform**
(DApp means decentralized application). Responsibilities and integrations are
to be defined; this initiative starts with its identity and boundary.

| Field | Value |
|---|---|
| Epic ID | ignition |
| Status | Proposed |
| Architect | TBD |
| Technical lead | TBD |
| Team | TBD |
| Epic link | TBD |

The [workspace](workspace.dsl) extends the shared model in the same checkout.
The [model](model.dsl) defines `dapp_platform` once; the [context view](views/main.dsl)
shows that boundary alone. The DApp proposal has no containers, components, actors
or integrations yet. Inherited reference systems are available for future use but
are not selected into that diagram.

The workspace also contains an independent **Example System** with API and Backend
containers and relationships in both directions. These experiments are local to
Ignition and do not define DApp internals or an approved shared platform design.

| View key | Purpose | Definition |
|---|---|---|
| `ignition-dapp-platform-context` | Proposed DApp boundary | `views/main.dsl` |
| `ignition-example-containers` | Example API and Backend containers | `workspace.dsl` |
| `example-container-animation` | Container view with two animation steps | `workspace.dsl` |
| `stable_key_name` | Example dynamic interaction sequence | `workspace.dsl` |

These existing experiments are Structurizr views. Author new standalone behavioral
and code diagrams as PlantUML or Mermaid in [uml/](uml/README.md), with explanations
in [docs/](docs/README.md). Shared C4 definitions remain in the root model; local
annotations and additions do not modify it or sibling workspaces.

From the repository root, start this initiative directly from DSL:

```text
docker compose up -d ignition
```

Open [ignition](http://127.0.0.1:8081). Structurizr reads the authored
`workspace.dsl` directly from the mounted repository, including its
shared model and fragments. No script, custom image build or preprocessing is
required. The main workspace can stay open on port 8080.

After DSL changes, refresh the browser. Run
`docker compose stop ignition` to stop only this
initiative. The `ignition` service in [Compose](../../compose.yaml) selects its
workspace directory and port. Native Structurizr JSON/cache
files beside the DSL are generated automatically and ignored by Git.

Record future scenarios in the [use-case index](uml/README.md).
Create interim/target variants only when designs differ, following the
[contribution workflow](../../README.md#variants-and-promotion).

Validate or export from the repository root after acquiring the approved tools
image described in the [build guide](../../documentation/build.md):

```text
docker compose run --rm --pull never tools validate --workspace workspaces/ignition/workspace.dsl
docker compose run --rm --pull never tools export --workspace workspaces/ignition/workspace.dsl
```

`validate` is strict; `export` and the full `build` report inspection findings
without blocking diagram generation. The Example System currently has incomplete
technology metadata and coverage/connectivity findings. Reports are under
`build/.reports/workspaces/ignition/workspace.dsl/`. The DApp context exports into
`build/workspaces/ignition/views/`; the inline example views export directly into
`build/workspaces/ignition/`, using their view keys as filenames.

Promotion moves reviewed definitions into `model/platform/`, views into
`views/platform/`, and applicable behavioral diagrams into shared `uml/`.
Preserve `dapp_platform` and its `architecture.id`; remove the local definition
in the same reviewed change instead of copying it into two locations.
