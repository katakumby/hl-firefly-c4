component cyberarkPam.psm "100-security-cyberarkPam-psm-components" "Component - Privileged Session Manager: logical responsibilities" {
    title "Component - Privileged Session Manager: logical responsibilities"
    include element.parent==cyberarkPam.psm operator cyberarkPam.vault managedTarget
    autoLayout lr 360 200
}
