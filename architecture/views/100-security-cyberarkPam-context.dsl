systemContext cyberarkPam "100-security-cyberarkPam-context" "System Context - CyberArk PAM Self-Hosted reference" {
    title "System Context - CyberArk PAM Self-Hosted reference"
    include cyberarkPam securityAdmin operator managedTarget conjur
    exclude *->*
    include securityAdmin->cyberarkPam
    include securityAdmin->conjur
    include operator->cyberarkPam
    include cyberarkPam->managedTarget
    include managedTarget->cyberarkPam
    include cyberarkPam->operator
    include cyberarkPam->conjur
    include conjur->cyberarkPam
    autoLayout lr 360 200
}
