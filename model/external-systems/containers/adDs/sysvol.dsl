sysvol = container "SYSVOL store" "Domain-controller-owned policy templates and scripts; no filesystem deployment is specified." "SYSVOL / owned filesystem" {
    tags "Database"
    url "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview"
    properties {
        "architecture.id" "adDs.sysvol"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}
