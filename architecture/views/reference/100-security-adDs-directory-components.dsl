component adDs.directory "100-security-adDs-directory-components" "Component - Domain-controller services: logical responsibilities" {
    title "Component - Domain-controller services: logical responsibilities"
    include element.parent==adDs.directory business securityAdmin adDs.database adDs.sysvol
    autoLayout lr 360 200
}
