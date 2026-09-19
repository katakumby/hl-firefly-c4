systemContext cyberarkPam "100-security-cyberarkPam-context" "System Context - CyberArk PAM Self-Hosted reference" {
    title "System Context - CyberArk PAM Self-Hosted reference"
    include cyberarkPam securityAdmin operator managedTarget conjur
    autoLayout lr 360 200
}
