component firefly.core "23-core-event-token-adapters" "Component - Core token and event adapters" {
    title "Component - Core token and event adapters"
    include firefly.core.tokens firefly.core.fftokens firefly.core.eventplugin firefly.core.websockets firefly.core.webhooks firefly.core.systemEvents firefly.core.aggregator firefly.erc20 firefly.erc1155 apps.client
    exclude *->*
    include firefly.core.tokens->firefly.core.aggregator
    include firefly.core.tokens->firefly.erc20
    include firefly.core.tokens->firefly.erc1155
    include firefly.core.eventplugin->apps.client
    include firefly.core.tokens->firefly.core.fftokens
    include firefly.core.eventplugin->firefly.core.websockets
    include firefly.core.eventplugin->firefly.core.webhooks
    include firefly.core.eventplugin->firefly.core.systemEvents
    include firefly.core.systemEvents->firefly.core.aggregator
    include firefly.core.fftokens->firefly.erc20
    include firefly.core.fftokens->firefly.erc1155
    include firefly.core.websockets->apps.client
    include firefly.core.webhooks->apps.client
    include apps.client->firefly.core.websockets
    autoLayout lr 360 200
}
