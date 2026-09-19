component entraId.provisioning "100-security-entraId-provisioning-components" "Component - Cloud Sync provisioning service: logical responsibilities" {
    title "Component - Cloud Sync provisioning service: logical responsibilities"
    include entraId.provisioning.scheduler entraId.provisioning.mapping entraId.provisioning.writer entraId.agent entraId.directory
    exclude *->*
    include entraId.provisioning.scheduler->entraId.provisioning.mapping
    include entraId.provisioning.mapping->entraId.provisioning.writer
    include entraId.provisioning.writer->entraId.directory
    include entraId.provisioning.scheduler->entraId.agent
    include entraId.agent->entraId.provisioning.mapping
    autoLayout lr 360 200
}
