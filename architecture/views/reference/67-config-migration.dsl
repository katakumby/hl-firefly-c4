component tools.config "67-config-migration" "Component - FireFly configuration migrator" {
    title "Component - FireFly configuration migrator"
    include tools.config.commands tools.config.migration developer
    exclude *->*
    include developer->tools.config.commands
    include tools.config.commands->tools.config.migration
    include tools.config.migration->developer
    autoLayout lr 360 200
}
