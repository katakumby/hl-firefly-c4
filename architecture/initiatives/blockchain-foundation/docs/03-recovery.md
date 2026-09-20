# Failure behavior, recovery and acceptance

## Single-zone failure matrix

All rows assume the admitted HSM/key services, surviving network paths and
surviving-zone capacity meet their gates. A drawing alone does not establish this.

| Failure | Besu | Member/API path | Database and disks |
|---|---|---|---|
| AZ1 lost | V3-V6 give quorum 4; R2/R3 remain | Fence old member host; recover member in AZ2/3; two signers/gateways remain | PG AZ2 primary stays; reattach DX/Kubo ZRS disks |
| AZ2 lost | V1/V2/V5/V6 give quorum 4; R1/R3 remain | Member in AZ1 remains; retry database connections and pinned RPC streams | PG AZ3 standby promotes; stable FQDN reconnect |
| AZ3 lost | V1-V4 give quorum 4; R1/R2 remain | Member in AZ1 remains; two signers/gateways remain | PG AZ2 continues after managed standby-loss handling; redundancy degraded |
| One validator crashes | Five remain | No member relocation | Recover unique node/PVC; no validator-set change |
| An RPC backend fails | Consensus unchanged | Re-pin, recreate filters and replay from checkpoint | FFTM durable offsets preserved |
| One stateless signer fails | Consensus unchanged | Use another replica; preserve supplied nonce and request identity | Same authorized transaction key |
| Validator HSM unavailable to all nodes | Block production stops | Reads may work; new finality cannot be promised | Fail closed; no software-key fallback |
| DB fails over | Chain continues independently | Pause/retry member work; replay events after reconnection | Azure-managed promotion and client reconnect |
| Member node partitioned, not proven dead | Chain can continue | Do not create a second active member/nonce writer | Fence old compute before releasing state |

## Member failover sequence

1. Detect lost readiness/heartbeats, remove unhealthy endpoints and stop sending
   new requests there. Preserve request IDs for uncertain outcomes.
2. Elect one recovery controller. Record a recovery operation ID and the exact
   Azure VM/node owning the active member.
3. Stop/deallocate or otherwise terminate that VM through an approved Azure
   mechanism and **confirm completion**. Loss of a heartbeat is insufficient.
   If shutdown cannot be established, stop automatic promotion and alert.
4. Follow the AKS/CSI-supported non-graceful shutdown process. Only after fencing,
   reconcile the old pod/VolumeAttachments, mark the node out of service where
   supported, and detach/reattach the two data disks. Test force-detach procedures
   with the actual Azure Disk CSI/AKS versions.
5. Start one member unit in a surviving AZ using the original member identity,
   existing Core/FFTM databases, existing keys, original DX/Kubo state and
   unchanged infrastructure-contract address. Do not reinitialize it as a new member.
6. Recover durable pending transactions. Inspect on-chain receipt/status and pending
   nonce before resolving ambiguous submissions. Never create a second competing
   nonce allocation path. Rebuild RPC filters and replay from durable checkpoints.
7. Enable readiness only after database, signer, RPC and storage checks pass.
   Resume events with at-least-once semantics and stable event IDs.
8. Reconcile the failed zone after recovery. Clear fencing only after confirming no
   obsolete process can resume. Return replicas and capacity without starting a
   second member or duplicating a validator key.

The [Kubernetes non-graceful shutdown guidance](https://kubernetes.io/docs/concepts/cluster-administration/node-shutdown/#non-graceful-node-shutdown-handling)
requires care before treating a node as out of service. Our Azure-confirmed
fencing procedure and controller are proposed implementation responsibilities,
not built-in FireFly failover behavior. If the platform cannot guarantee timely
fencing, the proposed 10-minute member recovery target must be revised.

## Acceptance tests before declaring HA

| Test | Evidence to retain |
|---|---|
| Interrupt each AZ separately under representative write/event/blob load | Validator counts, block heights, last/next block time, finality and recovery timestamps |
| Fail the active member while transactions are being accepted | No second nonce writer; reconcile acknowledged IDs, receipts and final DB state |
| Partition old member from AKS but leave DB/HSM network access | Old host definitively fenced before new writer starts; no split brain |
| Fail each RPC backend while filters/streams are active | Filters recreated, checkpoints replayed, no silent event gaps |
| Trigger PostgreSQL primary and standby failures separately | Reconnect timing, committed transaction preservation and restored HA status |
| Detach/reattach DX and Kubo ZRS disks after hard node loss | Original identity and pins survive; file integrity and acknowledged payloads verified |
| Lose one signing replica and exercise HSM throttling | Bounded retries, no nonce reallocation, no incorrect duplicate transaction |
| Remove an HSM service node and simulate the target AZ loss | All four surviving validators still sign and complete peer handshakes |
| Restore backups to an isolated environment | Reconcile chain ID/genesis, member identity, DB offsets, private payloads and key references |
| Roll one validator/node pool during normal service | PDB/control procedure preserves five live validators; no maintenance during AZ loss |

Use transaction hashes and event IDs to check replay semantics; do not assert
exactly-once external delivery. For DX/Kubo, measure the actual durability boundary
of an acknowledged upload, including process/file flush behavior, before claiming
RPO zero for blobs. If the selected connector acknowledges before durable writes,
that is a release blocker or a changed RPO requirement.

Measure end-to-end recovery from fault injection to a finalized new transaction
and a delivered/acknowledged event. Infrastructure availability and an AKS API SLA
are not an application SLO. Record worst-case latency, remaining headroom, HSM
latency/rate limits and disk recovery time; do not infer them from replica counts.

## Minimum operational alerts

Alert on fewer than six live validators (degraded) and fewer than four (stopped);
also measure actual consensus participation and block age. Monitor RPC freshness,
HSM latency/errors/throttling, PostgreSQL failover/replication health, connector
pending transaction age, nonce conflicts, event lag, DX retries, disk free space,
Kubo pin/state integrity, certificate expiry and backup age.

Run periodic transaction-plus-event probes using a dedicated test identity and
infrastructure test contract in the qualification environment. Put production
probe behavior under explicit operational ownership. Monitor from outside the
member pod so a stopped member cannot suppress its own alert.
