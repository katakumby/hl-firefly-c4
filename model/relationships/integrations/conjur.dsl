conjur.synchronizer -> cyberarkPam.vault "Reads configured Vault accounts and changed credential versions" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

conjur.synchronizer.reader -> cyberarkPam.vault "Reads configured Vault accounts and changed credential versions" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

conjur.service -> apps.client "Returns short-lived access token or authorized application secret" "HTTPS / Conjur API response" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

conjur.service.api -> apps.client "Returns short-lived access token or authorized application secret" "HTTPS / Conjur API response" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

conjur -> cyberarkPam "Requests selected Vault accounts and changed credentials through Vault Synchronizer" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
    }
}

conjur -> apps "Returns short-lived token or authorized application secret" "HTTPS / Conjur API response" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}
