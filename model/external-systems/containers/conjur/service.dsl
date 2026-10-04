service = container "Conjur service" "Logical enterprise runtime for policy, workload authentication and secret APIs; no leader/follower placement is specified." "Conjur Enterprise / HTTPS API" {
    url "https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm"
    properties {
        "architecture.id" "conjur.service"
        "evidence" "Logical reference abstraction"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
    api = component "Secret and policy API" "Logical reference: Accepts authenticated secret and policy operations." "Conjur responsibility / logical reference" {
        url "https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm"
        properties {
            "architecture.id" "conjur.service.api"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
        }
    }
    authentication = component "Workload authentication" "Logical reference: Validates the configured workload identity proof and issues a short-lived Conjur access token." "Conjur responsibility / logical reference" {
        url "https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm"
        properties {
            "architecture.id" "conjur.service.authentication"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
        }
    }
    policy = component "Policy authorization" "Logical reference: Evaluates workload permissions for the requested secret variable or policy resource." "Conjur responsibility / logical reference" {
        url "https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm"
        properties {
            "architecture.id" "conjur.service.policy"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
        }
    }
    secrets = component "Secret access" "Logical reference: Returns only authorized secret values and accepts permitted updates." "Conjur responsibility / logical reference" {
        url "https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm"
        properties {
            "architecture.id" "conjur.service.secrets"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
        }
    }
    audit = component "Access auditing" "Logical reference: Records workload, variable identifier and operation outcome without secret values." "Conjur responsibility / logical reference" {
        url "https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm"
        properties {
            "architecture.id" "conjur.service.audit"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
        }
    }
}
