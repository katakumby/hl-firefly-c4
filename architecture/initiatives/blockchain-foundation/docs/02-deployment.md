# Deployment inventory, networking and persistence

## Initial resource inventory

The counts below describe the same resources at different levels of the diagrams.
An aggregate box in the platform view is not an extra set of machines.

| Resource | Normal placement/count | AZ failure behavior |
|---|---|---|
| AKS control plane | Private, Standard tier, zone-resilient | Azure-managed control plane recovery |
| System pools | Three zonal pools; one node in each AZ | Two remain; provision measured spare capacity |
| Ledger pools | Three zonal pools; three hosts each | Six ledger hosts remain |
| Besu validators | Six singleton identities, two per AZ, one per host | Four can continue; no emergency validator-set edit |
| Besu RPC nodes | Three non-validators, one per AZ, separate hosts | Two serve reads, submission and events |
| Middleware pools | Three zonal pools; two nodes each initially | Four hosts remain; must fit the recovered member and proxies |
| Core / EVMConnect / DX / Kubo | One pod with four containers, initially AZ1 | Fenced replacement in AZ2 or AZ3 |
| Signing gateway | Three replicas, one per AZ | Two continue with sufficient HSM capacity |
| Ingress gateway / RPC proxy | Three replicas of each, one per AZ | Route through healthy replicas/backends |
| Recovery controller | Three candidates, one elected leader | A surviving leader coordinates fenced recovery |
| PostgreSQL | One managed primary AZ2 + one standby AZ3 | Managed promotion if primary fails; stable FQDN |
| Member disk state | Two independent Premium_ZRS data PVCs | Reattach to recovered pod after fencing |
| Validator HSM | Candidate service, deployment admission pending | Must prove that all four surviving validators can sign and peer |
| Transaction keys | Key Vault Premium EC-HSM keys | Require documented zone-resilient regional service |
| Secrets, registry, backups, monitoring | Private Azure-managed dependencies | Qualify each selected region/SKU; pre-pull recovery images |

The initial count is **18 AKS worker VMs**: three system, nine ledger and six
middleware. This is a placement starting point, not performance sizing. Start with
at least four vCPUs per production VM; choose memory, disk capacity/IOPS, network
bandwidth and member pod limits from measurements. No Spot or burstable production
ledger capacity. Keep the validator host assignment explicit.

Each surviving zone should have capacity to take the complete member recovery
unit while sustaining its existing traffic. Do not rely on obtaining new zonal
quota during the outage. After losing one of three stateless replicas, each
remaining replica can see 1.5 times normal traffic; test this plus retry bursts.

## Kubernetes controls

- Use unique StatefulSet/pod identities and independent data directories for all
  nine Besu nodes. Required zone affinity fixes the 2/2/2 validator distribution;
  required hostname anti-affinity separates ledger processes.
- Use topology spread and hostname anti-affinity for three-replica services.
  Keep replacement scheduling possible in surviving zones; a requirement for all
  three zones to remain eligible must not prevent recovery.
- Label all six validators for a shared PDB with `minAvailable: 5`, plus an
  operational upgrade lock spanning node pools. This allows one planned eviction
  while healthy and blocks drains when four remain. PDBs do not stop involuntary
  AZ failures or every direct deletion.
- Three-replica gateways/signers/proxies use PDB `minAvailable: 2`. The singleton
  member has `minAvailable: 1`; planned upgrades require a deliberate maintenance
  procedure. Never force a drain around this without following fencing rules.
- Keep a single member pod, one PVC writer, no overlapping rollout, stable DNS and
  separate requests/limits for each container. A Kubernetes Lease or a
  `replicas: 1` setting alone is not fencing of a partitioned old worker.
- Set startup probes for chain synchronization and member recovery, useful readiness
  checks for routing, conservative liveness checks, graceful termination and bounded
  request retries. Brief HSM/DB slowness should not cause restart storms.
- Patch sequentially across zones and one validator at a time; return to six healthy
  validators before the next maintenance action. Do not autoscale validator count.
  Autoscaling non-validator pools must preserve recovery reservations and disk limits.

## Traffic and endpoint plan

