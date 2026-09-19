container conjur "100-security-conjur-containers" "Container - CyberArk Conjur Enterprise logical reference" {
    title "Container - CyberArk Conjur Enterprise logical reference"
    include conjur.service conjur.store conjur.synchronizer securityAdmin apps.client cyberarkPam.vault
    exclude *->*
    include conjur.service->conjur.store
    include conjur.synchronizer->cyberarkPam.vault
    include cyberarkPam.vault->conjur.synchronizer
    include conjur.synchronizer->conjur.service
    include apps.client->conjur.service
    include conjur.service->apps.client
    include securityAdmin->conjur.service
    autoLayout lr 360 200
}
