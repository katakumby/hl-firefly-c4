component conjur.service "100-security-conjur-service-components" "Component - Conjur service: logical responsibilities" {
    title "Component - Conjur service: logical responsibilities"
    include conjur.service.api conjur.service.authentication conjur.service.policy conjur.service.secrets conjur.service.audit apps.client securityAdmin conjur.store
    exclude *->*
    include conjur.service.api->conjur.service.authentication
    include conjur.service.authentication->conjur.service.api
    include conjur.service.api->conjur.service.policy
    include conjur.service.policy->conjur.service.secrets
    include conjur.service.secrets->conjur.service.api
    include conjur.service.api->conjur.service.audit
    include conjur.service.secrets->conjur.store
    include conjur.service.policy->conjur.store
    include apps.client->conjur.service.api
    include conjur.service.api->apps.client
    include securityAdmin->conjur.service.api
    autoLayout lr 360 200
}
