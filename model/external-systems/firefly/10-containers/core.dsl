!element firefly {
    core = container "FireFly Core" "Exposes member APIs, serves Explorer assets and orchestrates multiparty operations." "Go" {
        url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator"
        properties {
            "architecture.id" "firefly.core"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
        }
        api = component "REST API and routing" "Accepts namespace-scoped commands and queries." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/apiserver"
            properties {
                "architecture.id" "firefly.core.api"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/apiserver\"]"
            }
        }
        auth = component "API authentication" "Applies configured namespace authorization; Basic Auth reference plugin." "Go" {
            url "https://github.com/hyperledger-firefly/common/tree/b91a1eb645e5bc39c54ed20ad0e917cff7d15d2e/pkg/auth"
            properties {
                "architecture.id" "firefly.core.auth"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/common/tree/b91a1eb645e5bc39c54ed20ad0e917cff7d15d2e/pkg/auth\"]"
            }
        }
        namespaces = component "Namespace manager" "Initializes isolated orchestrators and configured plugins." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/namespace"
            properties {
                "architecture.id" "firefly.core.namespaces"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/namespace\"]"
            }
        }
        orchestrator = component "Orchestrator" "Coordinates API operations and subsystem lifecycles." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator"
            properties {
                "architecture.id" "firefly.core.orchestrator"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
            }
        }
        identity = component "Identity manager" "Resolves organizations, nodes and transaction signing identities." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/identity"
            properties {
                "architecture.id" "firefly.core.identity"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/identity\"]"
            }
        }
        networkmap = component "Network map" "Indexes registered members, nodes and their endpoints." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/networkmap"
            properties {
                "architecture.id" "firefly.core.networkmap"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/networkmap\"]"
            }
        }
        definitions = component "Definition exchange" "Publishes and processes schemas, interfaces and token definitions." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/definitions"
            properties {
                "architecture.id" "firefly.core.definitions"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/definitions\"]"
            }
        }
        data = component "Data manager" "Validates, hashes and retrieves structured data and blob references." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/data"
            properties {
                "architecture.id" "firefly.core.data"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/data\"]"
            }
        }
        schema = component "Schema validation" "Checks JSON payloads against registered datatype definitions." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/data"
            properties {
                "architecture.id" "firefly.core.schema"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/data\"]"
            }
        }
        batch = component "Batch manager" "Selects outbound messages and dispatches recoverable batches." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/batch"
            properties {
                "architecture.id" "firefly.core.batch"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/batch\"]"
            }
        }
        batchprocessor = component "Batch processor" "Assembles ordered message batches and aggregate hashes." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/batch"
            properties {
                "architecture.id" "firefly.core.batchprocessor"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/batch\"]"
            }
        }
        broadcast = component "Broadcast manager" "Publishes shared payloads and orchestrates ledger pinning." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/broadcast"
            properties {
                "architecture.id" "firefly.core.broadcast"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/broadcast\"]"
            }
        }
        private = component "Private messaging and groups" "Routes messages to recipient groups and coordinates delivery." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/privatemessaging"
            properties {
                "architecture.id" "firefly.core.private"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/privatemessaging\"]"
            }
        }
        multiparty = component "Multiparty manager" "Coordinates network actions and FireFly contract pinning." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/multiparty"
            properties {
                "architecture.id" "firefly.core.multiparty"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/multiparty\"]"
            }
        }
        download = component "Shared download manager" "Retrieves referenced broadcast batches and blobs." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/shareddownload"
            properties {
                "architecture.id" "firefly.core.download"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/shareddownload\"]"
            }
        }
        contracts = component "Contract manager" "Maps FFIs and APIs to contract calls and event listeners." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/contracts"
            properties {
                "architecture.id" "firefly.core.contracts"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/contracts\"]"
            }
        }
        assets = component "Asset manager" "Coordinates token pools, balances and transfers." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/assets"
            properties {
                "architecture.id" "firefly.core.assets"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/assets\"]"
            }
        }
        operations = component "Operations manager" "Tracks asynchronous connector requests and results." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/operations"
            properties {
                "architecture.id" "firefly.core.operations"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/operations\"]"
            }
        }
        txhelper = component "Transaction helper" "Correlates operations, messages and blockchain transactions." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/txcommon"
            properties {
                "architecture.id" "firefly.core.txhelper"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/txcommon\"]"
            }
        }
        txwriter = component "Transaction writer" "Batches transaction persistence and submission work." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/txwriter"
            properties {
                "architecture.id" "firefly.core.txwriter"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/txwriter\"]"
            }
        }
        aggregator = component "Inbound event aggregator" "Correlates ledger pins with payloads and sequences confirmed messages." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/aggregator.go"
            properties {
                "architecture.id" "firefly.core.aggregator"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/aggregator.go\"]"
            }
        }
        subscriptions = component "Subscription manager" "Filters events and persists subscriber offsets." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/subscription_manager.go"
            properties {
                "architecture.id" "firefly.core.subscriptions"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/subscription_manager.go\"]"
            }
        }
        dispatcher = component "Event dispatcher" "Delivers ordered event batches and processes acknowledgements." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/event_dispatcher.go"
            properties {
                "architecture.id" "firefly.core.dispatcher"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/event_dispatcher.go\"]"
            }
        }
        syncasync = component "Sync/async bridge" "Correlates asynchronous completion with waiting API requests." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/syncasync"
            properties {
                "architecture.id" "firefly.core.syncasync"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/syncasync\"]"
            }
        }
        cache = component "Cache manager" "Caches reusable namespace resources and lookups." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/cache"
            properties {
                "architecture.id" "firefly.core.cache"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/cache\"]"
            }
        }
        metrics = component "Metrics" "Exposes runtime and operation measurements." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/metrics"
            properties {
                "architecture.id" "firefly.core.metrics"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/metrics\"]"
            }
        }
        spievents = component "SPI event manager" "Publishes internal lifecycle and namespace change events." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/spievents"
            properties {
                "architecture.id" "firefly.core.spievents"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/spievents\"]"
            }
        }
        blockchain = component "Blockchain plugin" "Defines blockchain operations and dispatches to the configured chain adapter." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain"
            properties {
                "architecture.id" "firefly.core.blockchain"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain\"]"
            }
        }
        database = component "Database plugin" "Defines transactional persistence and dispatches to the selected SQL adapter." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database"
            properties {
                "architecture.id" "firefly.core.database"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database\"]"
            }
        }
        dataexchange = component "Data exchange plugin" "Binds message, blob and peer operations to the HTTPS connector." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/dataexchange"
            properties {
                "architecture.id" "firefly.core.dataexchange"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/dataexchange\"]"
            }
        }
        sharedstorage = component "Shared storage plugin" "Publishes and retrieves content through IPFS APIs." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/sharedstorage"
            properties {
                "architecture.id" "firefly.core.sharedstorage"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/sharedstorage\"]"
            }
        }
        tokens = component "Token plugin" "Binds standard token operations to remote token connectors." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/tokens"
            properties {
                "architecture.id" "firefly.core.tokens"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/tokens\"]"
            }
        }
        identityplugin = component "Identity extension placeholder" "Registers the onchain compatibility placeholder; external identity resolution is not implemented." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/identity/tbd"
            properties {
                "architecture.id" "firefly.core.identityplugin"
                "evidence" "Unfinished extension"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/identity/tbd\"]"
            }
        }
        eventplugin = component "Event transport interface" "Binds subscriber delivery to a configured event transport." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events"
            properties {
                "architecture.id" "firefly.core.eventplugin"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events\"]"
            }
        }
        config = component "Configuration and plugin initialization" "Loads namespace settings and initializes plugin factories." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/coreconfig"
            properties {
                "architecture.id" "firefly.core.config"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/coreconfig\"]"
            }
        }
        basicAuth = component "HTTP Basic authentication" "Verifies htpasswd bcrypt credentials for configured namespaces." "Go" {
            url "https://github.com/hyperledger-firefly/common/tree/b91a1eb645e5bc39c54ed20ad0e917cff7d15d2e/pkg/auth/basic"
            properties {
                "architecture.id" "firefly.core.basicAuth"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/common/tree/b91a1eb645e5bc39c54ed20ad0e917cff7d15d2e/pkg/auth/basic\"]"
            }
        }
        ethereum = component "Ethereum blockchain adapter" "Maps Core operations to EVMConnect or legacy EthConnect." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain/ethereum"
            properties {
                "architecture.id" "firefly.core.ethereum"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain/ethereum\"]"
            }
        }
        fabricAdapter = component "Fabric blockchain adapter" "Maps chaincode operations and ledger events to FabConnect." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain/fabric"
            properties {
                "architecture.id" "firefly.core.fabricAdapter"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain/fabric\"]"
            }
        }
        tezosAdapter = component "Tezos blockchain adapter" "Maps FireFly contract operations to TezosConnect." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain/tezos"
            properties {
                "architecture.id" "firefly.core.tezosAdapter"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain/tezos\"]"
            }
        }
        cardanoAdapter = component "Cardano blockchain adapter" "Maps transactions and contract operations to CardanoConnect." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain/cardano"
            properties {
                "architecture.id" "firefly.core.cardanoAdapter"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain/cardano\"]"
            }
        }
        postgres = component "PostgreSQL adapter" "Implements Core persistence through the shared SQL layer." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/postgres"
            properties {
                "architecture.id" "firefly.core.postgres"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/postgres\"]"
            }
        }
        sqlite = component "SQLite adapter" "Implements Core persistence in an embedded SQLite database." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/sqlite3"
            properties {
                "architecture.id" "firefly.core.sqlite"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/sqlite3\"]"
            }
        }
        sql = component "SQL persistence implementation" "Builds resource queries and transactions for SQL backends." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/sqlcommon"
            properties {
                "architecture.id" "firefly.core.sql"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/sqlcommon\"]"
            }
        }
        ffdx = component "HTTPS Data Exchange adapter" "Maps private envelopes, blobs, peers and acknowledgements to FFDX." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/dataexchange/ffdx"
            properties {
                "architecture.id" "firefly.core.ffdx"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/dataexchange/ffdx\"]"
            }
        }
        ipfs = component "IPFS shared-storage adapter" "Adds and retrieves broadcast content by CID." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/sharedstorage/ipfs"
            properties {
                "architecture.id" "firefly.core.ipfs"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/sharedstorage/ipfs\"]"
            }
        }
        fftokens = component "Token connector adapter" "Maps token operations and events to standard remote token APIs." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/tokens/fftokens"
            properties {
                "architecture.id" "firefly.core.fftokens"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/tokens/fftokens\"]"
            }
        }
        websockets = component "WebSocket event transport" "Delivers subscription batches and consumes acknowledgements." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/websockets"
            properties {
                "architecture.id" "firefly.core.websockets"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/websockets\"]"
            }
        }
        webhooks = component "Webhook event transport" "Posts event batches to configured callback endpoints." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/webhooks"
            properties {
                "architecture.id" "firefly.core.webhooks"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/webhooks\"]"
            }
        }
        systemEvents = component "System event transport" "Delivers internal subscriptions to Core event consumers." "Go" {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/system"
            properties {
                "architecture.id" "firefly.core.systemEvents"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/system\"]"
            }
        }
    }
}
