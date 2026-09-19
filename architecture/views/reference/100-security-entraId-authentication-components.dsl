component entraId.authentication "100-security-entraId-authentication-components" "Component - Authentication and token service: logical responsibilities" {
    title "Component - Authentication and token service: logical responsibilities"
    include entraId.authentication.endpoints entraId.authentication.credentials entraId.authentication.policy entraId.authentication.tokens apps.client entraId.directory
    exclude *->*
    include entraId.authentication.endpoints->entraId.authentication.credentials
    include entraId.authentication.credentials->entraId.authentication.policy
    include entraId.authentication.policy->entraId.authentication.tokens
    include entraId.authentication.tokens->entraId.authentication.endpoints
    include entraId.authentication.credentials->entraId.directory
    include entraId.authentication.policy->entraId.directory
    include apps.client->entraId.authentication.endpoints
    include entraId.authentication.endpoints->apps.client
    autoLayout lr 360 200
}
