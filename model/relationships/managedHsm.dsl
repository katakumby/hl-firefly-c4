managedHsm.service.api -> managedHsm.service.authentication "Passes bearer token and requested resource audience" "In-process logical interface" "Dataflow,SecurityCatalog,KeyFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

managedHsm.service.authentication -> managedHsm.service.authorization "Passes validated caller identity and requested operation" "In-process logical interface" "Dataflow,SecurityCatalog,KeyFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

managedHsm.service.authorization -> managedHsm.service.lifecycle "Authorizes key lifecycle or local role-management command" "In-process logical interface" "Dataflow,SecurityCatalog,KeyFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

managedHsm.service.authorization -> managedHsm.service.crypto "Authorizes cryptographic operation on the selected key version" "In-process logical interface" "Dataflow,SecurityCatalog,KeyFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

managedHsm.service.crypto -> managedHsm.service.api "Returns signature, ciphertext or wrapped-key result" "In-process logical interface" "Dataflow,SecurityCatalog,KeyFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

managedHsm.service.lifecycle -> managedHsm.service.api "Returns key identifier, public metadata and operation outcome" "In-process logical interface" "Dataflow,SecurityCatalog,KeyFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

managedHsm.service.api -> managedHsm.service.audit "Records caller, key identifier, operation and outcome" "In-process logical interface" "Dataflow,SecurityCatalog,KeyFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

managedHsm.service -> managedHsm.keys "Creates or updates protected keys, versions and local role records" "Protected managed-service storage interface" "Dataflow,SecurityCatalog,KeyFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
    }
}

managedHsm.service.lifecycle -> managedHsm.keys "Creates or updates protected keys, versions and local role records" "Protected managed-service storage interface" "Dataflow,SecurityCatalog,KeyFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
    }
}

managedHsm.service.crypto -> managedHsm.keys "Invokes cryptographic operation using protected key handle; no private-key export" "Protected cryptographic interface (logical)" "Dataflow,SecurityCatalog,KeyFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
    }
}

managedHsm.keys -> managedHsm.service.crypto "Returns cryptographic result without private key material" "Protected cryptographic interface (logical)" "Dataflow,SecurityCatalog,KeyFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

managedHsm.service -> managedHsm.keys "Invokes signing or key-wrapping operation through a protected key handle" "Protected cryptographic interface (logical)" "Dataflow,SecurityCatalog,KeyFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
    }
}

managedHsm.keys -> managedHsm.service "Returns cryptographic result without private key material" "Protected cryptographic interface (logical)" "Dataflow,SecurityCatalog,KeyFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}
