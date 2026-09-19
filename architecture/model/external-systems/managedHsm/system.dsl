managedHsm = softwareSystem "Azure Managed HSM" "Protects cryptographic keys and performs authorized cryptographic operations; not a general secret or certificate store." {
    tags "SecurityCatalog"
    url "https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control"
    properties {
        "architecture.id" "managedHsm"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
    !docs ../../../documentation/system
    !adrs ../../../decisions/adr
    !include service.dsl
    !include keys.dsl
}
