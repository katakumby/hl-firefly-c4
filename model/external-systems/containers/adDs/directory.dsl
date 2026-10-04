directory = container "Domain-controller services" "Logical AD DS runtime; no server instances, sites or replication topology are modeled." "Windows Server / AD DS" {
    url "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview"
    properties {
        "architecture.id" "adDs.directory"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
    }
    ldap = component "LDAP directory interface" "Logical reference: Accepts directory searches and authenticated binds." "AD DS logical responsibility" {
        url "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview"
        properties {
            "architecture.id" "adDs.directory.ldap"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
        }
    }
    kdc = component "Kerberos KDC" "Logical reference: Validates domain authentication and issues Kerberos tickets." "AD DS logical responsibility" {
        url "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview"
        properties {
            "architecture.id" "adDs.directory.kdc"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
        }
    }
    access = component "Directory access and authorization" "Logical reference: Applies directory permissions and resolves requested account attributes." "AD DS logical responsibility" {
        url "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview"
        properties {
            "architecture.id" "adDs.directory.access"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
        }
    }
    persistence = component "Directory persistence" "Logical reference: Reads and writes directory objects and account records." "AD DS logical responsibility" {
        url "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview"
        properties {
            "architecture.id" "adDs.directory.persistence"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
        }
    }
    replication = component "Directory replication responsibility" "Logical reference: Processes directory change records; controller topology is deliberately omitted." "AD DS logical responsibility" {
        url "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview"
        properties {
            "architecture.id" "adDs.directory.replication"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
        }
    }
    policy = component "Group Policy and SYSVOL access" "Logical reference: Supplies domain policy metadata and policy-file references." "AD DS logical responsibility" {
        url "https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview"
        properties {
            "architecture.id" "adDs.directory.policy"
            "evidence" "Logical reference abstraction"
            "architecture.sources" "[\"https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview\"]"
        }
    }
}
