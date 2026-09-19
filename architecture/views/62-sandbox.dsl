component tools.sandbox "62-sandbox" "Component - Sandbox server" {
    title "Component - Sandbox server"
    include tools.sandbox.backend tools.sandbox.sdk tools.sandboxUi firefly.core tools.sandbox.sdkHttp tools.sandbox.sdkEvents
    exclude *->*
    include tools.sandboxUi->tools.sandbox.backend
    include tools.sandbox.backend->tools.sandbox.sdk
    include tools.sandbox.sdk->firefly.core
    include tools.sandbox.sdk->tools.sandbox.sdkHttp
    include tools.sandbox.sdk->tools.sandbox.sdkEvents
    include tools.sandbox.sdkHttp->firefly.core
    include tools.sandbox.sdkEvents->firefly.core
    autoLayout lr 360 200
}
