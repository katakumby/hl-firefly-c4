component firefly.ethconnect "75-ethconnect-requests" "Component - EthConnect (legacy option): requests" {
    title "Component - EthConnect (legacy option): requests"
    include firefly.ethconnect.rest firefly.ethconnect.auth firefly.ethconnect.contracts firefly.ethconnect.registry firefly.ethconnect.openapi firefly.ethconnect.transactions firefly.ethconnect.rpc firefly.ethconnect.receipts firefly.ethconnect.kv firefly.core firefly.signer firefly.ethconnectState mongo
    autoLayout lr 360 200
}
