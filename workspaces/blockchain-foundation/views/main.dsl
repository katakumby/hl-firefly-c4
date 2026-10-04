deployment * "AZ1 outage - recovered" "blockchain-foundation-05-az-outage" {
    title "05 - Deployment after AZ1 loss - surviving quorum and recovered member"
    description "Four validators keep quorum; the existing member resumes in AZ2 after fencing. This is a recovery snapshot, conditional on HSM and recovery qualification."
    include *
    autoLayout tb 100 100
}
deployment * "Production - three AZ" "blockchain-foundation-01-platform" {
    title "01 - Azure platform deployment - three availability zones"
    description "Pool capacity and shared dependencies. Summary boxes represent the same resources detailed in subsequent views. HSM gate H1 prevents an unconditional HA claim."
    include production.region.network.control
    include production.region.network.ingress
    include production.region.network.dns
    include production.region.aks.az1.capacity
    include production.region.aks.az2.capacity
    include production.region.aks.az3.capacity
    include production.region.data.pgsummary
    include production.region.data.backup
    include production.region.security.validatorhsm
    include production.region.security.vault
    include production.region.operations.registry
    include production.region.operations.monitor
    autoLayout tb 100 100
}
deployment * "Production - three AZ" "blockchain-foundation-02-besu" {
    title "02 - Besu deployment - six validators and three RPC nodes"
    description "Two validators per AZ; quorum 4 of 6. All six validators peer directly; only representative consensus links are drawn. HSM service placement requires qualification."
    include production.region.network.rpc
    include production.region.aks.az1.ledger.v1pod.node
    include production.region.aks.az1.ledger.v2pod.node
    include production.region.aks.az1.ledger.rpcpod.node
    include production.region.aks.az2.ledger.v3pod.node
    include production.region.aks.az2.ledger.v4pod.node
    include production.region.aks.az2.ledger.rpcpod.node
    include production.region.aks.az3.ledger.v5pod.node
    include production.region.aks.az3.ledger.v6pod.node
    include production.region.aks.az3.ledger.rpcpod.node
    include production.region.security.validatorhsm
    // Deliberately show representative direct peer links; all nine nodes participate in the private P2P network.
    exclude *->*
    include production.region.network.rpc->production.region.aks.az1.ledger.rpcpod.node
    include production.region.aks.az1.ledger.v1pod.node->production.region.security.validatorhsm
    include production.region.aks.az1.ledger.rpcpod.node->production.region.aks.az1.ledger.v1pod.node
    include production.region.aks.az1.ledger.v2pod.node->production.region.security.validatorhsm
    include production.region.aks.az1.ledger.rpcpod.node->production.region.aks.az1.ledger.v2pod.node
    include production.region.network.rpc->production.region.aks.az2.ledger.rpcpod.node
    include production.region.aks.az2.ledger.v3pod.node->production.region.security.validatorhsm
    include production.region.aks.az2.ledger.rpcpod.node->production.region.aks.az2.ledger.v3pod.node
    include production.region.aks.az2.ledger.v4pod.node->production.region.security.validatorhsm
    include production.region.aks.az2.ledger.rpcpod.node->production.region.aks.az2.ledger.v4pod.node
    include production.region.network.rpc->production.region.aks.az3.ledger.rpcpod.node
    include production.region.aks.az3.ledger.v5pod.node->production.region.security.validatorhsm
    include production.region.aks.az3.ledger.rpcpod.node->production.region.aks.az3.ledger.v5pod.node
    include production.region.aks.az3.ledger.v6pod.node->production.region.security.validatorhsm
    include production.region.aks.az3.ledger.rpcpod.node->production.region.aks.az3.ledger.v6pod.node
    include production.region.aks.az1.ledger.v1pod.node->production.region.aks.az1.ledger.v2pod.node
    include production.region.aks.az2.ledger.v3pod.node->production.region.aks.az2.ledger.v4pod.node
    include production.region.aks.az3.ledger.v5pod.node->production.region.aks.az3.ledger.v6pod.node
    include production.region.aks.az1.ledger.v1pod.node->production.region.aks.az2.ledger.v3pod.node
    include production.region.aks.az2.ledger.v3pod.node->production.region.aks.az3.ledger.v5pod.node
    include production.region.aks.az1.ledger.v1pod.node->production.region.aks.az3.ledger.v5pod.node
    autoLayout tb 100 100
}
deployment * "Production - three AZ" "blockchain-foundation-03-firefly" {
    title "03 - FireFly deployment - one member with fenced cross-zone recovery"
    description "One active member; three controller candidates with AZ2 illustrating the elected leader. The signing service summarizes three replicas detailed in view 04. Slots labelled recovery capacity are not running replicas."
    include production.region.network.ingress
    include production.region.network.signing
    include production.region.network.rpc
    include production.region.aks.az1.middleware.signerpod.signer
    include production.region.aks.az1.middleware.recoverypod.controller
    include production.region.aks.az1.middleware.member.core
    include production.region.aks.az1.middleware.member.evm
    include production.region.aks.az1.middleware.member.dx
    include production.region.aks.az1.middleware.member.ipfs
    include production.region.aks.az2.middleware.signerpod.signer
    include production.region.aks.az2.middleware.recoverypod.controller
    include production.region.aks.az2.middleware.spare
    include production.region.aks.az3.middleware.signerpod.signer
    include production.region.aks.az3.middleware.recoverypod.controller
    include production.region.aks.az3.middleware.spare
    include production.region.data.pg.core
    include production.region.data.pg.tx
    include production.region.data.zrs.blobs
    include production.region.data.zrs.ipfs
    include production.region.data.standby
    // The transaction signing service preserves the end-to-end path here; view 04 details all three replicas.
    exclude production.region.aks.az1.middleware.signerpod.signer
    exclude production.region.aks.az2.middleware.signerpod.signer
    exclude production.region.aks.az3.middleware.signerpod.signer
    include production.region.data.zrs.blobs production.region.data.zrs.ipfs production.region.security.vault
    // AZ2 illustrates the elected leader; any candidate can take over. Keep all candidates visible.
    exclude production.region.aks.az1.middleware.recoverypod.controller->production.region.aks.az1.middleware.member.core
    exclude production.region.aks.az1.middleware.recoverypod.controller->production.region.aks.az2.middleware.spare
    exclude production.region.aks.az1.middleware.recoverypod.controller->production.region.aks.az3.middleware.spare
    exclude production.region.aks.az2.middleware.recoverypod.controller->production.region.aks.az1.middleware.member.core
    exclude production.region.aks.az2.middleware.recoverypod.controller->production.region.aks.az2.middleware.spare
    exclude production.region.aks.az2.middleware.recoverypod.controller->production.region.aks.az3.middleware.spare
    exclude production.region.aks.az3.middleware.recoverypod.controller->production.region.aks.az1.middleware.member.core
    exclude production.region.aks.az3.middleware.recoverypod.controller->production.region.aks.az2.middleware.spare
    exclude production.region.aks.az3.middleware.recoverypod.controller->production.region.aks.az3.middleware.spare
    include production.region.aks.az2.middleware.recoverypod.controller->production.region.aks.az1.middleware.member.core
    include production.region.aks.az2.middleware.recoverypod.controller->production.region.aks.az2.middleware.spare
    include production.region.aks.az2.middleware.recoverypod.controller->production.region.aks.az3.middleware.spare
    autoLayout tb 100 100
}
deployment * "Production - three AZ" "blockchain-foundation-04-keys" {
    title "04 - Key and signing deployment - separate validator and transaction keys"
    description "V1 represents six independent validator keys. Transaction gateways use Azure Key Vault Premium. Validator HSM compatibility and AZ isolation are unresolved gate H1; custom signing integration is gate H2."
    include production.region.aks.az1.middleware.signerpod.signer
    include production.region.aks.az1.middleware.recoverypod.controller
    include production.region.aks.az1.middleware.member.evm
    include production.region.aks.az2.middleware.signerpod.signer
    include production.region.aks.az2.middleware.recoverypod.controller
    include production.region.aks.az3.middleware.signerpod.signer
    include production.region.aks.az3.middleware.recoverypod.controller
    include production.region.data.backup
    include production.region.security.validatorhsm
    include production.region.security.vault
    include production.region.security.identity
    include production.region.aks.az1.ledger.v1pod.node production.region.network.rpc
    autoLayout tb 100 100
}
