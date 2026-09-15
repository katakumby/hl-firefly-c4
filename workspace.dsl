// Generated from scripts/build_workspace.py and model_data.py. Rebuild after editing the source definitions.
workspace "FireFly + Besu - three-member consortium" "C4 levels 1-3 and three-zone AKS reference with explicit static dataflows." {
    !identifiers hierarchical
    !impliedRelationships false
    properties {
        "structurizr.inspection.workspace.scope" "info"
    }
    !docs docs/workspace
    !adrs decisions
    model {
        developer = person "Application developer" "Builds and tests member business integrations." {
            url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            properties {
                "architecture.id" "developer"
                "evidence" "Reference choice"
            }
        }
        operator = person "Consortium operator" "Operates member namespaces, recovery and the Besu network." {
            url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            properties {
                "architecture.id" "operator"
                "evidence" "Reference choice"
            }
        }
        business = person "Business user" "Submits consortium business actions through a member application." {
            url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            properties {
                "architecture.id" "business"
                "evidence" "Reference choice"
            }
        }
        firefly = softwareSystem "Hyperledger FireFly" "Reusable supernode architecture; each consortium member deploys an isolated instance." {
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d"
            properties {
                "architecture.id" "firefly"
                "evidence" "Implementation"
            }
            !docs docs/system
            !adrs decisions
            core = container "FireFly Core" "Exposes member APIs and bundled Explorer; orchestrates multiparty operations." "Go + React" {
                url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                properties {
                    "architecture.id" "firefly.core"
                    "evidence" "Implementation"
                }
                api = component "REST API and routing" "Accepts namespace-scoped commands and queries." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/apiserver"
                    properties {
                        "architecture.id" "firefly.core.api"
                        "evidence" "Implementation"
                    }
                }
                explorer = component "Explorer UI" "Serves the bundled React operator interface." "React / TypeScript" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/Dockerfile"
                    properties {
                        "architecture.id" "firefly.core.explorer"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.api "Queries messages, operations and network state" "In-process calls / Go" "Dataflow"
                }
                auth = component "API authentication" "Applies configured namespace authorization; Basic Auth reference plugin." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/doc-site/docs/overview/key_components/security.md"
                    properties {
                        "architecture.id" "firefly.core.auth"
                        "evidence" "Implementation"
                    }
                }
                namespaces = component "Namespace manager" "Initializes isolated orchestrators and configured plugins." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/namespace"
                    properties {
                        "architecture.id" "firefly.core.namespaces"
                        "evidence" "Implementation"
                    }
                }
                orchestrator = component "Orchestrator" "Coordinates API operations and subsystem lifecycles." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                    properties {
                        "architecture.id" "firefly.core.orchestrator"
                        "evidence" "Implementation"
                    }
                }
                identity = component "Identity manager" "Resolves organizations, nodes and transaction signing identities." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/identity"
                    properties {
                        "architecture.id" "firefly.core.identity"
                        "evidence" "Implementation"
                    }
                }
                networkmap = component "Network map" "Indexes registered members, nodes and their endpoints." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/networkmap"
                    properties {
                        "architecture.id" "firefly.core.networkmap"
                        "evidence" "Implementation"
                    }
                }
                definitions = component "Definition exchange" "Publishes and processes schemas, interfaces and token definitions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/definitions"
                    properties {
                        "architecture.id" "firefly.core.definitions"
                        "evidence" "Implementation"
                    }
                }
                data = component "Data manager" "Validates, hashes and retrieves structured data and blob references." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    properties {
                        "architecture.id" "firefly.core.data"
                        "evidence" "Implementation"
                    }
                }
                schema = component "Schema validation" "Checks JSON payloads against registered datatype definitions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    properties {
                        "architecture.id" "firefly.core.schema"
                        "evidence" "Implementation"
                    }
                }
                batch = component "Batch manager" "Selects outbound messages and dispatches recoverable batches." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    properties {
                        "architecture.id" "firefly.core.batch"
                        "evidence" "Implementation"
                    }
                }
                batchprocessor = component "Batch processor" "Assembles ordered message batches and aggregate hashes." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    properties {
                        "architecture.id" "firefly.core.batchprocessor"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.data "Loads payloads for batch assembly" "In-process calls / Go" "Dataflow"
                }
                broadcast = component "Broadcast manager" "Publishes shared payloads and orchestrates ledger pinning." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/broadcast"
                    properties {
                        "architecture.id" "firefly.core.broadcast"
                        "evidence" "Implementation"
                    }
                }
                private = component "Private messaging and groups" "Routes messages to recipient groups and coordinates delivery." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/privatemessaging"
                    properties {
                        "architecture.id" "firefly.core.private"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.identity "Resolves group recipients and endpoints" "In-process calls / Go" "Dataflow"
                }
                multiparty = component "Multiparty manager" "Coordinates network actions and FireFly contract pinning." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/multiparty"
                    properties {
                        "architecture.id" "firefly.core.multiparty"
                        "evidence" "Implementation"
                    }
                }
                download = component "Shared download manager" "Retrieves referenced broadcast batches and blobs." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/shareddownload"
                    properties {
                        "architecture.id" "firefly.core.download"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.data "Validates downloaded data and stores metadata" "In-process calls / Go" "Dataflow"
                }
                contracts = component "Contract manager" "Maps FFIs and APIs to contract calls and event listeners." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/contracts"
                    properties {
                        "architecture.id" "firefly.core.contracts"
                        "evidence" "Implementation"
                    }
                }
                assets = component "Asset manager" "Coordinates token pools, balances and transfers." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/assets"
                    properties {
                        "architecture.id" "firefly.core.assets"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.contracts "Resolves token contract interfaces" "In-process calls / Go" "Dataflow"
                }
                operations = component "Operations manager" "Tracks asynchronous connector requests and results." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/operations"
                    properties {
                        "architecture.id" "firefly.core.operations"
                        "evidence" "Implementation"
                    }
                }
                txhelper = component "Transaction helper" "Correlates operations, messages and blockchain transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txcommon"
                    properties {
                        "architecture.id" "firefly.core.txhelper"
                        "evidence" "Implementation"
                    }
                }
                txwriter = component "Transaction writer" "Batches transaction persistence and submission work." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txwriter"
                    properties {
                        "architecture.id" "firefly.core.txwriter"
                        "evidence" "Implementation"
                    }
                }
                aggregator = component "Inbound event aggregator" "Correlates ledger pins with payloads and sequences confirmed messages." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/aggregator.go"
                    properties {
                        "architecture.id" "firefly.core.aggregator"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.download "Requests missing shared data" "In-process calls / Go" "Dataflow"
                }
                subscriptions = component "Subscription manager" "Filters events and persists subscriber offsets." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/subscription_manager.go"
                    properties {
                        "architecture.id" "firefly.core.subscriptions"
                        "evidence" "Implementation"
                    }
                }
                dispatcher = component "Event dispatcher" "Delivers ordered event batches and processes acknowledgements." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/event_dispatcher.go"
                    properties {
                        "architecture.id" "firefly.core.dispatcher"
                        "evidence" "Implementation"
                    }
                }
                syncasync = component "Sync/async bridge" "Correlates asynchronous completion with waiting API requests." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/syncasync"
                    properties {
                        "architecture.id" "firefly.core.syncasync"
                        "evidence" "Implementation"
                    }
                }
                cache = component "Cache manager" "Caches reusable namespace resources and lookups." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/cache"
                    properties {
                        "architecture.id" "firefly.core.cache"
                        "evidence" "Implementation"
                    }
                }
                metrics = component "Metrics" "Exposes runtime and operation measurements." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/metrics"
                    properties {
                        "architecture.id" "firefly.core.metrics"
                        "evidence" "Implementation"
                    }
                }
                spievents = component "SPI event manager" "Publishes internal lifecycle and namespace change events." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/spievents"
                    properties {
                        "architecture.id" "firefly.core.spievents"
                        "evidence" "Implementation"
                    }
                }
                blockchain = component "Blockchain plugin" "Binds Ethereum operations to EVMConnect; other chains are alternatives." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain"
                    properties {
                        "architecture.id" "firefly.core.blockchain"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.aggregator "Delivers confirmed ledger events" "In-process calls / Go" "Dataflow"
                }
                database = component "Database plugin" "Maps logical resources to PostgreSQL; SQLite is an alternative." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/database"
                    properties {
                        "architecture.id" "firefly.core.database"
                        "evidence" "Implementation"
                    }
                }
                dataexchange = component "Data exchange plugin" "Binds message, blob and peer operations to the HTTPS connector." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/dataexchange"
                    properties {
                        "architecture.id" "firefly.core.dataexchange"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.aggregator "Delivers received payload notifications" "In-process calls / Go" "Dataflow"
                }
                sharedstorage = component "Shared storage plugin" "Publishes and retrieves content through IPFS APIs." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/sharedstorage"
                    properties {
                        "architecture.id" "firefly.core.sharedstorage"
                        "evidence" "Implementation"
                    }
                }
                tokens = component "Token plugin" "Binds standard token operations to remote token connectors." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/tokens"
                    properties {
                        "architecture.id" "firefly.core.tokens"
                        "evidence" "Implementation"
                    }
                    -> firefly.core.aggregator "Delivers token creation and transfer events" "In-process calls / Go" "Dataflow"
                }
                identityplugin = component "Identity plugin" "Resolves external identity claims through the configured resolver." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/pkg/identity"
                    properties {
                        "architecture.id" "firefly.core.identityplugin"
                        "evidence" "Implementation"
                    }
                }
                eventplugin = component "Event transport plugins" "Provides WebSocket, webhook and system-event delivery." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events"
                    properties {
                        "architecture.id" "firefly.core.eventplugin"
                        "evidence" "Implementation"
                    }
                }
                !element firefly.core.api {
                    -> firefly.core.auth "Passes request credentials for authorization" "In-process calls / Go" "Dataflow"
                    -> firefly.core.namespaces "Resolves the requested namespace" "In-process calls / Go" "Dataflow"
                    -> firefly.core.orchestrator "Submits validated commands and queries" "In-process calls / Go" "Dataflow"
                }
                !element firefly.core.namespaces {
                    -> firefly.core.orchestrator "Initializes namespace resources and plugins" "In-process calls / Go" "Dataflow"
                    -> firefly.core.spievents "Publishes namespace lifecycle changes" "In-process calls / Go" "Dataflow"
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
                    -> firefly.core.identityplugin "Resolves configured identity claims" "In-process calls / Go" "Dataflow"
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
            }
            evm = container "EVMConnect + FFTM" "Submits Ethereum transactions and streams confirmed events; one nonce writer." "Go" {
                url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                properties {
                    "architecture.id" "firefly.evm"
                    "evidence" "Implementation"
                }
                api = component "Connector REST API" "Accepts transaction, query and event-stream requests." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                    properties {
                        "architecture.id" "firefly.evm.api"
                        "evidence" "Implementation"
                    }
                }
                manager = component "Transaction manager" "Coordinates durable transaction and stream lifecycles." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    properties {
                        "architecture.id" "firefly.evm.manager"
                        "evidence" "Implementation"
                    }
                }
                handler = component "Transaction policy handler" "Schedules signing, submission, gas and retry policy." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/txhandler"
                    properties {
                        "architecture.id" "firefly.evm.handler"
                        "evidence" "Implementation"
                    }
                }
                nonce = component "Nonce allocation" "Assigns and persists ordered nonces per signing address." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    properties {
                        "architecture.id" "firefly.evm.nonce"
                        "evidence" "Implementation"
                    }
                }
                abi = component "EVM API adapter" "Encodes ABIs and implements the blockchain connector API." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/internal/ethereum"
                    properties {
                        "architecture.id" "firefly.evm.abi"
                        "evidence" "Implementation"
                    }
                }
                rpc = component "Ethereum JSON-RPC client" "Submits calls and transactions through the signing proxy." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethrpc"
                    properties {
                        "architecture.id" "firefly.evm.rpc"
                        "evidence" "Implementation"
                    }
                }
                blocks = component "Block listener" "Tracks chain heads and block/filter updates." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethblocklistener"
                    properties {
                        "architecture.id" "firefly.evm.blocks"
                        "evidence" "Implementation"
                    }
                }
                receipts = component "Receipt tracking" "Polls receipt status for submitted transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    properties {
                        "architecture.id" "firefly.evm.receipts"
                        "evidence" "Implementation"
                    }
                    -> firefly.evm.rpc "Queries transaction receipt status" "In-process calls / Go" "Dataflow"
                }
                confirmations = component "Confirmation manager" "Confirms receipts and events against the observed chain." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/confirmations"
                    properties {
                        "architecture.id" "firefly.evm.confirmations"
                        "evidence" "Implementation"
                    }
                }
                streams = component "Event streams" "Orders and batches confirmed listener events." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/events"
                    properties {
                        "architecture.id" "firefly.evm.streams"
                        "evidence" "Implementation"
                    }
                }
                delivery = component "WebSocket and webhook delivery" "Delivers batches and accepts consumer acknowledgements." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/ws"
                    properties {
                        "architecture.id" "firefly.evm.delivery"
                        "evidence" "Implementation"
                    }
                    -> firefly.evm.streams "Acknowledges consumed batches" "In-process calls / Go" "Dataflow"
                    -> firefly.core "Delivers confirmed event batches" "WebSocket / JSON" "Dataflow"
                }
                persistence = component "Persistence adapter" "Stores transactions, nonces, streams and checkpoints." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    properties {
                        "architecture.id" "firefly.evm.persistence"
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
            blobs = container "Private blob and peer store" "Stores private blobs and mutable peer metadata." "Filesystem / Premium SSD ZRS" {
                tags "Database,Private"
                url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                properties {
                    "architecture.id" "firefly.blobs"
                    "evidence" "Implementation"
                }
            }
            ipfsRepo = container "IPFS repository" "Stores this member's Kubo identity, pins and content blocks." "Filesystem / Premium SSD ZRS" {
                tags "Database,Shared"
                url "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                properties {
                    "architecture.id" "firefly.ipfsRepo"
                    "evidence" "Implementation"
                }
            }
            secrets = container "Member keys and configuration" "Holds signing keystores, mTLS keys and configuration." "Kubernetes Secrets" {
                tags "Database,Private"
                url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                properties {
                    "architecture.id" "firefly.secrets"
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
            }
            !element firefly.evm {
                -> firefly.signer "Submits Ethereum calls and unsigned transactions" "HTTP JSON-RPC" "Dataflow"
                -> firefly.pg "Reads and writes the separate FFTM database" "PostgreSQL wire / TLS" "Dataflow"
                -> firefly.secrets "Loads connector endpoints and credentials" "Read-only projected files" "Dataflow"
                -> firefly.erc20.stream "Streams confirmed token logs" "WebSocket / JSON" "Dataflow"
                -> firefly.erc1155.stream "Streams confirmed token logs" "WebSocket / JSON" "Dataflow"
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
        }
        besu = softwareSystem "Private Besu network" "Permissioned Ethereum network with QBFT validators, private RPC and contracts." {
            tags "Blockchain"
            url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
            properties {
                "architecture.id" "besu"
                "evidence" "Implementation"
            }
            !docs docs/system
            !adrs decisions
            node = container "Besu node" "Runs the selected validator or non-validator RPC/discovery role; each instance owns its key and ledger." "Java / Besu / RocksDB" {
                tags "Blockchain"
                url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                properties {
                    "architecture.id" "besu.node"
                    "evidence" "Implementation"
                }
                rpc = component "JSON-RPC and subscriptions" "Accepts private-network queries and signed transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    properties {
                        "architecture.id" "besu.node.rpc"
                        "evidence" "Implementation"
                    }
                }
                permissioning = component "Node and account permissioning" "Applies local peer and account allowlists." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    properties {
                        "architecture.id" "besu.node.permissioning"
                        "evidence" "Implementation"
                    }
                }
                discovery = component "Peer discovery" "Discovers peers through configured bootnodes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.node.discovery"
                        "evidence" "Implementation"
                    }
                }
                p2p = component "DevP2P transport" "Exchanges transactions, blocks and consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.node.p2p"
                        "evidence" "Implementation"
                    }
                    -> besu.node.permissioning "Checks connecting node admission" "In-process calls / Java" "Dataflow"
                }
                txpool = component "Transaction pool" "Validates and queues pending transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.node.txpool"
                        "evidence" "Implementation"
                    }
                }
                sync = component "Chain synchronization" "Downloads and validates missing blocks and state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.node.sync"
                        "evidence" "Implementation"
                    }
                }
                blockprocessor = component "Block processor" "Validates blocks and applies state transitions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    properties {
                        "architecture.id" "besu.node.blockprocessor"
                        "evidence" "Implementation"
                    }
                }
                qbft = component "QBFT consensus" "Proposes blocks and verifies validator votes. Active only on validator instances." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/consensus/qbft"
                    properties {
                        "architecture.id" "besu.node.qbft"
                        "evidence" "Implementation"
                    }
                    -> besu.node.blockprocessor "Commits quorum-approved blocks" "In-process calls / Java" "Dataflow"
                }
                evm = component "EVM execution" "Executes smart-contract bytecode deterministically." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    properties {
                        "architecture.id" "besu.node.evm"
                        "evidence" "Implementation"
                    }
                }
                worldstate = component "World state and trie" "Tracks account balances, storage and contract state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    properties {
                        "architecture.id" "besu.node.worldstate"
                        "evidence" "Implementation"
                    }
                }
                storage = component "Storage provider" "Persists blockchain data and world-state records." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    properties {
                        "architecture.id" "besu.node.storage"
                        "evidence" "Implementation"
                    }
                }
                keys = component "Node key and security module" "Signs node identity and validator consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    properties {
                        "architecture.id" "besu.node.keys"
                        "evidence" "Implementation"
                    }
                }
                metrics = component "Metrics and health" "Exposes node, peer and consensus measurements." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    properties {
                        "architecture.id" "besu.node.metrics"
                        "evidence" "Implementation"
                    }
                }
                fireflycontract = component "FireFly multiparty contract" "Executes batch pinning and emits sequencing events." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    properties {
                        "architecture.id" "besu.node.fireflycontract"
                        "evidence" "Implementation"
                    }
                    -> besu.node.worldstate "Writes pinning state and log results" "In-process calls / Java" "Dataflow"
                }
                tokencontracts = component "Token contracts" "Executes ERC-20, ERC-721 and ERC-1155 state changes." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    properties {
                        "architecture.id" "besu.node.tokencontracts"
                        "evidence" "Implementation"
                    }
                    -> besu.node.worldstate "Writes token balances and log results" "In-process calls / Java" "Dataflow"
                }
                businesscontracts = component "Application contracts" "Executes member-defined business rules; example extension." "Solidity / EVM" {
                    tags "Contract"
                    url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    properties {
                        "architecture.id" "besu.node.businesscontracts"
                        "evidence" "Reference choice"
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
            url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            properties {
                "architecture.id" "apps"
                "evidence" "Reference choice"
            }
            !docs docs/system
            !adrs decisions
            client = container "Member business application" "Submits requests and consumes acknowledged FireFly events." "Example application / REST client" {
                url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                properties {
                    "architecture.id" "apps.client"
                    "evidence" "Reference choice"
                }
                -> firefly.core "Submits member-scoped commands and queries" "HTTPS / REST" "Dataflow"
                -> firefly.core.api "Submits API commands and queries" "HTTPS / REST" "Dataflow"
            }
            -> firefly "Submits member requests and consumes events" "HTTPS + WebSocket" "Dataflow"
        }
        tools = softwareSystem "FireFly developer tools" "Development utilities and optional sample applications." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/doc-site/docs/overview/key_components/tools.md"
            properties {
                "architecture.id" "tools"
                "evidence" "Implementation"
            }
            !docs docs/system
            !adrs decisions
            cli = container "FireFly CLI" "Creates local stacks and performs development administration." "Go / CLI" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/doc-site/docs/overview/key_components/tools.md"
                properties {
                    "architecture.id" "tools.cli"
                    "evidence" "Implementation"
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
                    url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069"
                    properties {
                        "architecture.id" "tools.sandbox.frontend"
                        "evidence" "Implementation"
                    }
                }
                backend = component "Sandbox backend" "Maps UI actions into SDK requests." "Node.js / TypeScript" {
                    url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069"
                    properties {
                        "architecture.id" "tools.sandbox.backend"
                        "evidence" "Implementation"
                    }
                }
                sdk = component "FireFly Node.js SDK" "Calls the selected API and consumes events." "TypeScript library" {
                    url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069"
                    properties {
                        "architecture.id" "tools.sandbox.sdk"
                        "evidence" "Implementation"
                    }
                    -> firefly.core "Invokes member APIs and consumes events" "HTTPS + WebSocket" "Dataflow"
                }
                !element tools.sandbox.frontend {
                    -> tools.sandbox.backend "Submits selected sample actions" "HTTP / JSON" "Dataflow"
                }
                !element tools.sandbox.backend {
                    -> tools.sandbox.sdk "Submits SDK requests" "In-process calls / TypeScript" "Dataflow"
                }
                -> firefly.core "Exercises APIs and subscriptions" "HTTPS + WebSocket" "Dataflow"
            }
            -> firefly "Exercises the selected member API" "HTTPS + WebSocket" "Dataflow"
        }
        ops = softwareSystem "Platform operations" "Reference ingress, database operations and metrics on AKS." {
            url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            properties {
                "architecture.id" "ops"
                "evidence" "Reference choice"
            }
            !docs docs/system
            !adrs decisions
            gateway = container "Gateway / ingress" "Routes API traffic; preserves peer mTLS with TLS passthrough." "Envoy Gateway / Kubernetes" {
                tags "Operational"
                url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
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
                url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                properties {
                    "architecture.id" "ops.prometheus"
                    "evidence" "Reference choice"
                }
                -> firefly.core "Scrapes member runtime measurements" "HTTP / Prometheus metrics" "Operational"
                -> besu.node "Scrapes peer, block and consensus measurements" "HTTP / Prometheus metrics" "Operational"
            }
            grafana = container "Operations dashboard" "Displays metrics, replication lag and quorum health." "Grafana" {
                tags "Operational"
                url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                properties {
                    "architecture.id" "ops.grafana"
                    "evidence" "Reference choice"
                }
                -> ops.prometheus "Queries operational time series" "HTTP / PromQL" "Operational"
            }
            -> firefly "Routes API requests and observes health" "HTTPS + metrics" "Operational"
            -> besu "Observes peer and quorum health" "HTTP / metrics" "Operational"
        }
        ethconnect = softwareSystem "EthConnect / Ethereum" "Alternative Ethereum connector; different transaction-management architecture." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/README.md"
            properties {
                "architecture.id" "ethconnect"
                "evidence" "Alternative"
            }
        }
        fabric = softwareSystem "Fabric / FabConnect" "Alternative permissioned-ledger adapter and network." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain/fabric"
            properties {
                "architecture.id" "fabric"
                "evidence" "Alternative"
            }
        }
        tezos = softwareSystem "Tezos connector / network" "Alternative supported blockchain adapter." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain/tezos"
            properties {
                "architecture.id" "tezos"
                "evidence" "Alternative"
            }
        }
        cardano = softwareSystem "Cardano connector / network" "Alternative supported blockchain adapter." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain/cardano"
            properties {
                "architecture.id" "cardano"
                "evidence" "Alternative"
            }
        }
        corda = softwareSystem "Corda connector starter" "Extension starter requiring CorDapp customization; not turnkey." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/README.md"
            properties {
                "architecture.id" "corda"
                "evidence" "Alternative"
            }
        }
        !element firefly {
            -> besu "Submits transactions and consumes finalized events" "Ethereum JSON-RPC + events" "Dataflow"
            -> ethconnect "Can route blockchain operations here when configured instead" "Connector API / backend-specific transport" "Alternative"
            -> fabric "Can route blockchain operations here when configured instead" "Connector API / backend-specific transport" "Alternative"
            -> tezos "Can route blockchain operations here when configured instead" "Connector API / backend-specific transport" "Alternative"
            -> cardano "Can route blockchain operations here when configured instead" "Connector API / backend-specific transport" "Alternative"
            -> corda "Can route blockchain operations here when configured instead" "Connector API / backend-specific transport" "Alternative"
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
            -> ethconnect "Can bind the blockchain plugin to this alternative" "Connector API / backend-specific transport" "Alternative"
            -> fabric "Can bind the blockchain plugin to this alternative" "Connector API / backend-specific transport" "Alternative"
            -> tezos "Can bind the blockchain plugin to this alternative" "Connector API / backend-specific transport" "Alternative"
            -> cardano "Can bind the blockchain plugin to this alternative" "Connector API / backend-specific transport" "Alternative"
            -> corda "Can bind the blockchain plugin to this alternative" "Connector API / backend-specific transport" "Alternative"
        }
        !element firefly.core.eventplugin {
            -> apps.client "Delivers events through configured transports" "WebSocket / webhook / HTTPS" "Dataflow"
        }
        !element developer {
            -> tools "Develops and tests integrations" "CLI + HTTPS" "Dataflow"
            -> tools.cli "Creates local test stacks" "Local process invocation" "Dataflow"
            -> tools.sandbox "Exercises sample workflows" "HTTPS" "Dataflow"
        }
        production = deploymentEnvironment "AKS reference" {
            memberA = deploymentGroup "Member A private runtime"
            memberB = deploymentGroup "Member B private runtime"
            memberC = deploymentGroup "Member C private runtime"
            privateExchange = deploymentGroup "Authenticated Data Exchange peers"
            sharedContent = deploymentGroup "Shared IPFS swarm"
            rpcAccess = deploymentGroup "Private RPC clients and endpoints"
            blockchain = deploymentGroup "Besu peer network"
            azure = deploymentNode "Azure region" "One region supporting three zones and Premium SSD ZRS." "Microsoft Azure" {
                properties {
                    "architecture.id" "azure"
                }
                cluster = deploymentNode "AKS reference cluster" "Separate member namespaces; shared administrative trust." "Azure Kubernetes Service" {
                    properties {
                        "architecture.id" "azure.cluster"
                    }
                    az1 = deploymentNode "Availability Zone 1" "Independent fault domain AZ 1." "Azure availability zone" {
                        tags "Zone1"
                        properties {
                            "architecture.id" "azure.cluster.az1"
                        }
                        system = deploymentNode "System node pool" "System capacity in AZ 1." "AKS VM scale set" {
                            properties {
                                "architecture.id" "azure.cluster.az1.system"
                            }
                            agent = infrastructureNode "Cluster services" "Runs DNS, networking and storage agents." "CoreDNS / CNI / CSI" {
                                tags "Operational"
                                properties {
                                    "architecture.id" "azure.cluster.az1.system.agent"
                                }
                            }
                        }
                        apps = deploymentNode "Application node pool" "Member pods; surviving zones retain spare recovery capacity." "AKS Linux nodes" {
                            properties {
                                "architecture.id" "azure.cluster.az1.apps"
                            }
                            gateway = deploymentNode "Ingress pod" "Routes API requests and passes peer TLS through unchanged." "Kubernetes Deployment" {
                                properties {
                                    "architecture.id" "azure.cluster.az1.apps.gateway"
                                }
                                instance = containerInstance ops.gateway production.memberA,production.memberB,production.memberC,production.blockchain {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.apps.gateway.instance"
                                        "member" "consortium"
                                        "zone" "1"
                                        "role" "active"
                                    }
                                }
                            }
                            cnpg = deploymentNode "cnpg pod" "Operational replicas are spread across zones." "Kubernetes Deployment" {
                                properties {
                                    "architecture.id" "azure.cluster.az1.apps.cnpg"
                                }
                                instance = containerInstance ops.cnpg production.memberA,production.memberB,production.memberC,production.blockchain {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.apps.cnpg.instance"
                                        "member" "consortium"
                                        "zone" "1"
                                        "role" "active"
                                    }
                                }
                            }
                            prometheus = deploymentNode "prometheus pod" "Operational replicas are spread across zones." "Kubernetes Deployment" {
                                properties {
                                    "architecture.id" "azure.cluster.az1.apps.prometheus"
                                }
                                instance = containerInstance ops.prometheus production.memberA,production.memberB,production.memberC,production.blockchain {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.apps.prometheus.instance"
                                        "member" "consortium"
                                        "zone" "1"
                                        "role" "active"
                                    }
                                }
                            }
                            grafana = deploymentNode "Grafana pod" "Provisioned dashboards; restart eligible in surviving zones." "Kubernetes Deployment" {
                                properties {
                                    "architecture.id" "azure.cluster.az1.apps.grafana"
                                }
                                instance = containerInstance ops.grafana production.memberA,production.memberB,production.memberC,production.blockchain {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.apps.grafana.instance"
                                        "member" "consortium"
                                        "zone" "1"
                                        "role" "active"
                                    }
                                }
                            }
                            memberA = deploymentNode "Member A namespace - active services" "Separate identity and NetworkPolicies; restart eligible in AZ 1/2/3." "Kubernetes namespace / placement slice" {
                                tags "MemberA"
                                properties {
                                    "architecture.id" "azure.cluster.az1.apps.memberA"
                                }
                                core = deploymentNode "FireFly Core pod" "One active member instance; fence before replacement after node loss." "Kubernetes StatefulSet" {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.apps.memberA.core"
                                    }
                                    instance = containerInstance firefly.core production.memberA {
                                        properties {
                                            "architecture.id" "azure.cluster.az1.apps.memberA.core.instance"
                                            "member" "a"
                                            "zone" "1"
                                            "role" "active"
                                        }
                                    }
                                }
                                evm = deploymentNode "EVMConnect + FFTM pod" "One active member instance; fence before replacement after node loss." "Kubernetes StatefulSet" {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.apps.memberA.evm"
                                    }
                                    instance = containerInstance firefly.evm production.memberA {
                                        properties {
                                            "architecture.id" "azure.cluster.az1.apps.memberA.evm.instance"
                                            "member" "a"
                                            "zone" "1"
                                            "role" "active"
                                        }
                                    }
                                }
                                signer = deploymentNode "FireFly Signer pod" "One active member instance; fence before replacement after node loss." "Kubernetes Deployment" {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.apps.memberA.signer"
                                    }
                                    instance = containerInstance firefly.signer production.memberA,production.rpcAccess {
                                        properties {
                                            "architecture.id" "azure.cluster.az1.apps.memberA.signer.instance"
                                            "member" "a"
                                            "zone" "1"
                                            "role" "active"
                                        }
                                    }
                                }
                                dx = deploymentNode "HTTPS Data Exchange pod" "One active member instance; fence before replacement after node loss." "Kubernetes StatefulSet" {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.apps.memberA.dx"
                                    }
                                    instance = containerInstance firefly.dx production.memberA,production.privateExchange {
                                        properties {
                                            "architecture.id" "azure.cluster.az1.apps.memberA.dx.instance"
                                            "member" "a"
                                            "zone" "1"
                                            "role" "active"
                                        }
                                    }
                                }
                                erc20 = deploymentNode "ERC-20 / ERC-721 connector pod" "One active member instance; fence before replacement after node loss." "Kubernetes Deployment" {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.apps.memberA.erc20"
                                    }
                                    instance = containerInstance firefly.erc20 production.memberA {
                                        properties {
                                            "architecture.id" "azure.cluster.az1.apps.memberA.erc20.instance"
                                            "member" "a"
                                            "zone" "1"
                                            "role" "active"
                                        }
                                    }
                                }
                                erc1155 = deploymentNode "ERC-1155 connector pod" "One active member instance; fence before replacement after node loss." "Kubernetes Deployment" {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.apps.memberA.erc1155"
                                    }
                                    instance = containerInstance firefly.erc1155 production.memberA {
                                        properties {
                                            "architecture.id" "azure.cluster.az1.apps.memberA.erc1155.instance"
                                            "member" "a"
                                            "zone" "1"
                                            "role" "active"
                                        }
                                    }
                                }
                                ipfs = deploymentNode "IPFS Kubo pod" "One active member instance; fence before replacement after node loss." "Kubernetes StatefulSet" {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.apps.memberA.ipfs"
                                    }
                                    instance = containerInstance firefly.ipfs production.memberA,production.sharedContent {
                                        properties {
                                            "architecture.id" "azure.cluster.az1.apps.memberA.ipfs.instance"
                                            "member" "a"
                                            "zone" "1"
                                            "role" "active"
                                        }
                                    }
                                }
                                blobs = deploymentNode "ZRS volume - Private blob and peer store" "Replicated across three zones; RWO; fence and detach before reattach." "Premium SSD ZRS / CSI" {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.apps.memberA.blobs"
                                    }
                                    store = containerInstance firefly.blobs production.memberA {
                                        properties {
                                            "architecture.id" "azure.cluster.az1.apps.memberA.blobs.store"
                                            "member" "a"
                                            "zone" "regional"
                                            "role" "persistent volume"
                                        }
                                    }
                                }
                                ipfsRepo = deploymentNode "ZRS volume - IPFS repository" "Replicated across three zones; RWO; fence and detach before reattach." "Premium SSD ZRS / CSI" {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.apps.memberA.ipfsRepo"
                                    }
                                    store = containerInstance firefly.ipfsRepo production.memberA {
                                        properties {
                                            "architecture.id" "azure.cluster.az1.apps.memberA.ipfsRepo.store"
                                            "member" "a"
                                            "zone" "regional"
                                            "role" "persistent volume"
                                        }
                                    }
                                }
                            }
                        }
                        data = deploymentNode "Stateful node pool" "PostgreSQL and Besu; node anti-affinity separates replicas." "AKS Linux nodes" {
                            properties {
                                "architecture.id" "azure.cluster.az1.data"
                            }
                            pgA = deploymentNode "Member A PostgreSQL primary" "One instance per zone; separate Core/FFTM databases; ANY 1 synchronous standby." "CloudNativePG pod" {
                                tags "MemberA"
                                properties {
                                    "architecture.id" "azure.cluster.az1.data.pgA"
                                }
                                instance = containerInstance firefly.pg production.memberA {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.data.pgA.instance"
                                        "member" "a"
                                        "zone" "1"
                                        "role" "primary"
                                    }
                                }
                                volume = infrastructureNode "PGDATA A AZ 1" "Independent durable data directory for this instance." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az1.data.pgA.volume"
                                    }
                                }
                            }
                            pgB = deploymentNode "Member B PostgreSQL standby" "One instance per zone; separate Core/FFTM databases; ANY 1 synchronous standby." "CloudNativePG pod" {
                                tags "MemberB"
                                properties {
                                    "architecture.id" "azure.cluster.az1.data.pgB"
                                }
                                instance = containerInstance firefly.pgReplica production.memberB {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.data.pgB.instance"
                                        "member" "b"
                                        "zone" "1"
                                        "role" "standby"
                                    }
                                }
                                volume = infrastructureNode "PGDATA B AZ 1" "Independent durable data directory for this instance." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az1.data.pgB.volume"
                                    }
                                }
                            }
                            pgC = deploymentNode "Member C PostgreSQL standby" "One instance per zone; separate Core/FFTM databases; ANY 1 synchronous standby." "CloudNativePG pod" {
                                tags "MemberC"
                                properties {
                                    "architecture.id" "azure.cluster.az1.data.pgC"
                                }
                                instance = containerInstance firefly.pgReplica production.memberC {
                                    properties {
                                        "architecture.id" "azure.cluster.az1.data.pgC.instance"
                                        "member" "c"
                                        "zone" "1"
                                        "role" "standby"
                                    }
                                }
                                volume = infrastructureNode "PGDATA C AZ 1" "Independent durable data directory for this instance." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az1.data.pgC.volume"
                                    }
                                }
                            }
                            besua1 = deploymentNode "Besu A1 validator pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az1.data.besua1"
                                }
                                instance = containerInstance besu.node production.blockchain {
                                    description "A1: validator; owner A; AZ 1. Dedicated node key and ledger."
                                    properties {
                                        "architecture.id" "azure.cluster.az1.data.besua1.instance"
                                        "member" "a"
                                        "zone" "1"
                                        "role" "validator"
                                    }
                                }
                                volume = infrastructureNode "Besu ledger A1" "Dedicated node data, retained during replacement." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az1.data.besua1.volume"
                                    }
                                }
                            }
                            besub1 = deploymentNode "Besu B1 validator pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az1.data.besub1"
                                }
                                instance = containerInstance besu.node production.blockchain {
                                    description "B1: validator; owner B; AZ 1. Dedicated node key and ledger."
                                    properties {
                                        "architecture.id" "azure.cluster.az1.data.besub1.instance"
                                        "member" "b"
                                        "zone" "1"
                                        "role" "validator"
                                    }
                                }
                                volume = infrastructureNode "Besu ledger B1" "Dedicated node data, retained during replacement." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az1.data.besub1.volume"
                                    }
                                }
                            }
                            besurpc1 = deploymentNode "Besu RPC1 RPC pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az1.data.besurpc1"
                                }
                                instance = containerInstance besu.node production.blockchain,production.rpcAccess {
                                    description "RPC1: rpc and bootnode; owner CONSORTIUM; AZ 1. Dedicated node key and ledger."
                                    properties {
                                        "architecture.id" "azure.cluster.az1.data.besurpc1.instance"
                                        "member" "consortium"
                                        "zone" "1"
                                        "role" "rpc and bootnode"
                                    }
                                }
                                volume = infrastructureNode "Besu ledger RPC1" "Dedicated node data, retained during replacement." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az1.data.besurpc1.volume"
                                    }
                                }
                            }
                        }
                    }
                    az2 = deploymentNode "Availability Zone 2" "Independent fault domain AZ 2." "Azure availability zone" {
                        tags "Zone2"
                        properties {
                            "architecture.id" "azure.cluster.az2"
                        }
                        system = deploymentNode "System node pool" "System capacity in AZ 2." "AKS VM scale set" {
                            properties {
                                "architecture.id" "azure.cluster.az2.system"
                            }
                            agent = infrastructureNode "Cluster services" "Runs DNS, networking and storage agents." "CoreDNS / CNI / CSI" {
                                tags "Operational"
                                properties {
                                    "architecture.id" "azure.cluster.az2.system.agent"
                                }
                            }
                        }
                        apps = deploymentNode "Application node pool" "Member pods; surviving zones retain spare recovery capacity." "AKS Linux nodes" {
                            properties {
                                "architecture.id" "azure.cluster.az2.apps"
                            }
                            gateway = deploymentNode "Ingress pod" "Routes API requests and passes peer TLS through unchanged." "Kubernetes Deployment" {
                                properties {
                                    "architecture.id" "azure.cluster.az2.apps.gateway"
                                }
                                instance = containerInstance ops.gateway production.memberA,production.memberB,production.memberC,production.blockchain {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.apps.gateway.instance"
                                        "member" "consortium"
                                        "zone" "2"
                                        "role" "active"
                                    }
                                }
                            }
                            cnpg = deploymentNode "cnpg pod" "Operational replicas are spread across zones." "Kubernetes Deployment" {
                                properties {
                                    "architecture.id" "azure.cluster.az2.apps.cnpg"
                                }
                                instance = containerInstance ops.cnpg production.memberA,production.memberB,production.memberC,production.blockchain {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.apps.cnpg.instance"
                                        "member" "consortium"
                                        "zone" "2"
                                        "role" "active"
                                    }
                                }
                            }
                            prometheus = deploymentNode "prometheus pod" "Operational replicas are spread across zones." "Kubernetes Deployment" {
                                properties {
                                    "architecture.id" "azure.cluster.az2.apps.prometheus"
                                }
                                instance = containerInstance ops.prometheus production.memberA,production.memberB,production.memberC,production.blockchain {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.apps.prometheus.instance"
                                        "member" "consortium"
                                        "zone" "2"
                                        "role" "active"
                                    }
                                }
                            }
                            memberB = deploymentNode "Member B namespace - active services" "Separate identity and NetworkPolicies; restart eligible in AZ 1/2/3." "Kubernetes namespace / placement slice" {
                                tags "MemberB"
                                properties {
                                    "architecture.id" "azure.cluster.az2.apps.memberB"
                                }
                                core = deploymentNode "FireFly Core pod" "One active member instance; fence before replacement after node loss." "Kubernetes StatefulSet" {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.apps.memberB.core"
                                    }
                                    instance = containerInstance firefly.core production.memberB {
                                        properties {
                                            "architecture.id" "azure.cluster.az2.apps.memberB.core.instance"
                                            "member" "b"
                                            "zone" "2"
                                            "role" "active"
                                        }
                                    }
                                }
                                evm = deploymentNode "EVMConnect + FFTM pod" "One active member instance; fence before replacement after node loss." "Kubernetes StatefulSet" {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.apps.memberB.evm"
                                    }
                                    instance = containerInstance firefly.evm production.memberB {
                                        properties {
                                            "architecture.id" "azure.cluster.az2.apps.memberB.evm.instance"
                                            "member" "b"
                                            "zone" "2"
                                            "role" "active"
                                        }
                                    }
                                }
                                signer = deploymentNode "FireFly Signer pod" "One active member instance; fence before replacement after node loss." "Kubernetes Deployment" {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.apps.memberB.signer"
                                    }
                                    instance = containerInstance firefly.signer production.memberB,production.rpcAccess {
                                        properties {
                                            "architecture.id" "azure.cluster.az2.apps.memberB.signer.instance"
                                            "member" "b"
                                            "zone" "2"
                                            "role" "active"
                                        }
                                    }
                                }
                                dx = deploymentNode "HTTPS Data Exchange pod" "One active member instance; fence before replacement after node loss." "Kubernetes StatefulSet" {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.apps.memberB.dx"
                                    }
                                    instance = containerInstance firefly.dx production.memberB,production.privateExchange {
                                        properties {
                                            "architecture.id" "azure.cluster.az2.apps.memberB.dx.instance"
                                            "member" "b"
                                            "zone" "2"
                                            "role" "active"
                                        }
                                    }
                                }
                                erc20 = deploymentNode "ERC-20 / ERC-721 connector pod" "One active member instance; fence before replacement after node loss." "Kubernetes Deployment" {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.apps.memberB.erc20"
                                    }
                                    instance = containerInstance firefly.erc20 production.memberB {
                                        properties {
                                            "architecture.id" "azure.cluster.az2.apps.memberB.erc20.instance"
                                            "member" "b"
                                            "zone" "2"
                                            "role" "active"
                                        }
                                    }
                                }
                                erc1155 = deploymentNode "ERC-1155 connector pod" "One active member instance; fence before replacement after node loss." "Kubernetes Deployment" {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.apps.memberB.erc1155"
                                    }
                                    instance = containerInstance firefly.erc1155 production.memberB {
                                        properties {
                                            "architecture.id" "azure.cluster.az2.apps.memberB.erc1155.instance"
                                            "member" "b"
                                            "zone" "2"
                                            "role" "active"
                                        }
                                    }
                                }
                                ipfs = deploymentNode "IPFS Kubo pod" "One active member instance; fence before replacement after node loss." "Kubernetes StatefulSet" {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.apps.memberB.ipfs"
                                    }
                                    instance = containerInstance firefly.ipfs production.memberB,production.sharedContent {
                                        properties {
                                            "architecture.id" "azure.cluster.az2.apps.memberB.ipfs.instance"
                                            "member" "b"
                                            "zone" "2"
                                            "role" "active"
                                        }
                                    }
                                }
                                blobs = deploymentNode "ZRS volume - Private blob and peer store" "Replicated across three zones; RWO; fence and detach before reattach." "Premium SSD ZRS / CSI" {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.apps.memberB.blobs"
                                    }
                                    store = containerInstance firefly.blobs production.memberB {
                                        properties {
                                            "architecture.id" "azure.cluster.az2.apps.memberB.blobs.store"
                                            "member" "b"
                                            "zone" "regional"
                                            "role" "persistent volume"
                                        }
                                    }
                                }
                                ipfsRepo = deploymentNode "ZRS volume - IPFS repository" "Replicated across three zones; RWO; fence and detach before reattach." "Premium SSD ZRS / CSI" {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.apps.memberB.ipfsRepo"
                                    }
                                    store = containerInstance firefly.ipfsRepo production.memberB {
                                        properties {
                                            "architecture.id" "azure.cluster.az2.apps.memberB.ipfsRepo.store"
                                            "member" "b"
                                            "zone" "regional"
                                            "role" "persistent volume"
                                        }
                                    }
                                }
                            }
                        }
                        data = deploymentNode "Stateful node pool" "PostgreSQL and Besu; node anti-affinity separates replicas." "AKS Linux nodes" {
                            properties {
                                "architecture.id" "azure.cluster.az2.data"
                            }
                            pgA = deploymentNode "Member A PostgreSQL standby" "One instance per zone; separate Core/FFTM databases; ANY 1 synchronous standby." "CloudNativePG pod" {
                                tags "MemberA"
                                properties {
                                    "architecture.id" "azure.cluster.az2.data.pgA"
                                }
                                instance = containerInstance firefly.pgReplica production.memberA {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.data.pgA.instance"
                                        "member" "a"
                                        "zone" "2"
                                        "role" "standby"
                                    }
                                }
                                volume = infrastructureNode "PGDATA A AZ 2" "Independent durable data directory for this instance." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az2.data.pgA.volume"
                                    }
                                }
                            }
                            pgB = deploymentNode "Member B PostgreSQL primary" "One instance per zone; separate Core/FFTM databases; ANY 1 synchronous standby." "CloudNativePG pod" {
                                tags "MemberB"
                                properties {
                                    "architecture.id" "azure.cluster.az2.data.pgB"
                                }
                                instance = containerInstance firefly.pg production.memberB {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.data.pgB.instance"
                                        "member" "b"
                                        "zone" "2"
                                        "role" "primary"
                                    }
                                }
                                volume = infrastructureNode "PGDATA B AZ 2" "Independent durable data directory for this instance." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az2.data.pgB.volume"
                                    }
                                }
                            }
                            pgC = deploymentNode "Member C PostgreSQL standby" "One instance per zone; separate Core/FFTM databases; ANY 1 synchronous standby." "CloudNativePG pod" {
                                tags "MemberC"
                                properties {
                                    "architecture.id" "azure.cluster.az2.data.pgC"
                                }
                                instance = containerInstance firefly.pgReplica production.memberC {
                                    properties {
                                        "architecture.id" "azure.cluster.az2.data.pgC.instance"
                                        "member" "c"
                                        "zone" "2"
                                        "role" "standby"
                                    }
                                }
                                volume = infrastructureNode "PGDATA C AZ 2" "Independent durable data directory for this instance." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az2.data.pgC.volume"
                                    }
                                }
                            }
                            besub2 = deploymentNode "Besu B2 validator pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az2.data.besub2"
                                }
                                instance = containerInstance besu.node production.blockchain {
                                    description "B2: validator; owner B; AZ 2. Dedicated node key and ledger."
                                    properties {
                                        "architecture.id" "azure.cluster.az2.data.besub2.instance"
                                        "member" "b"
                                        "zone" "2"
                                        "role" "validator"
                                    }
                                }
                                volume = infrastructureNode "Besu ledger B2" "Dedicated node data, retained during replacement." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az2.data.besub2.volume"
                                    }
                                }
                            }
                            besuc1 = deploymentNode "Besu C1 validator pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az2.data.besuc1"
                                }
                                instance = containerInstance besu.node production.blockchain {
                                    description "C1: validator; owner C; AZ 2. Dedicated node key and ledger."
                                    properties {
                                        "architecture.id" "azure.cluster.az2.data.besuc1.instance"
                                        "member" "c"
                                        "zone" "2"
                                        "role" "validator"
                                    }
                                }
                                volume = infrastructureNode "Besu ledger C1" "Dedicated node data, retained during replacement." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az2.data.besuc1.volume"
                                    }
                                }
                            }
                            besurpc2 = deploymentNode "Besu RPC2 RPC pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az2.data.besurpc2"
                                }
                                instance = containerInstance besu.node production.blockchain,production.rpcAccess {
                                    description "RPC2: rpc; owner CONSORTIUM; AZ 2. Dedicated node key and ledger."
                                    properties {
                                        "architecture.id" "azure.cluster.az2.data.besurpc2.instance"
                                        "member" "consortium"
                                        "zone" "2"
                                        "role" "rpc"
                                    }
                                }
                                volume = infrastructureNode "Besu ledger RPC2" "Dedicated node data, retained during replacement." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az2.data.besurpc2.volume"
                                    }
                                }
                            }
                        }
                    }
                    az3 = deploymentNode "Availability Zone 3" "Independent fault domain AZ 3." "Azure availability zone" {
                        tags "Zone3"
                        properties {
                            "architecture.id" "azure.cluster.az3"
                        }
                        system = deploymentNode "System node pool" "System capacity in AZ 3." "AKS VM scale set" {
                            properties {
                                "architecture.id" "azure.cluster.az3.system"
                            }
                            agent = infrastructureNode "Cluster services" "Runs DNS, networking and storage agents." "CoreDNS / CNI / CSI" {
                                tags "Operational"
                                properties {
                                    "architecture.id" "azure.cluster.az3.system.agent"
                                }
                            }
                        }
                        apps = deploymentNode "Application node pool" "Member pods; surviving zones retain spare recovery capacity." "AKS Linux nodes" {
                            properties {
                                "architecture.id" "azure.cluster.az3.apps"
                            }
                            gateway = deploymentNode "Ingress pod" "Routes API requests and passes peer TLS through unchanged." "Kubernetes Deployment" {
                                properties {
                                    "architecture.id" "azure.cluster.az3.apps.gateway"
                                }
                                instance = containerInstance ops.gateway production.memberA,production.memberB,production.memberC,production.blockchain {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.apps.gateway.instance"
                                        "member" "consortium"
                                        "zone" "3"
                                        "role" "active"
                                    }
                                }
                            }
                            cnpg = deploymentNode "cnpg pod" "Operational replicas are spread across zones." "Kubernetes Deployment" {
                                properties {
                                    "architecture.id" "azure.cluster.az3.apps.cnpg"
                                }
                                instance = containerInstance ops.cnpg production.memberA,production.memberB,production.memberC,production.blockchain {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.apps.cnpg.instance"
                                        "member" "consortium"
                                        "zone" "3"
                                        "role" "active"
                                    }
                                }
                            }
                            prometheus = deploymentNode "prometheus pod" "Operational replicas are spread across zones." "Kubernetes Deployment" {
                                properties {
                                    "architecture.id" "azure.cluster.az3.apps.prometheus"
                                }
                                instance = containerInstance ops.prometheus production.memberA,production.memberB,production.memberC,production.blockchain {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.apps.prometheus.instance"
                                        "member" "consortium"
                                        "zone" "3"
                                        "role" "active"
                                    }
                                }
                            }
                            memberC = deploymentNode "Member C namespace - active services" "Separate identity and NetworkPolicies; restart eligible in AZ 1/2/3." "Kubernetes namespace / placement slice" {
                                tags "MemberC"
                                properties {
                                    "architecture.id" "azure.cluster.az3.apps.memberC"
                                }
                                core = deploymentNode "FireFly Core pod" "One active member instance; fence before replacement after node loss." "Kubernetes StatefulSet" {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.apps.memberC.core"
                                    }
                                    instance = containerInstance firefly.core production.memberC {
                                        properties {
                                            "architecture.id" "azure.cluster.az3.apps.memberC.core.instance"
                                            "member" "c"
                                            "zone" "3"
                                            "role" "active"
                                        }
                                    }
                                }
                                evm = deploymentNode "EVMConnect + FFTM pod" "One active member instance; fence before replacement after node loss." "Kubernetes StatefulSet" {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.apps.memberC.evm"
                                    }
                                    instance = containerInstance firefly.evm production.memberC {
                                        properties {
                                            "architecture.id" "azure.cluster.az3.apps.memberC.evm.instance"
                                            "member" "c"
                                            "zone" "3"
                                            "role" "active"
                                        }
                                    }
                                }
                                signer = deploymentNode "FireFly Signer pod" "One active member instance; fence before replacement after node loss." "Kubernetes Deployment" {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.apps.memberC.signer"
                                    }
                                    instance = containerInstance firefly.signer production.memberC,production.rpcAccess {
                                        properties {
                                            "architecture.id" "azure.cluster.az3.apps.memberC.signer.instance"
                                            "member" "c"
                                            "zone" "3"
                                            "role" "active"
                                        }
                                    }
                                }
                                dx = deploymentNode "HTTPS Data Exchange pod" "One active member instance; fence before replacement after node loss." "Kubernetes StatefulSet" {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.apps.memberC.dx"
                                    }
                                    instance = containerInstance firefly.dx production.memberC,production.privateExchange {
                                        properties {
                                            "architecture.id" "azure.cluster.az3.apps.memberC.dx.instance"
                                            "member" "c"
                                            "zone" "3"
                                            "role" "active"
                                        }
                                    }
                                }
                                erc20 = deploymentNode "ERC-20 / ERC-721 connector pod" "One active member instance; fence before replacement after node loss." "Kubernetes Deployment" {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.apps.memberC.erc20"
                                    }
                                    instance = containerInstance firefly.erc20 production.memberC {
                                        properties {
                                            "architecture.id" "azure.cluster.az3.apps.memberC.erc20.instance"
                                            "member" "c"
                                            "zone" "3"
                                            "role" "active"
                                        }
                                    }
                                }
                                erc1155 = deploymentNode "ERC-1155 connector pod" "One active member instance; fence before replacement after node loss." "Kubernetes Deployment" {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.apps.memberC.erc1155"
                                    }
                                    instance = containerInstance firefly.erc1155 production.memberC {
                                        properties {
                                            "architecture.id" "azure.cluster.az3.apps.memberC.erc1155.instance"
                                            "member" "c"
                                            "zone" "3"
                                            "role" "active"
                                        }
                                    }
                                }
                                ipfs = deploymentNode "IPFS Kubo pod" "One active member instance; fence before replacement after node loss." "Kubernetes StatefulSet" {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.apps.memberC.ipfs"
                                    }
                                    instance = containerInstance firefly.ipfs production.memberC,production.sharedContent {
                                        properties {
                                            "architecture.id" "azure.cluster.az3.apps.memberC.ipfs.instance"
                                            "member" "c"
                                            "zone" "3"
                                            "role" "active"
                                        }
                                    }
                                }
                                blobs = deploymentNode "ZRS volume - Private blob and peer store" "Replicated across three zones; RWO; fence and detach before reattach." "Premium SSD ZRS / CSI" {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.apps.memberC.blobs"
                                    }
                                    store = containerInstance firefly.blobs production.memberC {
                                        properties {
                                            "architecture.id" "azure.cluster.az3.apps.memberC.blobs.store"
                                            "member" "c"
                                            "zone" "regional"
                                            "role" "persistent volume"
                                        }
                                    }
                                }
                                ipfsRepo = deploymentNode "ZRS volume - IPFS repository" "Replicated across three zones; RWO; fence and detach before reattach." "Premium SSD ZRS / CSI" {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.apps.memberC.ipfsRepo"
                                    }
                                    store = containerInstance firefly.ipfsRepo production.memberC {
                                        properties {
                                            "architecture.id" "azure.cluster.az3.apps.memberC.ipfsRepo.store"
                                            "member" "c"
                                            "zone" "regional"
                                            "role" "persistent volume"
                                        }
                                    }
                                }
                            }
                        }
                        data = deploymentNode "Stateful node pool" "PostgreSQL and Besu; node anti-affinity separates replicas." "AKS Linux nodes" {
                            properties {
                                "architecture.id" "azure.cluster.az3.data"
                            }
                            pgA = deploymentNode "Member A PostgreSQL standby" "One instance per zone; separate Core/FFTM databases; ANY 1 synchronous standby." "CloudNativePG pod" {
                                tags "MemberA"
                                properties {
                                    "architecture.id" "azure.cluster.az3.data.pgA"
                                }
                                instance = containerInstance firefly.pgReplica production.memberA {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.data.pgA.instance"
                                        "member" "a"
                                        "zone" "3"
                                        "role" "standby"
                                    }
                                }
                                volume = infrastructureNode "PGDATA A AZ 3" "Independent durable data directory for this instance." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az3.data.pgA.volume"
                                    }
                                }
                            }
                            pgB = deploymentNode "Member B PostgreSQL standby" "One instance per zone; separate Core/FFTM databases; ANY 1 synchronous standby." "CloudNativePG pod" {
                                tags "MemberB"
                                properties {
                                    "architecture.id" "azure.cluster.az3.data.pgB"
                                }
                                instance = containerInstance firefly.pgReplica production.memberB {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.data.pgB.instance"
                                        "member" "b"
                                        "zone" "3"
                                        "role" "standby"
                                    }
                                }
                                volume = infrastructureNode "PGDATA B AZ 3" "Independent durable data directory for this instance." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az3.data.pgB.volume"
                                    }
                                }
                            }
                            pgC = deploymentNode "Member C PostgreSQL primary" "One instance per zone; separate Core/FFTM databases; ANY 1 synchronous standby." "CloudNativePG pod" {
                                tags "MemberC"
                                properties {
                                    "architecture.id" "azure.cluster.az3.data.pgC"
                                }
                                instance = containerInstance firefly.pg production.memberC {
                                    properties {
                                        "architecture.id" "azure.cluster.az3.data.pgC.instance"
                                        "member" "c"
                                        "zone" "3"
                                        "role" "primary"
                                    }
                                }
                                volume = infrastructureNode "PGDATA C AZ 3" "Independent durable data directory for this instance." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az3.data.pgC.volume"
                                    }
                                }
                            }
                            besuc2 = deploymentNode "Besu C2 validator pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az3.data.besuc2"
                                }
                                instance = containerInstance besu.node production.blockchain {
                                    description "C2: validator; owner C; AZ 3. Dedicated node key and ledger."
                                    properties {
                                        "architecture.id" "azure.cluster.az3.data.besuc2.instance"
                                        "member" "c"
                                        "zone" "3"
                                        "role" "validator"
                                    }
                                }
                                volume = infrastructureNode "Besu ledger C2" "Dedicated node data, retained during replacement." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az3.data.besuc2.volume"
                                    }
                                }
                            }
                            besua2 = deploymentNode "Besu A2 validator pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az3.data.besua2"
                                }
                                instance = containerInstance besu.node production.blockchain {
                                    description "A2: validator; owner A; AZ 3. Dedicated node key and ledger."
                                    properties {
                                        "architecture.id" "azure.cluster.az3.data.besua2.instance"
                                        "member" "a"
                                        "zone" "3"
                                        "role" "validator"
                                    }
                                }
                                volume = infrastructureNode "Besu ledger A2" "Dedicated node data, retained during replacement." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az3.data.besua2.volume"
                                    }
                                }
                            }
                            besurpc3 = deploymentNode "Besu RPC3 RPC pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az3.data.besurpc3"
                                }
                                instance = containerInstance besu.node production.blockchain,production.rpcAccess {
                                    description "RPC3: rpc and bootnode; owner CONSORTIUM; AZ 3. Dedicated node key and ledger."
                                    properties {
                                        "architecture.id" "azure.cluster.az3.data.besurpc3.instance"
                                        "member" "consortium"
                                        "zone" "3"
                                        "role" "rpc and bootnode"
                                    }
                                }
                                volume = infrastructureNode "Besu ledger RPC3" "Dedicated node data, retained during replacement." "Premium SSD ZRS / CSI" {
                                    tags "Database"
                                    properties {
                                        "architecture.id" "azure.cluster.az3.data.besurpc3.volume"
                                    }
                                }
                            }
                        }
                    }
                }
                control = infrastructureNode "Managed control plane" "Schedules workloads and stores Kubernetes objects; Azure-managed." "AKS API / etcd" {
                    tags "Operational"
                    properties {
                        "architecture.id" "azure.control"
                    }
                    -> production.azure.cluster.az1.system.agent "Schedules and reconciles system workloads" "Kubernetes API / TLS" "Operational"
                    -> production.azure.cluster.az2.system.agent "Schedules and reconciles system workloads" "Kubernetes API / TLS" "Operational"
                    -> production.azure.cluster.az3.system.agent "Schedules and reconciles system workloads" "Kubernetes API / TLS" "Operational"
                }
                lb = infrastructureNode "Zone-redundant load balancer" "Exposes private member API and passthrough peer endpoints." "Azure Standard Load Balancer" {
                    tags "Operational"
                    properties {
                        "architecture.id" "azure.lb"
                    }
                    -> production.azure.cluster.az1.apps.gateway.instance "Routes HTTPS and peer TLS sessions" "TCP / TLS" "Operational"
                    -> production.azure.cluster.az2.apps.gateway.instance "Routes HTTPS and peer TLS sessions" "TCP / TLS" "Operational"
                    -> production.azure.cluster.az3.apps.gateway.instance "Routes HTTPS and peer TLS sessions" "TCP / TLS" "Operational"
                }
                secrets = infrastructureNode "Kubernetes secret projection" "Projects namespaced configuration and distinct node keys." "Kubernetes API / Secret volumes" {
                    tags "Operational"
                    properties {
                        "architecture.id" "azure.secrets"
                    }
                }
                csi = infrastructureNode "Azure Disk CSI controller" "Provisions volumes and coordinates safe reattachment." "Azure Disk CSI / ARM" {
                    tags "Operational"
                    properties {
                        "architecture.id" "azure.csi"
                    }
                    -> production.azure.cluster.az1.apps.memberA.blobs.store "Provisions and safely attaches member storage" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az1.apps.memberA.ipfsRepo.store "Provisions and safely attaches member storage" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az1.data.pgA.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az2.data.pgA.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az3.data.pgA.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az2.apps.memberB.blobs.store "Provisions and safely attaches member storage" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az2.apps.memberB.ipfsRepo.store "Provisions and safely attaches member storage" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az1.data.pgB.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az2.data.pgB.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az3.data.pgB.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az3.apps.memberC.blobs.store "Provisions and safely attaches member storage" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az3.apps.memberC.ipfsRepo.store "Provisions and safely attaches member storage" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az1.data.pgC.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az2.data.pgC.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az3.data.pgC.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az1.data.besua1.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az1.data.besub1.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az2.data.besub2.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az2.data.besuc1.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az3.data.besuc2.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az3.data.besua2.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az1.data.besurpc1.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az2.data.besurpc2.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
                    -> production.azure.cluster.az3.data.besurpc3.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
                }
                secretStores = deploymentNode "Member secret stores" "Separate namespace objects containing encrypted keystores and credentials." "Kubernetes Secrets" {
                    properties {
                        "architecture.id" "azure.secretStores"
                    }
                    a = containerInstance firefly.secrets production.memberA {
                        properties {
                            "architecture.id" "azure.secretStores.a"
                            "member" "a"
                            "zone" "regional"
                            "role" "projected configuration"
                        }
                    }
                    b = containerInstance firefly.secrets production.memberB {
                        properties {
                            "architecture.id" "azure.secretStores.b"
                            "member" "b"
                            "zone" "regional"
                            "role" "projected configuration"
                        }
                    }
                    c = containerInstance firefly.secrets production.memberC {
                        properties {
                            "architecture.id" "azure.secretStores.c"
                            "member" "c"
                            "zone" "regional"
                            "role" "projected configuration"
                        }
                    }
                }
                rpc = infrastructureNode "Private RPC Service" "Routes to synchronized RPC nodes; session affinity protects node-local filters." "Kubernetes Service / session affinity" {
                    tags "Operational"
                    properties {
                        "architecture.id" "azure.rpc"
                    }
                    -> production.azure.cluster.az1.data.besurpc1.instance "Routes pinned JSON-RPC sessions" "HTTP JSON-RPC" "Operational"
                    -> production.azure.cluster.az2.data.besurpc2.instance "Routes pinned JSON-RPC sessions" "HTTP JSON-RPC" "Operational"
                    -> production.azure.cluster.az3.data.besurpc3.instance "Routes pinned JSON-RPC sessions" "HTTP JSON-RPC" "Operational"
                }
            }
        }
        !element production.azure.control {
            -> production.azure.secrets "Stores and projects namespace configuration" "Kubernetes API / TLS" "Operational"
            -> production.azure.csi "Reconciles volume attachments" "Kubernetes API / TLS" "Operational"
        }
        !element production.azure.cluster.az1.apps.cnpg.instance {
            -> production.azure.control "Watches clusters and updates primary Services" "Kubernetes API / TLS" "Operational"
        }
        !element production.azure.cluster.az2.apps.cnpg.instance {
            -> production.azure.control "Watches clusters and updates primary Services" "Kubernetes API / TLS" "Operational"
        }
        !element production.azure.cluster.az3.apps.cnpg.instance {
            -> production.azure.control "Watches clusters and updates primary Services" "Kubernetes API / TLS" "Operational"
        }
        !element production.azure.cluster.az1.apps.memberA.core.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az1.apps.memberA.evm.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az1.apps.memberA.signer.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            -> production.azure.rpc "Sends signed transactions and queries" "HTTP JSON-RPC" "Operational"
        }
        !element production.azure.cluster.az1.apps.memberA.dx.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az1.apps.memberA.erc20.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az1.apps.memberA.erc1155.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az1.apps.memberA.ipfs.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az1.data.pgA.instance {
            -> production.azure.cluster.az1.data.pgA.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
        }
        !element production.azure.cluster.az2.data.pgA.instance {
            -> production.azure.cluster.az2.data.pgA.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
        }
        !element production.azure.cluster.az3.data.pgA.instance {
            -> production.azure.cluster.az3.data.pgA.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
        }
        !element production.azure.cluster.az2.apps.memberB.core.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az2.apps.memberB.evm.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az2.apps.memberB.signer.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            -> production.azure.rpc "Sends signed transactions and queries" "HTTP JSON-RPC" "Operational"
        }
        !element production.azure.cluster.az2.apps.memberB.dx.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az2.apps.memberB.erc20.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az2.apps.memberB.erc1155.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az2.apps.memberB.ipfs.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az1.data.pgB.instance {
            -> production.azure.cluster.az1.data.pgB.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
        }
        !element production.azure.cluster.az2.data.pgB.instance {
            -> production.azure.cluster.az2.data.pgB.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
        }
        !element production.azure.cluster.az3.data.pgB.instance {
            -> production.azure.cluster.az3.data.pgB.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
        }
        !element production.azure.cluster.az3.apps.memberC.core.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az3.apps.memberC.evm.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az3.apps.memberC.signer.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            -> production.azure.rpc "Sends signed transactions and queries" "HTTP JSON-RPC" "Operational"
        }
        !element production.azure.cluster.az3.apps.memberC.dx.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az3.apps.memberC.erc20.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az3.apps.memberC.erc1155.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az3.apps.memberC.ipfs.instance {
            -> production.azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
        }
        !element production.azure.cluster.az1.data.pgC.instance {
            -> production.azure.cluster.az1.data.pgC.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
        }
        !element production.azure.cluster.az2.data.pgC.instance {
            -> production.azure.cluster.az2.data.pgC.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
        }
        !element production.azure.cluster.az3.data.pgC.instance {
            -> production.azure.cluster.az3.data.pgC.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
        }
        !element production.azure.cluster.az1.data.besua1.instance {
            -> production.azure.cluster.az1.data.besua1.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            -> production.azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
        }
        !element production.azure.cluster.az1.data.besub1.instance {
            -> production.azure.cluster.az1.data.besub1.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            -> production.azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
        }
        !element production.azure.cluster.az2.data.besub2.instance {
            -> production.azure.cluster.az2.data.besub2.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            -> production.azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
        }
        !element production.azure.cluster.az2.data.besuc1.instance {
            -> production.azure.cluster.az2.data.besuc1.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            -> production.azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
        }
        !element production.azure.cluster.az3.data.besuc2.instance {
            -> production.azure.cluster.az3.data.besuc2.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            -> production.azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
        }
        !element production.azure.cluster.az3.data.besua2.instance {
            -> production.azure.cluster.az3.data.besua2.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            -> production.azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
        }
        !element production.azure.cluster.az1.data.besurpc1.instance {
            -> production.azure.cluster.az1.data.besurpc1.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            -> production.azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
        }
        !element production.azure.cluster.az2.data.besurpc2.instance {
            -> production.azure.cluster.az2.data.besurpc2.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            -> production.azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
        }
        !element production.azure.cluster.az3.data.besurpc3.instance {
            -> production.azure.cluster.az3.data.besurpc3.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            -> production.azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
        }
    }
    views {
        systemLandscape "01-landscape" "System Landscape - FireFly consortium architecture" {
            title "System Landscape - FireFly consortium architecture"
            include business developer operator apps tools firefly besu ops
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
            autoLayout lr 360 200
        }
        systemContext firefly "02-context-firefly" "System Context - Hyperledger FireFly" {
            title "System Context - Hyperledger FireFly"
            include firefly apps operator besu ops tools
            exclude *->*
            include firefly->besu
            include operator->firefly
            include apps->firefly
            include tools->firefly
            include operator->ops
            include ops->firefly
            include ops->besu
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
            include firefly ethconnect fabric tezos cardano corda
            exclude *->*
            include firefly->ethconnect
            include firefly->fabric
            include firefly->tezos
            include firefly->cardano
            include firefly->corda
            autoLayout lr 360 200
        }
        container firefly "10-firefly-runtime" "Container - FireFly orchestration and connectors" {
            title "Container - FireFly orchestration and connectors"
            include firefly.core firefly.evm firefly.signer firefly.dx firefly.erc20 firefly.erc1155 firefly.ipfs firefly.pg apps.client besu.node
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
            include firefly.signer->besu.node
            include apps.client->firefly.core
            include firefly.core->apps.client
            autoLayout lr 360 200
        }
        container firefly "11-firefly-state" "Container - FireFly private state and shared storage" {
            title "Container - FireFly private state and shared storage"
            include firefly.core firefly.evm firefly.signer firefly.dx firefly.ipfs firefly.pg firefly.pgReplica firefly.blobs firefly.ipfsRepo firefly.secrets
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
            autoLayout lr 360 200
        }
        component firefly.core "20-firefly-core-api" "Component - FireFly Core: API, tenancy and Explorer" {
            title "Component - FireFly Core: API, tenancy and Explorer"
            include firefly.core.explorer firefly.core.api firefly.core.auth firefly.core.namespaces firefly.core.orchestrator firefly.core.syncasync firefly.core.spievents firefly.core.eventplugin apps.client
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
            include firefly.evm.manager firefly.evm.blocks firefly.evm.receipts firefly.evm.rpc firefly.evm.confirmations firefly.evm.streams firefly.evm.delivery firefly.evm.persistence firefly.pg firefly.signer firefly.core
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
            include firefly.signer.backend->besu.node
            autoLayout lr 360 200
        }
        component firefly.dx "40-firefly-dx" "Component - FireFly private data exchange" {
            title "Component - FireFly private data exchange"
            include firefly.dx.api firefly.dx.peers firefly.dx.p2p firefly.dx.messages firefly.dx.blobs firefly.dx.events firefly.blobs firefly.secrets
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
            include firefly.dx.blobs->firefly.blobs
            include firefly.dx.peers->firefly.blobs
            include firefly.dx.p2p->firefly.secrets
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
            include tools.cli tools.sandbox developer firefly.core
            exclude *->*
            include tools.sandbox->firefly.core
            include tools.cli->firefly.core
            include developer->tools.cli
            include developer->tools.sandbox
            autoLayout lr 360 200
        }
        component tools.sandbox "62-sandbox" "Component - Sandbox sample application" {
            title "Component - Sandbox sample application"
            include tools.sandbox.frontend tools.sandbox.backend tools.sandbox.sdk firefly.core
            exclude *->*
            include tools.sandbox.frontend->tools.sandbox.backend
            include tools.sandbox.backend->tools.sandbox.sdk
            include tools.sandbox.sdk->firefly.core
            autoLayout lr 360 200
        }
        container ops "63-operations" "Container - platform operations" {
            title "Container - platform operations"
            include ops.gateway ops.cnpg ops.prometheus ops.grafana operator firefly.core firefly.pg besu.node
            exclude *->*
            include firefly.core->firefly.pg
            include operator->ops.grafana
            include ops.grafana->ops.prometheus
            include ops.gateway->firefly.core
            include ops.cnpg->firefly.pg
            include ops.prometheus->firefly.core
            include ops.prometheus->besu.node
            autoLayout lr 360 200
        }
        deployment * production "80-deployment-a" "Deployment - Member A across three AKS zones" {
            title "Deployment - Member A across three AKS zones"
            include production.azure.secretStores.a production.azure.cluster.az1.apps.memberA.core.instance production.azure.cluster.az1.apps.memberA.evm.instance production.azure.cluster.az1.apps.memberA.signer.instance production.azure.cluster.az1.apps.memberA.dx.instance production.azure.cluster.az1.apps.memberA.erc20.instance production.azure.cluster.az1.apps.memberA.erc1155.instance production.azure.cluster.az1.apps.memberA.ipfs.instance production.azure.cluster.az1.apps.memberA.blobs.store production.azure.cluster.az1.apps.memberA.ipfsRepo.store production.azure.cluster.az1.data.pgA.instance production.azure.cluster.az2.data.pgA.instance production.azure.cluster.az3.data.pgA.instance production.azure.control production.azure.secrets production.azure.csi production.azure.cluster.az1.data.pgA.volume production.azure.cluster.az2.data.pgA.volume production.azure.cluster.az3.data.pgA.volume production.azure.rpc
            autoLayout lr 360 200
        }
        deployment * production "80-deployment-b" "Deployment - Member B across three AKS zones" {
            title "Deployment - Member B across three AKS zones"
            include production.azure.secretStores.b production.azure.cluster.az2.apps.memberB.core.instance production.azure.cluster.az2.apps.memberB.evm.instance production.azure.cluster.az2.apps.memberB.signer.instance production.azure.cluster.az2.apps.memberB.dx.instance production.azure.cluster.az2.apps.memberB.erc20.instance production.azure.cluster.az2.apps.memberB.erc1155.instance production.azure.cluster.az2.apps.memberB.ipfs.instance production.azure.cluster.az2.apps.memberB.blobs.store production.azure.cluster.az2.apps.memberB.ipfsRepo.store production.azure.cluster.az1.data.pgB.instance production.azure.cluster.az2.data.pgB.instance production.azure.cluster.az3.data.pgB.instance production.azure.control production.azure.secrets production.azure.csi production.azure.cluster.az1.data.pgB.volume production.azure.cluster.az2.data.pgB.volume production.azure.cluster.az3.data.pgB.volume production.azure.rpc
            autoLayout lr 360 200
        }
        deployment * production "80-deployment-c" "Deployment - Member C across three AKS zones" {
            title "Deployment - Member C across three AKS zones"
            include production.azure.secretStores.c production.azure.cluster.az3.apps.memberC.core.instance production.azure.cluster.az3.apps.memberC.evm.instance production.azure.cluster.az3.apps.memberC.signer.instance production.azure.cluster.az3.apps.memberC.dx.instance production.azure.cluster.az3.apps.memberC.erc20.instance production.azure.cluster.az3.apps.memberC.erc1155.instance production.azure.cluster.az3.apps.memberC.ipfs.instance production.azure.cluster.az3.apps.memberC.blobs.store production.azure.cluster.az3.apps.memberC.ipfsRepo.store production.azure.cluster.az1.data.pgC.instance production.azure.cluster.az2.data.pgC.instance production.azure.cluster.az3.data.pgC.instance production.azure.control production.azure.secrets production.azure.csi production.azure.cluster.az1.data.pgC.volume production.azure.cluster.az2.data.pgC.volume production.azure.cluster.az3.data.pgC.volume production.azure.rpc
            autoLayout lr 360 200
        }
        deployment * production "81-deployment-besu" "Deployment - six QBFT validators and three RPC nodes" {
            title "Deployment - six QBFT validators and three RPC nodes"
            include production.azure.cluster.az1.data.besua1.instance production.azure.cluster.az1.data.besub1.instance production.azure.cluster.az2.data.besub2.instance production.azure.cluster.az2.data.besuc1.instance production.azure.cluster.az3.data.besuc2.instance production.azure.cluster.az3.data.besua2.instance production.azure.cluster.az1.data.besurpc1.instance production.azure.cluster.az2.data.besurpc2.instance production.azure.cluster.az3.data.besurpc3.instance production.azure.secrets production.azure.cluster.az1.data.besua1.volume production.azure.cluster.az1.data.besub1.volume production.azure.cluster.az2.data.besub2.volume production.azure.cluster.az2.data.besuc1.volume production.azure.cluster.az3.data.besuc2.volume production.azure.cluster.az3.data.besua2.volume production.azure.cluster.az1.data.besurpc1.volume production.azure.cluster.az2.data.besurpc2.volume production.azure.cluster.az3.data.besurpc3.volume production.azure.rpc
            autoLayout tb 360 200
        }
        deployment * production "82-deployment-operations" "Deployment - AKS operations and control" {
            title "Deployment - AKS operations and control"
            include production.azure.cluster.az1.apps.gateway.instance production.azure.cluster.az1.apps.cnpg.instance production.azure.cluster.az1.apps.prometheus.instance production.azure.cluster.az1.apps.grafana.instance production.azure.cluster.az2.apps.gateway.instance production.azure.cluster.az2.apps.cnpg.instance production.azure.cluster.az2.apps.prometheus.instance production.azure.cluster.az3.apps.gateway.instance production.azure.cluster.az3.apps.cnpg.instance production.azure.cluster.az3.apps.prometheus.instance production.azure.control production.azure.lb production.azure.secrets production.azure.csi production.azure.cluster.az1.system.agent production.azure.cluster.az2.system.agent production.azure.cluster.az3.system.agent
            autoLayout lr 360 200
        }
        deployment * production "99-deployment-complete" "Deployment - complete three-member three-zone AKS reference" {
            title "Deployment - complete three-member three-zone AKS reference"
            include production.azure.control production.azure.lb production.azure.secrets production.azure.csi production.azure.secretStores.a production.azure.secretStores.b production.azure.secretStores.c production.azure.cluster.az1.system.agent production.azure.cluster.az1.apps.gateway.instance production.azure.cluster.az1.apps.cnpg.instance production.azure.cluster.az1.apps.prometheus.instance production.azure.cluster.az1.apps.grafana.instance production.azure.cluster.az2.system.agent production.azure.cluster.az2.apps.gateway.instance production.azure.cluster.az2.apps.cnpg.instance production.azure.cluster.az2.apps.prometheus.instance production.azure.cluster.az3.system.agent production.azure.cluster.az3.apps.gateway.instance production.azure.cluster.az3.apps.cnpg.instance production.azure.cluster.az3.apps.prometheus.instance production.azure.cluster.az1.apps.memberA.core.instance production.azure.cluster.az1.apps.memberA.evm.instance production.azure.cluster.az1.apps.memberA.signer.instance production.azure.cluster.az1.apps.memberA.dx.instance production.azure.cluster.az1.apps.memberA.erc20.instance production.azure.cluster.az1.apps.memberA.erc1155.instance production.azure.cluster.az1.apps.memberA.ipfs.instance production.azure.cluster.az1.apps.memberA.blobs.store production.azure.cluster.az1.apps.memberA.ipfsRepo.store production.azure.cluster.az1.data.pgA.instance production.azure.cluster.az1.data.pgA.volume production.azure.cluster.az2.data.pgA.instance production.azure.cluster.az2.data.pgA.volume production.azure.cluster.az3.data.pgA.instance production.azure.cluster.az3.data.pgA.volume production.azure.cluster.az2.apps.memberB.core.instance production.azure.cluster.az2.apps.memberB.evm.instance production.azure.cluster.az2.apps.memberB.signer.instance production.azure.cluster.az2.apps.memberB.dx.instance production.azure.cluster.az2.apps.memberB.erc20.instance production.azure.cluster.az2.apps.memberB.erc1155.instance production.azure.cluster.az2.apps.memberB.ipfs.instance production.azure.cluster.az2.apps.memberB.blobs.store production.azure.cluster.az2.apps.memberB.ipfsRepo.store production.azure.cluster.az1.data.pgB.instance production.azure.cluster.az1.data.pgB.volume production.azure.cluster.az2.data.pgB.instance production.azure.cluster.az2.data.pgB.volume production.azure.cluster.az3.data.pgB.instance production.azure.cluster.az3.data.pgB.volume production.azure.cluster.az3.apps.memberC.core.instance production.azure.cluster.az3.apps.memberC.evm.instance production.azure.cluster.az3.apps.memberC.signer.instance production.azure.cluster.az3.apps.memberC.dx.instance production.azure.cluster.az3.apps.memberC.erc20.instance production.azure.cluster.az3.apps.memberC.erc1155.instance production.azure.cluster.az3.apps.memberC.ipfs.instance production.azure.cluster.az3.apps.memberC.blobs.store production.azure.cluster.az3.apps.memberC.ipfsRepo.store production.azure.cluster.az1.data.pgC.instance production.azure.cluster.az1.data.pgC.volume production.azure.cluster.az2.data.pgC.instance production.azure.cluster.az2.data.pgC.volume production.azure.cluster.az3.data.pgC.instance production.azure.cluster.az3.data.pgC.volume production.azure.cluster.az1.data.besua1.instance production.azure.cluster.az1.data.besua1.volume production.azure.cluster.az1.data.besub1.instance production.azure.cluster.az1.data.besub1.volume production.azure.cluster.az2.data.besub2.instance production.azure.cluster.az2.data.besub2.volume production.azure.cluster.az2.data.besuc1.instance production.azure.cluster.az2.data.besuc1.volume production.azure.cluster.az3.data.besuc2.instance production.azure.cluster.az3.data.besuc2.volume production.azure.cluster.az3.data.besua2.instance production.azure.cluster.az3.data.besua2.volume production.azure.cluster.az1.data.besurpc1.instance production.azure.cluster.az1.data.besurpc1.volume production.azure.cluster.az2.data.besurpc2.instance production.azure.cluster.az2.data.besurpc2.volume production.azure.cluster.az3.data.besurpc3.instance production.azure.cluster.az3.data.besurpc3.volume production.azure.rpc
            autoLayout tb 360 200
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
