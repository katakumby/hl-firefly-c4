group "Identity and federation" {
    adDs = softwareSystem "Microsoft Active Directory Domain Services" "Directory identities, LDAP queries and Kerberos authentication for the enterprise domain." {
        url "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview"
        properties {
            "architecture.id" "adDs"
            "evidence" "Documented product capability"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
        }
        !include ../containers/adDs
    }
}
