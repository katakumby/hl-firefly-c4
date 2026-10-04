authentication = container "Authentication and token service" "Logical identity-platform service for user and application authentication and token issuance." "Microsoft Entra managed service (logical)" {
    url "https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc"
    properties {
        "architecture.id" "entraId.authentication"
        "evidence" "Logical reference abstraction"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
    }
    endpoints = component "Identity protocol endpoints" "Logical reference: Accepts OIDC authorization and OAuth token requests." "Identity-platform responsibility / implementation undisclosed" {
        url "https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc"
        properties {
            "architecture.id" "entraId.authentication.endpoints"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
        }
    }
    credentials = component "Identity authentication" "Logical reference: Validates configured user or application authentication proof." "Identity-platform responsibility / implementation undisclosed" {
        url "https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc"
        properties {
            "architecture.id" "entraId.authentication.credentials"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
        }
    }
    policy = component "Access-policy evaluation" "Logical reference: Applies applicable sign-in and access requirements for this identity and resource." "Identity-platform responsibility / implementation undisclosed" {
        url "https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc"
        properties {
            "architecture.id" "entraId.authentication.policy"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
        }
    }
    tokens = component "Token issuance" "Logical reference: Issues signed ID and access tokens with audience-specific claims." "Identity-platform responsibility / implementation undisclosed" {
        url "https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc"
        properties {
            "architecture.id" "entraId.authentication.tokens"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/identity-platform/v2-protocols-oidc\"]"
        }
    }
}
