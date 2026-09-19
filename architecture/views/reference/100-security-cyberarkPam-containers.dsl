container cyberarkPam "100-security-cyberarkPam-containers" "Container - CyberArk PAM Self-Hosted logical reference" {
    title "Container - CyberArk PAM Self-Hosted logical reference"
    include element.parent==cyberarkPam securityAdmin operator managedTarget conjur.synchronizer
    autoLayout lr 360 200
}
