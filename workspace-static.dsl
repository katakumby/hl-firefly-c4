// Generated from scripts/build_workspace.py and model_data.py. Rebuild after editing the source definitions.
workspace "FireFly ecosystem + private Besu" "C4 levels 1-3 with static dataflows; deployment validation excluded." {
    !identifiers hierarchical
    !impliedRelationships false
    properties {
        "structurizr.inspection.workspace.scope" "info"
    }
    !docs docs/static/workspace
    !adrs docs/static/decisions
    model {
        developer = person "Application developer" "Builds and tests member business integrations." {
            url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
            properties {
                "architecture.id" "developer"
                "evidence" "Reference choice"
            }
        }
        operator = person "Consortium operator" "Operates member namespaces, recovery and the Besu network." {
            url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
            properties {
                "architecture.id" "operator"
                "evidence" "Reference choice"
            }
        }
        business = person "Business user" "Submits consortium business actions through a member application." {
            url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
            properties {
                "architecture.id" "business"
                "evidence" "Reference choice"
            }
        }
        firefly = softwareSystem "Hyperledger FireFly" "Reusable supernode architecture; each consortium member deploys an isolated instance." {
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d"
            properties {
                "architecture.id" "firefly"
                "evidence" "Implementation"
            }
            !docs docs/static/system
            !adrs docs/static/decisions
            core = container "FireFly Core" "Exposes member APIs and bundled Explorer; orchestrates multiparty operations." "Go + React" {
                url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator"
                properties {
                    "architecture.id" "firefly.core"
                    "evidence" "Implementation"
                }
                api = component "REST API and routing" "Accepts namespace-scoped commands and queries." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/apiserver"
                    properties {
                        "architecture.id" "firefly.core.api"
                        "evidence" "Implementation"
                    }
                }
                explorer = component "Explorer UI" "Serves the bundled React operator interface." "React / TypeScript" {
                    url "https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5/src"
                    properties {
                        "architecture.id" "firefly.core.explorer"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.api "Queries messages, operations and network state" "In-process calls / Go" "Dataflow"
                }
                auth = component "API authentication" "Applies configured namespace authorization; Basic Auth reference plugin." "Go" {
                    url "https://github.com/hyperledger-firefly/common/tree/b91a1eb645e5bc39c54ed20ad0e917cff7d15d2e/pkg/auth"
                    properties {
                        "architecture.id" "firefly.core.auth"
                        "evidence" "Implementation"
                    }
                }
                namespaces = component "Namespace manager" "Initializes isolated orchestrators and configured plugins." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/namespace"
                    properties {
                        "architecture.id" "firefly.core.namespaces"
                        "evidence" "Implementation"
                    }
                }
                orchestrator = component "Orchestrator" "Coordinates API operations and subsystem lifecycles." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator"
                    properties {
                        "architecture.id" "firefly.core.orchestrator"
                        "evidence" "Implementation"
                    }
                }
                identity = component "Identity manager" "Resolves organizations, nodes and transaction signing identities." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/identity"
                    properties {
                        "architecture.id" "firefly.core.identity"
                        "evidence" "Implementation"
                    }
                }
                networkmap = component "Network map" "Indexes registered members, nodes and their endpoints." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/networkmap"
                    properties {
                        "architecture.id" "firefly.core.networkmap"
                        "evidence" "Implementation"
                    }
                }
                definitions = component "Definition exchange" "Publishes and processes schemas, interfaces and token definitions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/definitions"
                    properties {
                        "architecture.id" "firefly.core.definitions"
                        "evidence" "Implementation"
                    }
                }
                data = component "Data manager" "Validates, hashes and retrieves structured data and blob references." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/data"
                    properties {
                        "architecture.id" "firefly.core.data"
                        "evidence" "Implementation"
                    }
                }
                schema = component "Schema validation" "Checks JSON payloads against registered datatype definitions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/data"
                    properties {
                        "architecture.id" "firefly.core.schema"
                        "evidence" "Implementation"
                    }
                }
                batch = component "Batch manager" "Selects outbound messages and dispatches recoverable batches." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/batch"
                    properties {
                        "architecture.id" "firefly.core.batch"
                        "evidence" "Implementation"
                    }
                }
                batchprocessor = component "Batch processor" "Assembles ordered message batches and aggregate hashes." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/batch"
                    properties {
                        "architecture.id" "firefly.core.batchprocessor"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.data "Loads payloads for batch assembly" "In-process calls / Go" "Dataflow"
                }
                broadcast = component "Broadcast manager" "Publishes shared payloads and orchestrates ledger pinning." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/broadcast"
                    properties {
                        "architecture.id" "firefly.core.broadcast"
                        "evidence" "Implementation"
                    }
                }
                private = component "Private messaging and groups" "Routes messages to recipient groups and coordinates delivery." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/privatemessaging"
                    properties {
                        "architecture.id" "firefly.core.private"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.identity "Resolves group recipients and endpoints" "In-process calls / Go" "Dataflow"
                }
                multiparty = component "Multiparty manager" "Coordinates network actions and FireFly contract pinning." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/multiparty"
                    properties {
                        "architecture.id" "firefly.core.multiparty"
                        "evidence" "Implementation"
                    }
                }
                download = component "Shared download manager" "Retrieves referenced broadcast batches and blobs." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/shareddownload"
                    properties {
                        "architecture.id" "firefly.core.download"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.data "Validates downloaded data and stores metadata" "In-process calls / Go" "Dataflow"
                }
                contracts = component "Contract manager" "Maps FFIs and APIs to contract calls and event listeners." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/contracts"
                    properties {
                        "architecture.id" "firefly.core.contracts"
                        "evidence" "Implementation"
                    }
                }
                assets = component "Asset manager" "Coordinates token pools, balances and transfers." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/assets"
                    properties {
                        "architecture.id" "firefly.core.assets"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.contracts "Resolves token contract interfaces" "In-process calls / Go" "Dataflow"
                }
                operations = component "Operations manager" "Tracks asynchronous connector requests and results." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/operations"
                    properties {
                        "architecture.id" "firefly.core.operations"
                        "evidence" "Implementation"
                    }
                }
                txhelper = component "Transaction helper" "Correlates operations, messages and blockchain transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/txcommon"
                    properties {
                        "architecture.id" "firefly.core.txhelper"
                        "evidence" "Implementation"
                    }
                }
                txwriter = component "Transaction writer" "Batches transaction persistence and submission work." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/txwriter"
                    properties {
                        "architecture.id" "firefly.core.txwriter"
                        "evidence" "Implementation"
                    }
                }
                aggregator = component "Inbound event aggregator" "Correlates ledger pins with payloads and sequences confirmed messages." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/aggregator.go"
                    properties {
                        "architecture.id" "firefly.core.aggregator"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.download "Requests missing shared data" "In-process calls / Go" "Dataflow"
                }
                subscriptions = component "Subscription manager" "Filters events and persists subscriber offsets." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/subscription_manager.go"
                    properties {
                        "architecture.id" "firefly.core.subscriptions"
                        "evidence" "Implementation"
                    }
                }
                dispatcher = component "Event dispatcher" "Delivers ordered event batches and processes acknowledgements." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/event_dispatcher.go"
                    properties {
                        "architecture.id" "firefly.core.dispatcher"
                        "evidence" "Implementation"
                    }
                }
                syncasync = component "Sync/async bridge" "Correlates asynchronous completion with waiting API requests." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/syncasync"
                    properties {
                        "architecture.id" "firefly.core.syncasync"
                        "evidence" "Implementation"
                    }
                }
                cache = component "Cache manager" "Caches reusable namespace resources and lookups." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/cache"
                    properties {
                        "architecture.id" "firefly.core.cache"
                        "evidence" "Implementation"
                    }
                }
                metrics = component "Metrics" "Exposes runtime and operation measurements." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/metrics"
                    properties {
                        "architecture.id" "firefly.core.metrics"
                        "evidence" "Implementation"
                    }
                }
                spievents = component "SPI event manager" "Publishes internal lifecycle and namespace change events." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/spievents"
                    properties {
                        "architecture.id" "firefly.core.spievents"
                        "evidence" "Implementation"
                    }
                }
                blockchain = component "Blockchain plugin" "Defines blockchain operations and dispatches to the configured chain adapter." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain"
                    properties {
                        "architecture.id" "firefly.core.blockchain"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.aggregator "Delivers confirmed ledger events" "In-process calls / Go" "Dataflow"
                }
                database = component "Database plugin" "Defines transactional persistence and dispatches to the selected SQL adapter." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database"
                    properties {
                        "architecture.id" "firefly.core.database"
                        "evidence" "Implementation"
                    }
                }
                dataexchange = component "Data exchange plugin" "Binds message, blob and peer operations to the HTTPS connector." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/dataexchange"
                    properties {
                        "architecture.id" "firefly.core.dataexchange"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.aggregator "Delivers received payload notifications" "In-process calls / Go" "Dataflow"
                }
                sharedstorage = component "Shared storage plugin" "Publishes and retrieves content through IPFS APIs." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/sharedstorage"
                    properties {
                        "architecture.id" "firefly.core.sharedstorage"
                        "evidence" "Implementation"
                    }
                }
                tokens = component "Token plugin" "Binds standard token operations to remote token connectors." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/tokens"
                    properties {
                        "architecture.id" "firefly.core.tokens"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.aggregator "Delivers token creation and transfer events" "In-process calls / Go" "Dataflow"
                }
                identityplugin = component "Identity extension placeholder" "Registers the onchain compatibility placeholder; external identity resolution is not implemented." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/identity/tbd"
                    properties {
                        "architecture.id" "firefly.core.identityplugin"
                        "evidence" "Unfinished extension"
                    }
                }
                eventplugin = component "Event transport interface" "Binds subscriber delivery to a configured event transport." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events"
                    properties {
                        "architecture.id" "firefly.core.eventplugin"
                        "evidence" "Implementation"
                    }
                }
                config = component "Configuration and plugin initialization" "Loads namespace settings and initializes plugin factories." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/coreconfig"
                    properties {
                        "architecture.id" "firefly.core.config"
                        "evidence" "Implementation"
                    }
                }
                basicAuth = component "HTTP Basic authentication" "Verifies htpasswd bcrypt credentials for configured namespaces." "Go" {
                    url "https://github.com/hyperledger-firefly/common/tree/b91a1eb645e5bc39c54ed20ad0e917cff7d15d2e/pkg/auth/basic"
                    properties {
                        "architecture.id" "firefly.core.basicAuth"
                        "evidence" "Implementation"
                    }
                }
                ethereum = component "Ethereum blockchain adapter" "Maps Core operations to EVMConnect or legacy EthConnect." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain/ethereum"
                    properties {
                        "architecture.id" "firefly.core.ethereum"
                        "evidence" "Implementation"
                    }
                }
                fabricAdapter = component "Fabric blockchain adapter" "Maps chaincode operations and ledger events to FabConnect." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain/fabric"
                    properties {
                        "architecture.id" "firefly.core.fabricAdapter"
                        "evidence" "Implementation"
                    }
                }
                tezosAdapter = component "Tezos blockchain adapter" "Maps FireFly contract operations to TezosConnect." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain/tezos"
                    properties {
                        "architecture.id" "firefly.core.tezosAdapter"
                        "evidence" "Implementation"
                    }
                }
                cardanoAdapter = component "Cardano blockchain adapter" "Maps transactions and contract operations to CardanoConnect." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/blockchain/cardano"
                    properties {
                        "architecture.id" "firefly.core.cardanoAdapter"
                        "evidence" "Implementation"
                    }
                }
                postgres = component "PostgreSQL adapter" "Implements Core persistence through the shared SQL layer." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/postgres"
                    properties {
                        "architecture.id" "firefly.core.postgres"
                        "evidence" "Implementation"
                    }
                }
                sqlite = component "SQLite adapter" "Implements Core persistence in an embedded SQLite database." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/sqlite3"
                    properties {
                        "architecture.id" "firefly.core.sqlite"
                        "evidence" "Implementation"
                    }
                }
                sql = component "SQL persistence implementation" "Builds resource queries and transactions for SQL backends." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/sqlcommon"
                    properties {
                        "architecture.id" "firefly.core.sql"
                        "evidence" "Implementation"
                    }
                }
                ffdx = component "HTTPS Data Exchange adapter" "Maps private envelopes, blobs, peers and acknowledgements to FFDX." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/dataexchange/ffdx"
                    properties {
                        "architecture.id" "firefly.core.ffdx"
                        "evidence" "Implementation"
                    }
                }
                ipfs = component "IPFS shared-storage adapter" "Adds and retrieves broadcast content by CID." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/sharedstorage/ipfs"
                    properties {
                        "architecture.id" "firefly.core.ipfs"
                        "evidence" "Implementation"
                    }
                }
                fftokens = component "Token connector adapter" "Maps token operations and events to standard remote token APIs." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/tokens/fftokens"
                    properties {
                        "architecture.id" "firefly.core.fftokens"
                        "evidence" "Implementation"
                    }
                }
                websockets = component "WebSocket event transport" "Delivers subscription batches and consumes acknowledgements." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/websockets"
                    properties {
                        "architecture.id" "firefly.core.websockets"
                        "evidence" "Implementation"
                    }
                }
                webhooks = component "Webhook event transport" "Posts event batches to configured callback endpoints." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/webhooks"
                    properties {
                        "architecture.id" "firefly.core.webhooks"
                        "evidence" "Implementation"
                    }
                }
                systemEvents = component "System event transport" "Delivers internal subscriptions to Core event consumers." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/events/system"
                    properties {
                        "architecture.id" "firefly.core.systemEvents"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.aggregator "Routes internal subscription notifications" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.api {
                    -> firefly.core.auth "Passes request credentials for authorization" "In-process calls / Go" "Dataflow"
                    -> firefly.core.namespaces "Resolves the requested namespace" "In-process calls / Go" "Dataflow"
                    -> firefly.core.orchestrator "Submits validated commands and queries" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.namespaces {
                    -> firefly.core.orchestrator "Initializes namespace resources and plugins" "In-process calls / Go" "Dataflow"
                    -> firefly.core.spievents "Publishes namespace lifecycle changes" "In-process calls / Go" "Dataflow"
                    -> firefly.core.config "Loads namespace configuration and plugin selections" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.orchestrator {
                    -> firefly.core.syncasync "Waits for asynchronous request completion" "In-process calls / Go" "Dataflow"
                    -> firefly.core.identity "Resolves signing identities" "In-process calls / Go" "Dataflow"
                    -> firefly.core.multiparty "Submits consortium network actions" "In-process calls / Go" "Dataflow"
                    -> firefly.core.data "Submits payloads and datatype definitions" "In-process calls / Go" "Dataflow"
                    -> firefly.core.batch "Queues outbound messages" "In-process calls / Go" "Dataflow"
                    -> firefly.core.contracts "Submits contract queries and invocations" "In-process calls / Go" "Dataflow"
                    -> firefly.core.assets "Submits token pool and transfer requests" "In-process calls / Go" "Dataflow"
                    -> firefly.core.metrics "Records API and subsystem measurements" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.identity {
                    -> firefly.core.identityplugin "Initializes the configured onchain placeholder" "In-process calls / Go" "Dataflow"
                    -> firefly.core.networkmap "Looks up members and node endpoints" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.networkmap {
                    -> firefly.core.definitions "Registers shared member definitions" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.definitions {
                    -> firefly.core.broadcast "Publishes network definitions" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.multiparty {
                    -> firefly.core.blockchain "Submits contract pinning transactions" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.data {
                    -> firefly.core.schema "Validates structured payloads" "In-process calls / Go" "Dataflow"
                    -> firefly.core.database "Persists payload metadata and hashes" "In-process calls / Go" "Dataflow"
                    -> firefly.core.cache "Caches reusable data and schema lookups" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.batch {
                    -> firefly.core.batchprocessor "Assigns messages to recoverable batches" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.batchprocessor {
                    -> firefly.core.broadcast "Dispatches broadcast batches" "In-process calls / Go" "Dataflow"
                    -> firefly.core.private "Dispatches recipient-scoped batches" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.broadcast {
                    -> firefly.core.sharedstorage "Uploads broadcast payloads" "In-process calls / Go" "Dataflow"
                    -> firefly.core.multiparty "Pins batch hashes on the ledger" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.private {
                    -> firefly.core.dataexchange "Sends private payloads to recipient nodes" "In-process calls / Go" "Dataflow"
                    -> firefly.core.multiparty "Pins private batch hashes when requested" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.contracts {
                    -> firefly.core.blockchain "Submits ABI-backed calls and listeners" "In-process calls / Go" "Dataflow"
                    -> firefly.core.operations "Tracks contract operation completion" "In-process calls / Go" "Dataflow"
                    -> firefly.core.cache "Caches contract definitions" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.assets {
                    -> firefly.core.tokens "Requests standard token operations" "In-process calls / Go" "Dataflow"
                    -> firefly.core.operations "Tracks token operation completion" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.operations {
                    -> firefly.core.txhelper "Correlates operation and transaction identifiers" "In-process calls / Go" "Dataflow"
                    -> firefly.core.database "Persists operation state and retries" "In-process calls / Go" "Dataflow"
                    -> firefly.core.metrics "Records operation outcomes" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.txhelper {
                    -> firefly.core.txwriter "Queues transaction records for persistence" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.txwriter {
                    -> firefly.core.database "Flushes transaction records" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.download {
                    -> firefly.core.sharedstorage "Fetches content-addressed batches and blobs" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.aggregator {
                    -> firefly.core.database "Persists sequenced events and message state" "In-process calls / Go" "Dataflow"
                    -> firefly.core.subscriptions "Publishes locally ordered events" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.subscriptions {
                    -> firefly.core.database "Persists subscriptions and acknowledged offsets" "In-process calls / Go" "Dataflow"
                    -> firefly.core.dispatcher "Dispatches filtered event batches" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.dispatcher {
                    -> firefly.core.eventplugin "Delivers events via configured transports" "In-process calls / Go" "Dataflow"
                    -> firefly.core.syncasync "Completes waiting requests" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.spievents {
                    -> firefly.core.eventplugin "Publishes system notifications" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.auth {
                    -> firefly.core.basicAuth "Verifies configured Basic credentials" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.blockchain {
                    -> firefly.core.ethereum "Dispatches EVM operations when configured" "In-process calls / Go" "Dataflow"
                    -> firefly.core.fabricAdapter "Dispatches Fabric operations when configured" "In-process calls / Go" "Dataflow"
                    -> firefly.core.tezosAdapter "Dispatches Tezos operations when configured" "In-process calls / Go" "Dataflow"
                    -> firefly.core.cardanoAdapter "Dispatches Cardano operations when configured" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.database {
                    -> firefly.core.postgres "Dispatches PostgreSQL persistence when configured" "In-process calls / Go" "Dataflow"
                    -> firefly.core.sqlite "Dispatches embedded SQLite persistence when configured" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.postgres {
                    -> firefly.core.sql "Executes PostgreSQL resource queries and transactions" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.sqlite {
                    -> firefly.core.sql "Executes SQLite resource queries and transactions" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.dataexchange {
                    -> firefly.core.ffdx "Dispatches private data-transfer operations" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.sharedstorage {
                    -> firefly.core.ipfs "Dispatches shared-content operations" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.tokens {
                    -> firefly.core.fftokens "Dispatches standard token operations" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.eventplugin {
                    -> firefly.core.websockets "Delivers WebSocket subscription batches" "In-process calls / Go" "Dataflow"
                    -> firefly.core.webhooks "Delivers webhook subscription batches" "In-process calls / Go" "Dataflow"
                    -> firefly.core.systemEvents "Delivers internal subscription batches" "In-process calls / Go" "Dataflow"
                }
            }
            evm = container "EVMConnect + FFTM" "Submits Ethereum transactions and streams confirmed events; one nonce writer." "Go" {
                url "https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go"
                properties {
                    "architecture.id" "firefly.evm"
                    "evidence" "Implementation"
                }
                api = component "Connector REST API" "Accepts transaction, query and event-stream requests." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/cmd/evmconnect.go"
                    properties {
                        "architecture.id" "firefly.evm.api"
                        "evidence" "Implementation"
                    }
                }
                manager = component "Transaction manager" "Coordinates durable transaction and stream lifecycles." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/fftm"
                    properties {
                        "architecture.id" "firefly.evm.manager"
                        "evidence" "Implementation"
                    }
                }
                handler = component "Transaction policy handler" "Schedules signing, submission, gas and retry policy." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/txhandler"
                    properties {
                        "architecture.id" "firefly.evm.handler"
                        "evidence" "Implementation"
                    }
                }
                nonce = component "Nonce allocation" "Assigns and persists ordered nonces per signing address." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence"
                    properties {
                        "architecture.id" "firefly.evm.nonce"
                        "evidence" "Implementation"
                    }
                }
                abi = component "EVM API adapter" "Encodes ABIs and implements the blockchain connector API." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/internal/ethereum"
                    properties {
                        "architecture.id" "firefly.evm.abi"
                        "evidence" "Implementation"
                    }
                }
                rpc = component "Ethereum JSON-RPC client" "Submits calls and transactions through the signing proxy." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/pkg/ethrpc"
                    properties {
                        "architecture.id" "firefly.evm.rpc"
                        "evidence" "Implementation"
                    }
                }
                blocks = component "Block listener" "Tracks chain heads and block/filter updates." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/pkg/ethblocklistener"
                    properties {
                        "architecture.id" "firefly.evm.blocks"
                        "evidence" "Implementation"
                    }
                }
                receipts = component "Receipt tracking" "Polls receipt status for submitted transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/pkg/fftm"
                    properties {
                        "architecture.id" "firefly.evm.receipts"
                        "evidence" "Implementation"
                    }
                    -> firefly.evm.rpc "Queries transaction receipt status" "In-process calls / Go" "Dataflow"
                }
                confirmations = component "Confirmation manager" "Confirms receipts and events against the observed chain." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/confirmations"
                    properties {
                        "architecture.id" "firefly.evm.confirmations"
                        "evidence" "Implementation"
                    }
                }
                streams = component "Event streams" "Orders and batches confirmed listener events." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/events"
                    properties {
                        "architecture.id" "firefly.evm.streams"
                        "evidence" "Implementation"
                    }
                }
                delivery = component "WebSocket and webhook delivery" "Delivers batches and accepts consumer acknowledgements." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/ws"
                    properties {
                        "architecture.id" "firefly.evm.delivery"
                        "evidence" "Implementation"
                    }
                    -> firefly.evm.streams "Acknowledges consumed batches" "In-process calls / Go" "Dataflow"
                    -> firefly.core "Delivers confirmed event batches" "WebSocket / JSON" "Dataflow"
                }
                persistence = component "Persistence adapter" "Stores transactions, nonces, streams and checkpoints." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence"
                    properties {
                        "architecture.id" "firefly.evm.persistence"
                        "evidence" "Implementation"
                    }
                }
                postgres = component "PostgreSQL persistence" "Persists managed transactions and streams in SQL tables." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence/postgres"
                    properties {
                        "architecture.id" "firefly.evm.postgres"
                        "evidence" "Implementation"
                    }
                }
                leveldb = component "LevelDB persistence" "Persists transactions and stream state in local key-value files." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence/leveldb"
                    properties {
                        "architecture.id" "firefly.evm.leveldb"
                        "evidence" "Implementation"
                    }
                }
                blocklistener = component "Durable block notifications" "Coordinates block updates for listeners and confirmations." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/blocklistener"
                    properties {
                        "architecture.id" "firefly.evm.blocklistener"
                        "evidence" "Implementation"
                    }
                    -> firefly.evm.confirmations "Updates tracked canonical block history" "In-process calls / Go" "Dataflow"
                }
                metrics = component "Transaction and stream metrics" "Records transaction and event-processing measurements." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/metrics"
                    properties {
                        "architecture.id" "firefly.evm.metrics"
                        "evidence" "Implementation"
                    }
                }
                webhook = component "Webhook batch delivery" "Delivers event batches using configured HTTP callbacks." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/events"
                    properties {
                        "architecture.id" "firefly.evm.webhook"
                        "evidence" "Implementation"
                    }
                }
                !element firefly.evm.api {
                    -> firefly.evm.manager "Submits transaction and stream requests" "In-process calls / Go" "Dataflow"
                }
                !element firefly.evm.manager {
                    -> firefly.evm.handler "Schedules managed transaction processing" "In-process calls / Go" "Dataflow"
                    -> firefly.evm.streams "Configures listeners and stream lifecycle" "In-process calls / Go" "Dataflow"
                    -> firefly.evm.persistence "Persists transaction lifecycle state" "In-process calls / Go" "Dataflow"
                    -> firefly.evm.metrics "Records transaction processing measurements" "In-process calls / Go" "Dataflow"
                }
                !element firefly.evm.handler {
                    -> firefly.evm.nonce "Allocates the next sender nonce" "In-process calls / Go" "Dataflow"
                    -> firefly.evm.abi "Prepares calls and encoded transactions" "In-process calls / Go" "Dataflow"
                    -> firefly.evm.receipts "Tracks submitted transaction receipts" "In-process calls / Go" "Dataflow"
                }
                !element firefly.evm.nonce {
                    -> firefly.evm.persistence "Persists sender transaction ordering" "In-process calls / Go" "Dataflow"
                }
                !element firefly.evm.abi {
                    -> firefly.evm.rpc "Issues Ethereum JSON-RPC requests" "In-process calls / Go" "Dataflow"
                }
                !element firefly.evm.rpc {
                    -> firefly.evm.blocks "Returns block and filter responses" "In-process calls / Go" "Dataflow"
                }
                !element firefly.evm.blocks {
                    -> firefly.evm.confirmations "Publishes chain head updates" "In-process calls / Go" "Dataflow"
                    -> firefly.evm.blocklistener "Supplies blockchain head notifications" "In-process calls / Go" "Dataflow"
                }
                !element firefly.evm.receipts {
                    -> firefly.evm.confirmations "Submits receipts for confirmation" "In-process calls / Go" "Dataflow"
                }
                !element firefly.evm.confirmations {
                    -> firefly.evm.streams "Releases confirmed blockchain events" "In-process calls / Go" "Dataflow"
                }
                !element firefly.evm.streams {
                    -> firefly.evm.delivery "Delivers ordered event batches" "In-process calls / Go" "Dataflow"
                    -> firefly.evm.persistence "Persists acknowledged checkpoints" "In-process calls / Go" "Dataflow"
                    -> firefly.evm.webhook "Dispatches batches when webhook delivery is selected" "In-process calls / Go" "Dataflow"
                    -> firefly.evm.metrics "Records event-processing measurements" "In-process calls / Go" "Dataflow"
                }
                !element firefly.evm.persistence {
                    -> firefly.evm.postgres "Writes state through the selected PostgreSQL backend" "In-process calls / Go" "Dataflow"
                    -> firefly.evm.leveldb "Writes state through the selected LevelDB backend" "In-process calls / Go" "Dataflow"
                }
                -> firefly.core "Streams confirmed events and transaction results" "WebSocket / JSON" "Dataflow"
            }
            signer = container "FireFly Signer" "Signs member transactions and proxies Ethereum RPC calls." "Go" {
                url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                properties {
                    "architecture.id" "firefly.signer"
                    "evidence" "Implementation"
                }
                proxy = component "JSON-RPC proxy" "Intercepts transaction requests and forwards read calls." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                    properties {
                        "architecture.id" "firefly.signer.proxy"
                        "evidence" "Implementation"
                    }
                }
                wallet = component "Filesystem wallet" "Loads member keystore files and resolves signing accounts." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                    properties {
                        "architecture.id" "firefly.signer.wallet"
                        "evidence" "Implementation"
                    }
                }
                keystore = component "Keystore V3 decoder" "Decrypts encrypted account key files." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/keystorev3"
                    properties {
                        "architecture.id" "firefly.signer.keystore"
                        "evidence" "Implementation"
                    }
                }
                signing = component "Ethereum signing" "Encodes and signs EIP-155 and EIP-1559 transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/ethsigner"
                    properties {
                        "architecture.id" "firefly.signer.signing"
                        "evidence" "Implementation"
                    }
                    -> firefly.signer.wallet "Retrieves the selected signing key" "In-process calls / Go" "Dataflow"
                }
                backend = component "RPC backend" "Forwards signed raw transactions to Besu." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/rpcbackend"
                    properties {
                        "architecture.id" "firefly.signer.backend"
                        "evidence" "Implementation"
                    }
                }
                !element firefly.signer.proxy {
                    -> firefly.signer.wallet "Resolves requested signing accounts" "In-process calls / Go" "Dataflow"
                    -> firefly.signer.signing "Submits transactions for signing" "In-process calls / Go" "Dataflow"
                    -> firefly.signer.backend "Forwards unmodified RPC read requests" "In-process calls / Go" "Dataflow"
                }
                !element firefly.signer.wallet {
                    -> firefly.signer.keystore "Decrypts selected key material" "In-process calls / Go" "Dataflow"
                }
                !element firefly.signer.signing {
                    -> firefly.signer.backend "Submits signed raw transactions" "In-process calls / Go" "Dataflow"
                }
            }
            dx = container "HTTPS Data Exchange" "Exchanges private envelopes and blobs with authenticated members." "TypeScript / Node.js" {
                tags "Private"
                url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src"
                properties {
                    "architecture.id" "firefly.dx"
                    "evidence" "Implementation"
                }
                api = component "Internal REST API" "Accepts private messages, blobs and peer configuration." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/api.ts"
                    properties {
                        "architecture.id" "firefly.dx.api"
                        "evidence" "Implementation"
                    }
                }
                peers = component "Peer and certificate registry" "Resolves remote endpoints and trusted peer certificates." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/lib"
                    properties {
                        "architecture.id" "firefly.dx.peers"
                        "evidence" "Implementation"
                    }
                }
                p2p = component "Mutual TLS peer endpoint" "Authenticates remote members and transfers private data." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/p2p.ts"
                    properties {
                        "architecture.id" "firefly.dx.p2p"
                        "evidence" "Implementation"
                    }
                }
                messages = component "Message transfer handler" "Sends and receives recipient-scoped message envelopes." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/messages.ts"
                    properties {
                        "architecture.id" "firefly.dx.messages"
                        "evidence" "Implementation"
                    }
                    -> firefly.dx.peers "Resolves destination and trust material" "In-process calls / TypeScript" "Dataflow"
                    -> firefly.dx.p2p "Transfers private message envelopes" "In-process calls / TypeScript" "Dataflow"
                }
                blobs = component "Blob transfer handler" "Streams binary content to durable member storage." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                    properties {
                        "architecture.id" "firefly.dx.blobs"
                        "evidence" "Implementation"
                    }
                    -> firefly.dx.p2p "Transfers encrypted blob streams" "In-process calls / TypeScript" "Dataflow"
                }
                events = component "Event queue and acknowledgements" "Queues delivery notifications in memory and processes acknowledgements." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/events.ts"
                    properties {
                        "architecture.id" "firefly.dx.events"
                        "evidence" "Implementation"
                    }
                    -> firefly.dx.api "Delivers notifications and receives acknowledgements" "In-process calls / TypeScript" "Dataflow"
                    -> firefly.core "Delivers message and blob transfer notifications" "WebSocket / JSON" "Dataflow"
                }
                !element firefly.dx.api {
                    -> firefly.dx.peers "Updates peer endpoints and certificates" "In-process calls / TypeScript" "Dataflow"
                    -> firefly.dx.messages "Submits recipient-scoped messages" "In-process calls / TypeScript" "Dataflow"
                    -> firefly.dx.blobs "Uploads private binary content" "In-process calls / TypeScript" "Dataflow"
                }
                !element firefly.dx.p2p {
                    -> firefly.dx.messages "Delivers authenticated inbound messages" "In-process calls / TypeScript" "Dataflow"
                    -> firefly.dx.blobs "Stores authenticated inbound blobs" "In-process calls / TypeScript" "Dataflow"
                }
                !element firefly.dx.messages {
                    -> firefly.dx.events "Enqueues message delivery results" "In-process calls / TypeScript" "Dataflow"
                }
                !element firefly.dx.blobs {
                    -> firefly.dx.events "Enqueues blob delivery results" "In-process calls / TypeScript" "Dataflow"
                }
                -> firefly.core "Delivers transfer notifications and awaits ACKs" "WebSocket / JSON" "Dataflow"
            }
            erc20 = container "ERC-20 / ERC-721 connector" "Maps fungible and non-fungible token APIs to EVM contracts." "TypeScript / NestJS" {
                url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src"
                properties {
                    "architecture.id" "firefly.erc20"
                    "evidence" "Implementation"
                }
                api = component "Token REST controller" "Accepts pool, mint, burn, transfer and approval requests." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.controller.ts"
                    properties {
                        "architecture.id" "firefly.erc20.api"
                        "evidence" "Implementation"
                    }
                }
                service = component "Token service" "Applies token-specific behavior and tracks pools." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.service.ts"
                    properties {
                        "architecture.id" "firefly.erc20.service"
                        "evidence" "Implementation"
                    }
                }
                mapper = component "ABI and standard adapters" "Maps token operations to contract ABIs." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens"
                    properties {
                        "architecture.id" "firefly.erc20.mapper"
                        "evidence" "Implementation"
                    }
                }
                blockchain = component "Blockchain connector client" "Submits contract calls through EVMConnect." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/blockchain.service.ts"
                    properties {
                        "architecture.id" "firefly.erc20.blockchain"
                        "evidence" "Implementation"
                    }
                    -> firefly.evm "Submits contract calls and listeners" "HTTP REST / JSON" "Dataflow"
                }
                listener = component "Token event listener" "Interprets contract logs as standard token events." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.listener.ts"
                    properties {
                        "architecture.id" "firefly.erc20.listener"
                        "evidence" "Implementation"
                    }
                    -> firefly.erc20.service "Updates token pool state" "In-process calls / TypeScript" "Dataflow"
                }
                stream = component "Connector event stream" "Receives ordered blockchain events and acknowledges batches." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/event-stream"
                    properties {
                        "architecture.id" "firefly.erc20.stream"
                        "evidence" "Implementation"
                    }
                    -> firefly.erc20.listener "Delivers token contract logs" "In-process calls / TypeScript" "Dataflow"
                }
                proxy = component "Core event proxy" "Delivers token events to Core over WebSocket." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/eventstream-proxy"
                    properties {
                        "architecture.id" "firefly.erc20.proxy"
                        "evidence" "Implementation"
                    }
                    -> firefly.erc20.stream "Acknowledges consumed event batches" "In-process calls / TypeScript" "Dataflow"
                    -> firefly.core "Delivers token events and receives ACKs" "WebSocket / JSON" "Dataflow"
                }
                !element firefly.erc20.api {
                    -> firefly.erc20.service "Submits standard token operations" "In-process calls / TypeScript" "Dataflow"
                }
                !element firefly.erc20.service {
                    -> firefly.erc20.mapper "Encodes token contract calls" "In-process calls / TypeScript" "Dataflow"
                }
                !element firefly.erc20.mapper {
                    -> firefly.erc20.blockchain "Passes encoded contract requests" "In-process calls / TypeScript" "Dataflow"
                }
                !element firefly.erc20.blockchain {
                    -> firefly.erc20.stream "Registers contract event listeners" "In-process calls / TypeScript" "Dataflow"
                }
                !element firefly.erc20.listener {
                    -> firefly.erc20.proxy "Publishes normalized token events" "In-process calls / TypeScript" "Dataflow"
                }
                -> firefly.core "Delivers normalized token events" "WebSocket / JSON" "Dataflow"
                -> firefly.evm "Submits contract calls and consumes event streams" "HTTP REST + WebSocket" "Dataflow"
            }
            erc1155 = container "ERC-1155 connector" "Maps multi-token operations and events to FireFly." "TypeScript / NestJS" {
                url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src"
                properties {
                    "architecture.id" "firefly.erc1155"
                    "evidence" "Implementation"
                }
                api = component "Token REST controller" "Accepts pool, mint, burn, transfer and approval requests." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.controller.ts"
                    properties {
                        "architecture.id" "firefly.erc1155.api"
                        "evidence" "Implementation"
                    }
                }
                service = component "Token service" "Applies token-specific behavior and tracks pools." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.service.ts"
                    properties {
                        "architecture.id" "firefly.erc1155.service"
                        "evidence" "Implementation"
                    }
                }
                mapper = component "ABI and standard adapters" "Maps token operations to contract ABIs." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens"
                    properties {
                        "architecture.id" "firefly.erc1155.mapper"
                        "evidence" "Implementation"
                    }
                }
                blockchain = component "Blockchain connector client" "Submits contract calls through EVMConnect." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/blockchain.service.ts"
                    properties {
                        "architecture.id" "firefly.erc1155.blockchain"
                        "evidence" "Implementation"
                    }
                    -> firefly.evm "Submits contract calls and listeners" "HTTP REST / JSON" "Dataflow"
                }
                listener = component "Token event listener" "Interprets contract logs as standard token events." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.listener.ts"
                    properties {
                        "architecture.id" "firefly.erc1155.listener"
                        "evidence" "Implementation"
                    }
                    -> firefly.erc1155.service "Updates token pool state" "In-process calls / TypeScript" "Dataflow"
                }
                stream = component "Connector event stream" "Receives ordered blockchain events and acknowledges batches." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/event-stream"
                    properties {
                        "architecture.id" "firefly.erc1155.stream"
                        "evidence" "Implementation"
                    }
                    -> firefly.erc1155.listener "Delivers token contract logs" "In-process calls / TypeScript" "Dataflow"
                }
                proxy = component "Core event proxy" "Delivers token events to Core over WebSocket." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/eventstream-proxy"
                    properties {
                        "architecture.id" "firefly.erc1155.proxy"
                        "evidence" "Implementation"
                    }
                    -> firefly.erc1155.stream "Acknowledges consumed event batches" "In-process calls / TypeScript" "Dataflow"
                    -> firefly.core "Delivers token events and receives ACKs" "WebSocket / JSON" "Dataflow"
                }
                !element firefly.erc1155.api {
                    -> firefly.erc1155.service "Submits standard token operations" "In-process calls / TypeScript" "Dataflow"
                }
                !element firefly.erc1155.service {
                    -> firefly.erc1155.mapper "Encodes token contract calls" "In-process calls / TypeScript" "Dataflow"
                }
                !element firefly.erc1155.mapper {
                    -> firefly.erc1155.blockchain "Passes encoded contract requests" "In-process calls / TypeScript" "Dataflow"
                }
                !element firefly.erc1155.blockchain {
                    -> firefly.erc1155.stream "Registers contract event listeners" "In-process calls / TypeScript" "Dataflow"
                }
                !element firefly.erc1155.listener {
                    -> firefly.erc1155.proxy "Publishes normalized token events" "In-process calls / TypeScript" "Dataflow"
                }
                -> firefly.core "Delivers normalized token events" "WebSocket / JSON" "Dataflow"
                -> firefly.evm "Submits contract calls and consumes event streams" "HTTP REST + WebSocket" "Dataflow"
            }
            ipfs = container "IPFS Kubo" "Publishes and retrieves consortium-shared content." "Go / Kubo" {
                tags "Shared"
                url "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                properties {
                    "architecture.id" "firefly.ipfs"
                    "evidence" "Implementation"
                }
            }
            pg = container "PostgreSQL primary" "Stores Core and FFTM in separate databases with separate credentials." "PostgreSQL / CloudNativePG" {
                tags "Database,Private"
                url "https://cloudnative-pg.io/docs/1.28/replication/"
                properties {
                    "architecture.id" "firefly.pg"
                    "evidence" "Implementation"
                }
            }
            pgReplica = container "PostgreSQL standby" "Replicates this member's primary; eligible for fenced promotion." "PostgreSQL / CloudNativePG" {
                tags "Database,Private"
                url "https://cloudnative-pg.io/docs/1.28/replication/"
                properties {
                    "architecture.id" "firefly.pgReplica"
                    "evidence" "Implementation"
                }
            }
            blobs = container "Private blob and peer store" "Stores private binary payloads and peer metadata; storage-class placement is deferred." "Filesystem / Premium SSD ZRS" {
                tags "Database,Private"
                url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                properties {
                    "architecture.id" "firefly.blobs"
                    "evidence" "Implementation"
                }
            }
            ipfsRepo = container "IPFS repository" "Stores Kubo identity, pins and content blocks; storage-class placement is deferred." "Filesystem / Premium SSD ZRS" {
                tags "Database,Shared"
                url "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                properties {
                    "architecture.id" "firefly.ipfsRepo"
                    "evidence" "Implementation"
                }
            }
            secrets = container "Member keys and configuration" "Stores signing keystores, mTLS material and configuration; Kubernetes projection belongs to the deferred deployment reference." "Kubernetes Secrets" {
                tags "Database,Private"
                url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                properties {
                    "architecture.id" "firefly.secrets"
                    "evidence" "Implementation"
                }
            }
            sqlite = container "Core SQLite file" "Optional embedded Core database; no independent database server." "SQLite / filesystem" {
                tags "Database,Optional"
                url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/database/sqlite3"
                properties {
                    "architecture.id" "firefly.sqlite"
                    "evidence" "Implementation"
                }
            }
            leveldb = container "FFTM LevelDB files" "Optional embedded transaction and stream persistence." "LevelDB / filesystem" {
                tags "Database,Optional"
                url "https://github.com/hyperledger-firefly/transaction-manager/tree/5915cbc4e0e30dea25068b770dadbcc8bdfa9321/internal/persistence/leveldb"
                properties {
                    "architecture.id" "firefly.leveldb"
                    "evidence" "Implementation"
                }
            }
            ethconnect = container "EthConnect (legacy option)" "Original Ethereum connector; REST/direct and optional Kafka bridge configurations." "Go" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0"
                properties {
                    "architecture.id" "firefly.ethconnect"
                    "evidence" "Implementation"
                }
                rest = component "REST gateway and authorization" "Accepts requests and dispatches direct or asynchronous processing." "Go" {
                    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/rest"
                    properties {
                        "architecture.id" "firefly.ethconnect.rest"
                        "evidence" "Implementation"
                    }
                }
                auth = component "Authorization extension" "Applies configured request authorization hooks." "Go" {
                    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/auth"
                    properties {
                        "architecture.id" "firefly.ethconnect.auth"
                        "evidence" "Implementation"
                    }
                }
                contracts = component "Contract gateway" "Builds ABI-backed REST APIs and routes contract operations." "Go" {
                    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/contractgateway"
                    properties {
                        "architecture.id" "firefly.ethconnect.contracts"
                        "evidence" "Implementation"
                    }
                }
                registry = component "Contract registry and ABI metadata" "Stores deployed contract interfaces and resolves contract addresses." "Go" {
                    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/contractregistry"
                    properties {
                        "architecture.id" "firefly.ethconnect.registry"
                        "evidence" "Implementation"
                    }
                }
                openapi = component "OpenAPI generation" "Generates request schemas from contract ABIs." "Go" {
                    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/openapi"
                    properties {
                        "architecture.id" "firefly.ethconnect.openapi"
                        "evidence" "Implementation"
                    }
                }
                transactions = component "Transaction processor" "Allocates nonces, submits transactions and waits for receipts." "Go" {
                    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/tx"
                    properties {
                        "architecture.id" "firefly.ethconnect.transactions"
                        "evidence" "Implementation"
                    }
                }
                rpc = component "Ethereum RPC and ABI binding" "Encodes transactions, calls RPC and supports external signing." "Go" {
                    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/eth"
                    properties {
                        "architecture.id" "firefly.ethconnect.rpc"
                        "evidence" "Implementation"
                    }
                    -> firefly.signer "Requests Ethereum transaction signing and RPC forwarding" "HTTP JSON-RPC" "Dataflow"
                }
                events = component "Event subscriptions and confirmations" "Polls contract logs, confirms and batches them for delivery." "Go" {
                    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/events"
                    properties {
                        "architecture.id" "firefly.ethconnect.events"
                        "evidence" "Implementation"
                    }
                    -> firefly.ethconnect.rpc "Polls blocks and contract logs" "In-process calls / Go" "Dataflow"
                }
                websockets = component "WebSocket delivery" "Maintains event clients and acknowledgements." "Go" {
                    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/ws"
                    properties {
                        "architecture.id" "firefly.ethconnect.websockets"
                        "evidence" "Implementation"
                    }
                    -> firefly.core "Delivers confirmed contract event batches" "WebSocket / JSON" "Dataflow"
                }
                kafka = component "Kafka bridge" "Consumes transaction requests and publishes replies in Kafka mode." "Go" {
                    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kafka"
                    properties {
                        "architecture.id" "firefly.ethconnect.kafka"
                        "evidence" "Implementation"
                    }
                    -> firefly.ethconnect.transactions "Dispatches consumed transaction requests" "In-process calls / Go" "Dataflow"
                }
                receipts = component "Receipt store" "Persists transaction outcomes in a configured receipt backend." "Go" {
                    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts"
                    properties {
                        "architecture.id" "firefly.ethconnect.receipts"
                        "evidence" "Implementation"
                    }
                }
                kv = component "Embedded key-value storage" "Stores event subscriptions and registry data in LevelDB." "Go" {
                    url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kvstore"
                    properties {
                        "architecture.id" "firefly.ethconnect.kv"
                        "evidence" "Implementation"
                    }
                }
                !element firefly.ethconnect.rest {
                    -> firefly.ethconnect.auth "Checks configured authorization hooks" "In-process calls / Go" "Dataflow"
                    -> firefly.ethconnect.contracts "Routes ABI-backed contract requests" "In-process calls / Go" "Dataflow"
                    -> firefly.ethconnect.transactions "Dispatches direct transaction requests" "In-process calls / Go" "Dataflow"
                    -> firefly.ethconnect.kafka "Publishes requests in Kafka bridge mode" "In-process calls / Go" "Dataflow"
                }
                !element firefly.ethconnect.contracts {
                    -> firefly.ethconnect.registry "Resolves contract addresses and interfaces" "In-process calls / Go" "Dataflow"
                    -> firefly.ethconnect.openapi "Generates contract request schemas" "In-process calls / Go" "Dataflow"
                    -> firefly.ethconnect.transactions "Dispatches transaction requests" "In-process calls / Go" "Dataflow"
                }
                !element firefly.ethconnect.transactions {
                    -> firefly.ethconnect.rpc "Encodes and submits Ethereum transactions" "In-process calls / Go" "Dataflow"
                    -> firefly.ethconnect.receipts "Persists completed transaction outcomes" "In-process calls / Go" "Dataflow"
                }
                !element firefly.ethconnect.events {
                    -> firefly.ethconnect.websockets "Delivers confirmed event batches" "In-process calls / Go" "Dataflow"
                    -> firefly.ethconnect.kv "Persists subscriptions and checkpoints" "In-process calls / Go" "Dataflow"
                }
                !element firefly.ethconnect.registry {
                    -> firefly.ethconnect.kv "Persists contract metadata" "In-process calls / Go" "Dataflow"
                }
                -> firefly.signer "Submits unsigned transactions and read requests" "HTTP JSON-RPC" "Dataflow"
                -> firefly.core "Delivers confirmed contract events and transaction results" "WebSocket / JSON" "Dataflow"
            }
            ethconnectState = container "EthConnect local state" "Optional LevelDB receipts, subscriptions and contract metadata." "LevelDB / filesystem" {
                tags "Database,Optional"
                url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kvstore"
                properties {
                    "architecture.id" "firefly.ethconnectState"
                    "evidence" "Implementation"
                }
            }
            fabconnect = container "FabConnect" "Fabric transaction, identity and ledger-event connector." "Go / Fabric SDK" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b"
                properties {
                    "architecture.id" "firefly.fabconnect"
                    "evidence" "Implementation"
                }
                rest = component "REST gateway and dispatch" "Routes identity, transaction and receipt requests." "Go" {
                    url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest"
                    properties {
                        "architecture.id" "firefly.fabconnect.rest"
                        "evidence" "Implementation"
                    }
                }
                auth = component "Authorization extension" "Applies configured API authorization hooks." "Go" {
                    url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/auth"
                    properties {
                        "architecture.id" "firefly.fabconnect.auth"
                        "evidence" "Implementation"
                    }
                }
                identity = component "Identity enrollment API" "Registers and enrolls Fabric signing identities." "Go" {
                    url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest/identity"
                    properties {
                        "architecture.id" "firefly.fabconnect.identity"
                        "evidence" "Implementation"
                    }
                }
                transactions = component "Transaction processor" "Submits chaincode transactions and tracks completion." "Go" {
                    url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/tx"
                    properties {
                        "architecture.id" "firefly.fabconnect.transactions"
                        "evidence" "Implementation"
                    }
                }
                client = component "Fabric clients and wallet" "Uses connection profiles or discovery to access peers and ordering services." "Go" {
                    url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client"
                    properties {
                        "architecture.id" "firefly.fabconnect.client"
                        "evidence" "Implementation"
                    }
                }
                events = component "Event subscriptions and checkpoints" "Filters Fabric events and manages delivery checkpoints." "Go" {
                    url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/events"
                    properties {
                        "architecture.id" "firefly.fabconnect.events"
                        "evidence" "Implementation"
                    }
                    -> firefly.fabconnect.client "Subscribes to Fabric ledger events" "In-process calls / Go" "Dataflow"
                }
                websockets = component "WebSocket delivery" "Delivers event batches and consumes acknowledgements." "Go" {
                    url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/ws"
                    properties {
                        "architecture.id" "firefly.fabconnect.websockets"
                        "evidence" "Implementation"
                    }
                    -> firefly.core "Delivers acknowledged Fabric event batches" "WebSocket / JSON" "Dataflow"
                }
                kafka = component "Kafka bridge" "Supports optional asynchronous transaction request/reply messaging." "Go" {
                    url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/kafka"
                    properties {
                        "architecture.id" "firefly.fabconnect.kafka"
                        "evidence" "Implementation"
                    }
                    -> firefly.fabconnect.transactions "Dispatches consumed transaction requests" "In-process calls / Go" "Dataflow"
                }
                receipts = component "Receipt persistence" "Stores transaction results in configured receipt backends." "Go" {
                    url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/rest/receipt"
                    properties {
                        "architecture.id" "firefly.fabconnect.receipts"
                        "evidence" "Implementation"
                    }
                }
                kv = component "Key-value persistence" "Persists connector event state in LevelDB." "Go" {
                    url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/kvstore"
                    properties {
                        "architecture.id" "firefly.fabconnect.kv"
                        "evidence" "Implementation"
                    }
                }
                !element firefly.fabconnect.rest {
                    -> firefly.fabconnect.auth "Checks configured authorization hooks" "In-process calls / Go" "Dataflow"
                    -> firefly.fabconnect.identity "Routes identity enrollment requests" "In-process calls / Go" "Dataflow"
                    -> firefly.fabconnect.transactions "Dispatches chaincode transaction requests" "In-process calls / Go" "Dataflow"
                    -> firefly.fabconnect.kafka "Publishes requests in asynchronous Kafka mode" "In-process calls / Go" "Dataflow"
                }
                !element firefly.fabconnect.identity {
                    -> firefly.fabconnect.client "Registers and enrolls signing identities" "In-process calls / Go" "Dataflow"
                }
                !element firefly.fabconnect.transactions {
                    -> firefly.fabconnect.client "Submits chaincode invocations" "In-process calls / Go" "Dataflow"
                    -> firefly.fabconnect.receipts "Persists transaction results" "In-process calls / Go" "Dataflow"
                }
                !element firefly.fabconnect.events {
                    -> firefly.fabconnect.websockets "Delivers filtered ledger event batches" "In-process calls / Go" "Dataflow"
                    -> firefly.fabconnect.kv "Persists subscriptions and checkpoints" "In-process calls / Go" "Dataflow"
                }
                -> firefly.core "Delivers Fabric events and transaction results" "WebSocket / JSON" "Dataflow"
            }
            fabricState = container "FabConnect local state" "Connector LevelDB state and Fabric wallet identity material." "LevelDB + wallet files" {
                tags "Database,Optional"
                url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client/store.go"
                properties {
                    "architecture.id" "firefly.fabricState"
                    "evidence" "Implementation"
                }
            }
            tezosconnect = container "TezosConnect + FFTM" "Tezos connector with its dependency-pinned embedded transaction manager." "Go" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b"
                properties {
                    "architecture.id" "firefly.tezosconnect"
                    "evidence" "Implementation"
                }
                api = component "Connector API and transaction manager" "Accepts and manages durable transaction and stream requests." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/pkg/fftm"
                    properties {
                        "architecture.id" "firefly.tezosconnect.api"
                        "evidence" "Implementation"
                    }
                }
                policy = component "Transaction policy and nonce management" "Schedules Tezos operation submission, retries and counter allocation." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/pkg/txhandler"
                    properties {
                        "architecture.id" "firefly.tezosconnect.policy"
                        "evidence" "Implementation"
                    }
                }
                adapter = component "Tezos operation adapter" "Prepares, queries, estimates and submits Tezos operations." "Go" {
                    url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos"
                    properties {
                        "architecture.id" "firefly.tezosconnect.adapter"
                        "evidence" "Implementation"
                    }
                }
                signing = component "Remote signing client" "Requests operation signatures from Signatory." "Go" {
                    url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/send_transaction.go"
                    properties {
                        "architecture.id" "firefly.tezosconnect.signing"
                        "evidence" "Implementation"
                    }
                }
                blocks = component "Tezos block listener" "Monitors chain heads for events and receipts." "Go" {
                    url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/blocklistener.go"
                    properties {
                        "architecture.id" "firefly.tezosconnect.blocks"
                        "evidence" "Implementation"
                    }
                }
                events = component "Event listener and stream adapter" "Converts Tezos contract events to connector events." "Go" {
                    url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/internal/tezos/event_stream.go"
                    properties {
                        "architecture.id" "firefly.tezosconnect.events"
                        "evidence" "Implementation"
                    }
                }
                streams = component "FFTM confirmations and event delivery" "Confirms and delivers checkpointed event batches." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/events"
                    properties {
                        "architecture.id" "firefly.tezosconnect.streams"
                        "evidence" "Implementation"
                    }
                    -> firefly.core "Delivers confirmed event batches" "WebSocket / JSON" "Dataflow"
                }
                persistence = component "FFTM persistence" "Stores managed transactions and event checkpoints." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/persistence"
                    properties {
                        "architecture.id" "firefly.tezosconnect.persistence"
                        "evidence" "Implementation"
                    }
                }
                !element firefly.tezosconnect.api {
                    -> firefly.tezosconnect.policy "Schedules durable operation submission" "In-process calls / Go" "Dataflow"
                    -> firefly.tezosconnect.streams "Configures event streams" "In-process calls / Go" "Dataflow"
                    -> firefly.tezosconnect.persistence "Persists managed transaction state" "In-process calls / Go" "Dataflow"
                }
                !element firefly.tezosconnect.policy {
                    -> firefly.tezosconnect.adapter "Prepares and submits Tezos operations" "In-process calls / Go" "Dataflow"
                }
                !element firefly.tezosconnect.adapter {
                    -> firefly.tezosconnect.signing "Requests a signature for encoded operations" "In-process calls / Go" "Dataflow"
                }
                !element firefly.tezosconnect.blocks {
                    -> firefly.tezosconnect.events "Supplies observed Tezos blocks" "In-process calls / Go" "Dataflow"
                }
                !element firefly.tezosconnect.events {
                    -> firefly.tezosconnect.streams "Supplies decoded contract events" "In-process calls / Go" "Dataflow"
                }
                !element firefly.tezosconnect.streams {
                    -> firefly.tezosconnect.persistence "Persists acknowledged checkpoints" "In-process calls / Go" "Dataflow"
                }
                -> firefly.core "Delivers confirmed Tezos events" "WebSocket / JSON" "Dataflow"
            }
            tezosState = container "TezosConnect state" "Optional PostgreSQL or LevelDB persistence for the embedded FFTM." "PostgreSQL or LevelDB" {
                tags "Database,Optional"
                url "https://github.com/hyperledger-firefly/transaction-manager/tree/7a882ddaeaf2e7b9b2203a053402576e436debd9/internal/persistence"
                properties {
                    "architecture.id" "firefly.tezosState"
                    "evidence" "Implementation"
                }
            }
            cardanoconnect = container "CardanoConnect" "Native Cardano connector with operation, contract and event managers." "Rust / Axum" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect"
                properties {
                    "architecture.id" "firefly.cardanoconnect"
                    "evidence" "Implementation"
                }
                api = component "HTTP and WebSocket API" "Routes transaction, contract, operation and stream requests." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/routes"
                    properties {
                        "architecture.id" "firefly.cardanoconnect.api"
                        "evidence" "Implementation"
                    }
                }
                operations = component "Operations manager" "Coordinates transaction construction, signing and submission." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/operations"
                    properties {
                        "architecture.id" "firefly.cardanoconnect.operations"
                        "evidence" "Implementation"
                    }
                }
                blockchain = component "Blockchain client" "Selects Blockfrost or direct node-to-client ledger access." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/blockchain"
                    properties {
                        "architecture.id" "firefly.cardanoconnect.blockchain"
                        "evidence" "Implementation"
                    }
                }
                blockfrost = component "Blockfrost adapter" "Reads chain data and submits transactions through Blockfrost." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/blockchain/blockfrost"
                    properties {
                        "architecture.id" "firefly.cardanoconnect.blockfrost"
                        "evidence" "Implementation"
                    }
                }
                n2c = component "Node-to-client adapter" "Reads local node state and chain synchronization through Pallas." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/blockchain/n2c"
                    properties {
                        "architecture.id" "firefly.cardanoconnect.n2c"
                        "evidence" "Implementation"
                    }
                }
                signer = component "Signer service client" "Obtains transaction witnesses from the separate signer." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/signer.rs"
                    properties {
                        "architecture.id" "firefly.cardanoconnect.signer"
                        "evidence" "Implementation"
                    }
                }
                contracts = component "Contract manager and Balius runtime" "Runs optional application WASM workers over Cardano ledger data." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/contracts"
                    properties {
                        "architecture.id" "firefly.cardanoconnect.contracts"
                        "evidence" "Implementation"
                    }
                    -> firefly.cardanoconnect.blockchain "Retrieves ledger data for contract workers" "In-process calls / Rust" "Dataflow"
                }
                balius = component "FireFly Balius worker SDK" "Implements WASM worker logic, monitoring and contract events." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-balius/src"
                    properties {
                        "architecture.id" "firefly.cardanoconnect.balius"
                        "evidence" "Implementation"
                    }
                }
                streams = component "Stream manager and event multiplexer" "Orders operation and blockchain notifications for consumers." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/streams"
                    properties {
                        "architecture.id" "firefly.cardanoconnect.streams"
                        "evidence" "Implementation"
                    }
                    -> firefly.cardanoconnect.blockchain "Tracks ledger updates" "In-process calls / Rust" "Dataflow"
                    -> firefly.cardanoconnect.contracts "Consumes application contract events" "In-process calls / Rust" "Dataflow"
                    -> firefly.core "Delivers ordered operation and contract events" "WebSocket / JSON" "Dataflow"
                }
                persistence = component "SQLite persistence" "Persists operations, checkpoints and contract key-value state." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/persistence"
                    properties {
                        "architecture.id" "firefly.cardanoconnect.persistence"
                        "evidence" "Implementation"
                    }
                }
                server = component "Shared HTTP server and instrumentation" "Hosts routes, configuration and tracing; an embedded library." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-server/src"
                    properties {
                        "architecture.id" "firefly.cardanoconnect.server"
                        "evidence" "Implementation"
                    }
                    -> firefly.cardanoconnect.api "Hosts connector HTTP and WebSocket routes" "In-process calls / Rust" "Dataflow"
                }
                !element firefly.cardanoconnect.api {
                    -> firefly.cardanoconnect.operations "Submits operation requests" "In-process calls / Rust" "Dataflow"
                    -> firefly.cardanoconnect.streams "Creates streams and consumes notifications" "In-process calls / Rust" "Dataflow"
                }
                !element firefly.cardanoconnect.operations {
                    -> firefly.cardanoconnect.blockchain "Builds and submits ledger transactions" "In-process calls / Rust" "Dataflow"
                    -> firefly.cardanoconnect.signer "Requests transaction witnesses" "In-process calls / Rust" "Dataflow"
                    -> firefly.cardanoconnect.contracts "Invokes configured contract workers" "In-process calls / Rust" "Dataflow"
                    -> firefly.cardanoconnect.persistence "Persists operation lifecycle state" "In-process calls / Rust" "Dataflow"
                }
                !element firefly.cardanoconnect.blockchain {
                    -> firefly.cardanoconnect.blockfrost "Dispatches requests when Blockfrost is configured" "In-process calls / Rust" "Dataflow"
                    -> firefly.cardanoconnect.n2c "Dispatches requests when direct node access is configured" "In-process calls / Rust" "Dataflow"
                }
                !element firefly.cardanoconnect.contracts {
                    -> firefly.cardanoconnect.balius "Loads FireFly-compatible WASM worker logic" "In-process calls / Rust" "Dataflow"
                    -> firefly.cardanoconnect.persistence "Persists contract worker state" "In-process calls / Rust" "Dataflow"
                }
                !element firefly.cardanoconnect.streams {
                    -> firefly.cardanoconnect.persistence "Persists stream checkpoints" "In-process calls / Rust" "Dataflow"
                }
                -> firefly.core "Delivers Cardano operation and contract events" "WebSocket / JSON" "Dataflow"
            }
            cardanosigner = container "Cardano Signer" "Signs CBOR transaction bodies using separately stored Cardano keys." "Rust / Axum" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner"
                properties {
                    "architecture.id" "firefly.cardanosigner"
                    "evidence" "Implementation"
                }
                api = component "Signing HTTP API" "Accepts signing requests and returns CBOR witness sets." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/routes.rs"
                    properties {
                        "architecture.id" "firefly.cardanosigner.api"
                        "evidence" "Implementation"
                    }
                }
                keys = component "Address-indexed key store" "Loads configured key files and resolves signing addresses." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/keys.rs"
                    properties {
                        "architecture.id" "firefly.cardanosigner.keys"
                        "evidence" "Implementation"
                    }
                }
                crypto = component "Ed25519 signing" "Signs Cardano transaction-body hashes." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/private_key.rs"
                    properties {
                        "architecture.id" "firefly.cardanosigner.crypto"
                        "evidence" "Implementation"
                    }
                }
                server = component "Shared HTTP server" "Hosts signer routes and instrumentation." "Rust" {
                    url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-server/src"
                    properties {
                        "architecture.id" "firefly.cardanosigner.server"
                        "evidence" "Implementation"
                    }
                    -> firefly.cardanosigner.api "Hosts signing API requests" "In-process calls / Rust" "Dataflow"
                }
                !element firefly.cardanosigner.api {
                    -> firefly.cardanosigner.keys "Looks up the requested address key" "In-process calls / Rust" "Dataflow"
                    -> firefly.cardanosigner.crypto "Signs the transaction-body hash" "In-process calls / Rust" "Dataflow"
                }
                !element firefly.cardanosigner.keys {
                    -> firefly.cardanosigner.crypto "Supplies the resolved private key" "In-process calls / Rust" "Dataflow"
                }
            }
            cardanoState = container "CardanoConnect SQLite files" "Operation, checkpoint and optional contract worker state." "SQLite / filesystem" {
                tags "Database,Optional"
                url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanoconnect/src/persistence"
                properties {
                    "architecture.id" "firefly.cardanoState"
                    "evidence" "Implementation"
                }
            }
            cardanoKeys = container "Cardano signing keys" "Address-indexed signing key files held by the Cardano Signer." "Filesystem keystore" {
                tags "Database,Optional"
                url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/firefly-cardanosigner/src/keys.rs"
                properties {
                    "architecture.id" "firefly.cardanoKeys"
                    "evidence" "Implementation"
                }
            }
            cordaconnect = container "Corda connector starter" "Spring Boot reference starter; application CorDapps and a Core binding require customization." "Java / Spring Boot" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector"
                properties {
                    "architecture.id" "firefly.cordaconnect"
                    "evidence" "Starter requiring customization"
                }
                api = component "REST controllers" "Accepts FireFly flow, subscription and stream requests." "Java" {
                    url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/controller"
                    properties {
                        "architecture.id" "firefly.cordaconnect.api"
                        "evidence" "Implementation"
                    }
                }
                flows = component "CorDapp service and RPC client" "Starts application-specific flows through Corda RPC." "Java" {
                    url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/rpc"
                    properties {
                        "architecture.id" "firefly.cordaconnect.flows"
                        "evidence" "Implementation"
                    }
                }
                events = component "Event streams and subscriptions" "Collects vault events and batches them for subscribers." "Java" {
                    url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/service"
                    properties {
                        "architecture.id" "firefly.cordaconnect.events"
                        "evidence" "Implementation"
                    }
                }
                websockets = component "WebSocket delivery" "Delivers event batches to connector clients." "Java" {
                    url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/ws"
                    properties {
                        "architecture.id" "firefly.cordaconnect.websockets"
                        "evidence" "Implementation"
                    }
                    -> developer "Delivers starter event batches to an integration developer" "WebSocket / JSON" "Dataflow"
                }
                persistence = component "JPA repositories" "Persists event-stream and subscription definitions." "Java" {
                    url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/db"
                    properties {
                        "architecture.id" "firefly.cordaconnect.persistence"
                        "evidence" "Implementation"
                    }
                }
                !element firefly.cordaconnect.api {
                    -> firefly.cordaconnect.flows "Submits configured CorDapp flow requests" "In-process calls / Java" "Dataflow"
                    -> firefly.cordaconnect.events "Configures event streams and subscriptions" "In-process calls / Java" "Dataflow"
                }
                !element firefly.cordaconnect.flows {
                    -> firefly.cordaconnect.events "Supplies observed CorDapp state changes" "In-process calls / Java" "Dataflow"
                }
                !element firefly.cordaconnect.events {
                    -> firefly.cordaconnect.websockets "Publishes event batches" "In-process calls / Java" "Dataflow"
                    -> firefly.cordaconnect.persistence "Persists stream and subscription definitions" "In-process calls / Java" "Dataflow"
                }
            }
            cordaState = container "Corda starter database" "Starter JPA database; the supplied configuration uses in-memory H2 and is not durable." "H2 / in-memory default" {
                tags "Database,Optional"
                url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/resources"
                properties {
                    "architecture.id" "firefly.cordaState"
                    "evidence" "Implementation"
                }
            }
            !element firefly.core {
                -> firefly.evm "Submits contract calls, pins and listeners" "HTTP REST / JSON" "Dataflow"
                -> firefly.dx "Submits private messages, blobs and peer configuration" "HTTP REST / JSON + binary" "Dataflow"
                -> firefly.erc20 "Submits ERC-20 and ERC-721 operations" "HTTP REST / JSON" "Dataflow"
                -> firefly.erc1155 "Submits ERC-1155 operations" "HTTP REST / JSON" "Dataflow"
                -> firefly.pg "Reads and writes the private Core database" "PostgreSQL wire / TLS" "Dataflow"
                -> firefly.ipfs "Adds shared content and retrieves CIDs" "IPFS HTTP RPC / gateway" "Dataflow"
                -> firefly.secrets "Loads namespace and plugin configuration" "Read-only projected files" "Dataflow"
                -> firefly.sqlite "Persists Core state when SQLite is selected" "Embedded SQLite / filesystem" "Dataflow"
                -> firefly.dx.events "Acknowledges consumed transfer notifications" "WebSocket / JSON" "Dataflow"
                -> firefly.ethconnect "Submits calls and consumes events in the legacy configuration" "HTTP REST + WebSocket" "Dataflow"
                -> firefly.fabconnect "Submits Fabric requests when configured" "HTTP REST + WebSocket" "Dataflow"
                -> firefly.tezosconnect "Submits Tezos operations when configured" "HTTP REST + WebSocket" "Dataflow"
                -> firefly.cardanoconnect "Submits Cardano operations when configured" "HTTP REST + WebSocket" "Dataflow"
                -> firefly.ethconnect.rest "Submits configured ledger requests" "HTTP REST / JSON" "Dataflow"
                -> firefly.fabconnect.rest "Submits configured ledger requests" "HTTP REST / JSON" "Dataflow"
                -> firefly.tezosconnect.api "Submits configured ledger requests" "HTTP REST / JSON" "Dataflow"
                -> firefly.cardanoconnect.api "Submits configured ledger requests" "HTTP REST / JSON" "Dataflow"
            }
            !element firefly.evm {
                -> firefly.signer "Submits Ethereum calls and unsigned transactions" "HTTP JSON-RPC" "Dataflow"
                -> firefly.pg "Reads and writes the separate FFTM database" "PostgreSQL wire / TLS" "Dataflow"
                -> firefly.secrets "Loads connector endpoints and credentials" "Read-only projected files" "Dataflow"
                -> firefly.erc20.stream "Streams confirmed token logs" "WebSocket / JSON" "Dataflow"
                -> firefly.erc1155.stream "Streams confirmed token logs" "WebSocket / JSON" "Dataflow"
                -> firefly.leveldb "Persists transaction state when LevelDB is selected" "Embedded LevelDB / filesystem" "Dataflow"
            }
            !element firefly.pg {
                -> firefly.pgReplica "Streams WAL and awaits one synchronous standby" "PostgreSQL replication / TLS" "Dataflow"
            }
            !element firefly.dx {
                -> firefly.blobs "Reads and writes private blobs and peer records" "Filesystem I/O" "Dataflow"
                -> firefly.secrets "Loads member mTLS certificate and key" "Read-only projected files" "Dataflow"
                -> firefly.dx "Transfers private envelopes and blobs to peers; receives ACKs" "HTTPS / mutual TLS" "PrivateFlow"
            }
            !element firefly.ipfs {
                -> firefly.ipfsRepo "Reads and writes Kubo keys, pins and blocks" "Filesystem I/O" "Dataflow"
                -> firefly.ipfs "Retrieves shared content blocks from peers by CID" "IPFS / libp2p" "SharedFlow"
            }
            !element firefly.signer {
                -> firefly.secrets "Loads member signing keystore files" "Read-only projected files" "Dataflow"
            }
            !element firefly.core.blockchain {
                -> firefly.evm "Submits blockchain operations" "HTTP REST / JSON" "Dataflow"
            }
            !element firefly.core.database {
                -> firefly.pg "Persists Core resources and offsets" "PostgreSQL wire / TLS" "Dataflow"
            }
            !element firefly.core.dataexchange {
                -> firefly.dx "Exchanges private data and notifications" "HTTP + WebSocket" "Dataflow"
            }
            !element firefly.core.sharedstorage {
                -> firefly.ipfs "Publishes and retrieves CIDs" "IPFS HTTP RPC" "Dataflow"
            }
            !element firefly.core.tokens {
                -> firefly.erc20 "Submits ERC-20 and ERC-721 operations" "HTTP REST / JSON" "Dataflow"
                -> firefly.erc1155 "Submits ERC-1155 operations" "HTTP REST / JSON" "Dataflow"
            }
            !element firefly.evm.persistence {
                -> firefly.pg "Persists FFTM transactions and checkpoints" "PostgreSQL wire / TLS" "Dataflow"
            }
            !element firefly.evm.rpc {
                -> firefly.signer "Forwards transactions and read calls" "HTTP JSON-RPC" "Dataflow"
            }
            !element firefly.signer.wallet {
                -> firefly.secrets "Loads encrypted account keystores" "Read-only projected files" "Dataflow"
            }
            !element firefly.dx.blobs {
                -> firefly.blobs "Stores durable private blobs" "Filesystem I/O" "Dataflow"
            }
            !element firefly.dx.peers {
                -> firefly.blobs "Persists endpoints and peer certificates" "Filesystem I/O" "Dataflow"
            }
            !element firefly.dx.p2p {
                -> firefly.secrets "Loads the member mTLS identity" "Read-only projected files" "Dataflow"
            }
            !element firefly.core.ethereum {
                -> firefly.evm "Submits EVM calls, transactions and listeners" "HTTP REST / JSON" "Dataflow"
                -> firefly.ethconnect "Submits Ethereum requests in the legacy configuration" "HTTP REST + WebSocket" "Dataflow"
            }
            !element firefly.core.postgres {
                -> firefly.pg "Reads and writes the Core SQL database" "PostgreSQL wire protocol" "Dataflow"
            }
            !element firefly.core.ffdx {
                -> firefly.dx "Transfers messages, blobs and peer configuration" "HTTP REST + WebSocket" "Dataflow"
            }
            !element firefly.core.ipfs {
                -> firefly.ipfs "Publishes and retrieves shared CIDs" "IPFS HTTP RPC" "Dataflow"
            }
            !element firefly.core.fftokens {
                -> firefly.erc20 "Submits ERC-20 and ERC-721 operations" "HTTP REST + WebSocket" "Dataflow"
                -> firefly.erc1155 "Submits ERC-1155 operations" "HTTP REST + WebSocket" "Dataflow"
            }
            !element firefly.core.sqlite {
                -> firefly.sqlite "Reads and writes embedded database pages" "SQLite API / filesystem" "Dataflow"
            }
            !element firefly.evm.postgres {
                -> firefly.pg "Persists the separate FFTM SQL database" "PostgreSQL wire protocol" "Dataflow"
            }
            !element firefly.evm.leveldb {
                -> firefly.leveldb "Reads and writes local transaction state" "LevelDB API / filesystem" "Dataflow"
            }
            !element firefly.ethconnect {
                -> firefly.ethconnectState "Persists connector state in local files" "LevelDB / filesystem" "Dataflow"
            }
            !element firefly.ethconnect.kv {
                -> firefly.ethconnectState "Reads and writes event and registry records" "LevelDB API / filesystem" "Dataflow"
            }
            !element firefly.ethconnect.receipts {
                -> firefly.ethconnectState "Persists receipts when LevelDB is selected" "LevelDB API / filesystem" "Dataflow"
            }
            !element firefly.core.fabricAdapter {
                -> firefly.fabconnect "Submits chaincode calls and event subscriptions" "HTTP REST + WebSocket" "Dataflow"
            }
            !element firefly.fabconnect {
                -> firefly.fabricState "Persists wallet and event state" "Filesystem / LevelDB" "Dataflow"
            }
            !element firefly.fabconnect.client {
                -> firefly.fabricState "Reads and writes wallet identities" "Filesystem I/O" "Dataflow"
            }
            !element firefly.fabconnect.kv {
                -> firefly.fabricState "Persists event checkpoints" "LevelDB API / filesystem" "Dataflow"
            }
            !element firefly.fabconnect.receipts {
                -> firefly.fabricState "Persists receipts when LevelDB is selected" "LevelDB API / filesystem" "Dataflow"
            }
            !element firefly.core.tezosAdapter {
                -> firefly.tezosconnect "Submits Tezos operations and listeners" "HTTP REST + WebSocket" "Dataflow"
            }
            !element firefly.tezosconnect {
                -> firefly.tezosState "Persists transaction and stream state" "PostgreSQL wire or LevelDB API" "Dataflow"
            }
            !element firefly.tezosconnect.persistence {
                -> firefly.tezosState "Reads and writes managed state" "PostgreSQL wire or LevelDB API" "Dataflow"
            }
            !element firefly.core.cardanoAdapter {
                -> firefly.cardanoconnect "Submits Cardano operations and subscriptions" "HTTP REST + WebSocket" "Dataflow"
            }
            !element firefly.cardanoconnect {
                -> firefly.cardanosigner "Requests transaction witnesses" "HTTP / JSON" "Dataflow"
                -> firefly.cardanoState "Persists operation and stream state" "SQLite / filesystem" "Dataflow"
                -> firefly.cardanosigner.api "Requests a CBOR transaction witness set" "HTTP / JSON" "Dataflow"
            }
            !element firefly.cardanoconnect.signer {
                -> firefly.cardanosigner "Requests transaction witnesses" "HTTP / JSON" "Dataflow"
            }
            !element firefly.cardanoconnect.persistence {
                -> firefly.cardanoState "Reads and writes operation and checkpoint records" "SQLite API / filesystem" "Dataflow"
            }
            !element firefly.cardanosigner {
                -> firefly.cardanoKeys "Loads Cardano signing keys" "Filesystem I/O" "Dataflow"
            }
            !element firefly.cardanosigner.keys {
                -> firefly.cardanoKeys "Loads address-indexed signing key files" "Filesystem I/O" "Dataflow"
            }
            !element firefly.cordaconnect {
                -> firefly.cordaState "Persists starter stream definitions" "JPA / embedded H2" "Dataflow"
            }
            !element firefly.cordaconnect.persistence {
                -> firefly.cordaState "Reads and writes subscription definitions" "JPA / embedded H2" "Dataflow"
            }
        }
        besu = softwareSystem "Private Besu network" "Permissioned Ethereum network with QBFT validators, private RPC and contracts." {
            tags "Blockchain"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1"
            properties {
                "architecture.id" "besu"
                "evidence" "Implementation"
            }
            !docs docs/static/system
            !adrs docs/static/decisions
            node = container "Besu node" "Runs the selected validator or non-validator RPC/discovery role; each instance owns its key and ledger." "Java / Besu / RocksDB" {
                tags "Blockchain"
                url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1"
                properties {
                    "architecture.id" "besu.node"
                    "evidence" "Implementation"
                }
                rpc = component "JSON-RPC and subscriptions" "Accepts private-network queries and signed transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/api"
                    properties {
                        "architecture.id" "besu.node.rpc"
                        "evidence" "Implementation"
                    }
                }
                permissioning = component "Node and account permissioning" "Applies local peer and account allowlists." "Java" {
                    url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/permissioning"
                    properties {
                        "architecture.id" "besu.node.permissioning"
                        "evidence" "Implementation"
                    }
                }
                discovery = component "Peer discovery" "Discovers peers through configured bootnodes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.node.discovery"
                        "evidence" "Implementation"
                    }
                }
                p2p = component "DevP2P transport" "Exchanges transactions, blocks and consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.node.p2p"
                        "evidence" "Implementation"
                    }
                    -> besu.node.permissioning "Checks connecting node admission" "In-process calls / Java" "Dataflow"
                }
                txpool = component "Transaction pool" "Validates and queues pending transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/eth"
                    properties {
                        "architecture.id" "besu.node.txpool"
                        "evidence" "Implementation"
                    }
                }
                sync = component "Chain synchronization" "Downloads and validates missing blocks and state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/eth"
                    properties {
                        "architecture.id" "besu.node.sync"
                        "evidence" "Implementation"
                    }
                }
                blockprocessor = component "Block processor" "Validates blocks and applies state transitions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core"
                    properties {
                        "architecture.id" "besu.node.blockprocessor"
                        "evidence" "Implementation"
                    }
                }
                qbft = component "QBFT consensus" "Proposes blocks and verifies validator votes. Active only on validator instances." "Java" {
                    url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/consensus/qbft"
                    properties {
                        "architecture.id" "besu.node.qbft"
                        "evidence" "Implementation"
                    }
                    -> besu.node.blockprocessor "Commits quorum-approved blocks" "In-process calls / Java" "Dataflow"
                }
                evm = component "EVM execution" "Executes smart-contract bytecode deterministically." "Java" {
                    url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/evm"
                    properties {
                        "architecture.id" "besu.node.evm"
                        "evidence" "Implementation"
                    }
                }
                worldstate = component "World state and trie" "Tracks account balances, storage and contract state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core/src/main/java/org/hyperledger/besu/ethereum/worldstate"
                    properties {
                        "architecture.id" "besu.node.worldstate"
                        "evidence" "Implementation"
                    }
                }
                storage = component "Storage provider" "Persists blockchain data and world-state records." "Java" {
                    url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/plugins/rocksdb"
                    properties {
                        "architecture.id" "besu.node.storage"
                        "evidence" "Implementation"
                    }
                }
                keys = component "Node key and security module" "Signs node identity and validator consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/crypto/plugin-api/src/main/java/org/hyperledger/besu/plugin/services/securitymodule"
                    properties {
                        "architecture.id" "besu.node.keys"
                        "evidence" "Implementation"
                    }
                }
                metrics = component "Metrics and health" "Exposes node, peer and consensus measurements." "Java" {
                    url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/metrics"
                    properties {
                        "architecture.id" "besu.node.metrics"
                        "evidence" "Implementation"
                    }
                }
                fireflycontract = component "FireFly multiparty contract" "Executes batch pinning and emits sequencing events." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    properties {
                        "architecture.id" "besu.node.fireflycontract"
                        "evidence" "Deployed contract responsibility (reference mapping into EVM host)"
                    }
                    -> besu.node.worldstate "Writes pinning state and log results" "In-process calls / Java" "Dataflow"
                }
                tokencontracts = component "Token contracts" "Executes ERC-20, ERC-721 and ERC-1155 application contracts; not a Besu implementation module." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    properties {
                        "architecture.id" "besu.node.tokencontracts"
                        "evidence" "Deployed contract responsibility (reference mapping into EVM host)"
                    }
                    -> besu.node.worldstate "Writes token balances and log results" "In-process calls / Java" "Dataflow"
                }
                businesscontracts = component "Application contracts" "Executes member-defined business rules; example extension." "Solidity / EVM" {
                    tags "Contract"
                    url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
                    properties {
                        "architecture.id" "besu.node.businesscontracts"
                        "evidence" "Deployed contract responsibility (reference mapping into EVM host)"
                    }
                    -> besu.node.worldstate "Writes application state and log results" "In-process calls / Java" "Dataflow"
                }
                !element besu.node.rpc {
                    -> besu.node.permissioning "Checks transaction sender admission" "In-process calls / Java" "Dataflow"
                    -> besu.node.txpool "Submits signed transactions" "In-process calls / Java" "Dataflow"
                    -> besu.node.worldstate "Queries account and contract state" "In-process calls / Java" "Dataflow"
                    -> besu.node.blockprocessor "Reads receipts and contract logs" "In-process calls / Java" "Dataflow"
                }
                !element besu.node.discovery {
                    -> besu.node.p2p "Provides discovered peer endpoints" "In-process calls / Java" "Dataflow"
                }
                !element besu.node.p2p {
                    -> besu.node.txpool "Gossips pending transactions" "In-process calls / Java" "Dataflow"
                    -> besu.node.sync "Delivers requested blocks and state" "In-process calls / Java" "Dataflow"
                    -> besu.node.qbft "Delivers consensus protocol messages" "In-process calls / Java" "Dataflow"
                    -> besu.node.metrics "Records peer connectivity measurements" "In-process calls / Java" "Dataflow"
                    -> besu.node.keys "Authenticates node transport identity" "In-process calls / Java" "Dataflow"
                }
                !element besu.node.sync {
                    -> besu.node.blockprocessor "Submits downloaded blocks for validation" "In-process calls / Java" "Dataflow"
                }
                !element besu.node.txpool {
                    -> besu.node.qbft "Supplies transactions for proposed blocks" "In-process calls / Java" "Dataflow"
                }
                !element besu.node.qbft {
                    -> besu.node.keys "Signs proposals and consensus votes" "In-process calls / Java" "Dataflow"
                    -> besu.node.metrics "Records rounds and committed block measurements" "In-process calls / Java" "Dataflow"
                }
                !element besu.node.blockprocessor {
                    -> besu.node.evm "Executes transactions and validates results" "In-process calls / Java" "Dataflow"
                    -> besu.node.storage "Persists blocks, receipts and logs" "In-process calls / Java" "Dataflow"
                }
                !element besu.node.evm {
                    -> besu.node.worldstate "Reads and updates contract and account state" "EVM execution" "Dataflow"
                    -> besu.node.fireflycontract "Executes batch pinning calls" "EVM execution" "Dataflow"
                    -> besu.node.tokencontracts "Executes standard token operations" "EVM execution" "Dataflow"
                    -> besu.node.businesscontracts "Executes application business calls" "EVM execution" "Dataflow"
                }
                !element besu.node.worldstate {
                    -> besu.node.storage "Persists world-state updates" "In-process calls / Java" "Dataflow"
                }
            }
            !element besu.node {
                -> besu.node "Gossips transactions, blocks and QBFT peer messages" "DevP2P / TCP" "BlockchainFlow"
            }
        }
        apps = softwareSystem "Member applications" "Independently owned applications and event consumers." {
            url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
            properties {
                "architecture.id" "apps"
                "evidence" "Reference choice"
            }
            !docs docs/static/system
            !adrs docs/static/decisions
            client = container "Member business application" "Submits requests and consumes acknowledged FireFly events." "Example application / REST client" {
                url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
                properties {
                    "architecture.id" "apps.client"
                    "evidence" "Reference choice"
                }
                -> firefly.core "Submits member-scoped commands and queries" "HTTPS / REST" "Dataflow"
                -> firefly.core.api "Submits API commands and queries" "HTTPS / REST" "Dataflow"
                -> firefly.core.websockets "Acknowledges consumed event batches" "WebSocket / JSON" "Dataflow"
            }
            -> firefly "Submits member requests and consumes events" "HTTPS + WebSocket" "Dataflow"
        }
        tools = softwareSystem "FireFly developer tools" "Development utilities and optional sample applications." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/key_components/tools.md"
            properties {
                "architecture.id" "tools"
                "evidence" "Implementation"
            }
            !docs docs/static/system
            !adrs docs/static/decisions
            cli = container "FireFly CLI" "Creates local stacks and performs development administration." "Go / CLI" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/README.md"
                properties {
                    "architecture.id" "tools.cli"
                    "evidence" "Implementation"
                }
                commands = component "CLI commands" "Accepts stack creation, start, stop and administration commands." "Go" {
                    url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/cmd"
                    properties {
                        "architecture.id" "tools.cli.commands"
                        "evidence" "Implementation"
                    }
                }
                stacks = component "Stack configuration and manifests" "Assembles member stack configuration and state." "Go" {
                    url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/stacks"
                    properties {
                        "architecture.id" "tools.cli.stacks"
                        "evidence" "Implementation"
                    }
                }
                docker = component "Docker integration" "Invokes Docker Compose to manage local development runtimes." "Go" {
                    url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/docker"
                    properties {
                        "architecture.id" "tools.cli.docker"
                        "evidence" "Implementation"
                    }
                }
                blockchains = component "Blockchain setup adapters" "Configures selected Ethereum, Fabric, Tezos or Cardano backends." "Go" {
                    url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/blockchain"
                    properties {
                        "architecture.id" "tools.cli.blockchains"
                        "evidence" "Implementation"
                    }
                }
                tokens = component "Token setup adapters" "Configures optional ERC token connectors." "Go" {
                    url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/tokens"
                    properties {
                        "architecture.id" "tools.cli.tokens"
                        "evidence" "Implementation"
                    }
                }
                core = component "Core administration client" "Registers identities and configures Core namespaces." "Go" {
                    url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/core"
                    properties {
                        "architecture.id" "tools.cli.core"
                        "evidence" "Implementation"
                    }
                    -> firefly.core "Configures and inspects development members" "HTTP / REST + Admin API" "Dataflow"
                }
                !element tools.cli.commands {
                    -> tools.cli.stacks "Requests development stack lifecycle changes" "In-process calls / Go" "Dataflow"
                }
                !element tools.cli.stacks {
                    -> tools.cli.docker "Supplies generated runtime manifests" "In-process calls / Go" "Dataflow"
                    -> tools.cli.blockchains "Selects and configures the blockchain backend" "In-process calls / Go" "Dataflow"
                    -> tools.cli.tokens "Selects optional token services" "In-process calls / Go" "Dataflow"
                    -> tools.cli.core "Configures member Core instances" "In-process calls / Go" "Dataflow"
                }
                -> firefly.core "Registers and inspects development stacks" "HTTP / Admin API" "Dataflow"
            }
            sandbox = container "FireFly Sandbox" "Provides a sample web app calling a selected member API." "React + Node.js / TypeScript" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069"
                properties {
                    "architecture.id" "tools.sandbox"
                    "evidence" "Implementation"
                }
                frontend = component "Sandbox frontend" "Collects sample messages and token actions." "React / TypeScript" {
                    url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/ui/src"
                    properties {
                        "architecture.id" "tools.sandbox.frontend"
                        "evidence" "Implementation"
                    }
                }
                backend = component "Sandbox backend" "Maps UI actions into SDK requests." "Node.js / TypeScript" {
                    url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/server/src"
                    properties {
                        "architecture.id" "tools.sandbox.backend"
                        "evidence" "Implementation"
                    }
                }
                sdk = component "FireFly Node.js SDK" "Calls the selected API and consumes events." "TypeScript library" {
                    url "https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/firefly.ts"
                    properties {
                        "architecture.id" "tools.sandbox.sdk"
                        "evidence" "Implementation"
                    }
                    -> firefly.core "Invokes member APIs and consumes events" "HTTPS + WebSocket" "Dataflow"
                }
                sdkHttp = component "SDK HTTP client" "Embedded SDK transport for member requests and events." "TypeScript" {
                    url "https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/http.ts"
                    properties {
                        "architecture.id" "tools.sandbox.sdkHttp"
                        "evidence" "Implementation"
                    }
                    -> firefly.core "Sends namespace-scoped API requests" "HTTP REST / JSON" "Dataflow"
                }
                sdkEvents = component "SDK WebSocket client" "Embedded SDK transport for member requests and events." "TypeScript" {
                    url "https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/websocket.ts"
                    properties {
                        "architecture.id" "tools.sandbox.sdkEvents"
                        "evidence" "Implementation"
                    }
                    -> firefly.core "Subscribes to events and sends acknowledgements" "WebSocket / JSON" "Dataflow"
                }
                !element tools.sandbox.frontend {
                    -> tools.sandbox.backend "Submits selected sample actions" "HTTP / JSON" "Dataflow"
                }
                !element tools.sandbox.backend {
                    -> tools.sandbox.sdk "Submits SDK requests" "In-process calls / TypeScript" "Dataflow"
                }
                !element tools.sandbox.sdk {
                    -> tools.sandbox.sdkHttp "Dispatches SDK transport operations" "In-process calls / TypeScript" "Dataflow"
                    -> tools.sandbox.sdkEvents "Dispatches SDK transport operations" "In-process calls / TypeScript" "Dataflow"
                }
                -> firefly.core "Exercises APIs and subscriptions" "HTTPS + WebSocket" "Dataflow"
            }
            perf = container "FireFly Performance CLI" "Generates workloads and reports timings against configured FireFly members." "Go" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/README.md"
                properties {
                    "architecture.id" "tools.perf"
                    "evidence" "Implementation"
                }
                commands = component "Workload CLI" "Loads test configuration and starts performance scenarios." "Go" {
                    url "https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/cmd"
                    properties {
                        "architecture.id" "tools.perf.commands"
                        "evidence" "Implementation"
                    }
                }
                runner = component "Scenario runner" "Submits message, blob, token and contract workloads." "Go" {
                    url "https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/internal/perf"
                    properties {
                        "architecture.id" "tools.perf.runner"
                        "evidence" "Implementation"
                    }
                    -> firefly.core "Submits workloads and consumes completion events" "HTTP REST + WebSocket" "Dataflow"
                }
                server = component "Control and observation server" "Exposes run control and measurements." "Go" {
                    url "https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/internal/server"
                    properties {
                        "architecture.id" "tools.perf.server"
                        "evidence" "Implementation"
                    }
                    -> tools.perf.runner "Controls workload execution" "In-process calls / Go" "Dataflow"
                }
                report = component "Result reporting" "Builds workload timing and throughput reports." "Go" {
                    url "https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/internal/util"
                    properties {
                        "architecture.id" "tools.perf.report"
                        "evidence" "Implementation"
                    }
                }
                !element tools.perf.commands {
                    -> tools.perf.runner "Starts selected workload scenarios" "In-process calls / Go" "Dataflow"
                }
                !element tools.perf.runner {
                    -> tools.perf.report "Supplies measured workload results" "In-process calls / Go" "Dataflow"
                }
                -> firefly.core "Submits workloads and consumes completion events" "HTTP REST + WebSocket" "Dataflow"
            }
            eventAudit = container "FireFly event auditor" "Audits recorded blockchain-event ordering through the Core API." "Go / CLI" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents"
                properties {
                    "architecture.id" "tools.eventAudit"
                    "evidence" "Implementation"
                }
                reader = component "Event API reader" "Pages through recorded blockchain events." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents/main.go"
                    properties {
                        "architecture.id" "tools.eventAudit.reader"
                        "evidence" "Implementation"
                    }
                    -> firefly.core "Pages through status and enriched event records" "HTTP REST / JSON" "Dataflow"
                }
                ordering = component "Ordering auditor" "Checks increasing protocol identifiers and reports inconsistencies." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/auditevents/main.go"
                    properties {
                        "architecture.id" "tools.eventAudit.ordering"
                        "evidence" "Implementation"
                    }
                    -> developer "Reports ordering failures and checked event counts" "Console output" "Dataflow"
                }
                !element tools.eventAudit.reader {
                    -> tools.eventAudit.ordering "Supplies ordered event pages" "In-process calls / Go" "Dataflow"
                }
                -> firefly.core "Retrieves namespace status and recorded blockchain events" "HTTP REST / JSON" "Dataflow"
            }
            config = container "FireFly configuration migrator" "Migrates configuration files between supported FireFly versions." "Go / CLI" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig"
                properties {
                    "architecture.id" "tools.config"
                    "evidence" "Implementation"
                }
                commands = component "Configuration CLI" "Reads input configuration and requested versions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig/main.go"
                    properties {
                        "architecture.id" "tools.config.commands"
                        "evidence" "Implementation"
                    }
                }
                migration = component "Configuration migrations" "Transforms configuration to the selected schema version." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/ffconfig/migrate"
                    properties {
                        "architecture.id" "tools.config.migration"
                        "evidence" "Implementation"
                    }
                    -> developer "Writes migrated configuration for review" "YAML / standard output" "Dataflow"
                }
                !element tools.config.commands {
                    -> tools.config.migration "Submits parsed configuration for migration" "In-process calls / Go" "Dataflow"
                }
            }
            -> firefly "Exercises the selected member API" "HTTPS + WebSocket" "Dataflow"
        }
        ops = softwareSystem "Platform operations" "Reference ingress, database operations and metrics on AKS." {
            url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
            properties {
                "architecture.id" "ops"
                "evidence" "Reference choice"
            }
            !docs docs/static/system
            !adrs docs/static/decisions
            gateway = container "Gateway / ingress" "Routes API traffic; preserves peer mTLS with TLS passthrough." "Envoy Gateway / Kubernetes" {
                tags "Operational"
                url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
                properties {
                    "architecture.id" "ops.gateway"
                    "evidence" "Reference choice"
                }
                -> firefly.core "Routes authenticated API requests" "HTTPS / REST + WebSocket" "Operational"
                -> firefly.dx "Passes peer TLS sessions without terminating mTLS" "TCP / TLS passthrough" "PrivateFlow"
            }
            cnpg = container "PostgreSQL operator" "Reconciles database roles, endpoints and fenced failover." "CloudNativePG" {
                tags "Operational"
                url "https://cloudnative-pg.io/docs/1.28/replication/"
                properties {
                    "architecture.id" "ops.cnpg"
                    "evidence" "Reference choice"
                }
                -> firefly.pg "Reconciles primary role and health" "Kubernetes API / operator control" "Operational"
                -> firefly.pgReplica "Reconciles replication and failover candidates" "Kubernetes API / operator control" "Operational"
            }
            prometheus = container "Metrics collector" "Scrapes runtime metrics and evaluates availability alerts." "Prometheus" {
                tags "Operational"
                url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
                properties {
                    "architecture.id" "ops.prometheus"
                    "evidence" "Reference choice"
                }
                -> firefly.core "Scrapes member runtime measurements" "HTTP / Prometheus metrics" "Operational"
                -> besu.node "Scrapes peer, block and consensus measurements" "HTTP / Prometheus metrics" "Operational"
            }
            grafana = container "Operations dashboard" "Displays metrics, replication lag and quorum health." "Grafana" {
                tags "Operational"
                url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
                properties {
                    "architecture.id" "ops.grafana"
                    "evidence" "Reference choice"
                }
                -> ops.prometheus "Queries operational time series" "HTTP / PromQL" "Operational"
            }
            -> firefly "Routes API requests and observes health" "HTTPS + metrics" "Operational"
            -> besu "Observes peer and quorum health" "HTTP / metrics" "Operational"
        }
        fabric = softwareSystem "Hyperledger Fabric network" "External Fabric peer, ordering, discovery and chaincode services." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/README.md"
            properties {
                "architecture.id" "fabric"
                "evidence" "External integration boundary"
            }
        }
        tezos = softwareSystem "Tezos network" "External Tezos node RPC and chain-monitoring endpoints." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/README.md"
            properties {
                "architecture.id" "tezos"
                "evidence" "External integration boundary"
            }
        }
        cardano = softwareSystem "Cardano network" "External Cardano ledger accessed through Blockfrost or node-to-client protocols." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/README.md"
            properties {
                "architecture.id" "cardano"
                "evidence" "External integration boundary"
            }
        }
        corda = softwareSystem "Corda network" "External Corda node with application-specific CorDapps; starter integration requires customization." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/README.md"
            properties {
                "architecture.id" "corda"
                "evidence" "External integration boundary"
            }
        }
        peerMembers = softwareSystem "Other FireFly members" "Peer supernodes exchanging private envelopes and shared content." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/multiparty/multiparty_flow.md"
            properties {
                "architecture.id" "peerMembers"
                "evidence" "External integration boundary"
            }
            -> firefly "Delivers peer payloads and transfer acknowledgements" "HTTPS / mTLS" "Dataflow"
            -> firefly.dx "Delivers private envelopes, blobs and transfer results" "HTTPS / mTLS" "Dataflow"
            -> firefly.dx.p2p "Transfers inbound private envelopes and blobs" "HTTPS / mTLS" "Dataflow"
        }
        evmNetworks = softwareSystem "Other EVM networks" "Optional public or permissioned EVM-compatible networks; share the Ethereum adapter implementation." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/evmconnect/tree/6e12bb4c050677780cf5dd975a926923868b0cb8/README.md"
            properties {
                "architecture.id" "evmNetworks"
                "evidence" "External integration boundary"
            }
        }
        kafkaBroker = softwareSystem "Apache Kafka" "Optional transaction request/reply broker for legacy connector configurations." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/kafka"
            properties {
                "architecture.id" "kafkaBroker"
                "evidence" "External integration boundary"
            }
        }
        mongo = softwareSystem "MongoDB receipt service" "Optional receipt persistence for legacy Ethereum and Fabric connectors." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/ethconnect/tree/e8ae0eda16cc61b8ac256cdbf5f09edeb571b8c0/internal/receipts/mongoreceipts.go"
            properties {
                "architecture.id" "mongo"
                "evidence" "External integration boundary"
            }
        }
        fabricCA = softwareSystem "Fabric certificate authority" "Registers and enrolls client identities used by FabConnect." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client/identity.go"
            properties {
                "architecture.id" "fabricCA"
                "evidence" "External integration boundary"
            }
        }
        signatory = softwareSystem "Signatory" "Remote Tezos signing service; backend key management is external." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/tezosconnect/tree/508ec1e8bb8b671c1eb6e9c090a1d219043dbd8b/README.md"
            properties {
                "architecture.id" "signatory"
                "evidence" "External integration boundary"
            }
        }
        blockfrostService = softwareSystem "Blockfrost API" "Hosted or self-managed Cardano ledger API; alternative to direct node access." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/cardano/tree/0300bca6b0b99d2a16a81b94f65496934999346e/README.md"
            properties {
                "architecture.id" "blockfrostService"
                "evidence" "External integration boundary"
            }
            -> cardano "Reads the ledger and relays submitted transactions" "Cardano integration / service boundary" "Dataflow"
        }
        dockerEngine = softwareSystem "Developer Docker engine" "Local container engine used by FireFly CLI; no network is provisioned by this architecture task." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/docker"
            properties {
                "architecture.id" "dockerEngine"
                "evidence" "External integration boundary"
            }
        }
        !element firefly {
            -> besu "Submits transactions and consumes finalized events" "Ethereum JSON-RPC + events" "Dataflow"
            -> peerMembers "Exchanges private payloads and shared content references" "HTTPS / mTLS + IPFS" "Dataflow"
            -> evmNetworks "Submits ledger operations and consumes events when configured" "Ethereum JSON-RPC" "Dataflow"
            -> fabric "Submits ledger operations and consumes events when configured" "Fabric connector API" "Dataflow"
            -> tezos "Submits ledger operations and consumes events when configured" "Tezos connector API" "Dataflow"
            -> cardano "Submits ledger operations and consumes events when configured" "Cardano connector API" "Dataflow"
            -> signatory "Requests Tezos operation signatures in the optional configuration" "HTTP / Signatory API" "Dataflow"
            -> blockfrostService "Queries Cardano data and submits transactions in Blockfrost mode" "HTTPS / Blockfrost API" "Dataflow"
            -> fabricCA "Registers and enrolls signing identities through FabConnect" "Fabric CA / HTTPS" "Dataflow"
            -> kafkaBroker "Exchanges legacy connector transaction requests and replies" "Kafka protocol" "Dataflow"
            -> mongo "Persists legacy connector receipts when configured" "MongoDB wire protocol" "Dataflow"
        }
        !element operator {
            -> firefly "Inspects and administers member state" "HTTPS / Explorer + Admin API" "Operational"
            -> ops "Monitors availability and coordinates recovery" "HTTPS" "Operational"
            -> ops.grafana "Reviews quorum and recovery measurements" "HTTPS" "Operational"
        }
        !element firefly.signer {
            -> besu.node "Submits signed transactions and queries RPC nodes" "HTTP JSON-RPC" "Dataflow"
        }
        !element firefly.signer.backend {
            -> besu.node "Submits raw transactions and reads to RPC nodes" "HTTP JSON-RPC" "Dataflow"
        }
        !element business {
            -> apps.client "Submits business actions" "HTTPS" "Dataflow"
            -> apps "Submits consortium business actions" "HTTPS" "Dataflow"
        }
        !element firefly.core {
            -> apps.client "Delivers subscribed events and accepts ACKs" "WebSocket / webhook / HTTPS" "Dataflow"
        }
        !element firefly.core.eventplugin {
            -> apps.client "Delivers events through configured transports" "WebSocket / webhook / HTTPS" "Dataflow"
        }
        !element developer {
            -> tools "Develops and tests integrations" "CLI + HTTPS" "Dataflow"
            -> tools.cli "Creates local test stacks" "Local process invocation" "Dataflow"
            -> tools.sandbox "Exercises sample workflows" "HTTPS" "Dataflow"
            -> corda "Customizes the CorDapp and Core binding required by the starter" "Development toolchain" "Dataflow"
            -> firefly.cordaconnect "Exercises the starter after application-specific customization" "HTTP REST + WebSocket" "Dataflow"
            -> tools.perf "Runs configured performance workloads" "Local process invocation" "Dataflow"
            -> tools.eventAudit "Audits recorded blockchain-event ordering" "Local process invocation" "Dataflow"
            -> tools.config "Supplies configuration and migration versions" "CLI / file input" "Dataflow"
            -> tools.config.commands "Supplies configuration and target version" "CLI / file input" "Dataflow"
            -> tools.cli.commands "Invokes development stack commands" "Local process invocation" "Dataflow"
            -> tools.perf.commands "Invokes configured workload scenarios" "Local process invocation" "Dataflow"
            -> firefly.cordaconnect.api "Exercises customized starter operations" "HTTP REST / JSON" "Dataflow"
        }
        !element firefly.core.websockets {
            -> apps.client "Delivers subscribed event batches" "WebSocket / JSON" "Dataflow"
        }
        !element firefly.core.webhooks {
            -> apps.client "Delivers subscribed event batches" "HTTP POST / JSON" "Dataflow"
        }
        !element firefly.evm.webhook {
            -> apps.client "Posts configured blockchain event batches" "HTTP POST / JSON" "Dataflow"
        }
        !element firefly.dx {
            -> peerMembers "Sends private envelopes and blobs to selected peers" "HTTPS / mTLS" "Dataflow"
        }
        !element firefly.dx.p2p {
            -> peerMembers "Transfers authenticated private envelopes and blobs" "HTTPS / mTLS" "Dataflow"
        }
        !element firefly.ipfs {
            -> peerMembers "Fetches and serves shared content blocks by CID" "IPFS / libp2p" "Dataflow"
        }
        !element firefly.evm {
            -> evmNetworks "Submits transactions and polls an alternative EVM network" "HTTP JSON-RPC" "Dataflow"
        }
        !element firefly.ethconnect.receipts {
            -> mongo "Stores receipts when MongoDB is selected" "MongoDB wire protocol" "Dataflow"
        }
        !element firefly.ethconnect {
            -> kafkaBroker "Publishes requests and consumes transaction work in Kafka mode" "Kafka protocol" "Dataflow"
            -> mongo "Stores receipts in the optional MongoDB backend" "MongoDB wire protocol" "Dataflow"
        }
        !element firefly.ethconnect.kafka {
            -> kafkaBroker "Consumes transaction requests and publishes replies" "Kafka protocol" "Dataflow"
        }
        !element firefly.fabconnect {
            -> fabric "Submits endorsed transactions and receives ledger events" "Fabric SDK / gRPC + TLS" "Dataflow"
            -> fabricCA "Registers and enrolls client identities" "Fabric CA / HTTPS" "Dataflow"
            -> kafkaBroker "Processes requests through the optional Kafka bridge" "Kafka protocol" "Dataflow"
            -> mongo "Stores receipts in the optional MongoDB backend" "MongoDB wire protocol" "Dataflow"
        }
        !element firefly.fabconnect.client {
            -> fabric "Invokes chaincode and consumes peer ledger events" "Fabric SDK / gRPC + TLS" "Dataflow"
            -> fabricCA "Registers and enrolls Fabric identities" "Fabric CA / HTTPS" "Dataflow"
        }
        !element firefly.fabconnect.receipts {
            -> mongo "Persists receipts when MongoDB is selected" "MongoDB wire protocol" "Dataflow"
        }
        !element firefly.fabconnect.kafka {
            -> kafkaBroker "Consumes transaction requests and publishes replies" "Kafka protocol" "Dataflow"
        }
        !element firefly.tezosconnect {
            -> tezos "Queries chain state and injects signed operations" "Tezos HTTP RPC" "Dataflow"
            -> signatory "Requests signatures for encoded operations" "HTTP / Signatory API" "Dataflow"
        }
        !element firefly.tezosconnect.adapter {
            -> tezos "Queries state and injects signed operations" "Tezos HTTP RPC" "Dataflow"
        }
        !element firefly.tezosconnect.blocks {
            -> tezos "Monitors chain heads and retrieves blocks" "Tezos HTTP RPC / streaming" "Dataflow"
        }
        !element firefly.tezosconnect.signing {
            -> signatory "Requests an operation signature for a Tezos address" "HTTP / Signatory API" "Dataflow"
        }
        !element firefly.cardanoconnect {
            -> blockfrostService "Queries ledger data and submits transactions in Blockfrost mode" "HTTPS / Blockfrost API" "Dataflow"
            -> cardano "Synchronizes ledger state in direct-node mode" "Cardano node-to-client / local socket" "Dataflow"
        }
        !element firefly.cardanoconnect.blockfrost {
            -> blockfrostService "Queries blocks and submits signed transactions" "HTTPS / Blockfrost API" "Dataflow"
        }
        !element firefly.cardanoconnect.n2c {
            -> cardano "Synchronizes chain and queries ledger state" "Cardano node-to-client / local socket" "Dataflow"
        }
        !element firefly.cordaconnect {
            -> corda "Invokes custom CorDapps and consumes vault updates" "Corda RPC" "Dataflow"
        }
        !element firefly.cordaconnect.flows {
            -> corda "Invokes custom flows and subscribes to vault updates" "Corda RPC" "Dataflow"
        }
        !element tools.cli.docker {
            -> dockerEngine "Starts and stops local stack services" "Docker Compose CLI" "Dataflow"
        }
        !element tools.cli {
            -> dockerEngine "Manages local development stack services" "Docker Compose CLI" "Dataflow"
        }
        !element tools {
            -> dockerEngine "Creates and manages local development stack services" "Docker Compose CLI" "Dataflow"
        }
    }
    views {
        systemLandscape "01-landscape" "System Landscape - FireFly consortium architecture" {
            title "System Landscape - FireFly consortium architecture"
            include business developer operator apps tools firefly besu ops peerMembers
            exclude *->*
            include firefly->besu
            include operator->firefly
            include apps->firefly
            include business->apps
            include developer->tools
            include tools->firefly
            include operator->ops
            include ops->firefly
            include ops->besu
            include firefly->peerMembers
            include peerMembers->firefly
            autoLayout lr 360 200
        }
        systemContext firefly "02-context-firefly" "System Context - Hyperledger FireFly" {
            title "System Context - Hyperledger FireFly"
            include firefly apps operator besu ops tools peerMembers
            exclude *->*
            include firefly->besu
            include operator->firefly
            include apps->firefly
            include tools->firefly
            include operator->ops
            include ops->firefly
            include ops->besu
            include firefly->peerMembers
            include peerMembers->firefly
            autoLayout lr 360 200
        }
        systemContext besu "03-context-besu" "System Context - private Besu network" {
            title "System Context - private Besu network"
            include firefly besu ops
            exclude *->*
            include firefly->besu
            include ops->firefly
            include ops->besu
            autoLayout lr 360 200
        }
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
            include firefly->signatory
            include firefly->blockfrostService
            include firefly->fabricCA
            include firefly->kafkaBroker
            include firefly->mongo
            include tools->dockerEngine
            autoLayout lr 360 200
        }
        container firefly "10-firefly-runtime" "Container - FireFly orchestration and connectors" {
            title "Container - FireFly orchestration and connectors"
            include firefly.core firefly.evm firefly.signer firefly.dx firefly.erc20 firefly.erc1155 firefly.ipfs firefly.pg apps.client besu.node peerMembers
            exclude *->*
            include firefly.core->firefly.evm
            include firefly.evm->firefly.core
            include firefly.core->firefly.dx
            include firefly.dx->firefly.core
            include firefly.core->firefly.erc20
            include firefly.core->firefly.erc1155
            include firefly.erc20->firefly.core
            include firefly.erc1155->firefly.core
            include firefly.erc20->firefly.evm
            include firefly.erc1155->firefly.evm
            include firefly.evm->firefly.signer
            include firefly.core->firefly.pg
            include firefly.evm->firefly.pg
            include firefly.core->firefly.ipfs
            include besu.node->besu.node
            include firefly.signer->besu.node
            include firefly.dx->firefly.dx
            include firefly.ipfs->firefly.ipfs
            include apps.client->firefly.core
            include firefly.core->apps.client
            include firefly.dx->peerMembers
            include peerMembers->firefly.dx
            include firefly.ipfs->peerMembers
            autoLayout lr 360 200
        }
        container firefly "11-firefly-state" "Container - FireFly private state and shared storage" {
            title "Container - FireFly private state and shared storage"
            include firefly.core firefly.evm firefly.signer firefly.dx firefly.ipfs firefly.pg firefly.pgReplica firefly.blobs firefly.ipfsRepo firefly.secrets peerMembers
            exclude *->*
            include firefly.core->firefly.evm
            include firefly.evm->firefly.core
            include firefly.core->firefly.dx
            include firefly.dx->firefly.core
            include firefly.evm->firefly.signer
            include firefly.core->firefly.pg
            include firefly.evm->firefly.pg
            include firefly.pg->firefly.pgReplica
            include firefly.core->firefly.ipfs
            include firefly.dx->firefly.blobs
            include firefly.ipfs->firefly.ipfsRepo
            include firefly.signer->firefly.secrets
            include firefly.dx->firefly.secrets
            include firefly.core->firefly.secrets
            include firefly.evm->firefly.secrets
            include firefly.dx->firefly.dx
            include firefly.ipfs->firefly.ipfs
            include firefly.dx->peerMembers
            include peerMembers->firefly.dx
            include firefly.ipfs->peerMembers
            autoLayout lr 360 200
        }
        component firefly.core "20-firefly-core-api" "Component - FireFly Core: API, tenancy and Explorer" {
            title "Component - FireFly Core: API, tenancy and Explorer"
            include firefly.core.explorer firefly.core.api firefly.core.auth firefly.core.namespaces firefly.core.orchestrator firefly.core.syncasync firefly.core.spievents firefly.core.eventplugin apps.client firefly.core.config firefly.core.basicAuth
            exclude *->*
            include firefly.core.explorer->firefly.core.api
            include firefly.core.api->firefly.core.auth
            include firefly.core.api->firefly.core.namespaces
            include firefly.core.namespaces->firefly.core.orchestrator
            include firefly.core.api->firefly.core.orchestrator
            include firefly.core.orchestrator->firefly.core.syncasync
            include firefly.core.namespaces->firefly.core.spievents
            include firefly.core.spievents->firefly.core.eventplugin
            include apps.client->firefly.core.api
            include firefly.core.eventplugin->apps.client
            include firefly.core.namespaces->firefly.core.config
            include firefly.core.auth->firefly.core.basicAuth
            autoLayout lr 360 200
        }
        component firefly.core "20-firefly-core-identity" "Component - FireFly Core: Identity and multiparty coordination" {
            title "Component - FireFly Core: Identity and multiparty coordination"
            include firefly.core.orchestrator firefly.core.identity firefly.core.identityplugin firefly.core.networkmap firefly.core.definitions firefly.core.broadcast firefly.core.multiparty firefly.core.blockchain
            exclude *->*
            include firefly.core.orchestrator->firefly.core.identity
            include firefly.core.identity->firefly.core.identityplugin
            include firefly.core.identity->firefly.core.networkmap
            include firefly.core.networkmap->firefly.core.definitions
            include firefly.core.definitions->firefly.core.broadcast
            include firefly.core.orchestrator->firefly.core.multiparty
            include firefly.core.multiparty->firefly.core.blockchain
            include firefly.core.broadcast->firefly.core.multiparty
            autoLayout lr 360 200
        }
        component firefly.core "20-firefly-core-messaging" "Component - FireFly Core: Payloads and outbound messaging" {
            title "Component - FireFly Core: Payloads and outbound messaging"
            include firefly.core.orchestrator firefly.core.data firefly.core.schema firefly.core.batch firefly.core.batchprocessor firefly.core.broadcast firefly.core.private firefly.core.dataexchange firefly.core.sharedstorage firefly.core.multiparty firefly.dx firefly.ipfs
            exclude *->*
            include firefly.core.orchestrator->firefly.core.multiparty
            include firefly.core.orchestrator->firefly.core.data
            include firefly.core.data->firefly.core.schema
            include firefly.core.orchestrator->firefly.core.batch
            include firefly.core.batch->firefly.core.batchprocessor
            include firefly.core.batchprocessor->firefly.core.data
            include firefly.core.batchprocessor->firefly.core.broadcast
            include firefly.core.batchprocessor->firefly.core.private
            include firefly.core.broadcast->firefly.core.sharedstorage
            include firefly.core.broadcast->firefly.core.multiparty
            include firefly.core.private->firefly.core.dataexchange
            include firefly.core.private->firefly.core.multiparty
            include firefly.core.dataexchange->firefly.dx
            include firefly.core.sharedstorage->firefly.ipfs
            include firefly.dx->firefly.dx
            include firefly.ipfs->firefly.ipfs
            autoLayout lr 360 200
        }
        component firefly.core "20-firefly-core-contracts" "Component - FireFly Core: Contracts, tokens and operations" {
            title "Component - FireFly Core: Contracts, tokens and operations"
            include firefly.core.orchestrator firefly.core.contracts firefly.core.assets firefly.core.tokens firefly.core.blockchain firefly.core.operations firefly.core.txhelper firefly.core.txwriter firefly.core.database firefly.evm firefly.erc20 firefly.erc1155
            exclude *->*
            include firefly.core.orchestrator->firefly.core.contracts
            include firefly.core.orchestrator->firefly.core.assets
            include firefly.core.contracts->firefly.core.blockchain
            include firefly.core.assets->firefly.core.tokens
            include firefly.core.assets->firefly.core.contracts
            include firefly.core.contracts->firefly.core.operations
            include firefly.core.assets->firefly.core.operations
            include firefly.core.operations->firefly.core.txhelper
            include firefly.core.txhelper->firefly.core.txwriter
            include firefly.core.txwriter->firefly.core.database
            include firefly.core.operations->firefly.core.database
            include firefly.erc20->firefly.evm
            include firefly.erc1155->firefly.evm
            include firefly.core.blockchain->firefly.evm
            include firefly.core.tokens->firefly.erc20
            include firefly.core.tokens->firefly.erc1155
            autoLayout lr 360 200
        }
        component firefly.core "20-firefly-core-events" "Component - FireFly Core: Inbound sequencing and event delivery" {
            title "Component - FireFly Core: Inbound sequencing and event delivery"
            include firefly.core.blockchain firefly.core.dataexchange firefly.core.tokens firefly.core.aggregator firefly.core.download firefly.core.subscriptions firefly.core.dispatcher firefly.core.eventplugin firefly.core.syncasync firefly.core.database apps.client
            exclude *->*
            include firefly.core.blockchain->firefly.core.aggregator
            include firefly.core.dataexchange->firefly.core.aggregator
            include firefly.core.tokens->firefly.core.aggregator
            include firefly.core.aggregator->firefly.core.download
            include firefly.core.aggregator->firefly.core.database
            include firefly.core.aggregator->firefly.core.subscriptions
            include firefly.core.subscriptions->firefly.core.database
            include firefly.core.subscriptions->firefly.core.dispatcher
            include firefly.core.dispatcher->firefly.core.eventplugin
            include firefly.core.dispatcher->firefly.core.syncasync
            include firefly.core.eventplugin->apps.client
            autoLayout lr 360 200
        }
        component firefly.core "20-firefly-core-persistence" "Component - FireFly Core: Persistence and operational support" {
            title "Component - FireFly Core: Persistence and operational support"
            include firefly.core.orchestrator firefly.core.data firefly.core.download firefly.core.sharedstorage firefly.core.contracts firefly.core.operations firefly.core.txwriter firefly.core.database firefly.core.cache firefly.core.metrics firefly.pg firefly.ipfs
            exclude *->*
            include firefly.core.orchestrator->firefly.core.data
            include firefly.core.data->firefly.core.database
            include firefly.core.orchestrator->firefly.core.contracts
            include firefly.core.contracts->firefly.core.operations
            include firefly.core.txwriter->firefly.core.database
            include firefly.core.operations->firefly.core.database
            include firefly.core.download->firefly.core.sharedstorage
            include firefly.core.download->firefly.core.data
            include firefly.core.data->firefly.core.cache
            include firefly.core.contracts->firefly.core.cache
            include firefly.core.orchestrator->firefly.core.metrics
            include firefly.core.operations->firefly.core.metrics
            include firefly.core.database->firefly.pg
            include firefly.core.sharedstorage->firefly.ipfs
            include firefly.ipfs->firefly.ipfs
            autoLayout lr 360 200
        }
        component firefly.evm "30-firefly-evm-transactions" "Component - FireFly EVMConnect: Transaction submission" {
            title "Component - FireFly EVMConnect: Transaction submission"
            include firefly.evm.api firefly.evm.manager firefly.evm.handler firefly.evm.nonce firefly.evm.abi firefly.evm.rpc firefly.evm.persistence firefly.pg firefly.signer
            exclude *->*
            include firefly.evm.api->firefly.evm.manager
            include firefly.evm.manager->firefly.evm.handler
            include firefly.evm.handler->firefly.evm.nonce
            include firefly.evm.nonce->firefly.evm.persistence
            include firefly.evm.handler->firefly.evm.abi
            include firefly.evm.abi->firefly.evm.rpc
            include firefly.evm.manager->firefly.evm.persistence
            include firefly.evm.persistence->firefly.pg
            include firefly.evm.rpc->firefly.signer
            autoLayout lr 360 200
        }
        component firefly.evm "30-firefly-evm-events" "Component - FireFly EVMConnect: Block tracking and events" {
            title "Component - FireFly EVMConnect: Block tracking and events"
            include firefly.evm.manager firefly.evm.blocks firefly.evm.receipts firefly.evm.rpc firefly.evm.confirmations firefly.evm.streams firefly.evm.delivery firefly.evm.persistence firefly.pg firefly.signer firefly.core firefly.evm.blocklistener firefly.evm.metrics
            exclude *->*
            include firefly.evm.receipts->firefly.evm.rpc
            include firefly.evm.rpc->firefly.evm.blocks
            include firefly.evm.blocks->firefly.evm.confirmations
            include firefly.evm.receipts->firefly.evm.confirmations
            include firefly.evm.confirmations->firefly.evm.streams
            include firefly.evm.manager->firefly.evm.streams
            include firefly.evm.streams->firefly.evm.delivery
            include firefly.evm.delivery->firefly.evm.streams
            include firefly.evm.streams->firefly.evm.persistence
            include firefly.evm.manager->firefly.evm.persistence
            include firefly.core->firefly.pg
            include firefly.evm.delivery->firefly.core
            include firefly.evm.persistence->firefly.pg
            include firefly.evm.rpc->firefly.signer
            include firefly.evm.blocks->firefly.evm.blocklistener
            include firefly.evm.blocklistener->firefly.evm.confirmations
            include firefly.evm.manager->firefly.evm.metrics
            include firefly.evm.streams->firefly.evm.metrics
            autoLayout lr 360 200
        }
        component firefly.signer "40-firefly-signer" "Component - FireFly transaction signing" {
            title "Component - FireFly transaction signing"
            include firefly.signer.proxy firefly.signer.wallet firefly.signer.keystore firefly.signer.signing firefly.signer.backend firefly.secrets besu.node
            exclude *->*
            include firefly.signer.proxy->firefly.signer.wallet
            include firefly.signer.wallet->firefly.signer.keystore
            include firefly.signer.proxy->firefly.signer.signing
            include firefly.signer.signing->firefly.signer.wallet
            include firefly.signer.signing->firefly.signer.backend
            include firefly.signer.proxy->firefly.signer.backend
            include firefly.signer.wallet->firefly.secrets
            include besu.node->besu.node
            include firefly.signer.backend->besu.node
            autoLayout lr 360 200
        }
        component firefly.dx "40-firefly-dx" "Component - FireFly private data exchange" {
            title "Component - FireFly private data exchange"
            include firefly.dx.api firefly.dx.peers firefly.dx.p2p firefly.dx.messages firefly.dx.blobs firefly.dx.events firefly.blobs firefly.secrets peerMembers firefly.core
            exclude *->*
            include firefly.dx.api->firefly.dx.peers
            include firefly.dx.api->firefly.dx.messages
            include firefly.dx.api->firefly.dx.blobs
            include firefly.dx.messages->firefly.dx.peers
            include firefly.dx.messages->firefly.dx.p2p
            include firefly.dx.blobs->firefly.dx.p2p
            include firefly.dx.p2p->firefly.dx.messages
            include firefly.dx.p2p->firefly.dx.blobs
            include firefly.dx.messages->firefly.dx.events
            include firefly.dx.blobs->firefly.dx.events
            include firefly.dx.events->firefly.dx.api
            include firefly.core->firefly.secrets
            include firefly.dx.blobs->firefly.blobs
            include firefly.dx.peers->firefly.blobs
            include firefly.dx.p2p->firefly.secrets
            include firefly.dx.p2p->peerMembers
            include peerMembers->firefly.dx.p2p
            include firefly.dx.events->firefly.core
            include firefly.core->firefly.dx.events
            autoLayout lr 360 200
        }
        component firefly.erc20 "40-firefly-erc20" "Component - FireFly ERC-20 / ERC-721" {
            title "Component - FireFly ERC-20 / ERC-721"
            include firefly.erc20.api firefly.erc20.service firefly.erc20.mapper firefly.erc20.blockchain firefly.erc20.listener firefly.erc20.stream firefly.erc20.proxy firefly.core firefly.evm
            exclude *->*
            include firefly.erc20.api->firefly.erc20.service
            include firefly.erc20.service->firefly.erc20.mapper
            include firefly.erc20.mapper->firefly.erc20.blockchain
            include firefly.erc20.blockchain->firefly.erc20.stream
            include firefly.erc20.stream->firefly.erc20.listener
            include firefly.erc20.listener->firefly.erc20.service
            include firefly.erc20.listener->firefly.erc20.proxy
            include firefly.erc20.proxy->firefly.erc20.stream
            include firefly.core->firefly.evm
            include firefly.evm->firefly.core
            include firefly.erc20.blockchain->firefly.evm
            include firefly.evm->firefly.erc20.stream
            include firefly.erc20.proxy->firefly.core
            autoLayout lr 360 200
        }
        component firefly.erc1155 "40-firefly-erc1155" "Component - FireFly ERC-1155" {
            title "Component - FireFly ERC-1155"
            include firefly.erc1155.api firefly.erc1155.service firefly.erc1155.mapper firefly.erc1155.blockchain firefly.erc1155.listener firefly.erc1155.stream firefly.erc1155.proxy firefly.core firefly.evm
            exclude *->*
            include firefly.erc1155.api->firefly.erc1155.service
            include firefly.erc1155.service->firefly.erc1155.mapper
            include firefly.erc1155.mapper->firefly.erc1155.blockchain
            include firefly.erc1155.blockchain->firefly.erc1155.stream
            include firefly.erc1155.stream->firefly.erc1155.listener
            include firefly.erc1155.listener->firefly.erc1155.service
            include firefly.erc1155.listener->firefly.erc1155.proxy
            include firefly.erc1155.proxy->firefly.erc1155.stream
            include firefly.core->firefly.evm
            include firefly.evm->firefly.core
            include firefly.erc1155.blockchain->firefly.evm
            include firefly.evm->firefly.erc1155.stream
            include firefly.erc1155.proxy->firefly.core
            autoLayout lr 360 200
        }
        container besu "50-besu-network" "Container - reusable Besu node and RPC integration" {
            title "Container - reusable Besu node and RPC integration"
            include besu.node firefly.signer ops.prometheus
            exclude *->*
            include besu.node->besu.node
            include firefly.signer->besu.node
            include ops.prometheus->besu.node
            autoLayout lr 360 200
        }
        component besu.node "51-besu-network" "Component - Besu node: Network and admission" {
            title "Component - Besu node: Network and admission"
            include besu.node.rpc besu.node.permissioning besu.node.discovery besu.node.p2p besu.node.txpool besu.node.sync
            exclude *->*
            include besu.node.rpc->besu.node.permissioning
            include besu.node.rpc->besu.node.txpool
            include besu.node.discovery->besu.node.p2p
            include besu.node.p2p->besu.node.permissioning
            include besu.node.p2p->besu.node.txpool
            include besu.node.p2p->besu.node.sync
            autoLayout lr 360 200
        }
        component besu.node "51-besu-consensus" "Component - Besu node: Consensus and block processing" {
            title "Component - Besu node: Consensus and block processing"
            include besu.node.p2p besu.node.txpool besu.node.qbft besu.node.keys besu.node.blockprocessor besu.node.sync besu.node.metrics
            exclude *->*
            include besu.node.p2p->besu.node.txpool
            include besu.node.p2p->besu.node.sync
            include besu.node.p2p->besu.node.qbft
            include besu.node.sync->besu.node.blockprocessor
            include besu.node.txpool->besu.node.qbft
            include besu.node.qbft->besu.node.keys
            include besu.node.qbft->besu.node.blockprocessor
            include besu.node.qbft->besu.node.metrics
            include besu.node.p2p->besu.node.metrics
            include besu.node.p2p->besu.node.keys
            autoLayout lr 360 200
        }
        component besu.node "51-besu-execution" "Component - Besu node: Execution, contracts and storage" {
            title "Component - Besu node: Execution, contracts and storage"
            include besu.node.rpc besu.node.blockprocessor besu.node.evm besu.node.worldstate besu.node.storage besu.node.fireflycontract besu.node.tokencontracts besu.node.businesscontracts
            exclude *->*
            include besu.node.rpc->besu.node.worldstate
            include besu.node.rpc->besu.node.blockprocessor
            include besu.node.blockprocessor->besu.node.evm
            include besu.node.evm->besu.node.worldstate
            include besu.node.worldstate->besu.node.storage
            include besu.node.blockprocessor->besu.node.storage
            include besu.node.evm->besu.node.fireflycontract
            include besu.node.evm->besu.node.tokencontracts
            include besu.node.evm->besu.node.businesscontracts
            include besu.node.fireflycontract->besu.node.worldstate
            include besu.node.tokencontracts->besu.node.worldstate
            include besu.node.businesscontracts->besu.node.worldstate
            autoLayout lr 360 200
        }
        container apps "60-applications" "Container - member business applications" {
            title "Container - member business applications"
            include apps.client business firefly.core
            exclude *->*
            include business->apps.client
            include apps.client->firefly.core
            include firefly.core->apps.client
            autoLayout lr 360 200
        }
        container tools "61-tools" "Container - developer tooling" {
            title "Container - developer tooling"
            include tools.cli tools.sandbox developer firefly.core tools.perf tools.eventAudit tools.config dockerEngine
            exclude *->*
            include tools.sandbox->firefly.core
            include tools.cli->firefly.core
            include developer->tools.cli
            include developer->tools.sandbox
            include tools.cli->dockerEngine
            include developer->tools.perf
            include tools.perf->firefly.core
            include developer->tools.eventAudit
            include tools.eventAudit->firefly.core
            include developer->tools.config
            autoLayout lr 360 200
        }
        component tools.sandbox "62-sandbox" "Component - Sandbox sample application" {
            title "Component - Sandbox sample application"
            include tools.sandbox.frontend tools.sandbox.backend tools.sandbox.sdk firefly.core tools.sandbox.sdkHttp tools.sandbox.sdkEvents
            exclude *->*
            include tools.sandbox.frontend->tools.sandbox.backend
            include tools.sandbox.backend->tools.sandbox.sdk
            include tools.sandbox.sdk->firefly.core
            include tools.sandbox.sdk->tools.sandbox.sdkHttp
            include tools.sandbox.sdk->tools.sandbox.sdkEvents
            include tools.sandbox.sdkHttp->firefly.core
            include tools.sandbox.sdkEvents->firefly.core
            autoLayout lr 360 200
        }
        container ops "63-operations" "Container - platform operations" {
            title "Container - platform operations"
            include ops.gateway ops.cnpg ops.prometheus ops.grafana operator firefly.core firefly.pg besu.node
            exclude *->*
            include firefly.core->firefly.pg
            include besu.node->besu.node
            include operator->ops.grafana
            include ops.grafana->ops.prometheus
            include ops.gateway->firefly.core
            include ops.cnpg->firefly.pg
            include ops.prometheus->firefly.core
            include ops.prometheus->besu.node
            autoLayout lr 360 200
        }
        component firefly.core "21-core-blockchain-adapters" "Component - Core blockchain adapters" {
            title "Component - Core blockchain adapters"
            include firefly.core.blockchain firefly.core.ethereum firefly.core.fabricAdapter firefly.core.tezosAdapter firefly.core.cardanoAdapter firefly.evm firefly.ethconnect firefly.fabconnect firefly.tezosconnect firefly.cardanoconnect
            exclude *->*
            include firefly.core.blockchain->firefly.evm
            include firefly.core.blockchain->firefly.core.ethereum
            include firefly.core.blockchain->firefly.core.fabricAdapter
            include firefly.core.blockchain->firefly.core.tezosAdapter
            include firefly.core.blockchain->firefly.core.cardanoAdapter
            include firefly.core.ethereum->firefly.evm
            include firefly.core.ethereum->firefly.ethconnect
            include firefly.core.fabricAdapter->firefly.fabconnect
            include firefly.core.tezosAdapter->firefly.tezosconnect
            include firefly.core.cardanoAdapter->firefly.cardanoconnect
            autoLayout lr 360 200
        }
        component firefly.core "22-core-storage-adapters" "Component - Core storage and exchange adapters" {
            title "Component - Core storage and exchange adapters"
            include firefly.core.database firefly.core.postgres firefly.core.sqlite firefly.core.sql firefly.core.dataexchange firefly.core.ffdx firefly.core.sharedstorage firefly.core.ipfs firefly.pg firefly.sqlite firefly.dx firefly.ipfs
            exclude *->*
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
        component firefly.evm "31-evm-persistence-delivery" "Component - EVMConnect persistence and delivery options" {
            title "Component - EVMConnect persistence and delivery options"
            include firefly.evm.manager firefly.evm.persistence firefly.evm.postgres firefly.evm.leveldb firefly.evm.streams firefly.evm.delivery firefly.evm.webhook firefly.evm.metrics firefly.pg firefly.leveldb apps.client
            exclude *->*
            include firefly.evm.manager->firefly.evm.streams
            include firefly.evm.streams->firefly.evm.delivery
            include firefly.evm.delivery->firefly.evm.streams
            include firefly.evm.streams->firefly.evm.persistence
            include firefly.evm.manager->firefly.evm.persistence
            include firefly.evm.persistence->firefly.pg
            include firefly.evm.persistence->firefly.evm.postgres
            include firefly.evm.persistence->firefly.evm.leveldb
            include firefly.evm.streams->firefly.evm.webhook
            include firefly.evm.manager->firefly.evm.metrics
            include firefly.evm.streams->firefly.evm.metrics
            include firefly.evm.postgres->firefly.pg
            include firefly.evm.leveldb->firefly.leveldb
            include firefly.evm.webhook->apps.client
            autoLayout lr 360 200
        }
        container firefly "12-embedded-storage-options" "Container - Optional embedded Core and EVM persistence" {
            title "Container - Optional embedded Core and EVM persistence"
            include firefly.core firefly.sqlite firefly.evm firefly.leveldb
            exclude *->*
            include firefly.core->firefly.evm
            include firefly.evm->firefly.core
            include firefly.core->firefly.sqlite
            include firefly.evm->firefly.leveldb
            autoLayout lr 360 200
        }
        container firefly "70-option-ethconnect" "Container - Optional EthConnect (legacy option)" {
            title "Container - Optional EthConnect (legacy option)"
            include firefly.ethconnect firefly.core firefly.signer besu.node firefly.ethconnectState
            exclude *->*
            include besu.node->besu.node
            include firefly.signer->besu.node
            include firefly.core->firefly.ethconnect
            include firefly.ethconnect->firefly.signer
            include firefly.ethconnect->firefly.core
            include firefly.ethconnect->firefly.ethconnectState
            autoLayout lr 360 200
        }
        container firefly "71-option-fabconnect" "Container - Optional FabConnect" {
            title "Container - Optional FabConnect"
            include firefly.fabconnect firefly.core fabric fabricCA firefly.fabricState
            exclude *->*
            include firefly.core->firefly.fabconnect
            include firefly.fabconnect->fabric
            include firefly.fabconnect->fabricCA
            include firefly.fabconnect->firefly.core
            include firefly.fabconnect->firefly.fabricState
            autoLayout lr 360 200
        }
        container firefly "72-option-tezosconnect" "Container - Optional TezosConnect + FFTM" {
            title "Container - Optional TezosConnect + FFTM"
            include firefly.tezosconnect firefly.core tezos signatory firefly.tezosState
            exclude *->*
            include firefly.core->firefly.tezosconnect
            include firefly.tezosconnect->tezos
            include firefly.tezosconnect->signatory
            include firefly.tezosconnect->firefly.tezosState
            include firefly.tezosconnect->firefly.core
            autoLayout lr 360 200
        }
        container firefly "73-option-cardanoconnect" "Container - Optional CardanoConnect" {
            title "Container - Optional CardanoConnect"
            include firefly.cardanoconnect firefly.core firefly.cardanosigner firefly.cardanoState firefly.cardanoKeys cardano blockfrostService
            exclude *->*
            include firefly.core->firefly.cardanoconnect
            include firefly.cardanoconnect->firefly.cardanosigner
            include firefly.cardanoconnect->blockfrostService
            include blockfrostService->cardano
            include firefly.cardanoconnect->cardano
            include firefly.cardanoconnect->firefly.cardanoState
            include firefly.cardanosigner->firefly.cardanoKeys
            include firefly.cardanoconnect->firefly.core
            autoLayout lr 360 200
        }
        container firefly "74-option-cordaconnect" "Container - Optional Corda connector starter" {
            title "Container - Optional Corda connector starter"
            include firefly.cordaconnect developer corda firefly.cordaState
            exclude *->*
            include developer->corda
            include developer->firefly.cordaconnect
            include firefly.cordaconnect->corda
            include firefly.cordaconnect->firefly.cordaState
            autoLayout lr 360 200
        }
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
        component firefly.ethconnect "75-ethconnect-events" "Component - EthConnect (legacy option): events" {
            title "Component - EthConnect (legacy option): events"
            include firefly.ethconnect.rest firefly.ethconnect.transactions firefly.ethconnect.rpc firefly.ethconnect.events firefly.ethconnect.websockets firefly.ethconnect.kafka firefly.ethconnect.kv firefly.core firefly.signer kafkaBroker firefly.ethconnectState
            exclude *->*
            include firefly.ethconnect.rest->firefly.ethconnect.transactions
            include firefly.ethconnect.rest->firefly.ethconnect.kafka
            include firefly.ethconnect.kafka->firefly.ethconnect.transactions
            include firefly.ethconnect.transactions->firefly.ethconnect.rpc
            include firefly.ethconnect.events->firefly.ethconnect.rpc
            include firefly.ethconnect.events->firefly.ethconnect.websockets
            include firefly.ethconnect.events->firefly.ethconnect.kv
            include firefly.ethconnect.rpc->firefly.signer
            include firefly.ethconnect.websockets->firefly.core
            include firefly.ethconnect.kv->firefly.ethconnectState
            include firefly.ethconnect.kafka->kafkaBroker
            include firefly.core->firefly.ethconnect.rest
            autoLayout lr 360 200
        }
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
        component firefly.fabconnect "75-fabconnect-events" "Component - FabConnect: events" {
            title "Component - FabConnect: events"
            include firefly.fabconnect.rest firefly.fabconnect.transactions firefly.fabconnect.client firefly.fabconnect.events firefly.fabconnect.websockets firefly.fabconnect.kafka firefly.fabconnect.kv firefly.core fabric kafkaBroker firefly.fabricState
            exclude *->*
            include firefly.fabconnect.rest->firefly.fabconnect.transactions
            include firefly.fabconnect.rest->firefly.fabconnect.kafka
            include firefly.fabconnect.kafka->firefly.fabconnect.transactions
            include firefly.fabconnect.transactions->firefly.fabconnect.client
            include firefly.fabconnect.events->firefly.fabconnect.client
            include firefly.fabconnect.events->firefly.fabconnect.websockets
            include firefly.fabconnect.events->firefly.fabconnect.kv
            include firefly.fabconnect.client->fabric
            include firefly.fabconnect.websockets->firefly.core
            include firefly.fabconnect.client->firefly.fabricState
            include firefly.fabconnect.kv->firefly.fabricState
            include firefly.fabconnect.kafka->kafkaBroker
            include firefly.core->firefly.fabconnect.rest
            autoLayout lr 360 200
        }
        component firefly.tezosconnect "75-tezosconnect-transactions" "Component - TezosConnect + FFTM: transactions" {
            title "Component - TezosConnect + FFTM: transactions"
            include firefly.tezosconnect.api firefly.tezosconnect.policy firefly.tezosconnect.adapter firefly.tezosconnect.signing firefly.tezosconnect.persistence firefly.core tezos signatory firefly.tezosState
            exclude *->*
            include firefly.tezosconnect.api->firefly.tezosconnect.policy
            include firefly.tezosconnect.policy->firefly.tezosconnect.adapter
            include firefly.tezosconnect.adapter->firefly.tezosconnect.signing
            include firefly.tezosconnect.api->firefly.tezosconnect.persistence
            include firefly.tezosconnect.adapter->tezos
            include firefly.tezosconnect.signing->signatory
            include firefly.tezosconnect.persistence->firefly.tezosState
            include firefly.core->firefly.tezosconnect.api
            autoLayout lr 360 200
        }
        component firefly.tezosconnect "75-tezosconnect-events" "Component - TezosConnect + FFTM: events" {
            title "Component - TezosConnect + FFTM: events"
            include firefly.tezosconnect.api firefly.tezosconnect.blocks firefly.tezosconnect.events firefly.tezosconnect.streams firefly.tezosconnect.persistence tezos firefly.core firefly.tezosState
            exclude *->*
            include firefly.tezosconnect.blocks->firefly.tezosconnect.events
            include firefly.tezosconnect.events->firefly.tezosconnect.streams
            include firefly.tezosconnect.api->firefly.tezosconnect.streams
            include firefly.tezosconnect.api->firefly.tezosconnect.persistence
            include firefly.tezosconnect.streams->firefly.tezosconnect.persistence
            include firefly.tezosconnect.blocks->tezos
            include firefly.tezosconnect.persistence->firefly.tezosState
            include firefly.tezosconnect.streams->firefly.core
            include firefly.core->firefly.tezosconnect.api
            autoLayout lr 360 200
        }
        component firefly.cardanoconnect "75-cardanoconnect-operations" "Component - CardanoConnect: operations" {
            title "Component - CardanoConnect: operations"
            include firefly.cardanoconnect.server firefly.cardanoconnect.api firefly.cardanoconnect.operations firefly.cardanoconnect.blockchain firefly.cardanoconnect.blockfrost firefly.cardanoconnect.n2c firefly.cardanoconnect.signer firefly.cardanoconnect.persistence firefly.core firefly.cardanosigner blockfrostService cardano firefly.cardanoState
            exclude *->*
            include firefly.cardanoconnect.server->firefly.cardanoconnect.api
            include firefly.cardanoconnect.api->firefly.cardanoconnect.operations
            include firefly.cardanoconnect.operations->firefly.cardanoconnect.blockchain
            include firefly.cardanoconnect.blockchain->firefly.cardanoconnect.blockfrost
            include firefly.cardanoconnect.blockchain->firefly.cardanoconnect.n2c
            include firefly.cardanoconnect.operations->firefly.cardanoconnect.signer
            include firefly.cardanoconnect.operations->firefly.cardanoconnect.persistence
            include firefly.cardanoconnect.signer->firefly.cardanosigner
            include firefly.cardanoconnect.blockfrost->blockfrostService
            include blockfrostService->cardano
            include firefly.cardanoconnect.n2c->cardano
            include firefly.cardanoconnect.persistence->firefly.cardanoState
            include firefly.core->firefly.cardanoconnect.api
            autoLayout lr 360 200
        }
        component firefly.cardanoconnect "75-cardanoconnect-contracts-events" "Component - CardanoConnect: contracts-events" {
            title "Component - CardanoConnect: contracts-events"
            include firefly.cardanoconnect.api firefly.cardanoconnect.operations firefly.cardanoconnect.contracts firefly.cardanoconnect.balius firefly.cardanoconnect.blockchain firefly.cardanoconnect.streams firefly.cardanoconnect.persistence firefly.core firefly.cardanoState
            exclude *->*
            include firefly.cardanoconnect.api->firefly.cardanoconnect.operations
            include firefly.cardanoconnect.api->firefly.cardanoconnect.streams
            include firefly.cardanoconnect.operations->firefly.cardanoconnect.blockchain
            include firefly.cardanoconnect.operations->firefly.cardanoconnect.contracts
            include firefly.cardanoconnect.contracts->firefly.cardanoconnect.balius
            include firefly.cardanoconnect.contracts->firefly.cardanoconnect.blockchain
            include firefly.cardanoconnect.operations->firefly.cardanoconnect.persistence
            include firefly.cardanoconnect.streams->firefly.cardanoconnect.blockchain
            include firefly.cardanoconnect.streams->firefly.cardanoconnect.contracts
            include firefly.cardanoconnect.streams->firefly.cardanoconnect.persistence
            include firefly.cardanoconnect.contracts->firefly.cardanoconnect.persistence
            include firefly.cardanoconnect.persistence->firefly.cardanoState
            include firefly.cardanoconnect.streams->firefly.core
            include firefly.core->firefly.cardanoconnect.api
            autoLayout lr 360 200
        }
        component firefly.cardanosigner "75-cardanosigner-signing" "Component - Cardano Signer: signing" {
            title "Component - Cardano Signer: signing"
            include firefly.cardanosigner.server firefly.cardanosigner.api firefly.cardanosigner.keys firefly.cardanosigner.crypto firefly.cardanoconnect firefly.cardanoKeys
            exclude *->*
            include firefly.cardanosigner.server->firefly.cardanosigner.api
            include firefly.cardanosigner.api->firefly.cardanosigner.keys
            include firefly.cardanosigner.api->firefly.cardanosigner.crypto
            include firefly.cardanosigner.keys->firefly.cardanosigner.crypto
            include firefly.cardanosigner.keys->firefly.cardanoKeys
            include firefly.cardanoconnect->firefly.cardanosigner.api
            autoLayout lr 360 200
        }
        component firefly.cordaconnect "75-cordaconnect-starter" "Component - Corda connector starter: starter" {
            title "Component - Corda connector starter: starter"
            include firefly.cordaconnect.api firefly.cordaconnect.flows firefly.cordaconnect.events firefly.cordaconnect.websockets firefly.cordaconnect.persistence developer corda firefly.cordaState
            exclude *->*
            include developer->corda
            include firefly.cordaconnect.api->firefly.cordaconnect.flows
            include firefly.cordaconnect.api->firefly.cordaconnect.events
            include firefly.cordaconnect.flows->firefly.cordaconnect.events
            include firefly.cordaconnect.events->firefly.cordaconnect.websockets
            include firefly.cordaconnect.events->firefly.cordaconnect.persistence
            include firefly.cordaconnect.flows->corda
            include firefly.cordaconnect.persistence->firefly.cordaState
            include firefly.cordaconnect.websockets->developer
            include developer->firefly.cordaconnect.api
            autoLayout lr 360 200
        }
        container firefly "76-legacy-broker-options" "Container - Legacy connector broker and receipt options" {
            title "Container - Legacy connector broker and receipt options"
            include firefly.ethconnect firefly.fabconnect kafkaBroker mongo
            exclude *->*
            include firefly.ethconnect->kafkaBroker
            include firefly.fabconnect->kafkaBroker
            include firefly.ethconnect->mongo
            include firefly.fabconnect->mongo
            autoLayout lr 360 200
        }
        component tools.cli "64-cli" "Component - FireFly CLI" {
            title "Component - FireFly CLI"
            include tools.cli.commands tools.cli.stacks tools.cli.docker tools.cli.blockchains tools.cli.tokens tools.cli.core developer dockerEngine firefly.core
            exclude *->*
            include tools.cli.commands->tools.cli.stacks
            include tools.cli.stacks->tools.cli.docker
            include tools.cli.stacks->tools.cli.blockchains
            include tools.cli.stacks->tools.cli.tokens
            include tools.cli.stacks->tools.cli.core
            include tools.cli.docker->dockerEngine
            include tools.cli.core->firefly.core
            include developer->tools.cli.commands
            autoLayout lr 360 200
        }
        component tools.perf "65-performance" "Component - FireFly Performance CLI" {
            title "Component - FireFly Performance CLI"
            include tools.perf.commands tools.perf.runner tools.perf.server tools.perf.report developer firefly.core
            exclude *->*
            include tools.perf.commands->tools.perf.runner
            include tools.perf.server->tools.perf.runner
            include tools.perf.runner->tools.perf.report
            include tools.perf.runner->firefly.core
            include developer->tools.perf.commands
            autoLayout lr 360 200
        }
        component tools.eventAudit "66-event-audit" "Component - FireFly event auditor" {
            title "Component - FireFly event auditor"
            include tools.eventAudit.reader tools.eventAudit.ordering developer firefly.core
            exclude *->*
            include tools.eventAudit.reader->firefly.core
            include tools.eventAudit.reader->tools.eventAudit.ordering
            include tools.eventAudit.ordering->developer
            autoLayout lr 360 200
        }
        component tools.config "67-config-migration" "Component - FireFly configuration migrator" {
            title "Component - FireFly configuration migrator"
            include tools.config.commands tools.config.migration developer
            exclude *->*
            include developer->tools.config.commands
            include tools.config.commands->tools.config.migration
            include tools.config.migration->developer
            autoLayout lr 360 200
        }
        styles {
            element "Element" {
                color #122C43
                stroke #57718A
                strokeWidth 2
                fontSize 22
                width 360
                height 220
            }
            element "Person" {
                shape Person
                background #173F5F
                color #FFFFFF
            }
            element "Software System" {
                background #176B87
                color #FFFFFF
            }
            element "Container" {
                background #DCECF7
            }
            element "Component" {
                background #EEF5FA
            }
            element "Database" {
                shape Cylinder
                background #E8E4F5
            }
            element "Private" {
                stroke #8C4966
            }
            element "Shared" {
                stroke #237A69
            }
            element "Blockchain" {
                background #EFE4C8
                stroke #9B782E
                color #122C43
            }
            element "Contract" {
                background #FFF3D3
            }
            element "Optional" {
                background #F0F0F0
                stroke #7A7A7A
                border Dashed
                color #122C43
            }
            element "Operational" {
                background #E8EEEE
                stroke #59736C
            }
            element "Deployment Node" {
                background #FFFFFF
                stroke #A5B8C5
                fontSize 26
            }
            element "Zone1" {
                background #F4F9FD
                stroke #3680AD
            }
            element "Zone2" {
                background #F3FAF5
                stroke #428A61
            }
            element "Zone3" {
                background #FCF7EF
                stroke #A77E42
            }
            relationship "Relationship" {
                color #476177
                fontSize 18
                thickness 2
                routing Orthogonal
                dashed false
            }
            relationship "PrivateFlow" {
                color #8C4966
                fontSize 18
                thickness 2
                routing Orthogonal
                dashed false
            }
            relationship "SharedFlow" {
                color #237A69
                fontSize 18
                thickness 2
                routing Orthogonal
                dashed false
            }
            relationship "BlockchainFlow" {
                color #967228
                fontSize 18
                thickness 2
                routing Orthogonal
                dashed false
            }
            relationship "Operational" {
                color #6D817A
                fontSize 18
                thickness 2
                routing Orthogonal
                dashed true
            }
            relationship "Alternative" {
                color #888888
                fontSize 18
                thickness 2
                routing Orthogonal
                dashed true
            }
        }
        properties {
            "structurizr.sort" "key"
        }
    }
    configuration {
        scope none
    }
}
