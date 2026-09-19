workspace extends model.dsl {
    name "Shared reference architecture"
    description "FireFly ecosystem, private Besu, security and Unleash references; C4 levels 1-3."
    !docs documentation/workspace
    !adrs decisions/adr
    !adrs decisions/workspace
    views {
        !include views/reference
    }
}
