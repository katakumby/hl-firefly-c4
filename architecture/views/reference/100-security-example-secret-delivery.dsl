container conjur "100-security-example-secret-delivery" "Container - Example: Vault synchronization and workload secret retrieval" {
    title "Container - Example: Vault synchronization and workload secret retrieval"
    include element.parent==conjur cyberarkPam.vault apps.client
    autoLayout lr 360 200
}
