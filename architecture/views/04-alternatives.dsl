systemLandscape "04-alternatives" "System Landscape - alternative blockchain integrations" {
    title "System Landscape - alternative blockchain integrations"
    include firefly evmNetworks fabric tezos cardano corda developer signatory blockfrostService kafkaBroker mongo fabricCA tools dockerEngine
    exclude *->*
    include developer->tools
    include tools->firefly
    include firefly->evmNetworks
    include firefly->fabric
    include firefly->tezos
    include firefly->cardano
    include developer->corda
    include blockfrostService->cardano
    include developer->firefly
    include firefly->developer
    include firefly->corda
    include tools->developer
    include firefly->signatory
    include firefly->blockfrostService
    include firefly->fabricCA
    include firefly->kafkaBroker
    include firefly->mongo
    include tools->dockerEngine
    autoLayout lr 360 200
}
