entraId = softwareSystem "Microsoft Entra ID" "Cloud identity, token issuance, directory administration and provisioning; separate from AD DS and AD FS." {
    tags "SecurityCatalog"
    url "https://learn.microsoft.com/en-us/entra/architecture/architecture"
    properties {
        "architecture.id" "entraId"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/entra/architecture/architecture\"]"
    }
    !docs ../../../documentation/system
    !adrs ../../../decisions/adr
    !include authentication.dsl
    !include directory.dsl
    !include provisioning.dsl
    !include agent.dsl
}
