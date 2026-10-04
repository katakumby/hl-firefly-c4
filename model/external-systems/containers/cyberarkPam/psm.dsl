psm = container "Privileged Session Manager" "Brokers privileged target sessions and records session activity." "CyberArk PAM / proprietary service" {
    url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
    properties {
        "architecture.id" "cyberarkPam.psm"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
    broker = component "Session broker" "Logical reference: Accepts authorized session requests and retrieves target credentials." "PSM responsibility / proprietary implementation" {
        url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
        properties {
            "architecture.id" "cyberarkPam.psm.broker"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
        }
    }
    target = component "Target session connector" "Logical reference: Establishes the example SSH session using the vaulted privileged account." "PSM responsibility / proprietary implementation" {
        url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
        properties {
            "architecture.id" "cyberarkPam.psm.target"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
        }
    }
    recorder = component "Session recorder" "Logical reference: Captures session activity and uploads recordings to the Vault." "PSM responsibility / proprietary implementation" {
        url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
        properties {
            "architecture.id" "cyberarkPam.psm.recorder"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
        }
    }
}