| Source to destination | Transport | Boundary/control |
|---|---|---|
| Approved private consumer to member ingress | HTTPS 443; WebSocket | Internal zone-redundant LB, mTLS and service policy; client apps not modeled |
| Future member peer to DX ingress | mTLS HTTPS 443 | Separate peer route; preserve client certificate validation |
| Core to EVMConnect/DX/Kubo | Private REST/WebSocket; Kubo API 5001 | Pod-local/configured plugin ports, never public |
| Core/FFTM to database | PostgreSQL TLS 5432 | Private FQDN, separate database users and migration roles |
| EVMConnect to signing gateway | Private JSON-RPC over mTLS | Allowlisted chain, key and method; FFTM supplies nonce |
| Signing gateway to Key Vault | HTTPS 443 | Private endpoint, Workload Identity, per-key signing permission |
| Signing gateway/proxy to Besu RPC | JSON-RPC 8545; optional WS 8546 | TLS wrapper or qualified Besu TLS configuration; restricted methods |
| Besu peers to Besu peers | devp2p TCP 30303 | Stable per-node address; node/account permissioning; private routing |
| Optional peer discovery | UDP 30303 if enabled | Baseline uses static peer lists; discovery is not required |
| Kubo to admitted consortium Kubo peers | Private libp2p TCP 4001 | Private swarm and peer allowlist; disable public bootstrap; enable QUIC only with an explicit UDP rule |
| Besu HSM client to validator HSM | Vendor PKCS#11 transport | Private encrypted channel and exact vendor port allowlist after H1 |
| Platform components to Azure | HTTPS/DNS as required | Private endpoints where supported; controlled redundant egress |
| Recovery controller to Azure Compute/AKS | HTTPS 443 | Narrow identity scoped to approved recovery operations |

Static peers include cross-AZ addresses, not just peers in the local zone. Each
node has a stable per-node Service/address and advertised enode identity. P2P must
never run through a generic load balancer that randomly selects another node.
The three RPC nodes can also supply bootstrap endpoints; separate bootnode-only
pods are not a must-have dependency in this static topology.

The RPC routing service must preserve **backend affinity for node-local filters**.
Round-robin per request can invalidate filter IDs. Route an EVMConnect stream to
one backend, including when it crosses a stateless signer replica. On backend
loss, rebuild filters and replay from the persisted checkpoint. Health checks
verify chain ID/genesis, peer connectivity, synchronization and block freshness.
A process returning HTTP 200 can still be a stale blockchain node.

A chain ID, canonical genesis hash, static-peer/permissioning configuration,
validator public keys and image/plugin versions are controlled deployment artifacts.
All validators and RPC nodes use identical chain definitions.

RPC nodes also require persistent, unique node keys. The baseline stores these
non-validator identity keys in the secrets vault and projects them securely at
startup; they are not transaction accounts or validator credentials. If policy
requires HSM custody for every node identity, include all three RPC nodes in H1.
HSM custody is the selected security requirement, not a universal prerequisite
for starting an ordinary Besu node.

## Persistence and backups

| State | Store | Recovery rule |
|---|---|---|
| Besu ledger/RocksDB | Nine separate zonal Premium SSD LRS PVCs | Healthy nodes retain the chain; failed nodes resync from them |
| Validator private keys | Six distinct HSM keys | Never copy/export plaintext; do not duplicate live validator identity |
| Member account transaction keys | Key Vault Premium EC-HSM | Custom signing adapter; pin key version and Ethereum address |
| Core operations/events/member metadata | `firefly_core` PostgreSQL DB | HA pair, database PITR, separate role |
| FFTM transactions/nonces/checkpoints | `fftm` PostgreSQL DB | Sole writer; durable commit before acknowledging acceptance |
| DX blobs and peer registry | Dedicated Premium_ZRS RWO PVC | One writer; fence old node before reattachment |
| Kubo identity/pins/content | Different Premium_ZRS RWO PVC | One Kubo repo owner; persist pins and protect consortium swarm material |
| TLS credentials/HSM-client credentials | Separate Key Vault secrets/certificates | Workload Identity + CSI/provider, controlled rotation and reload |
| Recovery artifacts | Versioned, protected backups | Restore rehearsal; HA copies are not a backup |

Zonal Besu volumes are deliberate: surviving replicas already retain the ledger.
Do not block chain continuity waiting for a lost-zone disk to attach elsewhere.
ZRS is chosen for non-reconstructible member filesystem state. It does not turn
RWO storage into a multi-writer service or guarantee automatic pod failover.

Use application-consistent backups: PostgreSQL PITR, quiesced DX/Kubo backups or
tested snapshots, protected HSM backup/security-domain procedures, genesis and
configuration in version control. A backup operator should not have ordinary
signing permission. Retention, recovery-key custodians and off-region copies need
an explicit operational decision; no regional DR guarantee is included.

## Dependencies that are not required here

Kafka and Keycloak are excluded. EVMConnect/FFTM persists work in PostgreSQL.
No Redis, MongoDB, SQLite, local FFTM LevelDB, Ethereum consensus-layer client,
Tessera, token connector or DApp runtime is required by this selected baseline.
The Besu private-network consensus is QBFT; FireFly private off-chain exchange is
not a claim of confidential on-chain state.

For multiparty FireFly, deploy and register its version-matched infrastructure
contract and member identity as a controlled bootstrap step. This is middleware
initialization, not a business application deployment.
