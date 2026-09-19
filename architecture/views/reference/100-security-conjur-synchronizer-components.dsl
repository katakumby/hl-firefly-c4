component conjur.synchronizer "100-security-conjur-synchronizer-components" "Component - Vault Synchronizer: logical responsibilities" {
    title "Component - Vault Synchronizer: logical responsibilities"
    include element.parent==conjur.synchronizer cyberarkPam.vault conjur.service
    autoLayout lr 360 200
}
