component cyberarkPam.vault "100-security-cyberarkPam-vault-components" "Component - Digital Vault: logical responsibilities" {
    title "Component - Digital Vault: logical responsibilities"
    include cyberarkPam.vault.access cyberarkPam.vault.policy cyberarkPam.vault.storage cyberarkPam.vault.audit
    exclude *->*
    include cyberarkPam.vault.access->cyberarkPam.vault.policy
    include cyberarkPam.vault.policy->cyberarkPam.vault.storage
    include cyberarkPam.vault.storage->cyberarkPam.vault.access
    include cyberarkPam.vault.access->cyberarkPam.vault.audit
    autoLayout lr 360 200
}
