component cyberarkPam.pvwa "100-security-cyberarkPam-pvwa-components" "Component - Password Vault Web Access: logical responsibilities" {
    title "Component - Password Vault Web Access: logical responsibilities"
    include cyberarkPam.pvwa.portal cyberarkPam.pvwa.approval cyberarkPam.pvwa.vaultClient cyberarkPam.pvwa.sessions operator securityAdmin cyberarkPam.vault cyberarkPam.psm
    exclude *->*
    include cyberarkPam.pvwa.portal->cyberarkPam.pvwa.approval
    include cyberarkPam.pvwa.approval->cyberarkPam.pvwa.vaultClient
    include cyberarkPam.pvwa.approval->cyberarkPam.pvwa.sessions
    include cyberarkPam.pvwa.vaultClient->cyberarkPam.pvwa.portal
    include cyberarkPam.pvwa.vaultClient->cyberarkPam.vault
    include cyberarkPam.vault->cyberarkPam.pvwa.vaultClient
    include cyberarkPam.psm->cyberarkPam.vault
    include cyberarkPam.vault->cyberarkPam.psm
    include cyberarkPam.pvwa.sessions->cyberarkPam.psm
    include operator->cyberarkPam.pvwa.portal
    include operator->cyberarkPam.psm
    include cyberarkPam.psm->operator
    include securityAdmin->cyberarkPam.pvwa.portal
    autoLayout lr 360 200
}
