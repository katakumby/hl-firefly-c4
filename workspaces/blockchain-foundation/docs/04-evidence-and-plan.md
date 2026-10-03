# Qualification gates, implementation plan and evidence

Sources were reviewed on **2026-09-20**. Release and regional availability can
change. This proposal deliberately distinguishes documented product capabilities
from architecture choices and integrations that still require implementation.

## Admission gates

| Gate | Required result | Current status |
|---|---|---|
| H1: validator HSM | Supported Azure offering, AZ-failure isolation, secp256k1 signing and ECDH, compatible Besu security module, acceptable latency | Open; Azure Cloud HSM is a candidate |
| H2: transaction signing | Working custom Ethereum gateway to Key Vault Premium EC-HSM keys; interoperability, recovery parity and replay tests | Proposed, not implemented |
| F1: member recovery | Azure-confirmed old-host fencing, one writer, tested ZRS recovery and bounded failover time | Proposed, not implemented |
| R1: regional admission | AKS, PG zone-redundant HA, ZRS disks, Key Vault, private endpoints, ACR and HSM availability/quota all verified together | Region not selected |
| V1: release admission | Pin Besu/plugin, FireFly, EVMConnect/FFTM, DX, Kubo, PostgreSQL, AKS/CSI and proxy versions/images | Versions not yet qualified |
| S1: SLO acceptance | Confirm interruption/RPO targets, capacity and fault-test evidence for all three AZs | Provisional engineering targets |

These are implementation gates, not permission requests. They prevent an attractive
diagram from concealing an unresolved single point of failure.

### H1: why Managed HSM is not the validator answer by default

