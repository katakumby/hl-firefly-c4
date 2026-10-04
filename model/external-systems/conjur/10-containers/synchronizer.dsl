!element conjur {
    synchronizer = container "Vault Synchronizer" "Reads selected PAM Vault accounts and synchronizes their secret values into Conjur Enterprise." "CyberArk Vault Synchronizer" {
        url "https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm"
        properties {
            "architecture.id" "conjur.synchronizer"
            "evidence" "Documented product capability"
            "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
        }
        reader = component "Vault account reader" "Logical reference: Reads selected Vault accounts and changed credentials." "Synchronizer responsibility / proprietary implementation" {
            url "https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm"
            properties {
                "architecture.id" "conjur.synchronizer.reader"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
            }
        }
        mapping = component "Account-to-variable mapping" "Logical reference: Maps selected Vault account metadata to Conjur variable identifiers." "Synchronizer responsibility / proprietary implementation" {
            url "https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm"
            properties {
                "architecture.id" "conjur.synchronizer.mapping"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
            }
        }
        writer = component "Conjur update client" "Logical reference: Authenticates to Conjur and writes synchronized secret values." "Synchronizer responsibility / proprietary implementation" {
            url "https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm"
            properties {
                "architecture.id" "conjur.synchronizer.writer"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
            }
        }
    }
}
