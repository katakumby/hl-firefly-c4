component conjur.service "100-security-conjur-service-components" "Component - Conjur service: logical responsibilities" {
    title "Component - Conjur service: logical responsibilities"
    include element.parent==conjur.service apps.client securityAdmin conjur.store
    autoLayout lr 360 200
}
