component unleash.ui "110-unleash-ui-components" "Component - Unleash Admin UI" {
    title "Component - Unleash Admin UI"
    include unleash.ui.shell unleash.ui.api unleash.ui.flags unleash.ui.admin unleash.ui.reports unleash.server
    exclude *->*
    include unleash_uiShellQueries
    include unleash_uiFlagCommands
    include unleash_uiAdminCommands
    include unleash_uiReportQueries
    include unleash_uiComponentAssets
    include unleash_uiComponentSession
    include unleash_uiComponentAdmin
    autoLayout lr 360 200
}
