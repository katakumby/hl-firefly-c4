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

The native diagram key explains colors and line styles. Orange dashed boxes mark
unresolved qualification gates. Gray dashed boxes are standby/recovery resources;
their labels distinguish running standbys from reserved scheduling capacity.

View 03 represents the three transaction signing gateways with one **Transaction
signing service** summary box; view 04 shows their individual AZ placements.
The recovery controller has three candidates inside AKS, one per AZ; only the
elected leader coordinates fenced recovery. Views 03 and 04 show all candidates.
View 03 draws representative recovery paths from AZ2 as the illustrative leader;
any surviving candidate can be elected to perform those operations.

Start the dedicated viewer from the repository root:

```text
docker compose -f architecture/compose.yaml up -d blockchain-foundation
```

Open [the foundation diagrams](http://127.0.0.1:8082). Edit the DSL and refresh.

```text
docker compose -f architecture/compose.yaml run --rm tools validate --workspace architecture/initiatives/blockchain-foundation/workspace.dsl
docker compose -f architecture/compose.yaml run --rm tools export --workspace architecture/initiatives/blockchain-foundation/workspace.dsl
```

Use `--build` on the first tools run if its image has not been built.
The default C4-PlantUML definitions live under `build/architecture/workspaces/initiatives/blockchain-foundation/workspace/exports/all/plantuml/`.
Add `--format svg` or `--format png` when image exports are needed.

## Design and implementation plan

- [Scope, decisions and quorum](docs/01-design.md)
- [Deployment inventory, network and persistence](docs/02-deployment.md)
- [Failure behavior, recovery and acceptance tests](docs/03-recovery.md)
- [Qualification gates, delivery sequence and primary sources](docs/04-evidence-and-plan.md)

**Readiness limit:** six validators provide the requested omission-failure
quorum, but the complete platform must not be called AZ-resilient until the
validator HSM's failure domain and compatibility are proven and fenced member
recovery is implemented and tested. Azure Cloud HSM is a candidate, not a
claim of verified three-zone placement. No Azure resources are provisioned here.
