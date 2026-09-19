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
The [model](model.dsl) defines `dapp_platform` once; the [view](views.dsl)
shows that boundary alone. There are no containers, components, actors or
integrations for this proposal. Inherited reference systems are available for
future use but are not selected into the diagram.

From the repository root:

```powershell
./architecture/scripts/validate.ps1 -Workspace architecture/initiatives/ignition/workspace.dsl
./architecture/scripts/preview.ps1 -Workspace architecture/initiatives/ignition/workspace.dsl -Port 8080
```

Record future scenarios in the [use-case index](use-cases/README.md).
Create interim/target variants only when designs differ, following the
[contribution workflow](../../../README.md#variants-and-promotion).

Promotion moves the reviewed system definition into shared modules, preserving
`dapp_platform` and its `architecture.id`. Do not copy it into two locations.
