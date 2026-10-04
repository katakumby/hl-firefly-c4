configuration = container "AD FS configuration store" "Stores trust, claim-rule and federation configuration; WID is the reference store choice." "Windows Internal Database (reference choice)" {
    tags "SecurityCatalog,Database"
    url "https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview"
    properties {
        "architecture.id" "adFs.configuration"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
}
