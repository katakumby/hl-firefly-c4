database = container "AD directory data store" "Domain-controller-owned directory objects, schema and account records." "NTDS directory database / owned storage" {
    tags "SecurityCatalog,Database"
    url "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview"
    properties {
        "architecture.id" "adDs.database"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
}
