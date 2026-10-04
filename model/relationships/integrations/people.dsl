operator -> firefly.explorer "Inspects member messages, operations and network state" "Browser interaction" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5/src\"]"
    }
}

operator -> firefly.explorer.app "Selects member resources to inspect" "Browser interaction" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5/src\"]"
    }
}

operator -> firefly "Inspects and administers member state" "HTTPS / Explorer + Admin API" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
    }
}

business -> apps.client "Submits business actions" "HTTPS" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

business -> apps "Submits consortium business actions" "HTTPS" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

developer -> tools "Develops and tests integrations" "CLI + HTTPS" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/key_components/tools.md\"]"
    }
}

developer -> tools.cli "Creates local test stacks" "Local process invocation" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/README.md\"]"
    }
}

developer -> tools.sandboxUi "Exercises sample messages and token workflows" "Browser interaction" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/ui/src\"]"
    }
}

developer -> tools.sandboxUi.app "Selects sample messages and token actions" "Browser interaction" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/ui/src\"]"
    }
}

operator -> ops "Monitors availability and coordinates recovery" "HTTPS" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

operator -> ops.grafana "Reviews quorum and recovery measurements" "HTTPS" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

developer -> corda "Customizes the CorDapp and Core binding required by the starter" "Development toolchain" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/README.md\"]"
    }
}

developer -> firefly.cordaconnect "Exercises the starter after application-specific customization" "HTTP REST + WebSocket" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector\"]"
    }
}

developer -> tools.perf "Runs configured performance workloads" "Local process invocation" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/README.md\"]"
    }
}

developer -> tools.eventAudit "Audits recorded blockchain-event ordering" "Local process invocation" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents\"]"
    }
}

developer -> tools.config "Supplies configuration and migration versions" "CLI / file input" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig\"]"
    }
}

developer -> tools.config.commands "Supplies configuration and target version" "CLI / file input" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig/main.go\"]"
    }
}

developer -> tools.cli.commands "Invokes development stack commands" "Local process invocation" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/cmd\"]"
    }
}

developer -> tools.perf.commands "Invokes configured workload scenarios" "Local process invocation" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/cmd\"]"
    }
}

developer -> firefly.cordaconnect.api "Exercises customized starter operations" "HTTP REST / JSON" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/controller\"]"
    }
}

developer -> firefly "Exercises customized Corda starter operations" "HTTP REST / JSON" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
    }
}

business -> keycloak.server "Submits sign-in interaction through the user browser" "HTTPS / browser OIDC" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

business -> entraId.authentication "Submits sign-in interaction through the user browser" "HTTPS / browser OIDC" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

business -> adFs.service "Submits sign-in interaction through the user browser" "HTTPS / browser SAML 2.0" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

operator -> cyberarkPam.pvwa "Requests approved privileged-account access or recorded target session" "HTTPS / PAM web portal" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

operator -> cyberarkPam.pvwa.portal "Requests approved privileged-account access or recorded target session" "HTTPS / PAM web portal" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

operator -> cyberarkPam.psm "Connects authorized session client and submits administrative input" "PSM-supported session client / encrypted connection" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

operator -> cyberarkPam.psm.broker "Connects authorized session client and submits administrative input" "PSM-supported session client / encrypted connection" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

business -> adDs.directory "Requests domain sign-in and service tickets through the domain client" "Kerberos / domain client" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

business -> adDs.directory.kdc "Requests domain sign-in and service tickets through the domain client" "Kerberos / domain client" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

securityAdmin -> keycloak "Configures Keycloak access policy and reviews administrative outcomes" "HTTPS / product administration interface" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

securityAdmin -> managedHsm "Configures Azure Managed HSM access policy and reviews administrative outcomes" "HTTPS / product administration interface" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

securityAdmin -> cyberarkPam "Configures CyberArk PAM Self-Hosted access policy and reviews administrative outcomes" "HTTPS / product administration interface" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

securityAdmin -> conjur "Configures CyberArk Conjur Enterprise access policy and reviews administrative outcomes" "HTTPS / product administration interface" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

securityAdmin -> entraId "Configures Microsoft Entra ID access policy and reviews administrative outcomes" "HTTPS / product administration interface" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

securityAdmin -> adDs "Configures Microsoft Active Directory Domain Services access policy and reviews administrative outcomes" "Protected LDAP / directory administration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

securityAdmin -> adFs "Configures Microsoft Active Directory Federation Services access policy and reviews administrative outcomes" "AD FS administration / PowerShell" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

business -> keycloak "Completes user sign-in through browser-mediated authentication" "HTTPS / user browser" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

business -> entraId "Completes user sign-in through browser-mediated authentication" "HTTPS / user browser" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

business -> adFs "Completes user sign-in through browser-mediated authentication" "HTTPS / user browser" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

business -> adDs "Requests domain sign-in and service tickets through the domain client" "Kerberos" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

operator -> cyberarkPam "Requests approved privileged access and submits session commands" "HTTPS / PAM portal and encrypted session client" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

securityAdmin -> azureManagement "Submits Managed HSM resource administration request" "HTTPS / Azure Resource Manager API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

securityAdmin -> keycloak.server "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

securityAdmin -> keycloak.server.admin "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://www.keycloak.org/docs/latest/server_admin/index.html\"]"
    }
}

securityAdmin -> managedHsm.service "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

securityAdmin -> managedHsm.service.lifecycle "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/azure/key-vault/managed-hsm/access-control\"]"
    }
}

securityAdmin -> cyberarkPam.pvwa "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

securityAdmin -> cyberarkPam.pvwa.portal "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

securityAdmin -> conjur.service "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

securityAdmin -> conjur.service.api "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

securityAdmin -> entraId.directory "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

securityAdmin -> entraId.directory.api "Submits authorized configuration or access-policy changes" "HTTPS / product administration API" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

securityAdmin -> adDs.directory "Submits authorized configuration or access-policy changes" "Protected LDAP / directory administration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

securityAdmin -> adDs.directory.ldap "Submits authorized configuration or access-policy changes" "Protected LDAP / directory administration" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}

securityAdmin -> adFs.service "Submits authorized configuration or access-policy changes" "AD FS administration / PowerShell configuration interface" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}

securityAdmin -> adFs.service.configuration "Submits authorized configuration or access-policy changes" "AD FS administration / PowerShell configuration interface" {
    properties {
        "evidence" "Proposed reference integration; not built-in FireFly functionality"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\",\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\"]"
    }
}
