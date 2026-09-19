container entraId "100-security-entraId-containers" "Container - Microsoft Entra ID logical reference" {
    title "Container - Microsoft Entra ID logical reference"
    include entraId.authentication entraId.directory entraId.provisioning entraId.agent securityAdmin apps.client business adDs.directory
    exclude *->*
    include business->apps.client
    include entraId.authentication->entraId.directory
    include entraId.provisioning->entraId.directory
    include entraId.agent->entraId.provisioning
    include entraId.provisioning->entraId.agent
    include entraId.agent->adDs.directory
    include adDs.directory->entraId.agent
    include business->entraId.authentication
    include apps.client->entraId.authentication
    include entraId.authentication->apps.client
    include business->adDs.directory
    include adDs.directory->business
    include securityAdmin->entraId.directory
    include securityAdmin->adDs.directory
    autoLayout lr 360 200
}
