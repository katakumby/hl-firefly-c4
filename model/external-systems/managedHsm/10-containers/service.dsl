!element managedHsm {
    service = container "Managed HSM data-plane service" "Logical managed-service boundary for key operations and local role assignments; physical HSM topology is excluded." "Azure Managed HSM / HTTPS API" {
        url "https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control"
        properties {
            "architecture.id" "managedHsm.service"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
        }
        api = component "Data-plane API" "Logical reference: Accepts authenticated key-management and cryptographic requests." "Managed service responsibility / implementation undisclosed" {
            url "https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control"
            properties {
                "architecture.id" "managedHsm.service.api"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
            }
        }
        authentication = component "Entra token validation" "Logical reference: Validates token signature, issuer and resource audience using trusted metadata." "Managed service responsibility / implementation undisclosed" {
            url "https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control"
            properties {
                "architecture.id" "managedHsm.service.authentication"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
            }
        }
        authorization = component "Local RBAC authorization" "Logical reference: Checks Managed HSM local roles and key scope separately from Azure resource-management RBAC." "Managed service responsibility / implementation undisclosed" {
            url "https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control"
            properties {
                "architecture.id" "managedHsm.service.authorization"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
            }
        }
        lifecycle = component "Key lifecycle" "Logical reference: Creates and versions keys and manages permitted key operations and role assignments." "Managed service responsibility / implementation undisclosed" {
            url "https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control"
            properties {
                "architecture.id" "managedHsm.service.lifecycle"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
            }
        }
        crypto = component "Cryptographic operations" "Logical reference: Performs sign, verify, encrypt, decrypt, wrap and unwrap operations supported by the selected key." "Managed service responsibility / implementation undisclosed" {
            url "https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control"
            properties {
                "architecture.id" "managedHsm.service.crypto"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
            }
        }
        audit = component "Operation auditing" "Logical reference: Records principal, operation, key identifier and outcome without secret key material." "Managed service responsibility / implementation undisclosed" {
            url "https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control"
            properties {
                "architecture.id" "managedHsm.service.audit"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
            }
        }
    }
}
