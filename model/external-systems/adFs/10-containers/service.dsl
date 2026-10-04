!element adFs {
    service = container "AD FS federation service" "Authenticates users and issues claims under configured relying-party trust policy." "Windows Server / AD FS" {
        url "https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview"
        properties {
            "architecture.id" "adFs.service"
            "evidence" "Documented product capability"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
        }
        endpoints = component "Federation protocol endpoints" "Logical reference: Accepts relying-party requests and returns browser-mediated federation responses." "AD FS logical responsibility" {
            url "https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine"
            properties {
                "architecture.id" "adFs.service.endpoints"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\"]"
            }
        }
        authentication = component "Authentication adapters" "Logical reference: Validates user authentication through configured domain mechanisms." "AD FS logical responsibility" {
            url "https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine"
            properties {
                "architecture.id" "adFs.service.authentication"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\"]"
            }
        }
        claims = component "Claims engine" "Logical reference: Transforms incoming claims and directory attributes using configured claim rules." "AD FS logical responsibility" {
            url "https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine"
            properties {
                "architecture.id" "adFs.service.claims"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\"]"
            }
        }
        tokens = component "Token issuance" "Logical reference: Signs and issues claims tokens for the configured relying party." "AD FS logical responsibility" {
            url "https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine"
            properties {
                "architecture.id" "adFs.service.tokens"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\"]"
            }
        }
        configuration = component "Trust and configuration access" "Logical reference: Loads relying-party trusts, claims rules and signing configuration." "AD FS logical responsibility" {
            url "https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine"
            properties {
                "architecture.id" "adFs.service.configuration"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\"]"
            }
        }
        audit = component "Federation auditing" "Logical reference: Records authentication, claims issuance outcome and request context." "AD FS logical responsibility" {
            url "https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine"
            properties {
                "architecture.id" "adFs.service.audit"
                "evidence" "Logical reference abstraction"
                "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/technical-reference/the-role-of-the-claims-engine\"]"
            }
        }
    }
}
