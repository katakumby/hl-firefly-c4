pvwa = container "Password Vault Web Access" "Provides the web interface and APIs for privileged-account access and administration." "CyberArk PAM / proprietary service" {
    url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
    properties {
        "architecture.id" "cyberarkPam.pvwa"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
    portal = component "Web portal and API" "Logical reference: Accepts account access, session-launch and administration requests." "PVWA responsibility / proprietary implementation" {
        url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
        properties {
            "architecture.id" "cyberarkPam.pvwa.portal"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
        }
    }
    approval = component "Access request workflow" "Logical reference: Evaluates configured request and approval requirements." "PVWA responsibility / proprietary implementation" {
        url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
        properties {
            "architecture.id" "cyberarkPam.pvwa.approval"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
        }
    }
    vaultClient = component "Vault client" "Logical reference: Retrieves permitted account metadata or credentials and submits administration changes." "PVWA responsibility / proprietary implementation" {
        url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
        properties {
            "architecture.id" "cyberarkPam.pvwa.vaultClient"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
        }
    }
    sessions = component "Session launch" "Logical reference: Creates authorized session connection details for the session manager." "PVWA responsibility / proprietary implementation" {
        url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
        properties {
            "architecture.id" "cyberarkPam.pvwa.sessions"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
        }
    }
}
