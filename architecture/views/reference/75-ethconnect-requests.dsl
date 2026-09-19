component firefly.ethconnect "75-ethconnect-requests" "Component - EthConnect (legacy option): requests" {
    title "Component - EthConnect (legacy option): requests"
    include firefly.ethconnect.rest firefly.ethconnect.auth firefly.ethconnect.contracts firefly.ethconnect.registry firefly.ethconnect.openapi firefly.ethconnect.transactions firefly.ethconnect.rpc firefly.ethconnect.receipts firefly.ethconnect.kv firefly.core firefly.signer firefly.ethconnectState mongo
    exclude *->*
    include firefly.ethconnect.rest->firefly.ethconnect.auth
    include firefly.ethconnect.rest->firefly.ethconnect.contracts
    include firefly.ethconnect.contracts->firefly.ethconnect.registry
    include firefly.ethconnect.contracts->firefly.ethconnect.openapi
    include firefly.ethconnect.contracts->firefly.ethconnect.transactions
    include firefly.ethconnect.rest->firefly.ethconnect.transactions
    include firefly.ethconnect.transactions->firefly.ethconnect.rpc
    include firefly.ethconnect.transactions->firefly.ethconnect.receipts
    include firefly.ethconnect.registry->firefly.ethconnect.kv
    include firefly.ethconnect.rpc->firefly.signer
    include firefly.ethconnect.kv->firefly.ethconnectState
    include firefly.ethconnect.receipts->firefly.ethconnectState
    include firefly.ethconnect.receipts->mongo
    include firefly.core->firefly.ethconnect.rest
    autoLayout lr 360 200
}
