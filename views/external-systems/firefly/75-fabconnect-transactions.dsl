component firefly.fabconnect "75-fabconnect-transactions" "Component - FabConnect: transactions" {
    title "Component - FabConnect: transactions"
    include firefly.fabconnect.rest firefly.fabconnect.auth firefly.fabconnect.identity firefly.fabconnect.transactions firefly.fabconnect.client firefly.fabconnect.receipts firefly.core fabric fabricCA firefly.fabricState mongo
    autoLayout lr 360 200
}
