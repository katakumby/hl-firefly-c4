component entraId.authentication "100-security-entraId-authentication-components" "Component - Authentication and token service: logical responsibilities" {
    title "Component - Authentication and token service: logical responsibilities"
    include element.parent==entraId.authentication apps.client entraId.directory
    autoLayout lr 360 200
}
