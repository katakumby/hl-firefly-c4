!element cyberarkPam {
    cpm = container "Central Policy Manager" "Verifies, rotates and reconciles managed target-account passwords." "CyberArk PAM / proprietary service" {
        url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
        properties {
            "architecture.id" "cyberarkPam.cpm"
            "evidence" "Documented product capability"
            "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
        }
        scheduler = component "Password management scheduler" "Logical reference: Selects target accounts requiring verification, change or reconciliation." "CPM responsibility / proprietary implementation" {
            url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
            properties {
                "architecture.id" "cyberarkPam.cpm.scheduler"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
            }
        }
        rotation = component "Password rotation orchestration" "Logical reference: Coordinates target password change and Vault credential update." "CPM responsibility / proprietary implementation" {
            url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
            properties {
                "architecture.id" "cyberarkPam.cpm.rotation"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
            }
        }
        target = component "Target platform connector" "Logical reference: Runs the configured target-specific password verification or change operation." "CPM responsibility / proprietary implementation" {
            url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
            properties {
                "architecture.id" "cyberarkPam.cpm.target"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
            }
        }
        vaultClient = component "Vault credential client" "Logical reference: Reads current credentials and writes successfully changed credentials." "CPM responsibility / proprietary implementation" {
            url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
            properties {
                "architecture.id" "cyberarkPam.cpm.vaultClient"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
            }
        }
    }
}