Besu's validator/node key is used for both consensus signing and P2P cryptography.
The [Besu HSM plugin](https://github.com/besu-eth/besu-hsm-plugin) provides PKCS#11
integration and describes an ECDH requirement. Merely supporting ECDSA signatures
does not prove compatibility. Qualify the exact JDK/provider, digest behavior,
certificate/object lookup, derived-secret handling, session recovery and reconnect
behavior. Generate private keys inside the HSM; any exported derived shared secret
is distinct from exporting a node private key.

Microsoft's [Managed HSM reliability guidance](https://learn.microsoft.com/en-us/azure/reliability/reliability-managed-hsm)
describes rack distribution within a datacenter, not guaranteed AZ deployment.
Its [key operations](https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details)
are not proof of a compatible PKCS#11/ECDH node-key interface. Therefore a lone
Managed HSM pool is not silently substituted for this requirement.

[Azure Cloud HSM](https://learn.microsoft.com/en-us/azure/cloud-hsm/overview)
offers PKCS#11 and a three-node service with managed synchronization. The reviewed
overview and [FAQ](https://learn.microsoft.com/en-us/azure/cloud-hsm/faq) do not
establish the required AZ placement or the exact Besu/provider combination.
Obtain documented service/vendor confirmation and prove the integration before
admitting it. A three-node service must not be drawn as one node in each AZ without
evidence.

[Azure Dedicated HSM](https://learn.microsoft.com/en-us/azure/dedicated-hsm/overview)
is retiring on July 31, 2028 and accepts no new customers, so it is not the greenfield
default. If no available single-region Azure HSM offering passes H1, the requirement
cannot honestly be met with the candidate stack. Select a supported HSM deployment
with demonstrable AZ isolation, or explicitly revise scope (for example key-service
multi-region resilience). Do not weaken key protection or claim automatic failover
as a workaround.

### H2: transaction keys

Use Key Vault Premium EC-HSM P-256K transaction keys in a region covered by
[Key Vault AZ reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-key-vault).
The [Key Vault key types](https://learn.microsoft.com/en-us/azure/key-vault/keys/about-keys)
and API capabilities must be checked for the selected SKU. Key Vault is a different
service from Managed HSM and Cloud HSM.

The custom signer must preserve the FFTM-supplied nonce, chain ID, gas and payload;
encode the selected Ethereum transaction type; compute the correct Keccak-256
digest; invoke the raw digest-signing path without an extra SHA-256 hash; normalize
low-s; determine recovery parity; verify the recovered address; then send the
signed transaction. Require vectors for legacy EIP-155 and EIP-1559 typed
transactions used by the selected chain. Allow only designated keys and RPC methods.

Key version rotation changes the Ethereum address unless the same key is retained.
Do not blindly follow a latest-version URI. Govern address migration and
permissioning. Separate validator keys, member transaction accounts and DX/TLS
certificates. HSM credential and administrative recovery operations use distinct
roles from ordinary signing.

## Delivery sequence

1. **Approve the architecture inputs:** region, private network addressing,
   ownership, throughput/latency, retention and exact recovery objectives. Resolve
   H1 before committing to a product-specific production bill of materials.
2. **Qualify key integrations:** build an isolated Besu/HSM peer-handshake and
   consensus test; implement and test the transaction gateway; record supported
   provider/library/image versions and key-creation/recovery procedures.
3. **Build the Azure foundation:** infrastructure as code for VNet, private DNS,
   private AKS, zonal pools, ingress/egress, workload identities, vaults, registry,
   database HA, disks, monitoring and recovery storage. Inspect actual PG zones;
   reject a deployment that silently falls back to same-zone HA.
4. **Bootstrap the chain:** govern genesis and six HSM public keys; deploy unique
   validator/RPC identities, static peers and permissioning; verify chain identity,
   quorum and block production before connecting the member.
5. **Bootstrap one member:** isolated DBs/roles, controlled migrations, persistent
   DX/Kubo state, member identity and FireFly infrastructure contract; wire the
   connector to the signing gateway and session-aware RPC path.
6. **Implement recovery:** leader coordination, least-privilege Azure VM fencing,
   CSI handling, replay/nonce reconciliation, readiness gating and operational
   escalation. Reserve capacity and pre-pull images across all AZs.
7. **Run acceptance:** all tests in the recovery document, load and throttling
   tests, backup restoration and a controlled upgrade. Publish measured SLO/RPO
   results and close the gates before production admission.

This change supplies the DSL diagrams and this plan. It does not contain Terraform,
Bicep, Kubernetes rollout manifests, custom signer/controller code or a claim that
those integrations have been tested.

## Primary-source register

| Source | Supports | Design implication |
|---|---|---|
| [Besu QBFT](https://docs.besu-eth.org/private-networks/how-to/configure/consensus/qbft) | Consensus threshold; validator node keys; security module | Compute 6-node 2/2/2 placement and test selected build |
| [Besu HSM plugin](https://github.com/besu-eth/besu-hsm-plugin) | PKCS#11/JCE and ECDH constraints | HSM/provider qualification is mandatory |
| [FireFly plugin architecture](https://github.com/hyperledger-firefly/firefly/blob/main/doc-site/docs/architecture/plugin_architecture.md) | Different runtime/connector HA models | Do not set every connector to three active writers |
| [EVMConnect](https://github.com/hyperledger-firefly/evmconnect) | EVM JSON-RPC requirements, including filter methods | Backend affinity and filter recreation |
| [FFTM](https://github.com/hyperledger-firefly/transaction-manager) | PostgreSQL persistence, nonce ownership and event replay | One connector writer per account; durable restart |
| [AKS availability zones](https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure) | Zone-aware cluster/pool deployment | Explicit zonal capacity and placement |
| [AKS Workload Identity](https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview) | OIDC federation to Azure identity | Scoped credentials rather than embedded client secrets |
| [PostgreSQL reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-database-postgresql) | Primary/standby across two zones; synchronous HA | Managed HA pair, separate logical DBs, client retries |
| [Managed disk redundancy](https://learn.microsoft.com/en-us/azure/virtual-machines/disks-redundancy) | ZRS replication; attach/force-detach constraints | Member state on Premium_ZRS, tested fencing |
| [Kubernetes node shutdown](https://kubernetes.io/docs/concepts/cluster-administration/node-shutdown/#non-graceful-node-shutdown-handling) | Non-graceful node recovery precautions | Heartbeat loss is not proof of shutdown |
| [Managed HSM reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-managed-hsm) | Rack-level redundancy; multi-region option | Do not assert single-pool AZ isolation |
| [Cloud HSM overview](https://learn.microsoft.com/en-us/azure/cloud-hsm/overview) | PKCS#11, three service nodes | Candidate only; verify AZ and provider compatibility |
| [Dedicated HSM lifecycle](https://learn.microsoft.com/en-us/azure/dedicated-hsm/overview) | Retirement and closed new onboarding | Excluded as greenfield default |
| [Key Vault reliability](https://learn.microsoft.com/en-us/azure/reliability/reliability-key-vault) | Vault zone resilience in supported regions | Transaction-key service, separate from validator HSM |

Links to product main branches describe capabilities at review time, not a release
lock. The shared catalog retains its own pinned implementation evidence. V1 must
produce a tested compatibility manifest before deployment; no unspecified latest
image is authorized for production by this document.
