component conjur.synchronizer "100-security-conjur-synchronizer-components" "Component - Vault Synchronizer: logical responsibilities" {
    title "Component - Vault Synchronizer: logical responsibilities"
    include conjur.synchronizer.reader conjur.synchronizer.mapping conjur.synchronizer.writer cyberarkPam.vault conjur.service
    exclude *->*
    include conjur.synchronizer.reader->conjur.synchronizer.mapping
    include conjur.synchronizer.mapping->conjur.synchronizer.writer
    include conjur.synchronizer.reader->cyberarkPam.vault
    include cyberarkPam.vault->conjur.synchronizer.reader
    include conjur.synchronizer.writer->conjur.service
    autoLayout lr 360 200
}
