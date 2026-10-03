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
The [model](model.dsl) defines `dapp_platform` once; the [view](views/main.dsl)
shows that boundary alone. There are no containers, components, actors or
integrations for this proposal. Inherited reference systems are available for
future use but are not selected into the diagram.

From the repository root, start this initiative directly from DSL:

```text
docker compose up -d ignition
```

Open [ignition](http://127.0.0.1:8081). Structurizr reads the authored
`workspace.dsl` directly from the mounted architecture directory, including its
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

Promotion moves the reviewed system definition into shared modules, preserving
`dapp_platform` and its `architecture.id`. Do not copy it into two locations.
