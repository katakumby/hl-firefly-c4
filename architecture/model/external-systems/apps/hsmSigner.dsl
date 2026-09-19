hsmSigner = container "Proposed HSM signing adapter" "Optional custom Ethereum RPC signing proxy; requires implementation and compatibility testing. Not built into FireFly Signer." "Reference adapter / Ethereum JSON-RPC + Azure REST" {
    tags "SecurityCatalog,Optional,ReferenceIntegration"
    url "https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details"
    properties {
        "architecture.id" "apps.hsmSigner"
        "evidence" "Proposed reference integration"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
    }
    transactions = component "Transaction preparation" "Proposed reference: Prepares chain-aware Ethereum signing payloads and Keccak-256 digests; preserves supplied transaction fields." "Custom integration responsibility / implementation required" {
        tags "SecurityCatalog,Optional,ReferenceIntegration"
        url "https://ethereum.org/en/developers/docs/transactions/"
        properties {
            "architecture.id" "apps.hsmSigner.transactions"
            "evidence" "Proposed reference integration"
            "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
        }
    }
    hsm = component "HSM access client" "Proposed reference: Acquires an Entra application token and requests signing with the selected non-exportable secp256k1 key." "Custom integration responsibility / implementation required" {
        tags "SecurityCatalog,Optional,ReferenceIntegration"
        url "https://ethereum.org/en/developers/docs/transactions/"
        properties {
            "architecture.id" "apps.hsmSigner.hsm"
            "evidence" "Proposed reference integration"
            "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
        }
    }
    signature = component "Signature conversion and validation" "Proposed reference: Normalizes low-s, determines recovery parity and verifies the Ethereum sender before transaction encoding." "Custom integration responsibility / implementation required" {
        tags "SecurityCatalog,Optional,ReferenceIntegration"
        url "https://ethereum.org/en/developers/docs/transactions/"
        properties {
            "architecture.id" "apps.hsmSigner.signature"
            "evidence" "Proposed reference integration"
            "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
        }
    }
    rpc = component "RPC submission" "Proposed reference: Submits the encoded signed transaction to Besu and returns the transaction hash or RPC error." "Custom integration responsibility / implementation required" {
        tags "SecurityCatalog,Optional,ReferenceIntegration"
        url "https://ethereum.org/en/developers/docs/transactions/"
        properties {
            "architecture.id" "apps.hsmSigner.rpc"
            "evidence" "Proposed reference integration"
            "architecture.sources" "[\"https://ethereum.org/en/developers/docs/transactions/\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/about-keys-details\"]"
        }
    }
}
