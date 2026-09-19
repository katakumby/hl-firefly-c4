systemContext conjur "100-security-conjur-context" "System Context - CyberArk Conjur Enterprise reference" {
    title "System Context - CyberArk Conjur Enterprise reference"
    include conjur securityAdmin apps cyberarkPam
    exclude *->*
    include securityAdmin->cyberarkPam
    include securityAdmin->conjur
    include cyberarkPam->conjur
    include conjur->cyberarkPam
    include apps->conjur
    include conjur->apps
    autoLayout lr 360 200
}
