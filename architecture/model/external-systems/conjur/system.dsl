conjur = softwareSystem "CyberArk Conjur Enterprise" "Enterprise workload secret access; documented as Secrets Manager Self-Hosted. OSS is not the selected variant." {
    tags "SecurityCatalog"
    url "https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm"
    properties {
        "architecture.id" "conjur"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
    !docs ../../../documentation/system
    !adrs ../../../decisions/adr
    !include service.dsl
    !include store.dsl
    !include synchronizer.dsl
}
