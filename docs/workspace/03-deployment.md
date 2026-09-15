# AKS reference and zone recovery

## Normal placement

One Azure region contains three independent availability zones. The managed AKS control plane is a regional service; its physical replicas are not invented as user-managed pods. System, application and stateful node pools span the three zones. Reserve enough surviving-zone capacity to restart the largest affected member stack.

| Zone | Active member services | PostgreSQL primaries | PostgreSQL standbys | Validators | RPC / discovery |
|---|---|---|---|---|---|
| AZ 1 | A | A | B, C | A1, B1 | RPC1 / bootnode |
| AZ 2 | B | B | A, C | B2, C1 | RPC2 |
| AZ 3 | C | C | A, B | C2, A2 | RPC3 / bootnode |

A member's normal active placement is not a hard zone affinity. Core, EVMConnect, Data Exchange, token connectors and Kubo use a single active instance per member with restart eligibility in the surviving zones. This avoids asserting unsupported shared-state active-active semantics. Each member owns two validator identities in different zones.

The complete diagram shows the steady state. Deployment detail views are the readable inspection surfaces for member dependencies, blockchain nodes and cluster operations. Volume boxes identify their attachment location; **ZRS storage itself is replicated across zones**, not confined to that attachment zone.

## Database and storage

Use three CloudNativePG instances per member, one per zone. Configure quorum synchronous replication with method **any**, number **1**, and dataDurability **required**. Use the primary Service for Core/FFTM connections; let the operator promote the appropriate synchronized candidate and update the Service. Never promote an arbitrary lagging replica.

Use dedicated Premium SSD ZRS CSI volumes for PostgreSQL data, each Besu node ledger, each member's Kubo repository and its Data Exchange blob/peer data. Set WaitForFirstConsumer and retain persistent data through pod replacement. Use ReadWriteOncePod where supported for single-writer volumes; RWO alone does not fence processes on the same node.

Preserve Kubo identity, signer keystores, peer TLS keys and every unique Besu node key. Kubernetes Secret objects must be encrypted at rest, separately scoped and backed up. The reference uses local signing runtimes and projected keystore files; it does not assume remote Azure Key Vault signing compatibility.

## Quorum and failure matrix

Besu's captured BftHelpers implementation computes ceil(2N/3). For six validators, the quorum is four.

| Failed zone | Validators lost | Validators remaining | Quorum | Member recovery | Database recovery |
|---|---|---|---|---|---|
| AZ 1 | A1, B1 | B2, C1, C2, A2 | 4 of 6: sufficient | Recover A in AZ 2 or 3 | Promote A standby; B/C retain primaries |
| AZ 2 | B2, C1 | A1, B1, C2, A2 | 4 of 6: sufficient | Recover B in AZ 1 or 3 | Promote B standby; A/C retain primaries |
| AZ 3 | C2, A2 | A1, B1, B2, C1 | 4 of 6: sufficient | Recover C in AZ 1 or 2 | Promote C standby; A/B retain primaries |

This is crash/zone-outage availability reasoning, not a claim that two Byzantine validators are safe in every six-node failure model. After a zone loss there is no additional unavailable-validator headroom. Suspend validator maintenance until redundancy is restored. Each zone is distinct, but a shared region and cluster remain common failure domains.

## Recovery sequence and limits

1. Detect unavailable nodes, failed readiness, stalled blocks and replication lag; remove unhealthy endpoints.
2. Establish that affected single-writer processes cannot still run. Fence the failed machines before force-deleting pods or detaching volumes.
3. Permit database promotion and update primary endpoints. Safely detach and reattach retained ZRS volumes where needed.
4. Start replacement member services with the original identity and configuration in a healthy zone. Do not run duplicate nonce writers or duplicate validator identities.
5. Resume transactions and listeners from persistent state. Recreate node-local Ethereum filters. Reconnect application subscriptions.
6. Reconcile in-flight private-transfer notifications, test duplicate handling and verify all required CIDs and private blobs remain retrievable.
7. Rebuild failed-zone capacity and restore replicas before resuming normal maintenance.

Kubernetes cannot safely infer that an unreachable node is powered off. Non-graceful shutdown can require fencing and an out-of-service procedure before volume recovery. This reference is therefore **recovery-capable with conditional automation**, not a measured zero-downtime or guaranteed fully automatic failover product. A deployment-specific fencing controller/runbook and failure drills are acceptance prerequisites.

Brief API interruptions are expected. No numeric RTO or blanket zero-data-loss claim is made. Persisted acknowledged database writes benefit from synchronous replication; in-memory notifications and application acknowledgement boundaries require separate testing.

## Networking and operations

Use private RPC Services, local Besu node/account allowlists, restricted metrics endpoints, namespace NetworkPolicies and mTLS peer authentication. Private-network permissioning controls admission; it does not hide common-chain transactions from other admitted nodes. This reference does not use Tessera or Besu private-transaction privacy managers.

Spread ingress, metrics collection and database-operator capacity across zones. Operator replicas use their supported leader-election mechanism; they do not simultaneously promote databases. Three Prometheus collectors provide independent availability, not an invented shared-write TSDB cluster. Provision dashboards so they can restart without a configuration database dependency.

Back up Core/FFTM state, peer metadata, blobs, Kubo pins/content and configuration using an operational backup policy. ZRS and database replication are not backups. Cross-region disaster recovery and an actual backup backend are outside this single-region reference.

