group "Privileged access and secrets" {
    conjur = softwareSystem "CyberArk Conjur Enterprise" "Enterprise workload secret access; documented as Secrets Manager Self-Hosted. OSS is not the selected variant." {
        url "https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm"
        properties {
            "architecture.id" "conjur"
            "evidence" "Documented product capability"
            "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
        }
    }
}
