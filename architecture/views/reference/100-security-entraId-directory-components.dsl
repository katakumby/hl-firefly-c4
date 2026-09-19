component entraId.directory "100-security-entraId-directory-components" "Component - Directory and administration API: logical responsibilities" {
    title "Component - Directory and administration API: logical responsibilities"
    include entraId.directory.api entraId.directory.authorization entraId.directory.records securityAdmin
    exclude *->*
    include entraId.directory.api->entraId.directory.authorization
    include entraId.directory.authorization->entraId.directory.records
    include entraId.directory.records->entraId.directory.api
    include securityAdmin->entraId.directory.api
    autoLayout lr 360 200
}
