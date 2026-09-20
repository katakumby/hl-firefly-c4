// New infrastructure integrations only; product instances reuse the shared reference model.
foundation = softwareSystem "Blockchain infrastructure services" "Proposed routing, key integration and recovery controls for the Besu and FireFly foundation." {
    tags "Proposed"
    properties {
        "architecture.id" "blockchain_foundation"
        "architecture.status" "proposed"
        "evidence" "Proposed architecture"
        "structurizr.inspection.model.element.noview" "info"
    }
    signer = container "Ethereum HSM signing gateway" "Custom integration: signs supplied nonces with member transaction keys, normalizes signatures and forwards raw transactions. Does not allocate nonces." "Ethereum JSON-RPC / Azure Key Vault Premium REST" {
        tags "Proposed,FoundationIntegration"
        properties {
            "architecture.id" "blockchain_foundation.signer"
            "architecture.status" "proposed"
            "evidence" "Proposed architecture; implementation and interoperability tests required"
        }
    }
    recovery = container "Fenced recovery controller" "Proposed automation: confirms old VM termination before replacing singleton member workers or reusing a validator identity." "Kubernetes API / Azure Compute API / Workload Identity" {
        tags "Proposed,FoundationIntegration"
        properties {
            "architecture.id" "blockchain_foundation.recovery"
            "architecture.status" "proposed"
            "evidence" "Proposed architecture; implementation and failure drills required"
        }
    }
}
firefly.evm -> foundation.signer "Sends nonce-assigned transactions and pinned RPC sessions" "JSON-RPC / mTLS ClusterIP" "FoundationSigningFlow"
foundation -> firefly "Provides transaction signing and fenced member recovery" "Private infrastructure services"
foundation -> besu "Submits signed transactions through healthy RPC nodes" "Ethereum JSON-RPC"
foundation.recovery -> firefly.core "Restarts one member only after old-host fencing" "Kubernetes / Azure Compute APIs" "FoundationRecoveryFlow"
// This initiative intentionally shows deployment instances, not additional logical application views.
!elements element.parent==foundation {
    properties {
        "structurizr.inspection.model.element.noview" "info"
    }
}
