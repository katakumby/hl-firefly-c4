container entraId "100-security-example-directory-sync" "Container - Example: AD identity synchronization through Cloud Sync" {
    title "Container - Example: AD identity synchronization through Cloud Sync"
    include adDs.directory entraId.agent entraId.provisioning entraId.directory
    autoLayout lr 360 200
}
