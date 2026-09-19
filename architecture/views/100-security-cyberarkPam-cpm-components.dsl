component cyberarkPam.cpm "100-security-cyberarkPam-cpm-components" "Component - Central Policy Manager: logical responsibilities" {
    title "Component - Central Policy Manager: logical responsibilities"
    include cyberarkPam.cpm.scheduler cyberarkPam.cpm.rotation cyberarkPam.cpm.target cyberarkPam.cpm.vaultClient cyberarkPam.vault managedTarget
    exclude *->*
    include cyberarkPam.cpm.scheduler->cyberarkPam.cpm.rotation
    include cyberarkPam.cpm.rotation->cyberarkPam.cpm.vaultClient
    include cyberarkPam.cpm.vaultClient->cyberarkPam.cpm.rotation
    include cyberarkPam.cpm.rotation->cyberarkPam.cpm.target
    include cyberarkPam.cpm.target->cyberarkPam.cpm.rotation
    include cyberarkPam.cpm.vaultClient->cyberarkPam.vault
    include cyberarkPam.vault->cyberarkPam.cpm.vaultClient
    include cyberarkPam.cpm.target->managedTarget
    include managedTarget->cyberarkPam.cpm.target
    autoLayout lr 360 200
}
