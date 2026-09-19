container cyberarkPam "100-security-example-privileged-access" "Container - Example: PAM password rotation and recorded sessions" {
    title "Container - Example: PAM password rotation and recorded sessions"
    include operator cyberarkPam.pvwa cyberarkPam.vault cyberarkPam.cpm cyberarkPam.psm managedTarget
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
    include operator->cyberarkPam.pvwa
    include operator->cyberarkPam.psm
    include cyberarkPam.psm->operator
    autoLayout lr 360 200
}
