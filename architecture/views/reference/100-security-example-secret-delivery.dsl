container conjur "100-security-example-secret-delivery" "Container - Example: Vault synchronization and workload secret retrieval" {
    title "Container - Example: Vault synchronization and workload secret retrieval"
    include cyberarkPam.vault conjur.synchronizer conjur.service conjur.store apps.client
    exclude *->*
    include conjur.service->conjur.store
    include conjur.synchronizer->cyberarkPam.vault
    include cyberarkPam.vault->conjur.synchronizer
    include conjur.synchronizer->conjur.service
    include apps.client->conjur.service
    include conjur.service->apps.client
    autoLayout lr 360 200
}
