systemContext tools "06-context-tools" "System Context - FireFly developer tools" {
    title "System Context - FireFly developer tools"
    include tools developer firefly dockerEngine
    exclude *->*
    include developer->tools
    include tools->firefly
    include developer->firefly
    include firefly->developer
    include tools->developer
    include tools->dockerEngine
    autoLayout lr 360 200
}
