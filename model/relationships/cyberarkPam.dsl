cyberarkPam.vault.access -> cyberarkPam.vault.policy "Passes caller identity and requested Safe operation" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.vault.policy -> cyberarkPam.vault.storage "Authorizes credential read or write" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.vault.storage -> cyberarkPam.vault.access "Returns permitted credential or metadata response" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.vault.access -> cyberarkPam.vault.audit "Stores access events or uploaded session recordings" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.pvwa.portal -> cyberarkPam.pvwa.approval "Submits requested account and access justification" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.pvwa.approval -> cyberarkPam.pvwa.vaultClient "Passes approved credential or metadata request" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.pvwa.approval -> cyberarkPam.pvwa.sessions "Authorizes target session launch" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.pvwa.vaultClient -> cyberarkPam.pvwa.portal "Returns authorized account metadata and access outcome" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.cpm.scheduler -> cyberarkPam.cpm.rotation "Passes account identifier and password management task" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.cpm.rotation -> cyberarkPam.cpm.vaultClient "Requests current credential and target account metadata" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.cpm.vaultClient -> cyberarkPam.cpm.rotation "Returns permitted credential and target details" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.cpm.rotation -> cyberarkPam.cpm.target "Passes password verification or change operation" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.cpm.target -> cyberarkPam.cpm.rotation "Returns target password operation outcome" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.cpm.rotation -> cyberarkPam.cpm.vaultClient "Submits successfully changed credential for storage" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.psm.broker -> cyberarkPam.psm.target "Passes authorized target and privileged credential" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.psm.target -> cyberarkPam.psm.recorder "Supplies session activity for recording" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.psm.target -> cyberarkPam.psm.broker "Returns session output and completion status" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.pvwa -> cyberarkPam.vault "Submits permitted Safe credential or metadata operations" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.vault -> cyberarkPam.pvwa "Returns authorized credential or account metadata" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.pvwa.vaultClient -> cyberarkPam.vault "Submits permitted Safe credential or metadata operations" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.vault -> cyberarkPam.pvwa.vaultClient "Returns authorized credential or account metadata" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.cpm -> cyberarkPam.vault "Submits permitted Safe credential or metadata operations" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.vault -> cyberarkPam.cpm "Returns authorized credential or account metadata" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.cpm.vaultClient -> cyberarkPam.vault "Submits permitted Safe credential or metadata operations" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.vault -> cyberarkPam.cpm.vaultClient "Returns authorized credential or account metadata" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.psm -> cyberarkPam.vault "Submits permitted Safe credential or metadata operations" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.vault -> cyberarkPam.psm "Returns authorized credential or account metadata" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.psm.broker -> cyberarkPam.vault "Submits permitted Safe credential or metadata operations" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.vault -> cyberarkPam.psm.broker "Returns authorized credential or account metadata" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.psm -> cyberarkPam.vault "Uploads session recordings and audit metadata" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.psm.recorder -> cyberarkPam.vault "Uploads session recordings and audit metadata" "CyberArk Vault protocol / encrypted channel" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.pvwa -> cyberarkPam.psm "Supplies authorized session-launch context via the user session client" "Session connection parameters / client-mediated" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}

cyberarkPam.pvwa.sessions -> cyberarkPam.psm "Supplies authorized session-launch context via the user session client" "Session connection parameters / client-mediated" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/pam-self-hosted/latest/en/content/pas%20inst/installationoverview.htm\"]"
    }
}
