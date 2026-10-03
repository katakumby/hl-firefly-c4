# Scope, decisions and quorum

This is a proposed infrastructure baseline for Hyperledger Besu and Hyperledger
FireFly on Azure Kubernetes Service (AKS). It is an architecture and implementation
plan, not deployed infrastructure or a tested availability guarantee.

## Agreed requirement and assumptions

The user selected survival of **any one availability-zone outage**, in **one Azure
region**, for **one FireFly member**, with a repeatable pattern for additional
members. Kafka, Keycloak, DApps, business contracts and application deployments are
outside this work. Region-wide disaster recovery is deferred.

Assume a private permissioned EVM network using Besu QBFT, ordinary secp256k1 keys,
and a trusted operator running this initial member. A whole AZ failure means
omission/unavailability, not compromise of every key in that zone. Independent
consortium governance and Byzantine trust domains require a separate allocation
of validators across operators. Three AZs do not create three independent owners.

No numeric application SLA or outage-time limit has been agreed. Proposed
engineering targets are block production recovery within 60 seconds and member
API recovery within 10 minutes, measured under representative load. These are
acceptance-test targets, not vendor promises; change them after the first drills.
RPO zero applies to finalized ledger data and acknowledged, durably committed
member state in the modeled AZ failure. It does not cover an unacknowledged HTTP
request, a memory-only queue, a transaction only in a mempool, or regional loss.

## Besu consensus choice

Use six validators, two in each AZ, with distinct node keys and separate hosts.
Use a current, qualified Besu QBFT implementation with quorum
`q = ceil(2N / 3)`. Verify the selected build/genesis behavior in the test network.
The [Besu QBFT documentation](https://docs.besu-eth.org/private-networks/how-to/configure/consensus/qbft)
describes its voting threshold and the loss-of-validator liveness constraint.

| Validator count | Balanced AZ placement | Required quorum | Survivors after largest AZ loss | Result |
|---|---|---:|---:|---|
| 4 | 2 / 1 / 1 | 3 | 2 | Fails |
| 5 | 2 / 2 / 1 | 4 | 3 | Fails |
| **6** | **2 / 2 / 2** | **4** | **4** | **Selected: meets single-AZ omission target** |
| 7 | 3 / 2 / 2 | 5 | 4 | Fails |
| 9 | 3 / 3 / 3 | 6 | 6 | Works, with no extra post-AZ margin |

This is our quorum calculation, not a general claim that six validators tolerate
two Byzantine faults. With six and quorum four, the conservative Byzantine bound
is one faulty validator; two unavailable validators is a different failure case.
After an AZ outage every surviving validator must participate. A further failed,
partitioned, stalled or refusing validator stops progress. Pause planned
maintenance until the failed AZ is restored.

Adding validators only within the same three equally loaded zones cannot create
headroom for **any** AZ loss plus another failed validator: the largest zone holds
at least `ceil(N/3)`, leaving at most `floor(2N/3)`. An extra independent failure
domain or a different requirement would be needed.

Deploy three additional non-validator full nodes, one per AZ, for JSON-RPC and
event access. They do not count toward quorum. Validators expose P2P and restricted
operations endpoints only; member traffic goes through the RPC nodes.

## FireFly availability choice

Select the complete multiparty foundation: Core, EVMConnect with embedded FireFly
Transaction Manager (FFTM), HTTPS Data Exchange (DX), and IPFS Kubo. DX and shared
content storage support FireFly infrastructure messaging, independent of future
DApps. If the member is later explicitly restricted to gateway-only use, DX,
Kubo and the FireFly multiparty contract can be omitted together with that feature.

The baseline intentionally uses **one active recovery unit** containing these four
product containers, with capacity reserved in both other AZs. Separate processes
share a Kubernetes pod lifecycle; Core uses PostgreSQL, FFTM uses its own logical
PostgreSQL database, and DX/Kubo each have their own volume. A singleton StatefulSet
preserves identity. Each container keeps its own probes and resource requests;
readiness of the member API waits for the whole required dependency path.

This is an engineering choice to avoid assuming that all plugins coordinate
multiple active writers. It costs a bounded interruption while the member is
recovered. It is not a statement that every version or configuration of Core is
incapable of horizontal scaling. Product-level active-active can be added only
after proving namespace ownership, connector ownership and event delivery for
the selected releases.

The [FireFly plugin architecture](https://github.com/hyperledger-firefly/firefly/blob/main/doc-site/docs/architecture/plugin_architecture.md)
allows different HA models for different connectors. The
[FFTM source documentation](https://github.com/hyperledger-firefly/transaction-manager)
describes persisted nonces and at-least-once event delivery. Therefore this design
keeps one nonce owner per signing address and expects replay with stable IDs.

Three stateless Ethereum signing gateway replicas run across the AZs. These are
**custom infrastructure adapters**, not a claim that stock FireFly Signer supports
Azure HSM keys. They preserve the nonce supplied by FFTM, sign, validate and forward
raw transactions; they never introduce a second nonce allocator.

## Azure placement and security choices

Use one private **AKS Standard** cluster, with Standard tier availability guarantees,
in a region supporting all selected SKUs. Explicit zonal ledger pools, fixed
validator identity placement, controlled upgrades and custom HSM client qualification
justify Standard rather than the Automatic SKU for this proposal.

Use Azure CNI Overlay with Cilium, private AKS API access, OIDC/Workload Identity,
network policies and separate system/ledger/middleware pools. Select nonoverlapping
VNet, pod and service ranges during detailed network design. VNet and subnets span
zones; the AZ boxes show compute placement, not separate zonal subnets.

Use PostgreSQL Flexible Server with **zone-redundant HA**, primary in AZ2 and
synchronous standby in AZ3, General Purpose or Memory Optimized tier. Both member
databases can start on this pair with distinct roles and quotas. Do not substitute
same-zone HA or draw three active writers.

Use Azure Key Vault Premium for transaction EC-HSM keys and a separate secrets/
certificate vault, with private endpoints. Entra ID is present solely for Azure
administration and workload identity; Keycloak is not required.

Validator HSM service selection is gate H1. The current Azure Cloud HSM offering is
a candidate for PKCS#11; its three-node service description does **not** establish
three-zone placement. No unconditional end-to-end HA claim is made until H1 is
closed. See the [evidence and delivery plan](04-evidence-and-plan.md).

## Repeating the member pattern

A new member receives its own Core identity, namespace configuration, databases,
DX certificate/endpoint, Kubo identity and repository, transaction keys and signing
policy. Never clone one live member's writable state or signing identity into a
second independent member.

Prefer a separate AKS cluster/subscription for an independent consortium operator.
It can connect to the same chain through explicitly allowed P2P and RPC paths.
Adding a member does not automatically add validators; validator admission remains
a governed on-chain change, followed by recalculation of the zone distribution.
