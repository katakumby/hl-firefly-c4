cyberarkPam = softwareSystem "CyberArk PAM Self-Hosted" "Controls privileged credentials, password rotation and recorded administrative sessions." {
    tags "SecurityCatalog"
    url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
    properties {
        "architecture.id" "cyberarkPam"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
    !docs ../../../documentation/system
    !adrs ../../../decisions/adr
    !include vault.dsl
    !include pvwa.dsl
    !include cpm.dsl
    !include psm.dsl
}
