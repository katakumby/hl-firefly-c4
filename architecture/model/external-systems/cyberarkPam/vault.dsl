vault = container "Digital Vault" "Protects privileged credentials, Safe permissions and audit/session records." "CyberArk PAM / proprietary service" {
    tags "SecurityCatalog"
    url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
    properties {
        "architecture.id" "cyberarkPam.vault"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
    access = component "Vault access interface" "Logical reference: Accepts authenticated Safe, credential and record operations." "Vault responsibility / proprietary implementation" {
        tags "SecurityCatalog,LogicalReference"
        url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
        properties {
            "architecture.id" "cyberarkPam.vault.access"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
        }
    }
    policy = component "Safe permissions" "Logical reference: Checks access permissions for credentials and records." "Vault responsibility / proprietary implementation" {
        tags "SecurityCatalog,LogicalReference"
        url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
        properties {
            "architecture.id" "cyberarkPam.vault.policy"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
        }
    }
    storage = component "Protected credential storage" "Logical reference: Owns encrypted credential and Safe records inside the Vault boundary." "Vault responsibility / proprietary implementation" {
        tags "SecurityCatalog,LogicalReference"
        url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
        properties {
            "architecture.id" "cyberarkPam.vault.storage"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
        }
    }
    audit = component "Audit and recording storage" "Logical reference: Retains access audit records and uploaded session recordings." "Vault responsibility / proprietary implementation" {
        tags "SecurityCatalog,LogicalReference"
        url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
        properties {
            "architecture.id" "cyberarkPam.vault.audit"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
        }
    }
}
