container conjur "100-security-conjur-containers" "Container - CyberArk Conjur Enterprise logical reference" {
    title "Container - CyberArk Conjur Enterprise logical reference"
    include element.parent==conjur securityAdmin apps.client cyberarkPam.vault
    autoLayout lr 360 200
}
