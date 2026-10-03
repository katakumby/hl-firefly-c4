adFs = softwareSystem "Microsoft Active Directory Federation Services" "Federates AD-backed identities and issues claims to relying parties; separate from directory synchronization." {
    tags "SecurityCatalog"
    url "https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview"
    properties {
        "architecture.id" "adFs"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-fs/ad-fs-overview\"]"
    }
    !include service.dsl
    !include configuration.dsl
}
