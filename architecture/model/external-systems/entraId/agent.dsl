agent = container "Cloud Sync provisioning agent" "Customer-managed runtime that queries AD DS through outbound-established communication with the provisioning service." "Microsoft Entra provisioning agent / Windows service" {
    tags "SecurityCatalog"
    url "https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync"
    properties {
        "architecture.id" "entraId.agent"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
    channel = component "Outbound service channel" "Logical reference: Receives synchronization requests through the agent-established service connection." "Provisioning agent logical responsibility" {
        tags "SecurityCatalog,LogicalReference"
        url "https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync"
        properties {
            "architecture.id" "entraId.agent.channel"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
        }
    }
    directory = component "AD query connector" "Logical reference: Queries scoped AD objects and returns requested attributes." "Provisioning agent logical responsibility" {
        tags "SecurityCatalog,LogicalReference"
        url "https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync"
        properties {
            "architecture.id" "entraId.agent.directory"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
        }
    }
    response = component "Synchronization response" "Logical reference: Returns directory data and progress information to cloud provisioning." "Provisioning agent logical responsibility" {
        tags "SecurityCatalog,LogicalReference"
        url "https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync"
        properties {
            "architecture.id" "entraId.agent.response"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
        }
    }
}
