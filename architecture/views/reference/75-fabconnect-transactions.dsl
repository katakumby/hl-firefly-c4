component firefly.fabconnect "75-fabconnect-transactions" "Component - FabConnect: transactions" {
    title "Component - FabConnect: transactions"
    include firefly.fabconnect.rest firefly.fabconnect.auth firefly.fabconnect.identity firefly.fabconnect.transactions firefly.fabconnect.client firefly.fabconnect.receipts firefly.core fabric fabricCA firefly.fabricState mongo
    exclude *->*
    include firefly.fabconnect.rest->firefly.fabconnect.auth
    include firefly.fabconnect.rest->firefly.fabconnect.identity
    include firefly.fabconnect.identity->firefly.fabconnect.client
    include firefly.fabconnect.rest->firefly.fabconnect.transactions
    include firefly.fabconnect.transactions->firefly.fabconnect.client
    include firefly.fabconnect.transactions->firefly.fabconnect.receipts
    include firefly.fabconnect.client->fabric
    include firefly.fabconnect.client->fabricCA
    include firefly.fabconnect.client->firefly.fabricState
    include firefly.fabconnect.receipts->firefly.fabricState
    include firefly.fabconnect.receipts->mongo
    include firefly.core->firefly.fabconnect.rest
    autoLayout lr 360 200
}
