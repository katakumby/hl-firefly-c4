!element managedHsm {
    keys = container "HSM-protected key storage" "Logical protected store for non-exportable example private keys, key versions and local role data; not a separate database server." "HSM-protected managed storage (logical)" {
        tags "Database"
        url "https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details"
        properties {
            "architecture.id" "managedHsm.keys"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
        }
    }
}
