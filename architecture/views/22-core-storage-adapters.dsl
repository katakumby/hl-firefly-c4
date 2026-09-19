component firefly.core "22-core-storage-adapters" "Component - Core storage and exchange adapters" {
    title "Component - Core storage and exchange adapters"
    include firefly.core.data firefly.core.broadcast firefly.core.database firefly.core.postgres firefly.core.sqlite firefly.core.sql firefly.core.dataexchange firefly.core.ffdx firefly.core.sharedstorage firefly.core.ipfs firefly.core.private firefly.core.batchprocessor firefly.pg firefly.sqlite firefly.dx firefly.ipfs
    exclude *->*
    include firefly.core.data->firefly.core.database
    include firefly.core.batchprocessor->firefly.core.data
    include firefly.core.batchprocessor->firefly.core.broadcast
    include firefly.core.batchprocessor->firefly.core.private
    include firefly.core.broadcast->firefly.core.sharedstorage
    include firefly.core.private->firefly.core.dataexchange
    include firefly.core.database->firefly.pg
    include firefly.core.dataexchange->firefly.dx
    include firefly.core.sharedstorage->firefly.ipfs
    include firefly.dx->firefly.dx
    include firefly.ipfs->firefly.ipfs
    include firefly.core.database->firefly.core.postgres
    include firefly.core.database->firefly.core.sqlite
    include firefly.core.postgres->firefly.core.sql
    include firefly.core.sqlite->firefly.core.sql
    include firefly.core.dataexchange->firefly.core.ffdx
    include firefly.core.sharedstorage->firefly.core.ipfs
    include firefly.core.postgres->firefly.pg
    include firefly.core.ffdx->firefly.dx
    include firefly.core.ipfs->firefly.ipfs
    include firefly.core.sqlite->firefly.sqlite
    autoLayout lr 360 200
}
