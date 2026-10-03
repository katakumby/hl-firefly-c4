azureManagement = softwareSystem "Azure Resource Manager" "External management-plane boundary; applies Azure RBAC to Managed HSM resource administration, not key operations." {
    tags "SecurityCatalog"
    url "https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control"
    properties {
        "architecture.id" "azureManagement"
        "evidence" "External integration boundary"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}
