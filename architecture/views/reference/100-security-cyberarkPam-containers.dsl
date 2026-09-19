container cyberarkPam "100-security-cyberarkPam-containers" "Container - CyberArk PAM Self-Hosted logical reference" {
    title "Container - CyberArk PAM Self-Hosted logical reference"
    include cyberarkPam.vault cyberarkPam.pvwa cyberarkPam.cpm cyberarkPam.psm securityAdmin operator managedTarget conjur.synchronizer
    exclude *->*
    include cyberarkPam.pvwa->cyberarkPam.vault
    include cyberarkPam.vault->cyberarkPam.pvwa
    include cyberarkPam.cpm->cyberarkPam.vault
    include cyberarkPam.vault->cyberarkPam.cpm
    include cyberarkPam.psm->cyberarkPam.vault
    include cyberarkPam.vault->cyberarkPam.psm
    include cyberarkPam.pvwa->cyberarkPam.psm
    include cyberarkPam.cpm->managedTarget
    include managedTarget->cyberarkPam.cpm
    include cyberarkPam.psm->managedTarget
    include managedTarget->cyberarkPam.psm
    include conjur.synchronizer->cyberarkPam.vault
    include cyberarkPam.vault->conjur.synchronizer
    include operator->cyberarkPam.pvwa
    include operator->cyberarkPam.psm
    include cyberarkPam.psm->operator
    include securityAdmin->cyberarkPam.pvwa
    autoLayout lr 360 200
}
