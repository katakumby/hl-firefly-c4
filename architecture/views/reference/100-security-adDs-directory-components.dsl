component adDs.directory "100-security-adDs-directory-components" "Component - Domain-controller services: logical responsibilities" {
    title "Component - Domain-controller services: logical responsibilities"
    include adDs.directory.ldap adDs.directory.kdc adDs.directory.access adDs.directory.persistence adDs.directory.replication adDs.directory.policy business securityAdmin adDs.database adDs.sysvol
    exclude *->*
    include adDs.directory.ldap->adDs.directory.access
    include adDs.directory.access->adDs.directory.persistence
    include adDs.directory.kdc->adDs.directory.persistence
    include adDs.directory.replication->adDs.directory.persistence
    include adDs.directory.policy->adDs.directory.access
    include adDs.directory.persistence->adDs.database
    include adDs.directory.policy->adDs.sysvol
    include business->adDs.directory.kdc
    include adDs.directory.kdc->business
    include securityAdmin->adDs.directory.ldap
    autoLayout lr 360 200
}
