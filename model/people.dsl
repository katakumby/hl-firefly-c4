developer = person "Application developer" "Builds and tests member business integrations." {
    url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
    properties {
        "architecture.id" "developer"
        "evidence" "Reference choice"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

operator = person "Consortium operator" "Operates member namespaces, recovery and the Besu network." {
    url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
    properties {
        "architecture.id" "operator"
        "evidence" "Reference choice"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

business = person "Business user" "Submits consortium business actions through a member application." {
    url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
    properties {
        "architecture.id" "business"
        "evidence" "Reference choice"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

securityAdmin = person "Security administrator" "Configures identity, privileged access, secret policies and key permissions in these reference examples." {
    url "https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm"
    properties {
        "architecture.id" "securityAdmin"
        "evidence" "Reference choice"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}
