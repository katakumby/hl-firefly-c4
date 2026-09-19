entraId.authentication.endpoints -> entraId.authentication.credentials "Passes authorization or token request with authentication proof" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

entraId.authentication.credentials -> entraId.authentication.policy "Supplies authenticated identity and sign-in context" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

entraId.authentication.policy -> entraId.authentication.tokens "Supplies permitted identity, audience and scopes" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

entraId.authentication.tokens -> entraId.authentication.endpoints "Returns signed ID or access token response" "In-process logical interface" "Dataflow,SecurityCatalog,IdentityFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
}

entraId.directory.api -> entraId.directory.authorization "Passes caller, directory resource and operation" "In-process logical interface" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

entraId.directory.authorization -> entraId.directory.records "Authorizes identity or policy record access" "In-process logical interface" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

entraId.directory.records -> entraId.directory.api "Returns directory objects or update outcome" "In-process logical interface" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

entraId.provisioning.scheduler -> entraId.provisioning.mapping "Submits returned directory object changes and synchronization state" "In-process logical interface" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

entraId.provisioning.mapping -> entraId.provisioning.writer "Supplies filtered and mapped directory object changes" "In-process logical interface" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

entraId.agent.channel -> entraId.agent.directory "Passes requested directory scope and attribute query" "In-process logical interface" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

entraId.agent.directory -> entraId.agent.response "Supplies selected object attributes and query outcome" "In-process logical interface" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

entraId.agent.response -> entraId.agent.channel "Returns synchronization data for the established service channel" "In-process logical interface" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

entraId.authentication -> entraId.directory "Reads identity, application and applicable policy records" "Microsoft internal service interface (logical)" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

entraId.authentication.credentials -> entraId.directory "Reads identity, application and applicable policy records" "Microsoft internal service interface (logical)" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

entraId.authentication.policy -> entraId.directory "Reads identity, application and applicable policy records" "Microsoft internal service interface (logical)" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

entraId.provisioning -> entraId.directory "Commits scoped user, group and contact changes" "Microsoft internal directory interface (logical)" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

entraId.provisioning.writer -> entraId.directory "Commits scoped user, group and contact changes" "Microsoft internal directory interface (logical)" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\",\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
}

entraId.agent -> entraId.provisioning "Establishes outbound channel and returns requested directory attributes" "TLS / Cloud Sync service channel via Azure Service Bus" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

entraId.provisioning -> entraId.agent "Delivers scoped synchronization requests over the agent-established channel" "SCIM / established Cloud Sync channel" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

entraId.agent.channel -> entraId.provisioning "Establishes outbound channel and returns requested directory attributes" "TLS / Cloud Sync service channel via Azure Service Bus" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

entraId.provisioning -> entraId.agent.channel "Delivers scoped synchronization requests over the agent-established channel" "SCIM / established Cloud Sync channel" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

entraId.provisioning.scheduler -> entraId.agent "Delivers scoped directory synchronization requests" "SCIM / agent-established service channel" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}

entraId.agent -> entraId.provisioning.mapping "Returns scoped object attributes and synchronization progress" "TLS / established Cloud Sync channel" "Dataflow,SecurityCatalog,DirectoryFlow" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
}
