component entraId.agent "100-security-entraId-agent-components" "Component - Cloud Sync provisioning agent: logical responsibilities" {
    title "Component - Cloud Sync provisioning agent: logical responsibilities"
    include entraId.agent.channel entraId.agent.directory entraId.agent.response adDs.directory entraId.provisioning
    exclude *->*
    include entraId.agent.channel->entraId.agent.directory
    include entraId.agent.directory->entraId.agent.response
    include entraId.agent.response->entraId.agent.channel
    include entraId.agent.channel->entraId.provisioning
    include entraId.provisioning->entraId.agent.channel
    include entraId.agent.directory->adDs.directory
    include adDs.directory->entraId.agent.directory
    autoLayout lr 360 200
}
