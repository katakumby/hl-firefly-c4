component cyberarkPam.psm "100-security-cyberarkPam-psm-components" "Component - Privileged Session Manager: logical responsibilities" {
    title "Component - Privileged Session Manager: logical responsibilities"
    include cyberarkPam.psm.broker cyberarkPam.psm.target cyberarkPam.psm.recorder operator cyberarkPam.vault managedTarget
    exclude *->*
    include cyberarkPam.psm.broker->cyberarkPam.psm.target
    include cyberarkPam.psm.target->cyberarkPam.psm.recorder
    include cyberarkPam.psm.target->cyberarkPam.psm.broker
    include cyberarkPam.psm.broker->cyberarkPam.vault
    include cyberarkPam.vault->cyberarkPam.psm.broker
    include cyberarkPam.psm.recorder->cyberarkPam.vault
    include cyberarkPam.psm.target->managedTarget
    include managedTarget->cyberarkPam.psm.target
    include operator->cyberarkPam.psm.broker
    include cyberarkPam.psm.broker->operator
    autoLayout lr 360 200
}
