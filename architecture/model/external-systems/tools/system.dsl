tools = softwareSystem "FireFly developer tools" "Development utilities and optional sample applications." {
    tags "Optional"
    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/key_components/tools.md"
    properties {
        "architecture.id" "tools"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/key_components/tools.md\"]"
    }
    !docs ../../../documentation/system
    !adrs ../../../decisions/adr
    !include cli.dsl
    !include sandbox.dsl
    !include sandboxUi.dsl
    !include perf.dsl
    !include eventAudit.dsl
    !include config.dsl
}
