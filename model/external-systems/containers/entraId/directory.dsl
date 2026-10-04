directory = container "Directory and administration API" "Logical directory and Microsoft Graph-facing boundary for users, groups, applications and policies." "Microsoft Entra managed service (logical)" {
    url "https://learn.microsoft.com/en-us/entra/architecture/architecture"
    properties {
        "architecture.id" "entraId.directory"
        "evidence" "Logical reference abstraction"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
    api = component "Directory administration API" "Logical reference: Accepts authorized directory reads and changes through public administrative interfaces." "Directory responsibility / implementation undisclosed" {
        url "https://learn.microsoft.com/en-us/entra/architecture/architecture"
        properties {
            "architecture.id" "entraId.directory.api"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
        }
    }
    authorization = component "Directory authorization" "Logical reference: Checks caller permissions for the requested directory resource operation." "Directory responsibility / implementation undisclosed" {
        url "https://learn.microsoft.com/en-us/entra/architecture/architecture"
        properties {
            "architecture.id" "entraId.directory.authorization"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
        }
    }
    records = component "Directory object access" "Logical reference: Reads and writes identity, group, application and policy records." "Directory responsibility / implementation undisclosed" {
        url "https://learn.microsoft.com/en-us/entra/architecture/architecture"
        properties {
            "architecture.id" "entraId.directory.records"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
        }
    }
}
