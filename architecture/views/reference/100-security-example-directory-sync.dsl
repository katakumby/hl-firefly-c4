container entraId "100-security-example-directory-sync" "Container - Example: AD identity synchronization through Cloud Sync" {
    title "Container - Example: AD identity synchronization through Cloud Sync"
    include adDs.directory entraId.agent entraId.provisioning entraId.directory
    exclude *->*
    include entraId.provisioning->entraId.directory
    include entraId.agent->entraId.provisioning
    include entraId.provisioning->entraId.agent
    include entraId.agent->adDs.directory
    include adDs.directory->entraId.agent
    autoLayout lr 360 200
}
