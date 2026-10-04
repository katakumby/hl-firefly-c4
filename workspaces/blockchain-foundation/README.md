# Blockchain foundation: Besu and FireFly on Azure

Status: **proposed target topology; HSM and recovery integrations require qualification**.
Architect: TBD. Technical lead/team: TBD. Epic: TBD. Evidence reviewed: 2026-09-20.

The agreed scope is one Azure region, three availability zones, survival of any
one AZ outage, and one FireFly member with a repeatable pattern for future members.
Kafka, Keycloak and application/DApp deployment are excluded from these views.
The workspace reuses the shared Besu and FireFly product definitions; proposals
remain local to this initiative. The reference catalog is not a mandatory stack.

## Read the diagrams

| View | Purpose |
|---|---|
| `blockchain-foundation-01-platform` | Azure networking, AKS zone capacity and managed dependencies |
| `blockchain-foundation-02-besu` | Six validators in a 2/2/2 split, three RPC nodes, peer and HSM paths |
| `blockchain-foundation-03-firefly` | One member, singleton recovery unit, aggregated signing service, database HA and durable volumes |
| `blockchain-foundation-04-keys` | Three signing gateway replicas across the AZs; separate validator and transaction keys, identity and recovery material |
| `blockchain-foundation-05-az-outage` | AZ1 outage: four validators remain and the member recovers in AZ2 |

The native diagram key explains the shared C4 colours and shapes. Deployment
placements in this proposal carry `Planned` and use dashed borders; their labels
identify qualification gates, failed resources, running standbys and reserved
recovery capacity. Official Azure service icons are embedded locally for offline
native exports and the web UI. They do not change the shared colours or shapes.

View 03 represents the three transaction signing gateways with one **Transaction
signing service** summary box; view 04 shows their individual AZ placements.
The recovery controller has three candidates inside AKS, one per AZ; only the
elected leader coordinates fenced recovery. Views 03 and 04 show all candidates.
View 03 draws representative recovery paths from AZ2 as the illustrative leader;
any surviving candidate can be elected to perform those operations.

Start the dedicated viewer from the repository root:

```text
docker compose up -d blockchain-foundation
```

Open [the foundation diagrams](http://127.0.0.1:8082). Edit the DSL and refresh.

```text
docker compose run --rm --pull never tools validate --workspace workspaces/blockchain-foundation/workspace.dsl
docker compose run --rm --pull never tools export --workspace workspaces/blockchain-foundation/workspace.dsl
```

Acquire the approved tools image first; see the [corporate build guide](../../documentation/build.md).
The default C4-PlantUML definitions live under `build/workspaces/blockchain-foundation/views/`.
Add `--format svg` or `--format png` when image exports are needed.

## Design and implementation plan

`workspace.dsl` extends the root model and assembles local `model.dsl`,
`deployment.dsl`, `failure.dsl` and `views/main.dsl` fragments, plus the shared
`styles/themes/microsoft-azure-2024.07.15/icons.json` theme.
Keep deployment and failure definitions here until reviewed promotion; shared
product definitions stay in `model/external-systems/`. The `docs/` directory holds
the design below, and `uml/` is reserved for standalone local behavioral/code diagrams.

- [Scope, decisions and quorum](docs/01-design.md)
- [Deployment inventory, network and persistence](docs/02-deployment.md)
- [Failure behavior, recovery and acceptance tests](docs/03-recovery.md)
- [Qualification gates, delivery sequence and primary sources](docs/04-evidence-and-plan.md)

**Readiness limit:** six validators provide the requested omission-failure
quorum, but the complete platform must not be called AZ-resilient until the
validator HSM's failure domain and compatibility are proven and fenced member
recovery is implemented and tested. Azure Cloud HSM is a candidate, not a
claim of verified three-zone placement. No Azure resources are provisioned here.
