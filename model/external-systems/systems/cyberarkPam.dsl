group "Privileged access and secrets" {
    cyberarkPam = softwareSystem "CyberArk PAM Self-Hosted" "Controls privileged credentials, password rotation and recorded administrative sessions." {
        tags "SecurityCatalog"
        url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
        properties {
            "architecture.id" "cyberarkPam"
            "evidence" "Documented product capability"
            "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
        }
        !include ../containers/cyberarkPam
    }
}
