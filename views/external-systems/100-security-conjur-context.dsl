systemContext conjur "100-security-conjur-context" "System Context - CyberArk Conjur Enterprise reference" {
    title "System Context - CyberArk Conjur Enterprise reference"
    include conjur securityAdmin apps cyberarkPam
    autoLayout lr 360 200
}
