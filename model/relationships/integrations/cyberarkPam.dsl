cyberarkPam.cpm -> managedTarget "Verifies or changes the privileged target password" "SSH / target-specific password commands" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.cpm.target -> managedTarget "Verifies or changes the privileged target password" "SSH / target-specific password commands" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.psm -> managedTarget "Opens privileged SSH session and relays administrator commands" "SSH" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.psm.target -> managedTarget "Opens privileged SSH session and relays administrator commands" "SSH" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.vault -> conjur.synchronizer "Returns selected account metadata and credentials" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
    }
}

cyberarkPam.vault -> conjur.synchronizer.reader "Returns selected account metadata and credentials" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
    }
}

cyberarkPam.psm -> operator "Returns brokered session output and completion status" "PSM-supported session client / encrypted connection" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

cyberarkPam.psm.broker -> operator "Returns brokered session output and completion status" "PSM-supported session client / encrypted connection" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

cyberarkPam -> managedTarget "Rotates target credentials and brokers recorded privileged sessions" "SSH / target-specific password commands" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam -> operator "Returns brokered session output and completion status" "Encrypted session client" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

cyberarkPam -> conjur "Supplies selected Vault credentials through Vault Synchronizer" "CyberArk Vault protocol + HTTPS / Conjur API" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
    }
}
