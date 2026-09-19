component tools.sandboxUi "68-sandbox-browser" "Component - Sandbox browser application" {
    title "Component - Sandbox browser application"
    include tools.sandboxUi.app developer tools.sandbox
    exclude *->*
    include tools.sandboxUi.app->tools.sandbox
    include developer->tools.sandboxUi.app
    autoLayout lr 360 200
}
