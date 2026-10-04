provisioning = container "Cloud Sync provisioning service" "Orchestrates selected AD object synchronization and commits directory changes." "Microsoft Entra managed service (logical)" {
    url "https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync"
    properties {
        "architecture.id" "entraId.provisioning"
        "evidence" "Logical reference abstraction"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
    }
    scheduler = component "Provisioning orchestration" "Logical reference: Schedules scoped synchronization work and tracks incremental progress." "Cloud Sync logical responsibility" {
        url "https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync"
        properties {
            "architecture.id" "entraId.provisioning.scheduler"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
        }
    }
    mapping = component "Provisioning mapping and processing" "Logical reference: Processes returned attributes according to configured scopes and mappings." "Cloud Sync logical responsibility" {
        url "https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync"
        properties {
            "architecture.id" "entraId.provisioning.mapping"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
        }
    }
    writer = component "Directory update client" "Logical reference: Commits processed object changes to the Entra directory." "Cloud Sync logical responsibility" {
        url "https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync"
        properties {
            "architecture.id" "entraId.provisioning.writer"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity/hybrid/cloud-sync/what-is-cloud-sync\"]"
        }
    }
}
