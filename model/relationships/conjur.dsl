conjur.service.api -> conjur.service.authentication "Submits configured workload authentication proof" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

conjur.service.authentication -> conjur.service.api "Returns short-lived Conjur access token" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

conjur.service.api -> conjur.service.policy "Passes token identity, variable path and requested operation" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

conjur.service.policy -> conjur.service.secrets "Authorizes secret variable read or update" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

conjur.service.secrets -> conjur.service.api "Returns authorized secret value or update status" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

conjur.service.api -> conjur.service.audit "Records workload, variable identifier and operation outcome" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

conjur.synchronizer.reader -> conjur.synchronizer.mapping "Supplies selected account identifier, metadata and credential version" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
    }
}

conjur.synchronizer.mapping -> conjur.synchronizer.writer "Supplies mapped variable identifier and updated secret value" "In-process logical interface" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\"]"
    }
}

conjur.service -> conjur.store "Reads or writes encrypted secret records and versions" "Service-owned persistence interface (logical)" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

conjur.service.secrets -> conjur.store "Reads or writes encrypted secret records and versions" "Service-owned persistence interface (logical)" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

conjur.service.policy -> conjur.store "Reads workload permissions and variable policy records" "Service-owned persistence interface (logical)" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

conjur.synchronizer -> conjur.service "Authenticates and writes mapped secret variable values" "HTTPS / Conjur API" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}

conjur.synchronizer.writer -> conjur.service "Authenticates and writes mapped secret variable values" "HTTPS / Conjur API" {
    properties {
        "evidence" "Architecture dataflow inferred from documented product capabilities"
        "architecture.sources" "[\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/conjur/cv_synchronizer-lp.htm\",\"https://docs.cyberark.com/secrets-manager-sh/latest/en/content/resources/_topnav/cc_home.htm\"]"
    }
}
