component cyberarkPam.pvwa "100-security-cyberarkPam-pvwa-components" "Component - Password Vault Web Access: logical responsibilities" {
    title "Component - Password Vault Web Access: logical responsibilities"
    include element.parent==cyberarkPam.pvwa operator securityAdmin cyberarkPam.vault cyberarkPam.psm
    autoLayout lr 360 200
}
