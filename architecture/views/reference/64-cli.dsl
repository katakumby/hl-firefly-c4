component tools.cli "64-cli" "Component - FireFly CLI" {
    title "Component - FireFly CLI"
    include tools.cli.commands tools.cli.stacks tools.cli.docker tools.cli.blockchains tools.cli.tokens tools.cli.core developer dockerEngine firefly.core
    exclude *->*
    include tools.cli.commands->tools.cli.stacks
    include tools.cli.stacks->tools.cli.docker
    include tools.cli.stacks->tools.cli.blockchains
    include tools.cli.stacks->tools.cli.tokens
    include tools.cli.stacks->tools.cli.core
    include tools.cli.docker->dockerEngine
    include tools.cli.core->firefly.core
    include developer->tools.cli.commands
    autoLayout lr 360 200
}
