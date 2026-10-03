azureManagement -> managedHsm "Applies resource-management changes authorized by Azure RBAC; does not grant key access" "Azure management-plane interface" "Dataflow,SecurityCatalog,SecurityAdminFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

azureManagement -> managedHsm.service "Applies resource-management changes; key access still requires local RBAC" "Azure management-plane interface (logical)" "Dataflow,SecurityCatalog,SecurityAdminFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}
