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
                "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            }
        }
        operator = person "Consortium operator" "Operates member namespaces, recovery and the Besu network." {
            url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            properties {
                "architecture.id" "operator"
                "evidence" "Reference choice"
                "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            }
        }
        business = person "Business user" "Submits consortium business actions through a member application." {
            url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            properties {
                "architecture.id" "business"
                "evidence" "Reference choice"
                "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            }
        }
        a = softwareSystem "Member A FireFly" "An independently identified supernode with private member state." {
            tags "MemberA"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d"
            properties {
                "architecture.id" "a"
                "evidence" "Implementation"
                "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d"
            }
            !docs docs/system
            !adrs decisions
            core = container "FireFly Core" "Exposes member APIs and bundled Explorer; orchestrates multiparty operations." "Go + React" {
                url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                properties {
                    "architecture.id" "a.core"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                }
                api = component "REST API and routing" "Accepts namespace-scoped commands and queries." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/apiserver"
                    properties {
                        "architecture.id" "a.core.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/apiserver"
                    }
                }
                explorer = component "Explorer UI" "Serves the bundled React operator interface." "React / TypeScript" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/Dockerfile"
                    properties {
                        "architecture.id" "a.core.explorer"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/Dockerfile"
                    }
                }
                auth = component "API authentication" "Applies configured namespace authorization; Basic Auth reference plugin." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/doc-site/docs/overview/key_components/security.md"
                    properties {
                        "architecture.id" "a.core.auth"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/doc-site/docs/overview/key_components/security.md"
                    }
                }
                namespaces = component "Namespace manager" "Initializes isolated orchestrators and configured plugins." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/namespace"
                    properties {
                        "architecture.id" "a.core.namespaces"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/namespace"
                    }
                }
                orchestrator = component "Orchestrator" "Coordinates API operations and subsystem lifecycles." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                    properties {
                        "architecture.id" "a.core.orchestrator"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                    }
                }
                identity = component "Identity manager" "Resolves organizations, nodes and transaction signing identities." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/identity"
                    properties {
                        "architecture.id" "a.core.identity"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/identity"
                    }
                }
                networkmap = component "Network map" "Indexes registered members, nodes and their endpoints." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/networkmap"
                    properties {
                        "architecture.id" "a.core.networkmap"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/networkmap"
                    }
                }
                definitions = component "Definition exchange" "Publishes and processes schemas, interfaces and token definitions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/definitions"
                    properties {
                        "architecture.id" "a.core.definitions"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/definitions"
                    }
                }
                data = component "Data manager" "Validates, hashes and retrieves structured data and blob references." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    properties {
                        "architecture.id" "a.core.data"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    }
                }
                schema = component "Schema validation" "Checks JSON payloads against registered datatype definitions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    properties {
                        "architecture.id" "a.core.schema"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    }
                }
                batch = component "Batch manager" "Selects outbound messages and dispatches recoverable batches." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    properties {
                        "architecture.id" "a.core.batch"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    }
                }
                batchprocessor = component "Batch processor" "Assembles ordered message batches and aggregate hashes." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    properties {
                        "architecture.id" "a.core.batchprocessor"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    }
                }
                broadcast = component "Broadcast manager" "Publishes shared payloads and orchestrates ledger pinning." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/broadcast"
                    properties {
                        "architecture.id" "a.core.broadcast"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/broadcast"
                    }
                }
                private = component "Private messaging and groups" "Routes messages to recipient groups and coordinates delivery." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/privatemessaging"
                    properties {
                        "architecture.id" "a.core.private"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/privatemessaging"
                    }
                }
                multiparty = component "Multiparty manager" "Coordinates network actions and FireFly contract pinning." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/multiparty"
                    properties {
                        "architecture.id" "a.core.multiparty"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/multiparty"
                    }
                }
                download = component "Shared download manager" "Retrieves referenced broadcast batches and blobs." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/shareddownload"
                    properties {
                        "architecture.id" "a.core.download"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/shareddownload"
                    }
                }
                contracts = component "Contract manager" "Maps FFIs and APIs to contract calls and event listeners." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/contracts"
                    properties {
                        "architecture.id" "a.core.contracts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/contracts"
                    }
                }
                assets = component "Asset manager" "Coordinates token pools, balances and transfers." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/assets"
                    properties {
                        "architecture.id" "a.core.assets"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/assets"
                    }
                }
                operations = component "Operations manager" "Tracks asynchronous connector requests and results." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/operations"
                    properties {
                        "architecture.id" "a.core.operations"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/operations"
                    }
                }
                txhelper = component "Transaction helper" "Correlates operations, messages and blockchain transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txcommon"
                    properties {
                        "architecture.id" "a.core.txhelper"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txcommon"
                    }
                }
                txwriter = component "Transaction writer" "Batches transaction persistence and submission work." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txwriter"
                    properties {
                        "architecture.id" "a.core.txwriter"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txwriter"
                    }
                }
                aggregator = component "Inbound event aggregator" "Correlates ledger pins with payloads and sequences confirmed messages." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/aggregator.go"
                    properties {
                        "architecture.id" "a.core.aggregator"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/aggregator.go"
                    }
                }
                subscriptions = component "Subscription manager" "Filters events and persists subscriber offsets." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/subscription_manager.go"
                    properties {
                        "architecture.id" "a.core.subscriptions"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/subscription_manager.go"
                    }
                }
                dispatcher = component "Event dispatcher" "Delivers ordered event batches and processes acknowledgements." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/event_dispatcher.go"
                    properties {
                        "architecture.id" "a.core.dispatcher"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/event_dispatcher.go"
                    }
                }
                syncasync = component "Sync/async bridge" "Correlates asynchronous completion with waiting API requests." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/syncasync"
                    properties {
                        "architecture.id" "a.core.syncasync"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/syncasync"
                    }
                }
                cache = component "Cache manager" "Caches reusable namespace resources and lookups." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/cache"
                    properties {
                        "architecture.id" "a.core.cache"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/cache"
                    }
                }
                metrics = component "Metrics" "Exposes runtime and operation measurements." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/metrics"
                    properties {
                        "architecture.id" "a.core.metrics"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/metrics"
                    }
                }
                spievents = component "SPI event manager" "Publishes internal lifecycle and namespace change events." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/spievents"
                    properties {
                        "architecture.id" "a.core.spievents"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/spievents"
                    }
                }
                blockchain = component "Blockchain plugin" "Binds Ethereum operations to EVMConnect; other chains are alternatives." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain"
                    properties {
                        "architecture.id" "a.core.blockchain"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain"
                    }
                }
                database = component "Database plugin" "Maps logical resources to PostgreSQL; SQLite is an alternative." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/database"
                    properties {
                        "architecture.id" "a.core.database"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/database"
                    }
                }
                dataexchange = component "Data exchange plugin" "Binds message, blob and peer operations to the HTTPS connector." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/dataexchange"
                    properties {
                        "architecture.id" "a.core.dataexchange"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/dataexchange"
                    }
                }
                sharedstorage = component "Shared storage plugin" "Publishes and retrieves content through IPFS APIs." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/sharedstorage"
                    properties {
                        "architecture.id" "a.core.sharedstorage"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/sharedstorage"
                    }
                }
                tokens = component "Token plugin" "Binds standard token operations to remote token connectors." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/tokens"
                    properties {
                        "architecture.id" "a.core.tokens"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/tokens"
                    }
                }
                identityplugin = component "Identity plugin" "Resolves external identity claims through the configured resolver." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/pkg/identity"
                    properties {
                        "architecture.id" "a.core.identityplugin"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/pkg/identity"
                    }
                }
                eventplugin = component "Event transport plugins" "Provides WebSocket, webhook and system-event delivery." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events"
                    properties {
                        "architecture.id" "a.core.eventplugin"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events"
                    }
                }
            }
            evm = container "EVMConnect + FFTM" "Submits Ethereum transactions and streams confirmed events; one nonce writer." "Go" {
                url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                properties {
                    "architecture.id" "a.evm"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                }
                api = component "Connector REST API" "Accepts transaction, query and event-stream requests." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                    properties {
                        "architecture.id" "a.evm.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                    }
                }
                manager = component "Transaction manager" "Coordinates durable transaction and stream lifecycles." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    properties {
                        "architecture.id" "a.evm.manager"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    }
                }
                handler = component "Transaction policy handler" "Schedules signing, submission, gas and retry policy." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/txhandler"
                    properties {
                        "architecture.id" "a.evm.handler"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/txhandler"
                    }
                }
                nonce = component "Nonce allocation" "Assigns and persists ordered nonces per signing address." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    properties {
                        "architecture.id" "a.evm.nonce"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    }
                }
                abi = component "EVM API adapter" "Encodes ABIs and implements the blockchain connector API." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/internal/ethereum"
                    properties {
                        "architecture.id" "a.evm.abi"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/internal/ethereum"
                    }
                }
                rpc = component "Ethereum JSON-RPC client" "Submits calls and transactions through the signing proxy." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethrpc"
                    properties {
                        "architecture.id" "a.evm.rpc"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethrpc"
                    }
                }
                blocks = component "Block listener" "Tracks chain heads and block/filter updates." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethblocklistener"
                    properties {
                        "architecture.id" "a.evm.blocks"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethblocklistener"
                    }
                }
                receipts = component "Receipt tracking" "Polls receipt status for submitted transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    properties {
                        "architecture.id" "a.evm.receipts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    }
                }
                confirmations = component "Confirmation manager" "Confirms receipts and events against the observed chain." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/confirmations"
                    properties {
                        "architecture.id" "a.evm.confirmations"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/confirmations"
                    }
                }
                streams = component "Event streams" "Orders and batches confirmed listener events." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/events"
                    properties {
                        "architecture.id" "a.evm.streams"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/events"
                    }
                }
                delivery = component "WebSocket and webhook delivery" "Delivers batches and accepts consumer acknowledgements." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/ws"
                    properties {
                        "architecture.id" "a.evm.delivery"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/ws"
                    }
                }
                persistence = component "Persistence adapter" "Stores transactions, nonces, streams and checkpoints." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    properties {
                        "architecture.id" "a.evm.persistence"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    }
                }
            }
            signer = container "FireFly Signer" "Signs member transactions and proxies Ethereum RPC calls." "Go" {
                url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                properties {
                    "architecture.id" "a.signer"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                }
                proxy = component "JSON-RPC proxy" "Intercepts transaction requests and forwards read calls." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                    properties {
                        "architecture.id" "a.signer.proxy"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                    }
                }
                wallet = component "Filesystem wallet" "Loads member keystore files and resolves signing accounts." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                    properties {
                        "architecture.id" "a.signer.wallet"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                    }
                }
                keystore = component "Keystore V3 decoder" "Decrypts encrypted account key files." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/keystorev3"
                    properties {
                        "architecture.id" "a.signer.keystore"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/keystorev3"
                    }
                }
                signing = component "Ethereum signing" "Encodes and signs EIP-155 and EIP-1559 transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/ethsigner"
                    properties {
                        "architecture.id" "a.signer.signing"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/ethsigner"
                    }
                }
                backend = component "RPC backend" "Forwards signed raw transactions to Besu." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/rpcbackend"
                    properties {
                        "architecture.id" "a.signer.backend"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/rpcbackend"
                    }
                }
            }
            dx = container "HTTPS Data Exchange" "Exchanges private envelopes and blobs with authenticated members." "TypeScript / Node.js" {
                tags "Private"
                url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src"
                properties {
                    "architecture.id" "a.dx"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src"
                }
                api = component "Internal REST API" "Accepts private messages, blobs and peer configuration." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/api.ts"
                    properties {
                        "architecture.id" "a.dx.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/api.ts"
                    }
                }
                peers = component "Peer and certificate registry" "Resolves remote endpoints and trusted peer certificates." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/lib"
                    properties {
                        "architecture.id" "a.dx.peers"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/lib"
                    }
                }
                p2p = component "Mutual TLS peer endpoint" "Authenticates remote members and transfers private data." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/p2p.ts"
                    properties {
                        "architecture.id" "a.dx.p2p"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/p2p.ts"
                    }
                }
                messages = component "Message transfer handler" "Sends and receives recipient-scoped message envelopes." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/messages.ts"
                    properties {
                        "architecture.id" "a.dx.messages"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/messages.ts"
                    }
                }
                blobs = component "Blob transfer handler" "Streams binary content to durable member storage." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                    properties {
                        "architecture.id" "a.dx.blobs"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                    }
                }
                events = component "Event queue and acknowledgements" "Queues delivery notifications in memory and processes acknowledgements." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/events.ts"
                    properties {
                        "architecture.id" "a.dx.events"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/events.ts"
                    }
                }
            }
            erc20 = container "ERC-20 / ERC-721 connector" "Maps fungible and non-fungible token APIs to EVM contracts." "TypeScript / NestJS" {
                url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src"
                properties {
                    "architecture.id" "a.erc20"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src"
                }
                api = component "Token REST controller" "Accepts pool, mint, burn, transfer and approval requests." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.controller.ts"
                    properties {
                        "architecture.id" "a.erc20.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.controller.ts"
                    }
                }
                service = component "Token service" "Applies token-specific behavior and tracks pools." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.service.ts"
                    properties {
                        "architecture.id" "a.erc20.service"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.service.ts"
                    }
                }
                mapper = component "ABI and standard adapters" "Maps token operations to contract ABIs." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens"
                    properties {
                        "architecture.id" "a.erc20.mapper"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens"
                    }
                }
                blockchain = component "Blockchain connector client" "Submits contract calls through EVMConnect." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/blockchain.service.ts"
                    properties {
                        "architecture.id" "a.erc20.blockchain"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/blockchain.service.ts"
                    }
                }
                listener = component "Token event listener" "Interprets contract logs as standard token events." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.listener.ts"
                    properties {
                        "architecture.id" "a.erc20.listener"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.listener.ts"
                    }
                }
                stream = component "Connector event stream" "Receives ordered blockchain events and acknowledges batches." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/event-stream"
                    properties {
                        "architecture.id" "a.erc20.stream"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/event-stream"
                    }
                }
                proxy = component "Core event proxy" "Delivers token events to Core over WebSocket." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/eventstream-proxy"
                    properties {
                        "architecture.id" "a.erc20.proxy"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/eventstream-proxy"
                    }
                }
            }
            erc1155 = container "ERC-1155 connector" "Maps multi-token operations and events to FireFly." "TypeScript / NestJS" {
                url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src"
                properties {
                    "architecture.id" "a.erc1155"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src"
                }
                api = component "Token REST controller" "Accepts pool, mint, burn, transfer and approval requests." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.controller.ts"
                    properties {
                        "architecture.id" "a.erc1155.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.controller.ts"
                    }
                }
                service = component "Token service" "Applies token-specific behavior and tracks pools." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.service.ts"
                    properties {
                        "architecture.id" "a.erc1155.service"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.service.ts"
                    }
                }
                mapper = component "ABI and standard adapters" "Maps token operations to contract ABIs." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens"
                    properties {
                        "architecture.id" "a.erc1155.mapper"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens"
                    }
                }
                blockchain = component "Blockchain connector client" "Submits contract calls through EVMConnect." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/blockchain.service.ts"
                    properties {
                        "architecture.id" "a.erc1155.blockchain"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/blockchain.service.ts"
                    }
                }
                listener = component "Token event listener" "Interprets contract logs as standard token events." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.listener.ts"
                    properties {
                        "architecture.id" "a.erc1155.listener"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.listener.ts"
                    }
                }
                stream = component "Connector event stream" "Receives ordered blockchain events and acknowledges batches." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/event-stream"
                    properties {
                        "architecture.id" "a.erc1155.stream"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/event-stream"
                    }
                }
                proxy = component "Core event proxy" "Delivers token events to Core over WebSocket." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/eventstream-proxy"
                    properties {
                        "architecture.id" "a.erc1155.proxy"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/eventstream-proxy"
                    }
                }
            }
            ipfs = container "IPFS Kubo" "Publishes and retrieves consortium-shared content." "Go / Kubo" {
                tags "Shared"
                url "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                properties {
                    "architecture.id" "a.ipfs"
                    "evidence" "Implementation"
                    "source" "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                }
            }
            pg = container "PostgreSQL primary" "Stores Core and FFTM in separate databases with separate credentials." "PostgreSQL / CloudNativePG" {
                tags "Database,Private"
                url "https://cloudnative-pg.io/docs/1.28/replication/"
                properties {
                    "architecture.id" "a.pg"
                    "evidence" "Implementation"
                    "source" "https://cloudnative-pg.io/docs/1.28/replication/"
                }
            }
            pgReplica = container "PostgreSQL standby" "Replicates this member's primary; eligible for fenced promotion." "PostgreSQL / CloudNativePG" {
                tags "Database,Private"
                url "https://cloudnative-pg.io/docs/1.28/replication/"
                properties {
                    "architecture.id" "a.pgReplica"
                    "evidence" "Implementation"
                    "source" "https://cloudnative-pg.io/docs/1.28/replication/"
                }
            }
            blobs = container "Private blob and peer store" "Stores private blobs and mutable peer metadata." "Filesystem / Premium SSD ZRS" {
                tags "Database,Private"
                url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                properties {
                    "architecture.id" "a.blobs"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                }
            }
            ipfsRepo = container "IPFS repository" "Stores this member's Kubo identity, pins and content blocks." "Filesystem / Premium SSD ZRS" {
                tags "Database,Shared"
                url "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                properties {
                    "architecture.id" "a.ipfsRepo"
                    "evidence" "Implementation"
                    "source" "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                }
            }
            secrets = container "Member keys and configuration" "Holds signing keystores, mTLS keys and configuration." "Kubernetes Secrets" {
                tags "Database,Private"
                url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                properties {
                    "architecture.id" "a.secrets"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                }
            }
        }
        b = softwareSystem "Member B FireFly" "An independently identified supernode with private member state." {
            tags "MemberB"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d"
            properties {
                "architecture.id" "b"
                "evidence" "Implementation"
                "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d"
            }
            !docs docs/system
            !adrs decisions
            core = container "FireFly Core" "Exposes member APIs and bundled Explorer; orchestrates multiparty operations." "Go + React" {
                url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                properties {
                    "architecture.id" "b.core"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                }
                api = component "REST API and routing" "Accepts namespace-scoped commands and queries." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/apiserver"
                    properties {
                        "architecture.id" "b.core.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/apiserver"
                    }
                }
                explorer = component "Explorer UI" "Serves the bundled React operator interface." "React / TypeScript" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/Dockerfile"
                    properties {
                        "architecture.id" "b.core.explorer"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/Dockerfile"
                    }
                }
                auth = component "API authentication" "Applies configured namespace authorization; Basic Auth reference plugin." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/doc-site/docs/overview/key_components/security.md"
                    properties {
                        "architecture.id" "b.core.auth"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/doc-site/docs/overview/key_components/security.md"
                    }
                }
                namespaces = component "Namespace manager" "Initializes isolated orchestrators and configured plugins." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/namespace"
                    properties {
                        "architecture.id" "b.core.namespaces"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/namespace"
                    }
                }
                orchestrator = component "Orchestrator" "Coordinates API operations and subsystem lifecycles." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                    properties {
                        "architecture.id" "b.core.orchestrator"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                    }
                }
                identity = component "Identity manager" "Resolves organizations, nodes and transaction signing identities." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/identity"
                    properties {
                        "architecture.id" "b.core.identity"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/identity"
                    }
                }
                networkmap = component "Network map" "Indexes registered members, nodes and their endpoints." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/networkmap"
                    properties {
                        "architecture.id" "b.core.networkmap"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/networkmap"
                    }
                }
                definitions = component "Definition exchange" "Publishes and processes schemas, interfaces and token definitions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/definitions"
                    properties {
                        "architecture.id" "b.core.definitions"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/definitions"
                    }
                }
                data = component "Data manager" "Validates, hashes and retrieves structured data and blob references." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    properties {
                        "architecture.id" "b.core.data"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    }
                }
                schema = component "Schema validation" "Checks JSON payloads against registered datatype definitions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    properties {
                        "architecture.id" "b.core.schema"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    }
                }
                batch = component "Batch manager" "Selects outbound messages and dispatches recoverable batches." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    properties {
                        "architecture.id" "b.core.batch"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    }
                }
                batchprocessor = component "Batch processor" "Assembles ordered message batches and aggregate hashes." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    properties {
                        "architecture.id" "b.core.batchprocessor"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    }
                }
                broadcast = component "Broadcast manager" "Publishes shared payloads and orchestrates ledger pinning." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/broadcast"
                    properties {
                        "architecture.id" "b.core.broadcast"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/broadcast"
                    }
                }
                private = component "Private messaging and groups" "Routes messages to recipient groups and coordinates delivery." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/privatemessaging"
                    properties {
                        "architecture.id" "b.core.private"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/privatemessaging"
                    }
                }
                multiparty = component "Multiparty manager" "Coordinates network actions and FireFly contract pinning." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/multiparty"
                    properties {
                        "architecture.id" "b.core.multiparty"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/multiparty"
                    }
                }
                download = component "Shared download manager" "Retrieves referenced broadcast batches and blobs." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/shareddownload"
                    properties {
                        "architecture.id" "b.core.download"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/shareddownload"
                    }
                }
                contracts = component "Contract manager" "Maps FFIs and APIs to contract calls and event listeners." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/contracts"
                    properties {
                        "architecture.id" "b.core.contracts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/contracts"
                    }
                }
                assets = component "Asset manager" "Coordinates token pools, balances and transfers." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/assets"
                    properties {
                        "architecture.id" "b.core.assets"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/assets"
                    }
                }
                operations = component "Operations manager" "Tracks asynchronous connector requests and results." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/operations"
                    properties {
                        "architecture.id" "b.core.operations"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/operations"
                    }
                }
                txhelper = component "Transaction helper" "Correlates operations, messages and blockchain transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txcommon"
                    properties {
                        "architecture.id" "b.core.txhelper"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txcommon"
                    }
                }
                txwriter = component "Transaction writer" "Batches transaction persistence and submission work." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txwriter"
                    properties {
                        "architecture.id" "b.core.txwriter"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txwriter"
                    }
                }
                aggregator = component "Inbound event aggregator" "Correlates ledger pins with payloads and sequences confirmed messages." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/aggregator.go"
                    properties {
                        "architecture.id" "b.core.aggregator"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/aggregator.go"
                    }
                }
                subscriptions = component "Subscription manager" "Filters events and persists subscriber offsets." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/subscription_manager.go"
                    properties {
                        "architecture.id" "b.core.subscriptions"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/subscription_manager.go"
                    }
                }
                dispatcher = component "Event dispatcher" "Delivers ordered event batches and processes acknowledgements." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/event_dispatcher.go"
                    properties {
                        "architecture.id" "b.core.dispatcher"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/event_dispatcher.go"
                    }
                }
                syncasync = component "Sync/async bridge" "Correlates asynchronous completion with waiting API requests." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/syncasync"
                    properties {
                        "architecture.id" "b.core.syncasync"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/syncasync"
                    }
                }
                cache = component "Cache manager" "Caches reusable namespace resources and lookups." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/cache"
                    properties {
                        "architecture.id" "b.core.cache"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/cache"
                    }
                }
                metrics = component "Metrics" "Exposes runtime and operation measurements." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/metrics"
                    properties {
                        "architecture.id" "b.core.metrics"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/metrics"
                    }
                }
                spievents = component "SPI event manager" "Publishes internal lifecycle and namespace change events." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/spievents"
                    properties {
                        "architecture.id" "b.core.spievents"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/spievents"
                    }
                }
                blockchain = component "Blockchain plugin" "Binds Ethereum operations to EVMConnect; other chains are alternatives." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain"
                    properties {
                        "architecture.id" "b.core.blockchain"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain"
                    }
                }
                database = component "Database plugin" "Maps logical resources to PostgreSQL; SQLite is an alternative." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/database"
                    properties {
                        "architecture.id" "b.core.database"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/database"
                    }
                }
                dataexchange = component "Data exchange plugin" "Binds message, blob and peer operations to the HTTPS connector." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/dataexchange"
                    properties {
                        "architecture.id" "b.core.dataexchange"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/dataexchange"
                    }
                }
                sharedstorage = component "Shared storage plugin" "Publishes and retrieves content through IPFS APIs." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/sharedstorage"
                    properties {
                        "architecture.id" "b.core.sharedstorage"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/sharedstorage"
                    }
                }
                tokens = component "Token plugin" "Binds standard token operations to remote token connectors." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/tokens"
                    properties {
                        "architecture.id" "b.core.tokens"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/tokens"
                    }
                }
                identityplugin = component "Identity plugin" "Resolves external identity claims through the configured resolver." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/pkg/identity"
                    properties {
                        "architecture.id" "b.core.identityplugin"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/pkg/identity"
                    }
                }
                eventplugin = component "Event transport plugins" "Provides WebSocket, webhook and system-event delivery." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events"
                    properties {
                        "architecture.id" "b.core.eventplugin"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events"
                    }
                }
            }
            evm = container "EVMConnect + FFTM" "Submits Ethereum transactions and streams confirmed events; one nonce writer." "Go" {
                url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                properties {
                    "architecture.id" "b.evm"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                }
                api = component "Connector REST API" "Accepts transaction, query and event-stream requests." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                    properties {
                        "architecture.id" "b.evm.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                    }
                }
                manager = component "Transaction manager" "Coordinates durable transaction and stream lifecycles." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    properties {
                        "architecture.id" "b.evm.manager"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    }
                }
                handler = component "Transaction policy handler" "Schedules signing, submission, gas and retry policy." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/txhandler"
                    properties {
                        "architecture.id" "b.evm.handler"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/txhandler"
                    }
                }
                nonce = component "Nonce allocation" "Assigns and persists ordered nonces per signing address." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    properties {
                        "architecture.id" "b.evm.nonce"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    }
                }
                abi = component "EVM API adapter" "Encodes ABIs and implements the blockchain connector API." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/internal/ethereum"
                    properties {
                        "architecture.id" "b.evm.abi"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/internal/ethereum"
                    }
                }
                rpc = component "Ethereum JSON-RPC client" "Submits calls and transactions through the signing proxy." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethrpc"
                    properties {
                        "architecture.id" "b.evm.rpc"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethrpc"
                    }
                }
                blocks = component "Block listener" "Tracks chain heads and block/filter updates." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethblocklistener"
                    properties {
                        "architecture.id" "b.evm.blocks"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethblocklistener"
                    }
                }
                receipts = component "Receipt tracking" "Polls receipt status for submitted transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    properties {
                        "architecture.id" "b.evm.receipts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    }
                }
                confirmations = component "Confirmation manager" "Confirms receipts and events against the observed chain." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/confirmations"
                    properties {
                        "architecture.id" "b.evm.confirmations"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/confirmations"
                    }
                }
                streams = component "Event streams" "Orders and batches confirmed listener events." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/events"
                    properties {
                        "architecture.id" "b.evm.streams"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/events"
                    }
                }
                delivery = component "WebSocket and webhook delivery" "Delivers batches and accepts consumer acknowledgements." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/ws"
                    properties {
                        "architecture.id" "b.evm.delivery"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/ws"
                    }
                }
                persistence = component "Persistence adapter" "Stores transactions, nonces, streams and checkpoints." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    properties {
                        "architecture.id" "b.evm.persistence"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    }
                }
            }
            signer = container "FireFly Signer" "Signs member transactions and proxies Ethereum RPC calls." "Go" {
                url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                properties {
                    "architecture.id" "b.signer"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                }
                proxy = component "JSON-RPC proxy" "Intercepts transaction requests and forwards read calls." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                    properties {
                        "architecture.id" "b.signer.proxy"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                    }
                }
                wallet = component "Filesystem wallet" "Loads member keystore files and resolves signing accounts." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                    properties {
                        "architecture.id" "b.signer.wallet"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                    }
                }
                keystore = component "Keystore V3 decoder" "Decrypts encrypted account key files." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/keystorev3"
                    properties {
                        "architecture.id" "b.signer.keystore"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/keystorev3"
                    }
                }
                signing = component "Ethereum signing" "Encodes and signs EIP-155 and EIP-1559 transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/ethsigner"
                    properties {
                        "architecture.id" "b.signer.signing"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/ethsigner"
                    }
                }
                backend = component "RPC backend" "Forwards signed raw transactions to Besu." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/rpcbackend"
                    properties {
                        "architecture.id" "b.signer.backend"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/rpcbackend"
                    }
                }
            }
            dx = container "HTTPS Data Exchange" "Exchanges private envelopes and blobs with authenticated members." "TypeScript / Node.js" {
                tags "Private"
                url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src"
                properties {
                    "architecture.id" "b.dx"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src"
                }
                api = component "Internal REST API" "Accepts private messages, blobs and peer configuration." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/api.ts"
                    properties {
                        "architecture.id" "b.dx.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/api.ts"
                    }
                }
                peers = component "Peer and certificate registry" "Resolves remote endpoints and trusted peer certificates." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/lib"
                    properties {
                        "architecture.id" "b.dx.peers"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/lib"
                    }
                }
                p2p = component "Mutual TLS peer endpoint" "Authenticates remote members and transfers private data." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/p2p.ts"
                    properties {
                        "architecture.id" "b.dx.p2p"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/p2p.ts"
                    }
                }
                messages = component "Message transfer handler" "Sends and receives recipient-scoped message envelopes." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/messages.ts"
                    properties {
                        "architecture.id" "b.dx.messages"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/messages.ts"
                    }
                }
                blobs = component "Blob transfer handler" "Streams binary content to durable member storage." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                    properties {
                        "architecture.id" "b.dx.blobs"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                    }
                }
                events = component "Event queue and acknowledgements" "Queues delivery notifications in memory and processes acknowledgements." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/events.ts"
                    properties {
                        "architecture.id" "b.dx.events"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/events.ts"
                    }
                }
            }
            erc20 = container "ERC-20 / ERC-721 connector" "Maps fungible and non-fungible token APIs to EVM contracts." "TypeScript / NestJS" {
                url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src"
                properties {
                    "architecture.id" "b.erc20"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src"
                }
                api = component "Token REST controller" "Accepts pool, mint, burn, transfer and approval requests." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.controller.ts"
                    properties {
                        "architecture.id" "b.erc20.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.controller.ts"
                    }
                }
                service = component "Token service" "Applies token-specific behavior and tracks pools." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.service.ts"
                    properties {
                        "architecture.id" "b.erc20.service"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.service.ts"
                    }
                }
                mapper = component "ABI and standard adapters" "Maps token operations to contract ABIs." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens"
                    properties {
                        "architecture.id" "b.erc20.mapper"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens"
                    }
                }
                blockchain = component "Blockchain connector client" "Submits contract calls through EVMConnect." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/blockchain.service.ts"
                    properties {
                        "architecture.id" "b.erc20.blockchain"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/blockchain.service.ts"
                    }
                }
                listener = component "Token event listener" "Interprets contract logs as standard token events." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.listener.ts"
                    properties {
                        "architecture.id" "b.erc20.listener"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.listener.ts"
                    }
                }
                stream = component "Connector event stream" "Receives ordered blockchain events and acknowledges batches." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/event-stream"
                    properties {
                        "architecture.id" "b.erc20.stream"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/event-stream"
                    }
                }
                proxy = component "Core event proxy" "Delivers token events to Core over WebSocket." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/eventstream-proxy"
                    properties {
                        "architecture.id" "b.erc20.proxy"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/eventstream-proxy"
                    }
                }
            }
            erc1155 = container "ERC-1155 connector" "Maps multi-token operations and events to FireFly." "TypeScript / NestJS" {
                url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src"
                properties {
                    "architecture.id" "b.erc1155"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src"
                }
                api = component "Token REST controller" "Accepts pool, mint, burn, transfer and approval requests." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.controller.ts"
                    properties {
                        "architecture.id" "b.erc1155.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.controller.ts"
                    }
                }
                service = component "Token service" "Applies token-specific behavior and tracks pools." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.service.ts"
                    properties {
                        "architecture.id" "b.erc1155.service"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.service.ts"
                    }
                }
                mapper = component "ABI and standard adapters" "Maps token operations to contract ABIs." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens"
                    properties {
                        "architecture.id" "b.erc1155.mapper"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens"
                    }
                }
                blockchain = component "Blockchain connector client" "Submits contract calls through EVMConnect." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/blockchain.service.ts"
                    properties {
                        "architecture.id" "b.erc1155.blockchain"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/blockchain.service.ts"
                    }
                }
                listener = component "Token event listener" "Interprets contract logs as standard token events." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.listener.ts"
                    properties {
                        "architecture.id" "b.erc1155.listener"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.listener.ts"
                    }
                }
                stream = component "Connector event stream" "Receives ordered blockchain events and acknowledges batches." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/event-stream"
                    properties {
                        "architecture.id" "b.erc1155.stream"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/event-stream"
                    }
                }
                proxy = component "Core event proxy" "Delivers token events to Core over WebSocket." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/eventstream-proxy"
                    properties {
                        "architecture.id" "b.erc1155.proxy"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/eventstream-proxy"
                    }
                }
            }
            ipfs = container "IPFS Kubo" "Publishes and retrieves consortium-shared content." "Go / Kubo" {
                tags "Shared"
                url "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                properties {
                    "architecture.id" "b.ipfs"
                    "evidence" "Implementation"
                    "source" "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                }
            }
            pg = container "PostgreSQL primary" "Stores Core and FFTM in separate databases with separate credentials." "PostgreSQL / CloudNativePG" {
                tags "Database,Private"
                url "https://cloudnative-pg.io/docs/1.28/replication/"
                properties {
                    "architecture.id" "b.pg"
                    "evidence" "Implementation"
                    "source" "https://cloudnative-pg.io/docs/1.28/replication/"
                }
            }
            pgReplica = container "PostgreSQL standby" "Replicates this member's primary; eligible for fenced promotion." "PostgreSQL / CloudNativePG" {
                tags "Database,Private"
                url "https://cloudnative-pg.io/docs/1.28/replication/"
                properties {
                    "architecture.id" "b.pgReplica"
                    "evidence" "Implementation"
                    "source" "https://cloudnative-pg.io/docs/1.28/replication/"
                }
            }
            blobs = container "Private blob and peer store" "Stores private blobs and mutable peer metadata." "Filesystem / Premium SSD ZRS" {
                tags "Database,Private"
                url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                properties {
                    "architecture.id" "b.blobs"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                }
            }
            ipfsRepo = container "IPFS repository" "Stores this member's Kubo identity, pins and content blocks." "Filesystem / Premium SSD ZRS" {
                tags "Database,Shared"
                url "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                properties {
                    "architecture.id" "b.ipfsRepo"
                    "evidence" "Implementation"
                    "source" "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                }
            }
            secrets = container "Member keys and configuration" "Holds signing keystores, mTLS keys and configuration." "Kubernetes Secrets" {
                tags "Database,Private"
                url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                properties {
                    "architecture.id" "b.secrets"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                }
            }
        }
        c = softwareSystem "Member C FireFly" "An independently identified supernode with private member state." {
            tags "MemberC"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d"
            properties {
                "architecture.id" "c"
                "evidence" "Implementation"
                "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d"
            }
            !docs docs/system
            !adrs decisions
            core = container "FireFly Core" "Exposes member APIs and bundled Explorer; orchestrates multiparty operations." "Go + React" {
                url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                properties {
                    "architecture.id" "c.core"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                }
                api = component "REST API and routing" "Accepts namespace-scoped commands and queries." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/apiserver"
                    properties {
                        "architecture.id" "c.core.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/apiserver"
                    }
                }
                explorer = component "Explorer UI" "Serves the bundled React operator interface." "React / TypeScript" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/Dockerfile"
                    properties {
                        "architecture.id" "c.core.explorer"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/Dockerfile"
                    }
                }
                auth = component "API authentication" "Applies configured namespace authorization; Basic Auth reference plugin." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/doc-site/docs/overview/key_components/security.md"
                    properties {
                        "architecture.id" "c.core.auth"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/doc-site/docs/overview/key_components/security.md"
                    }
                }
                namespaces = component "Namespace manager" "Initializes isolated orchestrators and configured plugins." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/namespace"
                    properties {
                        "architecture.id" "c.core.namespaces"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/namespace"
                    }
                }
                orchestrator = component "Orchestrator" "Coordinates API operations and subsystem lifecycles." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                    properties {
                        "architecture.id" "c.core.orchestrator"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/orchestrator"
                    }
                }
                identity = component "Identity manager" "Resolves organizations, nodes and transaction signing identities." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/identity"
                    properties {
                        "architecture.id" "c.core.identity"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/identity"
                    }
                }
                networkmap = component "Network map" "Indexes registered members, nodes and their endpoints." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/networkmap"
                    properties {
                        "architecture.id" "c.core.networkmap"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/networkmap"
                    }
                }
                definitions = component "Definition exchange" "Publishes and processes schemas, interfaces and token definitions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/definitions"
                    properties {
                        "architecture.id" "c.core.definitions"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/definitions"
                    }
                }
                data = component "Data manager" "Validates, hashes and retrieves structured data and blob references." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    properties {
                        "architecture.id" "c.core.data"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    }
                }
                schema = component "Schema validation" "Checks JSON payloads against registered datatype definitions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    properties {
                        "architecture.id" "c.core.schema"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/data"
                    }
                }
                batch = component "Batch manager" "Selects outbound messages and dispatches recoverable batches." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    properties {
                        "architecture.id" "c.core.batch"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    }
                }
                batchprocessor = component "Batch processor" "Assembles ordered message batches and aggregate hashes." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    properties {
                        "architecture.id" "c.core.batchprocessor"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/batch"
                    }
                }
                broadcast = component "Broadcast manager" "Publishes shared payloads and orchestrates ledger pinning." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/broadcast"
                    properties {
                        "architecture.id" "c.core.broadcast"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/broadcast"
                    }
                }
                private = component "Private messaging and groups" "Routes messages to recipient groups and coordinates delivery." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/privatemessaging"
                    properties {
                        "architecture.id" "c.core.private"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/privatemessaging"
                    }
                }
                multiparty = component "Multiparty manager" "Coordinates network actions and FireFly contract pinning." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/multiparty"
                    properties {
                        "architecture.id" "c.core.multiparty"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/multiparty"
                    }
                }
                download = component "Shared download manager" "Retrieves referenced broadcast batches and blobs." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/shareddownload"
                    properties {
                        "architecture.id" "c.core.download"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/shareddownload"
                    }
                }
                contracts = component "Contract manager" "Maps FFIs and APIs to contract calls and event listeners." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/contracts"
                    properties {
                        "architecture.id" "c.core.contracts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/contracts"
                    }
                }
                assets = component "Asset manager" "Coordinates token pools, balances and transfers." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/assets"
                    properties {
                        "architecture.id" "c.core.assets"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/assets"
                    }
                }
                operations = component "Operations manager" "Tracks asynchronous connector requests and results." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/operations"
                    properties {
                        "architecture.id" "c.core.operations"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/operations"
                    }
                }
                txhelper = component "Transaction helper" "Correlates operations, messages and blockchain transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txcommon"
                    properties {
                        "architecture.id" "c.core.txhelper"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txcommon"
                    }
                }
                txwriter = component "Transaction writer" "Batches transaction persistence and submission work." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txwriter"
                    properties {
                        "architecture.id" "c.core.txwriter"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/txwriter"
                    }
                }
                aggregator = component "Inbound event aggregator" "Correlates ledger pins with payloads and sequences confirmed messages." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/aggregator.go"
                    properties {
                        "architecture.id" "c.core.aggregator"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/aggregator.go"
                    }
                }
                subscriptions = component "Subscription manager" "Filters events and persists subscriber offsets." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/subscription_manager.go"
                    properties {
                        "architecture.id" "c.core.subscriptions"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/subscription_manager.go"
                    }
                }
                dispatcher = component "Event dispatcher" "Delivers ordered event batches and processes acknowledgements." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/event_dispatcher.go"
                    properties {
                        "architecture.id" "c.core.dispatcher"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events/event_dispatcher.go"
                    }
                }
                syncasync = component "Sync/async bridge" "Correlates asynchronous completion with waiting API requests." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/syncasync"
                    properties {
                        "architecture.id" "c.core.syncasync"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/syncasync"
                    }
                }
                cache = component "Cache manager" "Caches reusable namespace resources and lookups." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/cache"
                    properties {
                        "architecture.id" "c.core.cache"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/cache"
                    }
                }
                metrics = component "Metrics" "Exposes runtime and operation measurements." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/metrics"
                    properties {
                        "architecture.id" "c.core.metrics"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/metrics"
                    }
                }
                spievents = component "SPI event manager" "Publishes internal lifecycle and namespace change events." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/spievents"
                    properties {
                        "architecture.id" "c.core.spievents"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/spievents"
                    }
                }
                blockchain = component "Blockchain plugin" "Binds Ethereum operations to EVMConnect; other chains are alternatives." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain"
                    properties {
                        "architecture.id" "c.core.blockchain"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain"
                    }
                }
                database = component "Database plugin" "Maps logical resources to PostgreSQL; SQLite is an alternative." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/database"
                    properties {
                        "architecture.id" "c.core.database"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/database"
                    }
                }
                dataexchange = component "Data exchange plugin" "Binds message, blob and peer operations to the HTTPS connector." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/dataexchange"
                    properties {
                        "architecture.id" "c.core.dataexchange"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/dataexchange"
                    }
                }
                sharedstorage = component "Shared storage plugin" "Publishes and retrieves content through IPFS APIs." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/sharedstorage"
                    properties {
                        "architecture.id" "c.core.sharedstorage"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/sharedstorage"
                    }
                }
                tokens = component "Token plugin" "Binds standard token operations to remote token connectors." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/tokens"
                    properties {
                        "architecture.id" "c.core.tokens"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/tokens"
                    }
                }
                identityplugin = component "Identity plugin" "Resolves external identity claims through the configured resolver." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/pkg/identity"
                    properties {
                        "architecture.id" "c.core.identityplugin"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/pkg/identity"
                    }
                }
                eventplugin = component "Event transport plugins" "Provides WebSocket, webhook and system-event delivery." "Go" {
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events"
                    properties {
                        "architecture.id" "c.core.eventplugin"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/events"
                    }
                }
            }
            evm = container "EVMConnect + FFTM" "Submits Ethereum transactions and streams confirmed events; one nonce writer." "Go" {
                url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                properties {
                    "architecture.id" "c.evm"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                }
                api = component "Connector REST API" "Accepts transaction, query and event-stream requests." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                    properties {
                        "architecture.id" "c.evm.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/cmd/evmconnect.go"
                    }
                }
                manager = component "Transaction manager" "Coordinates durable transaction and stream lifecycles." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    properties {
                        "architecture.id" "c.evm.manager"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    }
                }
                handler = component "Transaction policy handler" "Schedules signing, submission, gas and retry policy." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/txhandler"
                    properties {
                        "architecture.id" "c.evm.handler"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/txhandler"
                    }
                }
                nonce = component "Nonce allocation" "Assigns and persists ordered nonces per signing address." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    properties {
                        "architecture.id" "c.evm.nonce"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    }
                }
                abi = component "EVM API adapter" "Encodes ABIs and implements the blockchain connector API." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/internal/ethereum"
                    properties {
                        "architecture.id" "c.evm.abi"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/internal/ethereum"
                    }
                }
                rpc = component "Ethereum JSON-RPC client" "Submits calls and transactions through the signing proxy." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethrpc"
                    properties {
                        "architecture.id" "c.evm.rpc"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethrpc"
                    }
                }
                blocks = component "Block listener" "Tracks chain heads and block/filter updates." "Go" {
                    url "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethblocklistener"
                    properties {
                        "architecture.id" "c.evm.blocks"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559/pkg/ethblocklistener"
                    }
                }
                receipts = component "Receipt tracking" "Polls receipt status for submitted transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    properties {
                        "architecture.id" "c.evm.receipts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/pkg/fftm"
                    }
                }
                confirmations = component "Confirmation manager" "Confirms receipts and events against the observed chain." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/confirmations"
                    properties {
                        "architecture.id" "c.evm.confirmations"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/confirmations"
                    }
                }
                streams = component "Event streams" "Orders and batches confirmed listener events." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/events"
                    properties {
                        "architecture.id" "c.evm.streams"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/events"
                    }
                }
                delivery = component "WebSocket and webhook delivery" "Delivers batches and accepts consumer acknowledgements." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/ws"
                    properties {
                        "architecture.id" "c.evm.delivery"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/ws"
                    }
                }
                persistence = component "Persistence adapter" "Stores transactions, nonces, streams and checkpoints." "Go" {
                    url "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    properties {
                        "architecture.id" "c.evm.persistence"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286/internal/persistence"
                    }
                }
            }
            signer = container "FireFly Signer" "Signs member transactions and proxies Ethereum RPC calls." "Go" {
                url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                properties {
                    "architecture.id" "c.signer"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                }
                proxy = component "JSON-RPC proxy" "Intercepts transaction requests and forwards read calls." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                    properties {
                        "architecture.id" "c.signer.proxy"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/internal/rpcserver"
                    }
                }
                wallet = component "Filesystem wallet" "Loads member keystore files and resolves signing accounts." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                    properties {
                        "architecture.id" "c.signer.wallet"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                    }
                }
                keystore = component "Keystore V3 decoder" "Decrypts encrypted account key files." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/keystorev3"
                    properties {
                        "architecture.id" "c.signer.keystore"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/keystorev3"
                    }
                }
                signing = component "Ethereum signing" "Encodes and signs EIP-155 and EIP-1559 transactions." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/ethsigner"
                    properties {
                        "architecture.id" "c.signer.signing"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/ethsigner"
                    }
                }
                backend = component "RPC backend" "Forwards signed raw transactions to Besu." "Go" {
                    url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/rpcbackend"
                    properties {
                        "architecture.id" "c.signer.backend"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/rpcbackend"
                    }
                }
            }
            dx = container "HTTPS Data Exchange" "Exchanges private envelopes and blobs with authenticated members." "TypeScript / Node.js" {
                tags "Private"
                url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src"
                properties {
                    "architecture.id" "c.dx"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src"
                }
                api = component "Internal REST API" "Accepts private messages, blobs and peer configuration." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/api.ts"
                    properties {
                        "architecture.id" "c.dx.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/api.ts"
                    }
                }
                peers = component "Peer and certificate registry" "Resolves remote endpoints and trusted peer certificates." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/lib"
                    properties {
                        "architecture.id" "c.dx.peers"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/lib"
                    }
                }
                p2p = component "Mutual TLS peer endpoint" "Authenticates remote members and transfers private data." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/p2p.ts"
                    properties {
                        "architecture.id" "c.dx.p2p"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/p2p.ts"
                    }
                }
                messages = component "Message transfer handler" "Sends and receives recipient-scoped message envelopes." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/messages.ts"
                    properties {
                        "architecture.id" "c.dx.messages"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/messages.ts"
                    }
                }
                blobs = component "Blob transfer handler" "Streams binary content to durable member storage." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                    properties {
                        "architecture.id" "c.dx.blobs"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                    }
                }
                events = component "Event queue and acknowledgements" "Queues delivery notifications in memory and processes acknowledgements." "TypeScript / Node.js" {
                    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/events.ts"
                    properties {
                        "architecture.id" "c.dx.events"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/events.ts"
                    }
                }
            }
            erc20 = container "ERC-20 / ERC-721 connector" "Maps fungible and non-fungible token APIs to EVM contracts." "TypeScript / NestJS" {
                url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src"
                properties {
                    "architecture.id" "c.erc20"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src"
                }
                api = component "Token REST controller" "Accepts pool, mint, burn, transfer and approval requests." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.controller.ts"
                    properties {
                        "architecture.id" "c.erc20.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.controller.ts"
                    }
                }
                service = component "Token service" "Applies token-specific behavior and tracks pools." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.service.ts"
                    properties {
                        "architecture.id" "c.erc20.service"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.service.ts"
                    }
                }
                mapper = component "ABI and standard adapters" "Maps token operations to contract ABIs." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens"
                    properties {
                        "architecture.id" "c.erc20.mapper"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens"
                    }
                }
                blockchain = component "Blockchain connector client" "Submits contract calls through EVMConnect." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/blockchain.service.ts"
                    properties {
                        "architecture.id" "c.erc20.blockchain"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/blockchain.service.ts"
                    }
                }
                listener = component "Token event listener" "Interprets contract logs as standard token events." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.listener.ts"
                    properties {
                        "architecture.id" "c.erc20.listener"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/tokens/tokens.listener.ts"
                    }
                }
                stream = component "Connector event stream" "Receives ordered blockchain events and acknowledges batches." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/event-stream"
                    properties {
                        "architecture.id" "c.erc20.stream"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/event-stream"
                    }
                }
                proxy = component "Core event proxy" "Delivers token events to Core over WebSocket." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/eventstream-proxy"
                    properties {
                        "architecture.id" "c.erc20.proxy"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/eventstream-proxy"
                    }
                }
            }
            erc1155 = container "ERC-1155 connector" "Maps multi-token operations and events to FireFly." "TypeScript / NestJS" {
                url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src"
                properties {
                    "architecture.id" "c.erc1155"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src"
                }
                api = component "Token REST controller" "Accepts pool, mint, burn, transfer and approval requests." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.controller.ts"
                    properties {
                        "architecture.id" "c.erc1155.api"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.controller.ts"
                    }
                }
                service = component "Token service" "Applies token-specific behavior and tracks pools." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.service.ts"
                    properties {
                        "architecture.id" "c.erc1155.service"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.service.ts"
                    }
                }
                mapper = component "ABI and standard adapters" "Maps token operations to contract ABIs." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens"
                    properties {
                        "architecture.id" "c.erc1155.mapper"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens"
                    }
                }
                blockchain = component "Blockchain connector client" "Submits contract calls through EVMConnect." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/blockchain.service.ts"
                    properties {
                        "architecture.id" "c.erc1155.blockchain"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/blockchain.service.ts"
                    }
                }
                listener = component "Token event listener" "Interprets contract logs as standard token events." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.listener.ts"
                    properties {
                        "architecture.id" "c.erc1155.listener"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/tokens/tokens.listener.ts"
                    }
                }
                stream = component "Connector event stream" "Receives ordered blockchain events and acknowledges batches." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/event-stream"
                    properties {
                        "architecture.id" "c.erc1155.stream"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/event-stream"
                    }
                }
                proxy = component "Core event proxy" "Delivers token events to Core over WebSocket." "TypeScript / NestJS" {
                    url "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/eventstream-proxy"
                    properties {
                        "architecture.id" "c.erc1155.proxy"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/eventstream-proxy"
                    }
                }
            }
            ipfs = container "IPFS Kubo" "Publishes and retrieves consortium-shared content." "Go / Kubo" {
                tags "Shared"
                url "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                properties {
                    "architecture.id" "c.ipfs"
                    "evidence" "Implementation"
                    "source" "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                }
            }
            pg = container "PostgreSQL primary" "Stores Core and FFTM in separate databases with separate credentials." "PostgreSQL / CloudNativePG" {
                tags "Database,Private"
                url "https://cloudnative-pg.io/docs/1.28/replication/"
                properties {
                    "architecture.id" "c.pg"
                    "evidence" "Implementation"
                    "source" "https://cloudnative-pg.io/docs/1.28/replication/"
                }
            }
            pgReplica = container "PostgreSQL standby" "Replicates this member's primary; eligible for fenced promotion." "PostgreSQL / CloudNativePG" {
                tags "Database,Private"
                url "https://cloudnative-pg.io/docs/1.28/replication/"
                properties {
                    "architecture.id" "c.pgReplica"
                    "evidence" "Implementation"
                    "source" "https://cloudnative-pg.io/docs/1.28/replication/"
                }
            }
            blobs = container "Private blob and peer store" "Stores private blobs and mutable peer metadata." "Filesystem / Premium SSD ZRS" {
                tags "Database,Private"
                url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                properties {
                    "architecture.id" "c.blobs"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
                }
            }
            ipfsRepo = container "IPFS repository" "Stores this member's Kubo identity, pins and content blocks." "Filesystem / Premium SSD ZRS" {
                tags "Database,Shared"
                url "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                properties {
                    "architecture.id" "c.ipfsRepo"
                    "evidence" "Implementation"
                    "source" "https://docs.ipfs.tech/concepts/how-ipfs-works/"
                }
            }
            secrets = container "Member keys and configuration" "Holds signing keystores, mTLS keys and configuration." "Kubernetes Secrets" {
                tags "Database,Private"
                url "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                properties {
                    "architecture.id" "c.secrets"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d/pkg/fswallet"
                }
            }
        }
        besu = softwareSystem "Private Besu network" "Permissioned Ethereum network with QBFT validators, private RPC and contracts." {
            tags "Blockchain"
            url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
            properties {
                "architecture.id" "besu"
                "evidence" "Implementation"
                "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
            }
            !docs docs/system
            !adrs decisions
            a1 = container "Besu validator A1" "Validates QBFT blocks; owner A; AZ 1." "Java / Besu / RocksDB" {
                tags "Blockchain"
                url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                properties {
                    "architecture.id" "besu.a1"
                    "evidence" "Implementation"
                    "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                }
                rpc = component "JSON-RPC and subscriptions" "Accepts private-network queries and signed transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    properties {
                        "architecture.id" "besu.a1.rpc"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    }
                }
                permissioning = component "Node and account permissioning" "Applies local peer and account allowlists." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    properties {
                        "architecture.id" "besu.a1.permissioning"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    }
                }
                discovery = component "Peer discovery" "Discovers peers through configured bootnodes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.a1.discovery"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                p2p = component "DevP2P transport" "Exchanges transactions, blocks and consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.a1.p2p"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                txpool = component "Transaction pool" "Validates and queues pending transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.a1.txpool"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                sync = component "Chain synchronization" "Downloads and validates missing blocks and state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.a1.sync"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                blockprocessor = component "Block processor" "Validates blocks and applies state transitions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    properties {
                        "architecture.id" "besu.a1.blockprocessor"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    }
                }
                qbft = component "QBFT consensus" "Proposes blocks and verifies validator votes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/consensus/qbft"
                    properties {
                        "architecture.id" "besu.a1.qbft"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/consensus/qbft"
                    }
                }
                evm = component "EVM execution" "Executes smart-contract bytecode deterministically." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    properties {
                        "architecture.id" "besu.a1.evm"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    }
                }
                worldstate = component "World state and trie" "Tracks account balances, storage and contract state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    properties {
                        "architecture.id" "besu.a1.worldstate"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    }
                }
                storage = component "Storage provider" "Persists blockchain data and world-state records." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    properties {
                        "architecture.id" "besu.a1.storage"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    }
                }
                keys = component "Node key and security module" "Signs node identity and validator consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    properties {
                        "architecture.id" "besu.a1.keys"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    }
                }
                metrics = component "Metrics and health" "Exposes node, peer and consensus measurements." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    properties {
                        "architecture.id" "besu.a1.metrics"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    }
                }
                fireflycontract = component "FireFly multiparty contract" "Executes batch pinning and emits sequencing events." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    properties {
                        "architecture.id" "besu.a1.fireflycontract"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    }
                }
                tokencontracts = component "Token contracts" "Executes ERC-20, ERC-721 and ERC-1155 state changes." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    properties {
                        "architecture.id" "besu.a1.tokencontracts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    }
                }
                businesscontracts = component "Application contracts" "Executes member-defined business rules; example extension." "Solidity / EVM" {
                    tags "Contract"
                    url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    properties {
                        "architecture.id" "besu.a1.businesscontracts"
                        "evidence" "Reference choice"
                        "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    }
                }
            }
            b1 = container "Besu validator B1" "Validates QBFT blocks; owner B; AZ 1." "Java / Besu / RocksDB" {
                tags "Blockchain"
                url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                properties {
                    "architecture.id" "besu.b1"
                    "evidence" "Implementation"
                    "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                }
                rpc = component "JSON-RPC and subscriptions" "Accepts private-network queries and signed transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    properties {
                        "architecture.id" "besu.b1.rpc"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    }
                }
                permissioning = component "Node and account permissioning" "Applies local peer and account allowlists." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    properties {
                        "architecture.id" "besu.b1.permissioning"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    }
                }
                discovery = component "Peer discovery" "Discovers peers through configured bootnodes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.b1.discovery"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                p2p = component "DevP2P transport" "Exchanges transactions, blocks and consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.b1.p2p"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                txpool = component "Transaction pool" "Validates and queues pending transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.b1.txpool"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                sync = component "Chain synchronization" "Downloads and validates missing blocks and state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.b1.sync"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                blockprocessor = component "Block processor" "Validates blocks and applies state transitions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    properties {
                        "architecture.id" "besu.b1.blockprocessor"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    }
                }
                qbft = component "QBFT consensus" "Proposes blocks and verifies validator votes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/consensus/qbft"
                    properties {
                        "architecture.id" "besu.b1.qbft"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/consensus/qbft"
                    }
                }
                evm = component "EVM execution" "Executes smart-contract bytecode deterministically." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    properties {
                        "architecture.id" "besu.b1.evm"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    }
                }
                worldstate = component "World state and trie" "Tracks account balances, storage and contract state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    properties {
                        "architecture.id" "besu.b1.worldstate"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    }
                }
                storage = component "Storage provider" "Persists blockchain data and world-state records." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    properties {
                        "architecture.id" "besu.b1.storage"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    }
                }
                keys = component "Node key and security module" "Signs node identity and validator consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    properties {
                        "architecture.id" "besu.b1.keys"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    }
                }
                metrics = component "Metrics and health" "Exposes node, peer and consensus measurements." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    properties {
                        "architecture.id" "besu.b1.metrics"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    }
                }
                fireflycontract = component "FireFly multiparty contract" "Executes batch pinning and emits sequencing events." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    properties {
                        "architecture.id" "besu.b1.fireflycontract"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    }
                }
                tokencontracts = component "Token contracts" "Executes ERC-20, ERC-721 and ERC-1155 state changes." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    properties {
                        "architecture.id" "besu.b1.tokencontracts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    }
                }
                businesscontracts = component "Application contracts" "Executes member-defined business rules; example extension." "Solidity / EVM" {
                    tags "Contract"
                    url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    properties {
                        "architecture.id" "besu.b1.businesscontracts"
                        "evidence" "Reference choice"
                        "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    }
                }
            }
            b2 = container "Besu validator B2" "Validates QBFT blocks; owner B; AZ 2." "Java / Besu / RocksDB" {
                tags "Blockchain"
                url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                properties {
                    "architecture.id" "besu.b2"
                    "evidence" "Implementation"
                    "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                }
                rpc = component "JSON-RPC and subscriptions" "Accepts private-network queries and signed transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    properties {
                        "architecture.id" "besu.b2.rpc"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    }
                }
                permissioning = component "Node and account permissioning" "Applies local peer and account allowlists." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    properties {
                        "architecture.id" "besu.b2.permissioning"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    }
                }
                discovery = component "Peer discovery" "Discovers peers through configured bootnodes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.b2.discovery"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                p2p = component "DevP2P transport" "Exchanges transactions, blocks and consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.b2.p2p"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                txpool = component "Transaction pool" "Validates and queues pending transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.b2.txpool"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                sync = component "Chain synchronization" "Downloads and validates missing blocks and state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.b2.sync"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                blockprocessor = component "Block processor" "Validates blocks and applies state transitions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    properties {
                        "architecture.id" "besu.b2.blockprocessor"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    }
                }
                qbft = component "QBFT consensus" "Proposes blocks and verifies validator votes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/consensus/qbft"
                    properties {
                        "architecture.id" "besu.b2.qbft"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/consensus/qbft"
                    }
                }
                evm = component "EVM execution" "Executes smart-contract bytecode deterministically." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    properties {
                        "architecture.id" "besu.b2.evm"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    }
                }
                worldstate = component "World state and trie" "Tracks account balances, storage and contract state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    properties {
                        "architecture.id" "besu.b2.worldstate"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    }
                }
                storage = component "Storage provider" "Persists blockchain data and world-state records." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    properties {
                        "architecture.id" "besu.b2.storage"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    }
                }
                keys = component "Node key and security module" "Signs node identity and validator consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    properties {
                        "architecture.id" "besu.b2.keys"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    }
                }
                metrics = component "Metrics and health" "Exposes node, peer and consensus measurements." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    properties {
                        "architecture.id" "besu.b2.metrics"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    }
                }
                fireflycontract = component "FireFly multiparty contract" "Executes batch pinning and emits sequencing events." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    properties {
                        "architecture.id" "besu.b2.fireflycontract"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    }
                }
                tokencontracts = component "Token contracts" "Executes ERC-20, ERC-721 and ERC-1155 state changes." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    properties {
                        "architecture.id" "besu.b2.tokencontracts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    }
                }
                businesscontracts = component "Application contracts" "Executes member-defined business rules; example extension." "Solidity / EVM" {
                    tags "Contract"
                    url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    properties {
                        "architecture.id" "besu.b2.businesscontracts"
                        "evidence" "Reference choice"
                        "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    }
                }
            }
            c1 = container "Besu validator C1" "Validates QBFT blocks; owner C; AZ 2." "Java / Besu / RocksDB" {
                tags "Blockchain"
                url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                properties {
                    "architecture.id" "besu.c1"
                    "evidence" "Implementation"
                    "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                }
                rpc = component "JSON-RPC and subscriptions" "Accepts private-network queries and signed transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    properties {
                        "architecture.id" "besu.c1.rpc"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    }
                }
                permissioning = component "Node and account permissioning" "Applies local peer and account allowlists." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    properties {
                        "architecture.id" "besu.c1.permissioning"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    }
                }
                discovery = component "Peer discovery" "Discovers peers through configured bootnodes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.c1.discovery"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                p2p = component "DevP2P transport" "Exchanges transactions, blocks and consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.c1.p2p"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                txpool = component "Transaction pool" "Validates and queues pending transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.c1.txpool"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                sync = component "Chain synchronization" "Downloads and validates missing blocks and state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.c1.sync"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                blockprocessor = component "Block processor" "Validates blocks and applies state transitions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    properties {
                        "architecture.id" "besu.c1.blockprocessor"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    }
                }
                qbft = component "QBFT consensus" "Proposes blocks and verifies validator votes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/consensus/qbft"
                    properties {
                        "architecture.id" "besu.c1.qbft"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/consensus/qbft"
                    }
                }
                evm = component "EVM execution" "Executes smart-contract bytecode deterministically." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    properties {
                        "architecture.id" "besu.c1.evm"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    }
                }
                worldstate = component "World state and trie" "Tracks account balances, storage and contract state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    properties {
                        "architecture.id" "besu.c1.worldstate"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    }
                }
                storage = component "Storage provider" "Persists blockchain data and world-state records." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    properties {
                        "architecture.id" "besu.c1.storage"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    }
                }
                keys = component "Node key and security module" "Signs node identity and validator consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    properties {
                        "architecture.id" "besu.c1.keys"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    }
                }
                metrics = component "Metrics and health" "Exposes node, peer and consensus measurements." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    properties {
                        "architecture.id" "besu.c1.metrics"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    }
                }
                fireflycontract = component "FireFly multiparty contract" "Executes batch pinning and emits sequencing events." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    properties {
                        "architecture.id" "besu.c1.fireflycontract"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    }
                }
                tokencontracts = component "Token contracts" "Executes ERC-20, ERC-721 and ERC-1155 state changes." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    properties {
                        "architecture.id" "besu.c1.tokencontracts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    }
                }
                businesscontracts = component "Application contracts" "Executes member-defined business rules; example extension." "Solidity / EVM" {
                    tags "Contract"
                    url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    properties {
                        "architecture.id" "besu.c1.businesscontracts"
                        "evidence" "Reference choice"
                        "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    }
                }
            }
            c2 = container "Besu validator C2" "Validates QBFT blocks; owner C; AZ 3." "Java / Besu / RocksDB" {
                tags "Blockchain"
                url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                properties {
                    "architecture.id" "besu.c2"
                    "evidence" "Implementation"
                    "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                }
                rpc = component "JSON-RPC and subscriptions" "Accepts private-network queries and signed transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    properties {
                        "architecture.id" "besu.c2.rpc"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    }
                }
                permissioning = component "Node and account permissioning" "Applies local peer and account allowlists." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    properties {
                        "architecture.id" "besu.c2.permissioning"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    }
                }
                discovery = component "Peer discovery" "Discovers peers through configured bootnodes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.c2.discovery"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                p2p = component "DevP2P transport" "Exchanges transactions, blocks and consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.c2.p2p"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                txpool = component "Transaction pool" "Validates and queues pending transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.c2.txpool"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                sync = component "Chain synchronization" "Downloads and validates missing blocks and state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.c2.sync"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                blockprocessor = component "Block processor" "Validates blocks and applies state transitions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    properties {
                        "architecture.id" "besu.c2.blockprocessor"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    }
                }
                qbft = component "QBFT consensus" "Proposes blocks and verifies validator votes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/consensus/qbft"
                    properties {
                        "architecture.id" "besu.c2.qbft"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/consensus/qbft"
                    }
                }
                evm = component "EVM execution" "Executes smart-contract bytecode deterministically." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    properties {
                        "architecture.id" "besu.c2.evm"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    }
                }
                worldstate = component "World state and trie" "Tracks account balances, storage and contract state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    properties {
                        "architecture.id" "besu.c2.worldstate"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    }
                }
                storage = component "Storage provider" "Persists blockchain data and world-state records." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    properties {
                        "architecture.id" "besu.c2.storage"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    }
                }
                keys = component "Node key and security module" "Signs node identity and validator consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    properties {
                        "architecture.id" "besu.c2.keys"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    }
                }
                metrics = component "Metrics and health" "Exposes node, peer and consensus measurements." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    properties {
                        "architecture.id" "besu.c2.metrics"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    }
                }
                fireflycontract = component "FireFly multiparty contract" "Executes batch pinning and emits sequencing events." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    properties {
                        "architecture.id" "besu.c2.fireflycontract"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    }
                }
                tokencontracts = component "Token contracts" "Executes ERC-20, ERC-721 and ERC-1155 state changes." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    properties {
                        "architecture.id" "besu.c2.tokencontracts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    }
                }
                businesscontracts = component "Application contracts" "Executes member-defined business rules; example extension." "Solidity / EVM" {
                    tags "Contract"
                    url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    properties {
                        "architecture.id" "besu.c2.businesscontracts"
                        "evidence" "Reference choice"
                        "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    }
                }
            }
            a2 = container "Besu validator A2" "Validates QBFT blocks; owner A; AZ 3." "Java / Besu / RocksDB" {
                tags "Blockchain"
                url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                properties {
                    "architecture.id" "besu.a2"
                    "evidence" "Implementation"
                    "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                }
                rpc = component "JSON-RPC and subscriptions" "Accepts private-network queries and signed transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    properties {
                        "architecture.id" "besu.a2.rpc"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    }
                }
                permissioning = component "Node and account permissioning" "Applies local peer and account allowlists." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    properties {
                        "architecture.id" "besu.a2.permissioning"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    }
                }
                discovery = component "Peer discovery" "Discovers peers through configured bootnodes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.a2.discovery"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                p2p = component "DevP2P transport" "Exchanges transactions, blocks and consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.a2.p2p"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                txpool = component "Transaction pool" "Validates and queues pending transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.a2.txpool"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                sync = component "Chain synchronization" "Downloads and validates missing blocks and state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.a2.sync"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                blockprocessor = component "Block processor" "Validates blocks and applies state transitions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    properties {
                        "architecture.id" "besu.a2.blockprocessor"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    }
                }
                qbft = component "QBFT consensus" "Proposes blocks and verifies validator votes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/consensus/qbft"
                    properties {
                        "architecture.id" "besu.a2.qbft"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/consensus/qbft"
                    }
                }
                evm = component "EVM execution" "Executes smart-contract bytecode deterministically." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    properties {
                        "architecture.id" "besu.a2.evm"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    }
                }
                worldstate = component "World state and trie" "Tracks account balances, storage and contract state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    properties {
                        "architecture.id" "besu.a2.worldstate"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    }
                }
                storage = component "Storage provider" "Persists blockchain data and world-state records." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    properties {
                        "architecture.id" "besu.a2.storage"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    }
                }
                keys = component "Node key and security module" "Signs node identity and validator consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    properties {
                        "architecture.id" "besu.a2.keys"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    }
                }
                metrics = component "Metrics and health" "Exposes node, peer and consensus measurements." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    properties {
                        "architecture.id" "besu.a2.metrics"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    }
                }
                fireflycontract = component "FireFly multiparty contract" "Executes batch pinning and emits sequencing events." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    properties {
                        "architecture.id" "besu.a2.fireflycontract"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    }
                }
                tokencontracts = component "Token contracts" "Executes ERC-20, ERC-721 and ERC-1155 state changes." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    properties {
                        "architecture.id" "besu.a2.tokencontracts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    }
                }
                businesscontracts = component "Application contracts" "Executes member-defined business rules; example extension." "Solidity / EVM" {
                    tags "Contract"
                    url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    properties {
                        "architecture.id" "besu.a2.businesscontracts"
                        "evidence" "Reference choice"
                        "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    }
                }
            }
            rpc1 = container "Besu RPC node 1" "Serves private JSON-RPC and syncs blocks; owner CONSORTIUM; AZ 1." "Java / Besu / RocksDB" {
                tags "Blockchain"
                url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                properties {
                    "architecture.id" "besu.rpc1"
                    "evidence" "Implementation"
                    "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                }
                rpc = component "JSON-RPC and subscriptions" "Accepts private-network queries and signed transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    properties {
                        "architecture.id" "besu.rpc1.rpc"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    }
                }
                permissioning = component "Node and account permissioning" "Applies local peer and account allowlists." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    properties {
                        "architecture.id" "besu.rpc1.permissioning"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    }
                }
                discovery = component "Peer discovery" "Discovers peers through configured bootnodes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.rpc1.discovery"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                p2p = component "DevP2P transport" "Exchanges transactions, blocks and consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.rpc1.p2p"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                txpool = component "Transaction pool" "Validates and queues pending transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.rpc1.txpool"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                sync = component "Chain synchronization" "Downloads and validates missing blocks and state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.rpc1.sync"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                blockprocessor = component "Block processor" "Validates blocks and applies state transitions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    properties {
                        "architecture.id" "besu.rpc1.blockprocessor"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    }
                }
                evm = component "EVM execution" "Executes smart-contract bytecode deterministically." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    properties {
                        "architecture.id" "besu.rpc1.evm"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    }
                }
                worldstate = component "World state and trie" "Tracks account balances, storage and contract state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    properties {
                        "architecture.id" "besu.rpc1.worldstate"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    }
                }
                storage = component "Storage provider" "Persists blockchain data and world-state records." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    properties {
                        "architecture.id" "besu.rpc1.storage"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    }
                }
                keys = component "Node key and security module" "Signs node identity and validator consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    properties {
                        "architecture.id" "besu.rpc1.keys"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    }
                }
                metrics = component "Metrics and health" "Exposes node, peer and consensus measurements." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    properties {
                        "architecture.id" "besu.rpc1.metrics"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    }
                }
                fireflycontract = component "FireFly multiparty contract" "Executes batch pinning and emits sequencing events." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    properties {
                        "architecture.id" "besu.rpc1.fireflycontract"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    }
                }
                tokencontracts = component "Token contracts" "Executes ERC-20, ERC-721 and ERC-1155 state changes." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    properties {
                        "architecture.id" "besu.rpc1.tokencontracts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    }
                }
                businesscontracts = component "Application contracts" "Executes member-defined business rules; example extension." "Solidity / EVM" {
                    tags "Contract"
                    url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    properties {
                        "architecture.id" "besu.rpc1.businesscontracts"
                        "evidence" "Reference choice"
                        "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    }
                }
            }
            rpc2 = container "Besu RPC node 2" "Serves private JSON-RPC and syncs blocks; owner CONSORTIUM; AZ 2." "Java / Besu / RocksDB" {
                tags "Blockchain"
                url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                properties {
                    "architecture.id" "besu.rpc2"
                    "evidence" "Implementation"
                    "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                }
                rpc = component "JSON-RPC and subscriptions" "Accepts private-network queries and signed transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    properties {
                        "architecture.id" "besu.rpc2.rpc"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    }
                }
                permissioning = component "Node and account permissioning" "Applies local peer and account allowlists." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    properties {
                        "architecture.id" "besu.rpc2.permissioning"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    }
                }
                discovery = component "Peer discovery" "Discovers peers through configured bootnodes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.rpc2.discovery"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                p2p = component "DevP2P transport" "Exchanges transactions, blocks and consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.rpc2.p2p"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                txpool = component "Transaction pool" "Validates and queues pending transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.rpc2.txpool"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                sync = component "Chain synchronization" "Downloads and validates missing blocks and state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.rpc2.sync"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                blockprocessor = component "Block processor" "Validates blocks and applies state transitions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    properties {
                        "architecture.id" "besu.rpc2.blockprocessor"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    }
                }
                evm = component "EVM execution" "Executes smart-contract bytecode deterministically." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    properties {
                        "architecture.id" "besu.rpc2.evm"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    }
                }
                worldstate = component "World state and trie" "Tracks account balances, storage and contract state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    properties {
                        "architecture.id" "besu.rpc2.worldstate"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    }
                }
                storage = component "Storage provider" "Persists blockchain data and world-state records." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    properties {
                        "architecture.id" "besu.rpc2.storage"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    }
                }
                keys = component "Node key and security module" "Signs node identity and validator consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    properties {
                        "architecture.id" "besu.rpc2.keys"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    }
                }
                metrics = component "Metrics and health" "Exposes node, peer and consensus measurements." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    properties {
                        "architecture.id" "besu.rpc2.metrics"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    }
                }
                fireflycontract = component "FireFly multiparty contract" "Executes batch pinning and emits sequencing events." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    properties {
                        "architecture.id" "besu.rpc2.fireflycontract"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    }
                }
                tokencontracts = component "Token contracts" "Executes ERC-20, ERC-721 and ERC-1155 state changes." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    properties {
                        "architecture.id" "besu.rpc2.tokencontracts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    }
                }
                businesscontracts = component "Application contracts" "Executes member-defined business rules; example extension." "Solidity / EVM" {
                    tags "Contract"
                    url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    properties {
                        "architecture.id" "besu.rpc2.businesscontracts"
                        "evidence" "Reference choice"
                        "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    }
                }
            }
            rpc3 = container "Besu RPC node 3" "Serves private JSON-RPC and syncs blocks; owner CONSORTIUM; AZ 3." "Java / Besu / RocksDB" {
                tags "Blockchain"
                url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                properties {
                    "architecture.id" "besu.rpc3"
                    "evidence" "Implementation"
                    "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc"
                }
                rpc = component "JSON-RPC and subscriptions" "Accepts private-network queries and signed transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    properties {
                        "architecture.id" "besu.rpc3.rpc"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/api"
                    }
                }
                permissioning = component "Node and account permissioning" "Applies local peer and account allowlists." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    properties {
                        "architecture.id" "besu.rpc3.permissioning"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/permissioning"
                    }
                }
                discovery = component "Peer discovery" "Discovers peers through configured bootnodes." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.rpc3.discovery"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                p2p = component "DevP2P transport" "Exchanges transactions, blocks and consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    properties {
                        "architecture.id" "besu.rpc3.p2p"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/p2p"
                    }
                }
                txpool = component "Transaction pool" "Validates and queues pending transactions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.rpc3.txpool"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                sync = component "Chain synchronization" "Downloads and validates missing blocks and state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    properties {
                        "architecture.id" "besu.rpc3.sync"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/eth"
                    }
                }
                blockprocessor = component "Block processor" "Validates blocks and applies state transitions." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    properties {
                        "architecture.id" "besu.rpc3.blockprocessor"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/core"
                    }
                }
                evm = component "EVM execution" "Executes smart-contract bytecode deterministically." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    properties {
                        "architecture.id" "besu.rpc3.evm"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/evm"
                    }
                }
                worldstate = component "World state and trie" "Tracks account balances, storage and contract state." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    properties {
                        "architecture.id" "besu.rpc3.worldstate"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/ethereum/trie"
                    }
                }
                storage = component "Storage provider" "Persists blockchain data and world-state records." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    properties {
                        "architecture.id" "besu.rpc3.storage"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugins/rocksdb"
                    }
                }
                keys = component "Node key and security module" "Signs node identity and validator consensus messages." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    properties {
                        "architecture.id" "besu.rpc3.keys"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/plugin-api"
                    }
                }
                metrics = component "Metrics and health" "Exposes node, peer and consensus measurements." "Java" {
                    url "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    properties {
                        "architecture.id" "besu.rpc3.metrics"
                        "evidence" "Implementation"
                        "source" "https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc/metrics"
                    }
                }
                fireflycontract = component "FireFly multiparty contract" "Executes batch pinning and emits sequencing events." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    properties {
                        "architecture.id" "besu.rpc3.fireflycontract"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
                    }
                }
                tokencontracts = component "Token contracts" "Executes ERC-20, ERC-721 and ERC-1155 state changes." "Solidity / EVM" {
                    tags "Contract"
                    url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    properties {
                        "architecture.id" "besu.rpc3.tokencontracts"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
                    }
                }
                businesscontracts = component "Application contracts" "Executes member-defined business rules; example extension." "Solidity / EVM" {
                    tags "Contract"
                    url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    properties {
                        "architecture.id" "besu.rpc3.businesscontracts"
                        "evidence" "Reference choice"
                        "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                    }
                }
            }
        }
        apps = softwareSystem "Member applications" "Independently owned applications and event consumers." {
            url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            properties {
                "architecture.id" "apps"
                "evidence" "Reference choice"
                "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            }
            !docs docs/system
            !adrs decisions
            a = container "Member A business application" "Submits requests and consumes acknowledged FireFly events." "Example application / REST client" {
                url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                properties {
                    "architecture.id" "apps.a"
                    "evidence" "Reference choice"
                    "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                }
            }
            b = container "Member B business application" "Submits requests and consumes acknowledged FireFly events." "Example application / REST client" {
                url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                properties {
                    "architecture.id" "apps.b"
                    "evidence" "Reference choice"
                    "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                }
            }
            c = container "Member C business application" "Submits requests and consumes acknowledged FireFly events." "Example application / REST client" {
                url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                properties {
                    "architecture.id" "apps.c"
                    "evidence" "Reference choice"
                    "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                }
            }
        }
        tools = softwareSystem "FireFly developer tools" "Development utilities and optional sample applications." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/doc-site/docs/overview/key_components/tools.md"
            properties {
                "architecture.id" "tools"
                "evidence" "Implementation"
                "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/doc-site/docs/overview/key_components/tools.md"
            }
            !docs docs/system
            !adrs decisions
            cli = container "FireFly CLI" "Creates local stacks and performs development administration." "Go / CLI" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/doc-site/docs/overview/key_components/tools.md"
                properties {
                    "architecture.id" "tools.cli"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/doc-site/docs/overview/key_components/tools.md"
                }
            }
            sandbox = container "FireFly Sandbox" "Provides a sample web app calling a selected member API." "React + Node.js / TypeScript" {
                tags "Optional"
                url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069"
                properties {
                    "architecture.id" "tools.sandbox"
                    "evidence" "Implementation"
                    "source" "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069"
                }
                frontend = component "Sandbox frontend" "Collects sample messages and token actions." "React / TypeScript" {
                    url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069"
                    properties {
                        "architecture.id" "tools.sandbox.frontend"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069"
                    }
                }
                backend = component "Sandbox backend" "Maps UI actions into SDK requests." "Node.js / TypeScript" {
                    url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069"
                    properties {
                        "architecture.id" "tools.sandbox.backend"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069"
                    }
                }
                sdk = component "FireFly Node.js SDK" "Calls the selected API and consumes events." "TypeScript library" {
                    url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069"
                    properties {
                        "architecture.id" "tools.sandbox.sdk"
                        "evidence" "Implementation"
                        "source" "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069"
                    }
                }
            }
        }
        ops = softwareSystem "Platform operations" "Reference ingress, database operations and metrics on AKS." {
            url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            properties {
                "architecture.id" "ops"
                "evidence" "Reference choice"
                "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
            }
            !docs docs/system
            !adrs decisions
            gateway = container "Gateway / ingress" "Routes API traffic; preserves peer mTLS with TLS passthrough." "Envoy Gateway / Kubernetes" {
                tags "Operational"
                url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                properties {
                    "architecture.id" "ops.gateway"
                    "evidence" "Reference choice"
                    "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                }
            }
            cnpg = container "PostgreSQL operator" "Reconciles database roles, endpoints and fenced failover." "CloudNativePG" {
                tags "Operational"
                url "https://cloudnative-pg.io/docs/1.28/replication/"
                properties {
                    "architecture.id" "ops.cnpg"
                    "evidence" "Reference choice"
                    "source" "https://cloudnative-pg.io/docs/1.28/replication/"
                }
            }
            prometheus = container "Metrics collector" "Scrapes runtime metrics and evaluates availability alerts." "Prometheus" {
                tags "Operational"
                url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                properties {
                    "architecture.id" "ops.prometheus"
                    "evidence" "Reference choice"
                    "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                }
            }
            grafana = container "Operations dashboard" "Displays metrics, replication lag and quorum health." "Grafana" {
                tags "Operational"
                url "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                properties {
                    "architecture.id" "ops.grafana"
                    "evidence" "Reference choice"
                    "source" "https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure"
                }
            }
        }
        ethconnect = softwareSystem "EthConnect / Ethereum" "Alternative Ethereum connector; different transaction-management architecture." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/README.md"
            properties {
                "architecture.id" "ethconnect"
                "evidence" "Alternative"
                "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/README.md"
            }
        }
        fabric = softwareSystem "Fabric / FabConnect" "Alternative permissioned-ledger adapter and network." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain/fabric"
            properties {
                "architecture.id" "fabric"
                "evidence" "Alternative"
                "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain/fabric"
            }
        }
        tezos = softwareSystem "Tezos connector / network" "Alternative supported blockchain adapter." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain/tezos"
            properties {
                "architecture.id" "tezos"
                "evidence" "Alternative"
                "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain/tezos"
            }
        }
        cardano = softwareSystem "Cardano connector / network" "Alternative supported blockchain adapter." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain/cardano"
            properties {
                "architecture.id" "cardano"
                "evidence" "Alternative"
                "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/internal/blockchain/cardano"
            }
        }
        corda = softwareSystem "Corda connector starter" "Extension starter requiring CorDapp customization; not turnkey." {
            tags "Optional"
            url "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/README.md"
            properties {
                "architecture.id" "corda"
                "evidence" "Alternative"
                "source" "https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d/README.md"
            }
        }
        r0001 = a.core.explorer -> a.core.api "Queries messages, operations and network state" "In-process calls / Go" "Dataflow"
        r0002 = a.core.api -> a.core.auth "Passes request credentials for authorization" "In-process calls / Go" "Dataflow"
        r0003 = a.core.api -> a.core.namespaces "Resolves the requested namespace" "In-process calls / Go" "Dataflow"
        r0004 = a.core.namespaces -> a.core.orchestrator "Initializes namespace resources and plugins" "In-process calls / Go" "Dataflow"
        r0005 = a.core.api -> a.core.orchestrator "Submits validated commands and queries" "In-process calls / Go" "Dataflow"
        r0006 = a.core.orchestrator -> a.core.syncasync "Waits for asynchronous request completion" "In-process calls / Go" "Dataflow"
        r0007 = a.core.orchestrator -> a.core.identity "Resolves signing identities" "In-process calls / Go" "Dataflow"
        r0008 = a.core.identity -> a.core.identityplugin "Resolves configured identity claims" "In-process calls / Go" "Dataflow"
        r0009 = a.core.identity -> a.core.networkmap "Looks up members and node endpoints" "In-process calls / Go" "Dataflow"
        r0010 = a.core.networkmap -> a.core.definitions "Registers shared member definitions" "In-process calls / Go" "Dataflow"
        r0011 = a.core.definitions -> a.core.broadcast "Publishes network definitions" "In-process calls / Go" "Dataflow"
        r0012 = a.core.orchestrator -> a.core.multiparty "Submits consortium network actions" "In-process calls / Go" "Dataflow"
        r0013 = a.core.multiparty -> a.core.blockchain "Submits contract pinning transactions" "In-process calls / Go" "Dataflow"
        r0014 = a.core.orchestrator -> a.core.data "Submits payloads and datatype definitions" "In-process calls / Go" "Dataflow"
        r0015 = a.core.data -> a.core.schema "Validates structured payloads" "In-process calls / Go" "Dataflow"
        r0016 = a.core.data -> a.core.database "Persists payload metadata and hashes" "In-process calls / Go" "Dataflow"
        r0017 = a.core.orchestrator -> a.core.batch "Queues outbound messages" "In-process calls / Go" "Dataflow"
        r0018 = a.core.batch -> a.core.batchprocessor "Assigns messages to recoverable batches" "In-process calls / Go" "Dataflow"
        r0019 = a.core.batchprocessor -> a.core.data "Loads payloads for batch assembly" "In-process calls / Go" "Dataflow"
        r0020 = a.core.batchprocessor -> a.core.broadcast "Dispatches broadcast batches" "In-process calls / Go" "Dataflow"
        r0021 = a.core.batchprocessor -> a.core.private "Dispatches recipient-scoped batches" "In-process calls / Go" "Dataflow"
        r0022 = a.core.broadcast -> a.core.sharedstorage "Uploads broadcast payloads" "In-process calls / Go" "Dataflow"
        r0023 = a.core.broadcast -> a.core.multiparty "Pins batch hashes on the ledger" "In-process calls / Go" "Dataflow"
        r0024 = a.core.private -> a.core.dataexchange "Sends private payloads to recipient nodes" "In-process calls / Go" "Dataflow"
        r0025 = a.core.private -> a.core.multiparty "Pins private batch hashes when requested" "In-process calls / Go" "Dataflow"
        r0026 = a.core.private -> a.core.identity "Resolves group recipients and endpoints" "In-process calls / Go" "Dataflow"
        r0027 = a.core.orchestrator -> a.core.contracts "Submits contract queries and invocations" "In-process calls / Go" "Dataflow"
        r0028 = a.core.orchestrator -> a.core.assets "Submits token pool and transfer requests" "In-process calls / Go" "Dataflow"
        r0029 = a.core.contracts -> a.core.blockchain "Submits ABI-backed calls and listeners" "In-process calls / Go" "Dataflow"
        r0030 = a.core.assets -> a.core.tokens "Requests standard token operations" "In-process calls / Go" "Dataflow"
        r0031 = a.core.assets -> a.core.contracts "Resolves token contract interfaces" "In-process calls / Go" "Dataflow"
        r0032 = a.core.contracts -> a.core.operations "Tracks contract operation completion" "In-process calls / Go" "Dataflow"
        r0033 = a.core.assets -> a.core.operations "Tracks token operation completion" "In-process calls / Go" "Dataflow"
        r0034 = a.core.operations -> a.core.txhelper "Correlates operation and transaction identifiers" "In-process calls / Go" "Dataflow"
        r0035 = a.core.txhelper -> a.core.txwriter "Queues transaction records for persistence" "In-process calls / Go" "Dataflow"
        r0036 = a.core.txwriter -> a.core.database "Flushes transaction records" "In-process calls / Go" "Dataflow"
        r0037 = a.core.operations -> a.core.database "Persists operation state and retries" "In-process calls / Go" "Dataflow"
        r0038 = a.core.blockchain -> a.core.aggregator "Delivers confirmed ledger events" "In-process calls / Go" "Dataflow"
        r0039 = a.core.dataexchange -> a.core.aggregator "Delivers received payload notifications" "In-process calls / Go" "Dataflow"
        r0040 = a.core.tokens -> a.core.aggregator "Delivers token creation and transfer events" "In-process calls / Go" "Dataflow"
        r0041 = a.core.aggregator -> a.core.download "Requests missing shared data" "In-process calls / Go" "Dataflow"
        r0042 = a.core.download -> a.core.sharedstorage "Fetches content-addressed batches and blobs" "In-process calls / Go" "Dataflow"
        r0043 = a.core.download -> a.core.data "Validates downloaded data and stores metadata" "In-process calls / Go" "Dataflow"
        r0044 = a.core.aggregator -> a.core.database "Persists sequenced events and message state" "In-process calls / Go" "Dataflow"
        r0045 = a.core.aggregator -> a.core.subscriptions "Publishes locally ordered events" "In-process calls / Go" "Dataflow"
        r0046 = a.core.subscriptions -> a.core.database "Persists subscriptions and acknowledged offsets" "In-process calls / Go" "Dataflow"
        r0047 = a.core.subscriptions -> a.core.dispatcher "Dispatches filtered event batches" "In-process calls / Go" "Dataflow"
        r0048 = a.core.dispatcher -> a.core.eventplugin "Delivers events via configured transports" "In-process calls / Go" "Dataflow"
        r0049 = a.core.dispatcher -> a.core.syncasync "Completes waiting requests" "In-process calls / Go" "Dataflow"
        r0050 = a.core.namespaces -> a.core.spievents "Publishes namespace lifecycle changes" "In-process calls / Go" "Dataflow"
        r0051 = a.core.spievents -> a.core.eventplugin "Publishes system notifications" "In-process calls / Go" "Dataflow"
        r0052 = a.core.data -> a.core.cache "Caches reusable data and schema lookups" "In-process calls / Go" "Dataflow"
        r0053 = a.core.contracts -> a.core.cache "Caches contract definitions" "In-process calls / Go" "Dataflow"
        r0054 = a.core.orchestrator -> a.core.metrics "Records API and subsystem measurements" "In-process calls / Go" "Dataflow"
        r0055 = a.core.operations -> a.core.metrics "Records operation outcomes" "In-process calls / Go" "Dataflow"
        r0056 = a.evm.api -> a.evm.manager "Submits transaction and stream requests" "In-process calls / Go" "Dataflow"
        r0057 = a.evm.manager -> a.evm.handler "Schedules managed transaction processing" "In-process calls / Go" "Dataflow"
        r0058 = a.evm.handler -> a.evm.nonce "Allocates the next sender nonce" "In-process calls / Go" "Dataflow"
        r0059 = a.evm.nonce -> a.evm.persistence "Persists sender transaction ordering" "In-process calls / Go" "Dataflow"
        r0060 = a.evm.handler -> a.evm.abi "Prepares calls and encoded transactions" "In-process calls / Go" "Dataflow"
        r0061 = a.evm.abi -> a.evm.rpc "Issues Ethereum JSON-RPC requests" "In-process calls / Go" "Dataflow"
        r0062 = a.evm.handler -> a.evm.receipts "Tracks submitted transaction receipts" "In-process calls / Go" "Dataflow"
        r0063 = a.evm.receipts -> a.evm.rpc "Queries transaction receipt status" "In-process calls / Go" "Dataflow"
        r0064 = a.evm.rpc -> a.evm.blocks "Returns block and filter responses" "In-process calls / Go" "Dataflow"
        r0065 = a.evm.blocks -> a.evm.confirmations "Publishes chain head updates" "In-process calls / Go" "Dataflow"
        r0066 = a.evm.receipts -> a.evm.confirmations "Submits receipts for confirmation" "In-process calls / Go" "Dataflow"
        r0067 = a.evm.confirmations -> a.evm.streams "Releases confirmed blockchain events" "In-process calls / Go" "Dataflow"
        r0068 = a.evm.manager -> a.evm.streams "Configures listeners and stream lifecycle" "In-process calls / Go" "Dataflow"
        r0069 = a.evm.streams -> a.evm.delivery "Delivers ordered event batches" "In-process calls / Go" "Dataflow"
        r0070 = a.evm.delivery -> a.evm.streams "Acknowledges consumed batches" "In-process calls / Go" "Dataflow"
        r0071 = a.evm.streams -> a.evm.persistence "Persists acknowledged checkpoints" "In-process calls / Go" "Dataflow"
        r0072 = a.evm.manager -> a.evm.persistence "Persists transaction lifecycle state" "In-process calls / Go" "Dataflow"
        r0073 = a.signer.proxy -> a.signer.wallet "Resolves requested signing accounts" "In-process calls / Go" "Dataflow"
        r0074 = a.signer.wallet -> a.signer.keystore "Decrypts selected key material" "In-process calls / Go" "Dataflow"
        r0075 = a.signer.proxy -> a.signer.signing "Submits transactions for signing" "In-process calls / Go" "Dataflow"
        r0076 = a.signer.signing -> a.signer.wallet "Retrieves the selected signing key" "In-process calls / Go" "Dataflow"
        r0077 = a.signer.signing -> a.signer.backend "Submits signed raw transactions" "In-process calls / Go" "Dataflow"
        r0078 = a.signer.proxy -> a.signer.backend "Forwards unmodified RPC read requests" "In-process calls / Go" "Dataflow"
        r0079 = a.dx.api -> a.dx.peers "Updates peer endpoints and certificates" "In-process calls / TypeScript" "Dataflow"
        r0080 = a.dx.api -> a.dx.messages "Submits recipient-scoped messages" "In-process calls / TypeScript" "Dataflow"
        r0081 = a.dx.api -> a.dx.blobs "Uploads private binary content" "In-process calls / TypeScript" "Dataflow"
        r0082 = a.dx.messages -> a.dx.peers "Resolves destination and trust material" "In-process calls / TypeScript" "Dataflow"
        r0083 = a.dx.messages -> a.dx.p2p "Transfers private message envelopes" "In-process calls / TypeScript" "Dataflow"
        r0084 = a.dx.blobs -> a.dx.p2p "Transfers encrypted blob streams" "In-process calls / TypeScript" "Dataflow"
        r0085 = a.dx.p2p -> a.dx.messages "Delivers authenticated inbound messages" "In-process calls / TypeScript" "Dataflow"
        r0086 = a.dx.p2p -> a.dx.blobs "Stores authenticated inbound blobs" "In-process calls / TypeScript" "Dataflow"
        r0087 = a.dx.messages -> a.dx.events "Enqueues message delivery results" "In-process calls / TypeScript" "Dataflow"
        r0088 = a.dx.blobs -> a.dx.events "Enqueues blob delivery results" "In-process calls / TypeScript" "Dataflow"
        r0089 = a.dx.events -> a.dx.api "Delivers notifications and receives acknowledgements" "In-process calls / TypeScript" "Dataflow"
        r0090 = a.erc20.api -> a.erc20.service "Submits standard token operations" "In-process calls / TypeScript" "Dataflow"
        r0091 = a.erc20.service -> a.erc20.mapper "Encodes token contract calls" "In-process calls / TypeScript" "Dataflow"
        r0092 = a.erc20.mapper -> a.erc20.blockchain "Passes encoded contract requests" "In-process calls / TypeScript" "Dataflow"
        r0093 = a.erc20.blockchain -> a.erc20.stream "Registers contract event listeners" "In-process calls / TypeScript" "Dataflow"
        r0094 = a.erc20.stream -> a.erc20.listener "Delivers token contract logs" "In-process calls / TypeScript" "Dataflow"
        r0095 = a.erc20.listener -> a.erc20.service "Updates token pool state" "In-process calls / TypeScript" "Dataflow"
        r0096 = a.erc20.listener -> a.erc20.proxy "Publishes normalized token events" "In-process calls / TypeScript" "Dataflow"
        r0097 = a.erc20.proxy -> a.erc20.stream "Acknowledges consumed event batches" "In-process calls / TypeScript" "Dataflow"
        r0098 = a.erc1155.api -> a.erc1155.service "Submits standard token operations" "In-process calls / TypeScript" "Dataflow"
        r0099 = a.erc1155.service -> a.erc1155.mapper "Encodes token contract calls" "In-process calls / TypeScript" "Dataflow"
        r0100 = a.erc1155.mapper -> a.erc1155.blockchain "Passes encoded contract requests" "In-process calls / TypeScript" "Dataflow"
        r0101 = a.erc1155.blockchain -> a.erc1155.stream "Registers contract event listeners" "In-process calls / TypeScript" "Dataflow"
        r0102 = a.erc1155.stream -> a.erc1155.listener "Delivers token contract logs" "In-process calls / TypeScript" "Dataflow"
        r0103 = a.erc1155.listener -> a.erc1155.service "Updates token pool state" "In-process calls / TypeScript" "Dataflow"
        r0104 = a.erc1155.listener -> a.erc1155.proxy "Publishes normalized token events" "In-process calls / TypeScript" "Dataflow"
        r0105 = a.erc1155.proxy -> a.erc1155.stream "Acknowledges consumed event batches" "In-process calls / TypeScript" "Dataflow"
        r0106 = a.core -> a.evm "Submits contract calls, pins and listeners" "HTTP REST / JSON" "Dataflow"
        r0107 = a.evm -> a.core "Streams confirmed events and transaction results" "WebSocket / JSON" "Dataflow"
        r0108 = a.core -> a.dx "Submits private messages, blobs and peer configuration" "HTTP REST / JSON + binary" "Dataflow"
        r0109 = a.dx -> a.core "Delivers transfer notifications and awaits ACKs" "WebSocket / JSON" "Dataflow"
        r0110 = a.core -> a.erc20 "Submits ERC-20 and ERC-721 operations" "HTTP REST / JSON" "Dataflow"
        r0111 = a.core -> a.erc1155 "Submits ERC-1155 operations" "HTTP REST / JSON" "Dataflow"
        r0112 = a.erc20 -> a.core "Delivers normalized token events" "WebSocket / JSON" "Dataflow"
        r0113 = a.erc1155 -> a.core "Delivers normalized token events" "WebSocket / JSON" "Dataflow"
        r0114 = a.erc20 -> a.evm "Submits contract calls and consumes event streams" "HTTP REST + WebSocket" "Dataflow"
        r0115 = a.erc1155 -> a.evm "Submits contract calls and consumes event streams" "HTTP REST + WebSocket" "Dataflow"
        r0116 = a.evm -> a.signer "Submits Ethereum calls and unsigned transactions" "HTTP JSON-RPC" "Dataflow"
        r0117 = a.core -> a.pg "Reads and writes the private Core database" "PostgreSQL wire / TLS" "Dataflow"
        r0118 = a.evm -> a.pg "Reads and writes the separate FFTM database" "PostgreSQL wire / TLS" "Dataflow"
        r0119 = a.pg -> a.pgReplica "Streams WAL and awaits one synchronous standby" "PostgreSQL replication / TLS" "Dataflow"
        r0120 = a.core -> a.ipfs "Adds shared content and retrieves CIDs" "IPFS HTTP RPC / gateway" "Dataflow"
        r0121 = a.dx -> a.blobs "Reads and writes private blobs and peer records" "Filesystem I/O" "Dataflow"
        r0122 = a.ipfs -> a.ipfsRepo "Reads and writes Kubo keys, pins and blocks" "Filesystem I/O" "Dataflow"
        r0123 = a.signer -> a.secrets "Loads member signing keystore files" "Read-only projected files" "Dataflow"
        r0124 = a.dx -> a.secrets "Loads member mTLS certificate and key" "Read-only projected files" "Dataflow"
        r0125 = a.core -> a.secrets "Loads namespace and plugin configuration" "Read-only projected files" "Dataflow"
        r0126 = a.evm -> a.secrets "Loads connector endpoints and credentials" "Read-only projected files" "Dataflow"
        r0127 = a.core.blockchain -> a.evm "Submits blockchain operations" "HTTP REST / JSON" "Dataflow"
        r0128 = a.evm.delivery -> a.core "Delivers confirmed event batches" "WebSocket / JSON" "Dataflow"
        r0129 = a.core.database -> a.pg "Persists Core resources and offsets" "PostgreSQL wire / TLS" "Dataflow"
        r0130 = a.core.dataexchange -> a.dx "Exchanges private data and notifications" "HTTP + WebSocket" "Dataflow"
        r0131 = a.core.sharedstorage -> a.ipfs "Publishes and retrieves CIDs" "IPFS HTTP RPC" "Dataflow"
        r0132 = a.core.tokens -> a.erc20 "Submits ERC-20 and ERC-721 operations" "HTTP REST / JSON" "Dataflow"
        r0133 = a.core.tokens -> a.erc1155 "Submits ERC-1155 operations" "HTTP REST / JSON" "Dataflow"
        r0134 = a.evm.persistence -> a.pg "Persists FFTM transactions and checkpoints" "PostgreSQL wire / TLS" "Dataflow"
        r0135 = a.evm.rpc -> a.signer "Forwards transactions and read calls" "HTTP JSON-RPC" "Dataflow"
        r0136 = a.signer.wallet -> a.secrets "Loads encrypted account keystores" "Read-only projected files" "Dataflow"
        r0137 = a.dx.blobs -> a.blobs "Stores durable private blobs" "Filesystem I/O" "Dataflow"
        r0138 = a.dx.peers -> a.blobs "Persists endpoints and peer certificates" "Filesystem I/O" "Dataflow"
        r0139 = a.dx.p2p -> a.secrets "Loads the member mTLS identity" "Read-only projected files" "Dataflow"
        r0140 = a.erc20.blockchain -> a.evm "Submits contract calls and listeners" "HTTP REST / JSON" "Dataflow"
        r0141 = a.evm -> a.erc20.stream "Streams confirmed token logs" "WebSocket / JSON" "Dataflow"
        r0142 = a.erc20.proxy -> a.core "Delivers token events and receives ACKs" "WebSocket / JSON" "Dataflow"
        r0143 = a.erc1155.blockchain -> a.evm "Submits contract calls and listeners" "HTTP REST / JSON" "Dataflow"
        r0144 = a.evm -> a.erc1155.stream "Streams confirmed token logs" "WebSocket / JSON" "Dataflow"
        r0145 = a.erc1155.proxy -> a.core "Delivers token events and receives ACKs" "WebSocket / JSON" "Dataflow"
        r0146 = b.core.explorer -> b.core.api "Queries messages, operations and network state" "In-process calls / Go" "Dataflow"
        r0147 = b.core.api -> b.core.auth "Passes request credentials for authorization" "In-process calls / Go" "Dataflow"
        r0148 = b.core.api -> b.core.namespaces "Resolves the requested namespace" "In-process calls / Go" "Dataflow"
        r0149 = b.core.namespaces -> b.core.orchestrator "Initializes namespace resources and plugins" "In-process calls / Go" "Dataflow"
        r0150 = b.core.api -> b.core.orchestrator "Submits validated commands and queries" "In-process calls / Go" "Dataflow"
        r0151 = b.core.orchestrator -> b.core.syncasync "Waits for asynchronous request completion" "In-process calls / Go" "Dataflow"
        r0152 = b.core.orchestrator -> b.core.identity "Resolves signing identities" "In-process calls / Go" "Dataflow"
        r0153 = b.core.identity -> b.core.identityplugin "Resolves configured identity claims" "In-process calls / Go" "Dataflow"
        r0154 = b.core.identity -> b.core.networkmap "Looks up members and node endpoints" "In-process calls / Go" "Dataflow"
        r0155 = b.core.networkmap -> b.core.definitions "Registers shared member definitions" "In-process calls / Go" "Dataflow"
        r0156 = b.core.definitions -> b.core.broadcast "Publishes network definitions" "In-process calls / Go" "Dataflow"
        r0157 = b.core.orchestrator -> b.core.multiparty "Submits consortium network actions" "In-process calls / Go" "Dataflow"
        r0158 = b.core.multiparty -> b.core.blockchain "Submits contract pinning transactions" "In-process calls / Go" "Dataflow"
        r0159 = b.core.orchestrator -> b.core.data "Submits payloads and datatype definitions" "In-process calls / Go" "Dataflow"
        r0160 = b.core.data -> b.core.schema "Validates structured payloads" "In-process calls / Go" "Dataflow"
        r0161 = b.core.data -> b.core.database "Persists payload metadata and hashes" "In-process calls / Go" "Dataflow"
        r0162 = b.core.orchestrator -> b.core.batch "Queues outbound messages" "In-process calls / Go" "Dataflow"
        r0163 = b.core.batch -> b.core.batchprocessor "Assigns messages to recoverable batches" "In-process calls / Go" "Dataflow"
        r0164 = b.core.batchprocessor -> b.core.data "Loads payloads for batch assembly" "In-process calls / Go" "Dataflow"
        r0165 = b.core.batchprocessor -> b.core.broadcast "Dispatches broadcast batches" "In-process calls / Go" "Dataflow"
        r0166 = b.core.batchprocessor -> b.core.private "Dispatches recipient-scoped batches" "In-process calls / Go" "Dataflow"
        r0167 = b.core.broadcast -> b.core.sharedstorage "Uploads broadcast payloads" "In-process calls / Go" "Dataflow"
        r0168 = b.core.broadcast -> b.core.multiparty "Pins batch hashes on the ledger" "In-process calls / Go" "Dataflow"
        r0169 = b.core.private -> b.core.dataexchange "Sends private payloads to recipient nodes" "In-process calls / Go" "Dataflow"
        r0170 = b.core.private -> b.core.multiparty "Pins private batch hashes when requested" "In-process calls / Go" "Dataflow"
        r0171 = b.core.private -> b.core.identity "Resolves group recipients and endpoints" "In-process calls / Go" "Dataflow"
        r0172 = b.core.orchestrator -> b.core.contracts "Submits contract queries and invocations" "In-process calls / Go" "Dataflow"
        r0173 = b.core.orchestrator -> b.core.assets "Submits token pool and transfer requests" "In-process calls / Go" "Dataflow"
        r0174 = b.core.contracts -> b.core.blockchain "Submits ABI-backed calls and listeners" "In-process calls / Go" "Dataflow"
        r0175 = b.core.assets -> b.core.tokens "Requests standard token operations" "In-process calls / Go" "Dataflow"
        r0176 = b.core.assets -> b.core.contracts "Resolves token contract interfaces" "In-process calls / Go" "Dataflow"
        r0177 = b.core.contracts -> b.core.operations "Tracks contract operation completion" "In-process calls / Go" "Dataflow"
        r0178 = b.core.assets -> b.core.operations "Tracks token operation completion" "In-process calls / Go" "Dataflow"
        r0179 = b.core.operations -> b.core.txhelper "Correlates operation and transaction identifiers" "In-process calls / Go" "Dataflow"
        r0180 = b.core.txhelper -> b.core.txwriter "Queues transaction records for persistence" "In-process calls / Go" "Dataflow"
        r0181 = b.core.txwriter -> b.core.database "Flushes transaction records" "In-process calls / Go" "Dataflow"
        r0182 = b.core.operations -> b.core.database "Persists operation state and retries" "In-process calls / Go" "Dataflow"
        r0183 = b.core.blockchain -> b.core.aggregator "Delivers confirmed ledger events" "In-process calls / Go" "Dataflow"
        r0184 = b.core.dataexchange -> b.core.aggregator "Delivers received payload notifications" "In-process calls / Go" "Dataflow"
        r0185 = b.core.tokens -> b.core.aggregator "Delivers token creation and transfer events" "In-process calls / Go" "Dataflow"
        r0186 = b.core.aggregator -> b.core.download "Requests missing shared data" "In-process calls / Go" "Dataflow"
        r0187 = b.core.download -> b.core.sharedstorage "Fetches content-addressed batches and blobs" "In-process calls / Go" "Dataflow"
        r0188 = b.core.download -> b.core.data "Validates downloaded data and stores metadata" "In-process calls / Go" "Dataflow"
        r0189 = b.core.aggregator -> b.core.database "Persists sequenced events and message state" "In-process calls / Go" "Dataflow"
        r0190 = b.core.aggregator -> b.core.subscriptions "Publishes locally ordered events" "In-process calls / Go" "Dataflow"
        r0191 = b.core.subscriptions -> b.core.database "Persists subscriptions and acknowledged offsets" "In-process calls / Go" "Dataflow"
        r0192 = b.core.subscriptions -> b.core.dispatcher "Dispatches filtered event batches" "In-process calls / Go" "Dataflow"
        r0193 = b.core.dispatcher -> b.core.eventplugin "Delivers events via configured transports" "In-process calls / Go" "Dataflow"
        r0194 = b.core.dispatcher -> b.core.syncasync "Completes waiting requests" "In-process calls / Go" "Dataflow"
        r0195 = b.core.namespaces -> b.core.spievents "Publishes namespace lifecycle changes" "In-process calls / Go" "Dataflow"
        r0196 = b.core.spievents -> b.core.eventplugin "Publishes system notifications" "In-process calls / Go" "Dataflow"
        r0197 = b.core.data -> b.core.cache "Caches reusable data and schema lookups" "In-process calls / Go" "Dataflow"
        r0198 = b.core.contracts -> b.core.cache "Caches contract definitions" "In-process calls / Go" "Dataflow"
        r0199 = b.core.orchestrator -> b.core.metrics "Records API and subsystem measurements" "In-process calls / Go" "Dataflow"
        r0200 = b.core.operations -> b.core.metrics "Records operation outcomes" "In-process calls / Go" "Dataflow"
        r0201 = b.evm.api -> b.evm.manager "Submits transaction and stream requests" "In-process calls / Go" "Dataflow"
        r0202 = b.evm.manager -> b.evm.handler "Schedules managed transaction processing" "In-process calls / Go" "Dataflow"
        r0203 = b.evm.handler -> b.evm.nonce "Allocates the next sender nonce" "In-process calls / Go" "Dataflow"
        r0204 = b.evm.nonce -> b.evm.persistence "Persists sender transaction ordering" "In-process calls / Go" "Dataflow"
        r0205 = b.evm.handler -> b.evm.abi "Prepares calls and encoded transactions" "In-process calls / Go" "Dataflow"
        r0206 = b.evm.abi -> b.evm.rpc "Issues Ethereum JSON-RPC requests" "In-process calls / Go" "Dataflow"
        r0207 = b.evm.handler -> b.evm.receipts "Tracks submitted transaction receipts" "In-process calls / Go" "Dataflow"
        r0208 = b.evm.receipts -> b.evm.rpc "Queries transaction receipt status" "In-process calls / Go" "Dataflow"
        r0209 = b.evm.rpc -> b.evm.blocks "Returns block and filter responses" "In-process calls / Go" "Dataflow"
        r0210 = b.evm.blocks -> b.evm.confirmations "Publishes chain head updates" "In-process calls / Go" "Dataflow"
        r0211 = b.evm.receipts -> b.evm.confirmations "Submits receipts for confirmation" "In-process calls / Go" "Dataflow"
        r0212 = b.evm.confirmations -> b.evm.streams "Releases confirmed blockchain events" "In-process calls / Go" "Dataflow"
        r0213 = b.evm.manager -> b.evm.streams "Configures listeners and stream lifecycle" "In-process calls / Go" "Dataflow"
        r0214 = b.evm.streams -> b.evm.delivery "Delivers ordered event batches" "In-process calls / Go" "Dataflow"
        r0215 = b.evm.delivery -> b.evm.streams "Acknowledges consumed batches" "In-process calls / Go" "Dataflow"
        r0216 = b.evm.streams -> b.evm.persistence "Persists acknowledged checkpoints" "In-process calls / Go" "Dataflow"
        r0217 = b.evm.manager -> b.evm.persistence "Persists transaction lifecycle state" "In-process calls / Go" "Dataflow"
        r0218 = b.signer.proxy -> b.signer.wallet "Resolves requested signing accounts" "In-process calls / Go" "Dataflow"
        r0219 = b.signer.wallet -> b.signer.keystore "Decrypts selected key material" "In-process calls / Go" "Dataflow"
        r0220 = b.signer.proxy -> b.signer.signing "Submits transactions for signing" "In-process calls / Go" "Dataflow"
        r0221 = b.signer.signing -> b.signer.wallet "Retrieves the selected signing key" "In-process calls / Go" "Dataflow"
        r0222 = b.signer.signing -> b.signer.backend "Submits signed raw transactions" "In-process calls / Go" "Dataflow"
        r0223 = b.signer.proxy -> b.signer.backend "Forwards unmodified RPC read requests" "In-process calls / Go" "Dataflow"
        r0224 = b.dx.api -> b.dx.peers "Updates peer endpoints and certificates" "In-process calls / TypeScript" "Dataflow"
        r0225 = b.dx.api -> b.dx.messages "Submits recipient-scoped messages" "In-process calls / TypeScript" "Dataflow"
        r0226 = b.dx.api -> b.dx.blobs "Uploads private binary content" "In-process calls / TypeScript" "Dataflow"
        r0227 = b.dx.messages -> b.dx.peers "Resolves destination and trust material" "In-process calls / TypeScript" "Dataflow"
        r0228 = b.dx.messages -> b.dx.p2p "Transfers private message envelopes" "In-process calls / TypeScript" "Dataflow"
        r0229 = b.dx.blobs -> b.dx.p2p "Transfers encrypted blob streams" "In-process calls / TypeScript" "Dataflow"
        r0230 = b.dx.p2p -> b.dx.messages "Delivers authenticated inbound messages" "In-process calls / TypeScript" "Dataflow"
        r0231 = b.dx.p2p -> b.dx.blobs "Stores authenticated inbound blobs" "In-process calls / TypeScript" "Dataflow"
        r0232 = b.dx.messages -> b.dx.events "Enqueues message delivery results" "In-process calls / TypeScript" "Dataflow"
        r0233 = b.dx.blobs -> b.dx.events "Enqueues blob delivery results" "In-process calls / TypeScript" "Dataflow"
        r0234 = b.dx.events -> b.dx.api "Delivers notifications and receives acknowledgements" "In-process calls / TypeScript" "Dataflow"
        r0235 = b.erc20.api -> b.erc20.service "Submits standard token operations" "In-process calls / TypeScript" "Dataflow"
        r0236 = b.erc20.service -> b.erc20.mapper "Encodes token contract calls" "In-process calls / TypeScript" "Dataflow"
        r0237 = b.erc20.mapper -> b.erc20.blockchain "Passes encoded contract requests" "In-process calls / TypeScript" "Dataflow"
        r0238 = b.erc20.blockchain -> b.erc20.stream "Registers contract event listeners" "In-process calls / TypeScript" "Dataflow"
        r0239 = b.erc20.stream -> b.erc20.listener "Delivers token contract logs" "In-process calls / TypeScript" "Dataflow"
        r0240 = b.erc20.listener -> b.erc20.service "Updates token pool state" "In-process calls / TypeScript" "Dataflow"
        r0241 = b.erc20.listener -> b.erc20.proxy "Publishes normalized token events" "In-process calls / TypeScript" "Dataflow"
        r0242 = b.erc20.proxy -> b.erc20.stream "Acknowledges consumed event batches" "In-process calls / TypeScript" "Dataflow"
        r0243 = b.erc1155.api -> b.erc1155.service "Submits standard token operations" "In-process calls / TypeScript" "Dataflow"
        r0244 = b.erc1155.service -> b.erc1155.mapper "Encodes token contract calls" "In-process calls / TypeScript" "Dataflow"
        r0245 = b.erc1155.mapper -> b.erc1155.blockchain "Passes encoded contract requests" "In-process calls / TypeScript" "Dataflow"
        r0246 = b.erc1155.blockchain -> b.erc1155.stream "Registers contract event listeners" "In-process calls / TypeScript" "Dataflow"
        r0247 = b.erc1155.stream -> b.erc1155.listener "Delivers token contract logs" "In-process calls / TypeScript" "Dataflow"
        r0248 = b.erc1155.listener -> b.erc1155.service "Updates token pool state" "In-process calls / TypeScript" "Dataflow"
        r0249 = b.erc1155.listener -> b.erc1155.proxy "Publishes normalized token events" "In-process calls / TypeScript" "Dataflow"
        r0250 = b.erc1155.proxy -> b.erc1155.stream "Acknowledges consumed event batches" "In-process calls / TypeScript" "Dataflow"
        r0251 = b.core -> b.evm "Submits contract calls, pins and listeners" "HTTP REST / JSON" "Dataflow"
        r0252 = b.evm -> b.core "Streams confirmed events and transaction results" "WebSocket / JSON" "Dataflow"
        r0253 = b.core -> b.dx "Submits private messages, blobs and peer configuration" "HTTP REST / JSON + binary" "Dataflow"
        r0254 = b.dx -> b.core "Delivers transfer notifications and awaits ACKs" "WebSocket / JSON" "Dataflow"
        r0255 = b.core -> b.erc20 "Submits ERC-20 and ERC-721 operations" "HTTP REST / JSON" "Dataflow"
        r0256 = b.core -> b.erc1155 "Submits ERC-1155 operations" "HTTP REST / JSON" "Dataflow"
        r0257 = b.erc20 -> b.core "Delivers normalized token events" "WebSocket / JSON" "Dataflow"
        r0258 = b.erc1155 -> b.core "Delivers normalized token events" "WebSocket / JSON" "Dataflow"
        r0259 = b.erc20 -> b.evm "Submits contract calls and consumes event streams" "HTTP REST + WebSocket" "Dataflow"
        r0260 = b.erc1155 -> b.evm "Submits contract calls and consumes event streams" "HTTP REST + WebSocket" "Dataflow"
        r0261 = b.evm -> b.signer "Submits Ethereum calls and unsigned transactions" "HTTP JSON-RPC" "Dataflow"
        r0262 = b.core -> b.pg "Reads and writes the private Core database" "PostgreSQL wire / TLS" "Dataflow"
        r0263 = b.evm -> b.pg "Reads and writes the separate FFTM database" "PostgreSQL wire / TLS" "Dataflow"
        r0264 = b.pg -> b.pgReplica "Streams WAL and awaits one synchronous standby" "PostgreSQL replication / TLS" "Dataflow"
        r0265 = b.core -> b.ipfs "Adds shared content and retrieves CIDs" "IPFS HTTP RPC / gateway" "Dataflow"
        r0266 = b.dx -> b.blobs "Reads and writes private blobs and peer records" "Filesystem I/O" "Dataflow"
        r0267 = b.ipfs -> b.ipfsRepo "Reads and writes Kubo keys, pins and blocks" "Filesystem I/O" "Dataflow"
        r0268 = b.signer -> b.secrets "Loads member signing keystore files" "Read-only projected files" "Dataflow"
        r0269 = b.dx -> b.secrets "Loads member mTLS certificate and key" "Read-only projected files" "Dataflow"
        r0270 = b.core -> b.secrets "Loads namespace and plugin configuration" "Read-only projected files" "Dataflow"
        r0271 = b.evm -> b.secrets "Loads connector endpoints and credentials" "Read-only projected files" "Dataflow"
        r0272 = b.core.blockchain -> b.evm "Submits blockchain operations" "HTTP REST / JSON" "Dataflow"
        r0273 = b.evm.delivery -> b.core "Delivers confirmed event batches" "WebSocket / JSON" "Dataflow"
        r0274 = b.core.database -> b.pg "Persists Core resources and offsets" "PostgreSQL wire / TLS" "Dataflow"
        r0275 = b.core.dataexchange -> b.dx "Exchanges private data and notifications" "HTTP + WebSocket" "Dataflow"
        r0276 = b.core.sharedstorage -> b.ipfs "Publishes and retrieves CIDs" "IPFS HTTP RPC" "Dataflow"
        r0277 = b.core.tokens -> b.erc20 "Submits ERC-20 and ERC-721 operations" "HTTP REST / JSON" "Dataflow"
        r0278 = b.core.tokens -> b.erc1155 "Submits ERC-1155 operations" "HTTP REST / JSON" "Dataflow"
        r0279 = b.evm.persistence -> b.pg "Persists FFTM transactions and checkpoints" "PostgreSQL wire / TLS" "Dataflow"
        r0280 = b.evm.rpc -> b.signer "Forwards transactions and read calls" "HTTP JSON-RPC" "Dataflow"
        r0281 = b.signer.wallet -> b.secrets "Loads encrypted account keystores" "Read-only projected files" "Dataflow"
        r0282 = b.dx.blobs -> b.blobs "Stores durable private blobs" "Filesystem I/O" "Dataflow"
        r0283 = b.dx.peers -> b.blobs "Persists endpoints and peer certificates" "Filesystem I/O" "Dataflow"
        r0284 = b.dx.p2p -> b.secrets "Loads the member mTLS identity" "Read-only projected files" "Dataflow"
        r0285 = b.erc20.blockchain -> b.evm "Submits contract calls and listeners" "HTTP REST / JSON" "Dataflow"
        r0286 = b.evm -> b.erc20.stream "Streams confirmed token logs" "WebSocket / JSON" "Dataflow"
        r0287 = b.erc20.proxy -> b.core "Delivers token events and receives ACKs" "WebSocket / JSON" "Dataflow"
        r0288 = b.erc1155.blockchain -> b.evm "Submits contract calls and listeners" "HTTP REST / JSON" "Dataflow"
        r0289 = b.evm -> b.erc1155.stream "Streams confirmed token logs" "WebSocket / JSON" "Dataflow"
        r0290 = b.erc1155.proxy -> b.core "Delivers token events and receives ACKs" "WebSocket / JSON" "Dataflow"
        r0291 = c.core.explorer -> c.core.api "Queries messages, operations and network state" "In-process calls / Go" "Dataflow"
        r0292 = c.core.api -> c.core.auth "Passes request credentials for authorization" "In-process calls / Go" "Dataflow"
        r0293 = c.core.api -> c.core.namespaces "Resolves the requested namespace" "In-process calls / Go" "Dataflow"
        r0294 = c.core.namespaces -> c.core.orchestrator "Initializes namespace resources and plugins" "In-process calls / Go" "Dataflow"
        r0295 = c.core.api -> c.core.orchestrator "Submits validated commands and queries" "In-process calls / Go" "Dataflow"
        r0296 = c.core.orchestrator -> c.core.syncasync "Waits for asynchronous request completion" "In-process calls / Go" "Dataflow"
        r0297 = c.core.orchestrator -> c.core.identity "Resolves signing identities" "In-process calls / Go" "Dataflow"
        r0298 = c.core.identity -> c.core.identityplugin "Resolves configured identity claims" "In-process calls / Go" "Dataflow"
        r0299 = c.core.identity -> c.core.networkmap "Looks up members and node endpoints" "In-process calls / Go" "Dataflow"
        r0300 = c.core.networkmap -> c.core.definitions "Registers shared member definitions" "In-process calls / Go" "Dataflow"
        r0301 = c.core.definitions -> c.core.broadcast "Publishes network definitions" "In-process calls / Go" "Dataflow"
        r0302 = c.core.orchestrator -> c.core.multiparty "Submits consortium network actions" "In-process calls / Go" "Dataflow"
        r0303 = c.core.multiparty -> c.core.blockchain "Submits contract pinning transactions" "In-process calls / Go" "Dataflow"
        r0304 = c.core.orchestrator -> c.core.data "Submits payloads and datatype definitions" "In-process calls / Go" "Dataflow"
        r0305 = c.core.data -> c.core.schema "Validates structured payloads" "In-process calls / Go" "Dataflow"
        r0306 = c.core.data -> c.core.database "Persists payload metadata and hashes" "In-process calls / Go" "Dataflow"
        r0307 = c.core.orchestrator -> c.core.batch "Queues outbound messages" "In-process calls / Go" "Dataflow"
        r0308 = c.core.batch -> c.core.batchprocessor "Assigns messages to recoverable batches" "In-process calls / Go" "Dataflow"
        r0309 = c.core.batchprocessor -> c.core.data "Loads payloads for batch assembly" "In-process calls / Go" "Dataflow"
        r0310 = c.core.batchprocessor -> c.core.broadcast "Dispatches broadcast batches" "In-process calls / Go" "Dataflow"
        r0311 = c.core.batchprocessor -> c.core.private "Dispatches recipient-scoped batches" "In-process calls / Go" "Dataflow"
        r0312 = c.core.broadcast -> c.core.sharedstorage "Uploads broadcast payloads" "In-process calls / Go" "Dataflow"
        r0313 = c.core.broadcast -> c.core.multiparty "Pins batch hashes on the ledger" "In-process calls / Go" "Dataflow"
        r0314 = c.core.private -> c.core.dataexchange "Sends private payloads to recipient nodes" "In-process calls / Go" "Dataflow"
        r0315 = c.core.private -> c.core.multiparty "Pins private batch hashes when requested" "In-process calls / Go" "Dataflow"
        r0316 = c.core.private -> c.core.identity "Resolves group recipients and endpoints" "In-process calls / Go" "Dataflow"
        r0317 = c.core.orchestrator -> c.core.contracts "Submits contract queries and invocations" "In-process calls / Go" "Dataflow"
        r0318 = c.core.orchestrator -> c.core.assets "Submits token pool and transfer requests" "In-process calls / Go" "Dataflow"
        r0319 = c.core.contracts -> c.core.blockchain "Submits ABI-backed calls and listeners" "In-process calls / Go" "Dataflow"
        r0320 = c.core.assets -> c.core.tokens "Requests standard token operations" "In-process calls / Go" "Dataflow"
        r0321 = c.core.assets -> c.core.contracts "Resolves token contract interfaces" "In-process calls / Go" "Dataflow"
        r0322 = c.core.contracts -> c.core.operations "Tracks contract operation completion" "In-process calls / Go" "Dataflow"
        r0323 = c.core.assets -> c.core.operations "Tracks token operation completion" "In-process calls / Go" "Dataflow"
        r0324 = c.core.operations -> c.core.txhelper "Correlates operation and transaction identifiers" "In-process calls / Go" "Dataflow"
        r0325 = c.core.txhelper -> c.core.txwriter "Queues transaction records for persistence" "In-process calls / Go" "Dataflow"
        r0326 = c.core.txwriter -> c.core.database "Flushes transaction records" "In-process calls / Go" "Dataflow"
        r0327 = c.core.operations -> c.core.database "Persists operation state and retries" "In-process calls / Go" "Dataflow"
        r0328 = c.core.blockchain -> c.core.aggregator "Delivers confirmed ledger events" "In-process calls / Go" "Dataflow"
        r0329 = c.core.dataexchange -> c.core.aggregator "Delivers received payload notifications" "In-process calls / Go" "Dataflow"
        r0330 = c.core.tokens -> c.core.aggregator "Delivers token creation and transfer events" "In-process calls / Go" "Dataflow"
        r0331 = c.core.aggregator -> c.core.download "Requests missing shared data" "In-process calls / Go" "Dataflow"
        r0332 = c.core.download -> c.core.sharedstorage "Fetches content-addressed batches and blobs" "In-process calls / Go" "Dataflow"
        r0333 = c.core.download -> c.core.data "Validates downloaded data and stores metadata" "In-process calls / Go" "Dataflow"
        r0334 = c.core.aggregator -> c.core.database "Persists sequenced events and message state" "In-process calls / Go" "Dataflow"
        r0335 = c.core.aggregator -> c.core.subscriptions "Publishes locally ordered events" "In-process calls / Go" "Dataflow"
        r0336 = c.core.subscriptions -> c.core.database "Persists subscriptions and acknowledged offsets" "In-process calls / Go" "Dataflow"
        r0337 = c.core.subscriptions -> c.core.dispatcher "Dispatches filtered event batches" "In-process calls / Go" "Dataflow"
        r0338 = c.core.dispatcher -> c.core.eventplugin "Delivers events via configured transports" "In-process calls / Go" "Dataflow"
        r0339 = c.core.dispatcher -> c.core.syncasync "Completes waiting requests" "In-process calls / Go" "Dataflow"
        r0340 = c.core.namespaces -> c.core.spievents "Publishes namespace lifecycle changes" "In-process calls / Go" "Dataflow"
        r0341 = c.core.spievents -> c.core.eventplugin "Publishes system notifications" "In-process calls / Go" "Dataflow"
        r0342 = c.core.data -> c.core.cache "Caches reusable data and schema lookups" "In-process calls / Go" "Dataflow"
        r0343 = c.core.contracts -> c.core.cache "Caches contract definitions" "In-process calls / Go" "Dataflow"
        r0344 = c.core.orchestrator -> c.core.metrics "Records API and subsystem measurements" "In-process calls / Go" "Dataflow"
        r0345 = c.core.operations -> c.core.metrics "Records operation outcomes" "In-process calls / Go" "Dataflow"
        r0346 = c.evm.api -> c.evm.manager "Submits transaction and stream requests" "In-process calls / Go" "Dataflow"
        r0347 = c.evm.manager -> c.evm.handler "Schedules managed transaction processing" "In-process calls / Go" "Dataflow"
        r0348 = c.evm.handler -> c.evm.nonce "Allocates the next sender nonce" "In-process calls / Go" "Dataflow"
        r0349 = c.evm.nonce -> c.evm.persistence "Persists sender transaction ordering" "In-process calls / Go" "Dataflow"
        r0350 = c.evm.handler -> c.evm.abi "Prepares calls and encoded transactions" "In-process calls / Go" "Dataflow"
        r0351 = c.evm.abi -> c.evm.rpc "Issues Ethereum JSON-RPC requests" "In-process calls / Go" "Dataflow"
        r0352 = c.evm.handler -> c.evm.receipts "Tracks submitted transaction receipts" "In-process calls / Go" "Dataflow"
        r0353 = c.evm.receipts -> c.evm.rpc "Queries transaction receipt status" "In-process calls / Go" "Dataflow"
        r0354 = c.evm.rpc -> c.evm.blocks "Returns block and filter responses" "In-process calls / Go" "Dataflow"
        r0355 = c.evm.blocks -> c.evm.confirmations "Publishes chain head updates" "In-process calls / Go" "Dataflow"
        r0356 = c.evm.receipts -> c.evm.confirmations "Submits receipts for confirmation" "In-process calls / Go" "Dataflow"
        r0357 = c.evm.confirmations -> c.evm.streams "Releases confirmed blockchain events" "In-process calls / Go" "Dataflow"
        r0358 = c.evm.manager -> c.evm.streams "Configures listeners and stream lifecycle" "In-process calls / Go" "Dataflow"
        r0359 = c.evm.streams -> c.evm.delivery "Delivers ordered event batches" "In-process calls / Go" "Dataflow"
        r0360 = c.evm.delivery -> c.evm.streams "Acknowledges consumed batches" "In-process calls / Go" "Dataflow"
        r0361 = c.evm.streams -> c.evm.persistence "Persists acknowledged checkpoints" "In-process calls / Go" "Dataflow"
        r0362 = c.evm.manager -> c.evm.persistence "Persists transaction lifecycle state" "In-process calls / Go" "Dataflow"
        r0363 = c.signer.proxy -> c.signer.wallet "Resolves requested signing accounts" "In-process calls / Go" "Dataflow"
        r0364 = c.signer.wallet -> c.signer.keystore "Decrypts selected key material" "In-process calls / Go" "Dataflow"
        r0365 = c.signer.proxy -> c.signer.signing "Submits transactions for signing" "In-process calls / Go" "Dataflow"
        r0366 = c.signer.signing -> c.signer.wallet "Retrieves the selected signing key" "In-process calls / Go" "Dataflow"
        r0367 = c.signer.signing -> c.signer.backend "Submits signed raw transactions" "In-process calls / Go" "Dataflow"
        r0368 = c.signer.proxy -> c.signer.backend "Forwards unmodified RPC read requests" "In-process calls / Go" "Dataflow"
        r0369 = c.dx.api -> c.dx.peers "Updates peer endpoints and certificates" "In-process calls / TypeScript" "Dataflow"
        r0370 = c.dx.api -> c.dx.messages "Submits recipient-scoped messages" "In-process calls / TypeScript" "Dataflow"
        r0371 = c.dx.api -> c.dx.blobs "Uploads private binary content" "In-process calls / TypeScript" "Dataflow"
        r0372 = c.dx.messages -> c.dx.peers "Resolves destination and trust material" "In-process calls / TypeScript" "Dataflow"
        r0373 = c.dx.messages -> c.dx.p2p "Transfers private message envelopes" "In-process calls / TypeScript" "Dataflow"
        r0374 = c.dx.blobs -> c.dx.p2p "Transfers encrypted blob streams" "In-process calls / TypeScript" "Dataflow"
        r0375 = c.dx.p2p -> c.dx.messages "Delivers authenticated inbound messages" "In-process calls / TypeScript" "Dataflow"
        r0376 = c.dx.p2p -> c.dx.blobs "Stores authenticated inbound blobs" "In-process calls / TypeScript" "Dataflow"
        r0377 = c.dx.messages -> c.dx.events "Enqueues message delivery results" "In-process calls / TypeScript" "Dataflow"
        r0378 = c.dx.blobs -> c.dx.events "Enqueues blob delivery results" "In-process calls / TypeScript" "Dataflow"
        r0379 = c.dx.events -> c.dx.api "Delivers notifications and receives acknowledgements" "In-process calls / TypeScript" "Dataflow"
        r0380 = c.erc20.api -> c.erc20.service "Submits standard token operations" "In-process calls / TypeScript" "Dataflow"
        r0381 = c.erc20.service -> c.erc20.mapper "Encodes token contract calls" "In-process calls / TypeScript" "Dataflow"
        r0382 = c.erc20.mapper -> c.erc20.blockchain "Passes encoded contract requests" "In-process calls / TypeScript" "Dataflow"
        r0383 = c.erc20.blockchain -> c.erc20.stream "Registers contract event listeners" "In-process calls / TypeScript" "Dataflow"
        r0384 = c.erc20.stream -> c.erc20.listener "Delivers token contract logs" "In-process calls / TypeScript" "Dataflow"
        r0385 = c.erc20.listener -> c.erc20.service "Updates token pool state" "In-process calls / TypeScript" "Dataflow"
        r0386 = c.erc20.listener -> c.erc20.proxy "Publishes normalized token events" "In-process calls / TypeScript" "Dataflow"
        r0387 = c.erc20.proxy -> c.erc20.stream "Acknowledges consumed event batches" "In-process calls / TypeScript" "Dataflow"
        r0388 = c.erc1155.api -> c.erc1155.service "Submits standard token operations" "In-process calls / TypeScript" "Dataflow"
        r0389 = c.erc1155.service -> c.erc1155.mapper "Encodes token contract calls" "In-process calls / TypeScript" "Dataflow"
        r0390 = c.erc1155.mapper -> c.erc1155.blockchain "Passes encoded contract requests" "In-process calls / TypeScript" "Dataflow"
        r0391 = c.erc1155.blockchain -> c.erc1155.stream "Registers contract event listeners" "In-process calls / TypeScript" "Dataflow"
        r0392 = c.erc1155.stream -> c.erc1155.listener "Delivers token contract logs" "In-process calls / TypeScript" "Dataflow"
        r0393 = c.erc1155.listener -> c.erc1155.service "Updates token pool state" "In-process calls / TypeScript" "Dataflow"
        r0394 = c.erc1155.listener -> c.erc1155.proxy "Publishes normalized token events" "In-process calls / TypeScript" "Dataflow"
        r0395 = c.erc1155.proxy -> c.erc1155.stream "Acknowledges consumed event batches" "In-process calls / TypeScript" "Dataflow"
        r0396 = c.core -> c.evm "Submits contract calls, pins and listeners" "HTTP REST / JSON" "Dataflow"
        r0397 = c.evm -> c.core "Streams confirmed events and transaction results" "WebSocket / JSON" "Dataflow"
        r0398 = c.core -> c.dx "Submits private messages, blobs and peer configuration" "HTTP REST / JSON + binary" "Dataflow"
        r0399 = c.dx -> c.core "Delivers transfer notifications and awaits ACKs" "WebSocket / JSON" "Dataflow"
        r0400 = c.core -> c.erc20 "Submits ERC-20 and ERC-721 operations" "HTTP REST / JSON" "Dataflow"
        r0401 = c.core -> c.erc1155 "Submits ERC-1155 operations" "HTTP REST / JSON" "Dataflow"
        r0402 = c.erc20 -> c.core "Delivers normalized token events" "WebSocket / JSON" "Dataflow"
        r0403 = c.erc1155 -> c.core "Delivers normalized token events" "WebSocket / JSON" "Dataflow"
        r0404 = c.erc20 -> c.evm "Submits contract calls and consumes event streams" "HTTP REST + WebSocket" "Dataflow"
        r0405 = c.erc1155 -> c.evm "Submits contract calls and consumes event streams" "HTTP REST + WebSocket" "Dataflow"
        r0406 = c.evm -> c.signer "Submits Ethereum calls and unsigned transactions" "HTTP JSON-RPC" "Dataflow"
        r0407 = c.core -> c.pg "Reads and writes the private Core database" "PostgreSQL wire / TLS" "Dataflow"
        r0408 = c.evm -> c.pg "Reads and writes the separate FFTM database" "PostgreSQL wire / TLS" "Dataflow"
        r0409 = c.pg -> c.pgReplica "Streams WAL and awaits one synchronous standby" "PostgreSQL replication / TLS" "Dataflow"
        r0410 = c.core -> c.ipfs "Adds shared content and retrieves CIDs" "IPFS HTTP RPC / gateway" "Dataflow"
        r0411 = c.dx -> c.blobs "Reads and writes private blobs and peer records" "Filesystem I/O" "Dataflow"
        r0412 = c.ipfs -> c.ipfsRepo "Reads and writes Kubo keys, pins and blocks" "Filesystem I/O" "Dataflow"
        r0413 = c.signer -> c.secrets "Loads member signing keystore files" "Read-only projected files" "Dataflow"
        r0414 = c.dx -> c.secrets "Loads member mTLS certificate and key" "Read-only projected files" "Dataflow"
        r0415 = c.core -> c.secrets "Loads namespace and plugin configuration" "Read-only projected files" "Dataflow"
        r0416 = c.evm -> c.secrets "Loads connector endpoints and credentials" "Read-only projected files" "Dataflow"
        r0417 = c.core.blockchain -> c.evm "Submits blockchain operations" "HTTP REST / JSON" "Dataflow"
        r0418 = c.evm.delivery -> c.core "Delivers confirmed event batches" "WebSocket / JSON" "Dataflow"
        r0419 = c.core.database -> c.pg "Persists Core resources and offsets" "PostgreSQL wire / TLS" "Dataflow"
        r0420 = c.core.dataexchange -> c.dx "Exchanges private data and notifications" "HTTP + WebSocket" "Dataflow"
        r0421 = c.core.sharedstorage -> c.ipfs "Publishes and retrieves CIDs" "IPFS HTTP RPC" "Dataflow"
        r0422 = c.core.tokens -> c.erc20 "Submits ERC-20 and ERC-721 operations" "HTTP REST / JSON" "Dataflow"
        r0423 = c.core.tokens -> c.erc1155 "Submits ERC-1155 operations" "HTTP REST / JSON" "Dataflow"
        r0424 = c.evm.persistence -> c.pg "Persists FFTM transactions and checkpoints" "PostgreSQL wire / TLS" "Dataflow"
        r0425 = c.evm.rpc -> c.signer "Forwards transactions and read calls" "HTTP JSON-RPC" "Dataflow"
        r0426 = c.signer.wallet -> c.secrets "Loads encrypted account keystores" "Read-only projected files" "Dataflow"
        r0427 = c.dx.blobs -> c.blobs "Stores durable private blobs" "Filesystem I/O" "Dataflow"
        r0428 = c.dx.peers -> c.blobs "Persists endpoints and peer certificates" "Filesystem I/O" "Dataflow"
        r0429 = c.dx.p2p -> c.secrets "Loads the member mTLS identity" "Read-only projected files" "Dataflow"
        r0430 = c.erc20.blockchain -> c.evm "Submits contract calls and listeners" "HTTP REST / JSON" "Dataflow"
        r0431 = c.evm -> c.erc20.stream "Streams confirmed token logs" "WebSocket / JSON" "Dataflow"
        r0432 = c.erc20.proxy -> c.core "Delivers token events and receives ACKs" "WebSocket / JSON" "Dataflow"
        r0433 = c.erc1155.blockchain -> c.evm "Submits contract calls and listeners" "HTTP REST / JSON" "Dataflow"
        r0434 = c.evm -> c.erc1155.stream "Streams confirmed token logs" "WebSocket / JSON" "Dataflow"
        r0435 = c.erc1155.proxy -> c.core "Delivers token events and receives ACKs" "WebSocket / JSON" "Dataflow"
        r0436 = besu.a1.rpc -> besu.a1.permissioning "Checks transaction sender admission" "In-process calls / Java" "Dataflow"
        r0437 = besu.a1.rpc -> besu.a1.txpool "Submits signed transactions" "In-process calls / Java" "Dataflow"
        r0438 = besu.a1.rpc -> besu.a1.worldstate "Queries account and contract state" "In-process calls / Java" "Dataflow"
        r0439 = besu.a1.rpc -> besu.a1.blockprocessor "Reads receipts and contract logs" "In-process calls / Java" "Dataflow"
        r0440 = besu.a1.discovery -> besu.a1.p2p "Provides discovered peer endpoints" "In-process calls / Java" "Dataflow"
        r0441 = besu.a1.p2p -> besu.a1.permissioning "Checks connecting node admission" "In-process calls / Java" "Dataflow"
        r0442 = besu.a1.p2p -> besu.a1.txpool "Gossips pending transactions" "In-process calls / Java" "Dataflow"
        r0443 = besu.a1.p2p -> besu.a1.sync "Delivers requested blocks and state" "In-process calls / Java" "Dataflow"
        r0444 = besu.a1.p2p -> besu.a1.qbft "Delivers consensus protocol messages" "In-process calls / Java" "Dataflow"
        r0445 = besu.a1.sync -> besu.a1.blockprocessor "Submits downloaded blocks for validation" "In-process calls / Java" "Dataflow"
        r0446 = besu.a1.txpool -> besu.a1.qbft "Supplies transactions for proposed blocks" "In-process calls / Java" "Dataflow"
        r0447 = besu.a1.qbft -> besu.a1.keys "Signs proposals and consensus votes" "In-process calls / Java" "Dataflow"
        r0448 = besu.a1.qbft -> besu.a1.blockprocessor "Commits quorum-approved blocks" "In-process calls / Java" "Dataflow"
        r0449 = besu.a1.blockprocessor -> besu.a1.evm "Executes transactions and validates results" "In-process calls / Java" "Dataflow"
        r0450 = besu.a1.evm -> besu.a1.worldstate "Reads and updates contract and account state" "EVM execution" "Dataflow"
        r0451 = besu.a1.worldstate -> besu.a1.storage "Persists world-state updates" "In-process calls / Java" "Dataflow"
        r0452 = besu.a1.blockprocessor -> besu.a1.storage "Persists blocks, receipts and logs" "In-process calls / Java" "Dataflow"
        r0453 = besu.a1.evm -> besu.a1.fireflycontract "Executes batch pinning calls" "EVM execution" "Dataflow"
        r0454 = besu.a1.evm -> besu.a1.tokencontracts "Executes standard token operations" "EVM execution" "Dataflow"
        r0455 = besu.a1.evm -> besu.a1.businesscontracts "Executes application business calls" "EVM execution" "Dataflow"
        r0456 = besu.a1.fireflycontract -> besu.a1.worldstate "Writes pinning state and log results" "In-process calls / Java" "Dataflow"
        r0457 = besu.a1.tokencontracts -> besu.a1.worldstate "Writes token balances and log results" "In-process calls / Java" "Dataflow"
        r0458 = besu.a1.businesscontracts -> besu.a1.worldstate "Writes application state and log results" "In-process calls / Java" "Dataflow"
        r0459 = besu.a1.qbft -> besu.a1.metrics "Records rounds and committed block measurements" "In-process calls / Java" "Dataflow"
        r0460 = besu.a1.p2p -> besu.a1.metrics "Records peer connectivity measurements" "In-process calls / Java" "Dataflow"
        r0461 = besu.b1.rpc -> besu.b1.permissioning "Checks transaction sender admission" "In-process calls / Java" "Dataflow"
        r0462 = besu.b1.rpc -> besu.b1.txpool "Submits signed transactions" "In-process calls / Java" "Dataflow"
        r0463 = besu.b1.rpc -> besu.b1.worldstate "Queries account and contract state" "In-process calls / Java" "Dataflow"
        r0464 = besu.b1.rpc -> besu.b1.blockprocessor "Reads receipts and contract logs" "In-process calls / Java" "Dataflow"
        r0465 = besu.b1.discovery -> besu.b1.p2p "Provides discovered peer endpoints" "In-process calls / Java" "Dataflow"
        r0466 = besu.b1.p2p -> besu.b1.permissioning "Checks connecting node admission" "In-process calls / Java" "Dataflow"
        r0467 = besu.b1.p2p -> besu.b1.txpool "Gossips pending transactions" "In-process calls / Java" "Dataflow"
        r0468 = besu.b1.p2p -> besu.b1.sync "Delivers requested blocks and state" "In-process calls / Java" "Dataflow"
        r0469 = besu.b1.p2p -> besu.b1.qbft "Delivers consensus protocol messages" "In-process calls / Java" "Dataflow"
        r0470 = besu.b1.sync -> besu.b1.blockprocessor "Submits downloaded blocks for validation" "In-process calls / Java" "Dataflow"
        r0471 = besu.b1.txpool -> besu.b1.qbft "Supplies transactions for proposed blocks" "In-process calls / Java" "Dataflow"
        r0472 = besu.b1.qbft -> besu.b1.keys "Signs proposals and consensus votes" "In-process calls / Java" "Dataflow"
        r0473 = besu.b1.qbft -> besu.b1.blockprocessor "Commits quorum-approved blocks" "In-process calls / Java" "Dataflow"
        r0474 = besu.b1.blockprocessor -> besu.b1.evm "Executes transactions and validates results" "In-process calls / Java" "Dataflow"
        r0475 = besu.b1.evm -> besu.b1.worldstate "Reads and updates contract and account state" "EVM execution" "Dataflow"
        r0476 = besu.b1.worldstate -> besu.b1.storage "Persists world-state updates" "In-process calls / Java" "Dataflow"
        r0477 = besu.b1.blockprocessor -> besu.b1.storage "Persists blocks, receipts and logs" "In-process calls / Java" "Dataflow"
        r0478 = besu.b1.evm -> besu.b1.fireflycontract "Executes batch pinning calls" "EVM execution" "Dataflow"
        r0479 = besu.b1.evm -> besu.b1.tokencontracts "Executes standard token operations" "EVM execution" "Dataflow"
        r0480 = besu.b1.evm -> besu.b1.businesscontracts "Executes application business calls" "EVM execution" "Dataflow"
        r0481 = besu.b1.fireflycontract -> besu.b1.worldstate "Writes pinning state and log results" "In-process calls / Java" "Dataflow"
        r0482 = besu.b1.tokencontracts -> besu.b1.worldstate "Writes token balances and log results" "In-process calls / Java" "Dataflow"
        r0483 = besu.b1.businesscontracts -> besu.b1.worldstate "Writes application state and log results" "In-process calls / Java" "Dataflow"
        r0484 = besu.b1.qbft -> besu.b1.metrics "Records rounds and committed block measurements" "In-process calls / Java" "Dataflow"
        r0485 = besu.b1.p2p -> besu.b1.metrics "Records peer connectivity measurements" "In-process calls / Java" "Dataflow"
        r0486 = besu.b2.rpc -> besu.b2.permissioning "Checks transaction sender admission" "In-process calls / Java" "Dataflow"
        r0487 = besu.b2.rpc -> besu.b2.txpool "Submits signed transactions" "In-process calls / Java" "Dataflow"
        r0488 = besu.b2.rpc -> besu.b2.worldstate "Queries account and contract state" "In-process calls / Java" "Dataflow"
        r0489 = besu.b2.rpc -> besu.b2.blockprocessor "Reads receipts and contract logs" "In-process calls / Java" "Dataflow"
        r0490 = besu.b2.discovery -> besu.b2.p2p "Provides discovered peer endpoints" "In-process calls / Java" "Dataflow"
        r0491 = besu.b2.p2p -> besu.b2.permissioning "Checks connecting node admission" "In-process calls / Java" "Dataflow"
        r0492 = besu.b2.p2p -> besu.b2.txpool "Gossips pending transactions" "In-process calls / Java" "Dataflow"
        r0493 = besu.b2.p2p -> besu.b2.sync "Delivers requested blocks and state" "In-process calls / Java" "Dataflow"
        r0494 = besu.b2.p2p -> besu.b2.qbft "Delivers consensus protocol messages" "In-process calls / Java" "Dataflow"
        r0495 = besu.b2.sync -> besu.b2.blockprocessor "Submits downloaded blocks for validation" "In-process calls / Java" "Dataflow"
        r0496 = besu.b2.txpool -> besu.b2.qbft "Supplies transactions for proposed blocks" "In-process calls / Java" "Dataflow"
        r0497 = besu.b2.qbft -> besu.b2.keys "Signs proposals and consensus votes" "In-process calls / Java" "Dataflow"
        r0498 = besu.b2.qbft -> besu.b2.blockprocessor "Commits quorum-approved blocks" "In-process calls / Java" "Dataflow"
        r0499 = besu.b2.blockprocessor -> besu.b2.evm "Executes transactions and validates results" "In-process calls / Java" "Dataflow"
        r0500 = besu.b2.evm -> besu.b2.worldstate "Reads and updates contract and account state" "EVM execution" "Dataflow"
        r0501 = besu.b2.worldstate -> besu.b2.storage "Persists world-state updates" "In-process calls / Java" "Dataflow"
        r0502 = besu.b2.blockprocessor -> besu.b2.storage "Persists blocks, receipts and logs" "In-process calls / Java" "Dataflow"
        r0503 = besu.b2.evm -> besu.b2.fireflycontract "Executes batch pinning calls" "EVM execution" "Dataflow"
        r0504 = besu.b2.evm -> besu.b2.tokencontracts "Executes standard token operations" "EVM execution" "Dataflow"
        r0505 = besu.b2.evm -> besu.b2.businesscontracts "Executes application business calls" "EVM execution" "Dataflow"
        r0506 = besu.b2.fireflycontract -> besu.b2.worldstate "Writes pinning state and log results" "In-process calls / Java" "Dataflow"
        r0507 = besu.b2.tokencontracts -> besu.b2.worldstate "Writes token balances and log results" "In-process calls / Java" "Dataflow"
        r0508 = besu.b2.businesscontracts -> besu.b2.worldstate "Writes application state and log results" "In-process calls / Java" "Dataflow"
        r0509 = besu.b2.qbft -> besu.b2.metrics "Records rounds and committed block measurements" "In-process calls / Java" "Dataflow"
        r0510 = besu.b2.p2p -> besu.b2.metrics "Records peer connectivity measurements" "In-process calls / Java" "Dataflow"
        r0511 = besu.c1.rpc -> besu.c1.permissioning "Checks transaction sender admission" "In-process calls / Java" "Dataflow"
        r0512 = besu.c1.rpc -> besu.c1.txpool "Submits signed transactions" "In-process calls / Java" "Dataflow"
        r0513 = besu.c1.rpc -> besu.c1.worldstate "Queries account and contract state" "In-process calls / Java" "Dataflow"
        r0514 = besu.c1.rpc -> besu.c1.blockprocessor "Reads receipts and contract logs" "In-process calls / Java" "Dataflow"
        r0515 = besu.c1.discovery -> besu.c1.p2p "Provides discovered peer endpoints" "In-process calls / Java" "Dataflow"
        r0516 = besu.c1.p2p -> besu.c1.permissioning "Checks connecting node admission" "In-process calls / Java" "Dataflow"
        r0517 = besu.c1.p2p -> besu.c1.txpool "Gossips pending transactions" "In-process calls / Java" "Dataflow"
        r0518 = besu.c1.p2p -> besu.c1.sync "Delivers requested blocks and state" "In-process calls / Java" "Dataflow"
        r0519 = besu.c1.p2p -> besu.c1.qbft "Delivers consensus protocol messages" "In-process calls / Java" "Dataflow"
        r0520 = besu.c1.sync -> besu.c1.blockprocessor "Submits downloaded blocks for validation" "In-process calls / Java" "Dataflow"
        r0521 = besu.c1.txpool -> besu.c1.qbft "Supplies transactions for proposed blocks" "In-process calls / Java" "Dataflow"
        r0522 = besu.c1.qbft -> besu.c1.keys "Signs proposals and consensus votes" "In-process calls / Java" "Dataflow"
        r0523 = besu.c1.qbft -> besu.c1.blockprocessor "Commits quorum-approved blocks" "In-process calls / Java" "Dataflow"
        r0524 = besu.c1.blockprocessor -> besu.c1.evm "Executes transactions and validates results" "In-process calls / Java" "Dataflow"
        r0525 = besu.c1.evm -> besu.c1.worldstate "Reads and updates contract and account state" "EVM execution" "Dataflow"
        r0526 = besu.c1.worldstate -> besu.c1.storage "Persists world-state updates" "In-process calls / Java" "Dataflow"
        r0527 = besu.c1.blockprocessor -> besu.c1.storage "Persists blocks, receipts and logs" "In-process calls / Java" "Dataflow"
        r0528 = besu.c1.evm -> besu.c1.fireflycontract "Executes batch pinning calls" "EVM execution" "Dataflow"
        r0529 = besu.c1.evm -> besu.c1.tokencontracts "Executes standard token operations" "EVM execution" "Dataflow"
        r0530 = besu.c1.evm -> besu.c1.businesscontracts "Executes application business calls" "EVM execution" "Dataflow"
        r0531 = besu.c1.fireflycontract -> besu.c1.worldstate "Writes pinning state and log results" "In-process calls / Java" "Dataflow"
        r0532 = besu.c1.tokencontracts -> besu.c1.worldstate "Writes token balances and log results" "In-process calls / Java" "Dataflow"
        r0533 = besu.c1.businesscontracts -> besu.c1.worldstate "Writes application state and log results" "In-process calls / Java" "Dataflow"
        r0534 = besu.c1.qbft -> besu.c1.metrics "Records rounds and committed block measurements" "In-process calls / Java" "Dataflow"
        r0535 = besu.c1.p2p -> besu.c1.metrics "Records peer connectivity measurements" "In-process calls / Java" "Dataflow"
        r0536 = besu.c2.rpc -> besu.c2.permissioning "Checks transaction sender admission" "In-process calls / Java" "Dataflow"
        r0537 = besu.c2.rpc -> besu.c2.txpool "Submits signed transactions" "In-process calls / Java" "Dataflow"
        r0538 = besu.c2.rpc -> besu.c2.worldstate "Queries account and contract state" "In-process calls / Java" "Dataflow"
        r0539 = besu.c2.rpc -> besu.c2.blockprocessor "Reads receipts and contract logs" "In-process calls / Java" "Dataflow"
        r0540 = besu.c2.discovery -> besu.c2.p2p "Provides discovered peer endpoints" "In-process calls / Java" "Dataflow"
        r0541 = besu.c2.p2p -> besu.c2.permissioning "Checks connecting node admission" "In-process calls / Java" "Dataflow"
        r0542 = besu.c2.p2p -> besu.c2.txpool "Gossips pending transactions" "In-process calls / Java" "Dataflow"
        r0543 = besu.c2.p2p -> besu.c2.sync "Delivers requested blocks and state" "In-process calls / Java" "Dataflow"
        r0544 = besu.c2.p2p -> besu.c2.qbft "Delivers consensus protocol messages" "In-process calls / Java" "Dataflow"
        r0545 = besu.c2.sync -> besu.c2.blockprocessor "Submits downloaded blocks for validation" "In-process calls / Java" "Dataflow"
        r0546 = besu.c2.txpool -> besu.c2.qbft "Supplies transactions for proposed blocks" "In-process calls / Java" "Dataflow"
        r0547 = besu.c2.qbft -> besu.c2.keys "Signs proposals and consensus votes" "In-process calls / Java" "Dataflow"
        r0548 = besu.c2.qbft -> besu.c2.blockprocessor "Commits quorum-approved blocks" "In-process calls / Java" "Dataflow"
        r0549 = besu.c2.blockprocessor -> besu.c2.evm "Executes transactions and validates results" "In-process calls / Java" "Dataflow"
        r0550 = besu.c2.evm -> besu.c2.worldstate "Reads and updates contract and account state" "EVM execution" "Dataflow"
        r0551 = besu.c2.worldstate -> besu.c2.storage "Persists world-state updates" "In-process calls / Java" "Dataflow"
        r0552 = besu.c2.blockprocessor -> besu.c2.storage "Persists blocks, receipts and logs" "In-process calls / Java" "Dataflow"
        r0553 = besu.c2.evm -> besu.c2.fireflycontract "Executes batch pinning calls" "EVM execution" "Dataflow"
        r0554 = besu.c2.evm -> besu.c2.tokencontracts "Executes standard token operations" "EVM execution" "Dataflow"
        r0555 = besu.c2.evm -> besu.c2.businesscontracts "Executes application business calls" "EVM execution" "Dataflow"
        r0556 = besu.c2.fireflycontract -> besu.c2.worldstate "Writes pinning state and log results" "In-process calls / Java" "Dataflow"
        r0557 = besu.c2.tokencontracts -> besu.c2.worldstate "Writes token balances and log results" "In-process calls / Java" "Dataflow"
        r0558 = besu.c2.businesscontracts -> besu.c2.worldstate "Writes application state and log results" "In-process calls / Java" "Dataflow"
        r0559 = besu.c2.qbft -> besu.c2.metrics "Records rounds and committed block measurements" "In-process calls / Java" "Dataflow"
        r0560 = besu.c2.p2p -> besu.c2.metrics "Records peer connectivity measurements" "In-process calls / Java" "Dataflow"
        r0561 = besu.a2.rpc -> besu.a2.permissioning "Checks transaction sender admission" "In-process calls / Java" "Dataflow"
        r0562 = besu.a2.rpc -> besu.a2.txpool "Submits signed transactions" "In-process calls / Java" "Dataflow"
        r0563 = besu.a2.rpc -> besu.a2.worldstate "Queries account and contract state" "In-process calls / Java" "Dataflow"
        r0564 = besu.a2.rpc -> besu.a2.blockprocessor "Reads receipts and contract logs" "In-process calls / Java" "Dataflow"
        r0565 = besu.a2.discovery -> besu.a2.p2p "Provides discovered peer endpoints" "In-process calls / Java" "Dataflow"
        r0566 = besu.a2.p2p -> besu.a2.permissioning "Checks connecting node admission" "In-process calls / Java" "Dataflow"
        r0567 = besu.a2.p2p -> besu.a2.txpool "Gossips pending transactions" "In-process calls / Java" "Dataflow"
        r0568 = besu.a2.p2p -> besu.a2.sync "Delivers requested blocks and state" "In-process calls / Java" "Dataflow"
        r0569 = besu.a2.p2p -> besu.a2.qbft "Delivers consensus protocol messages" "In-process calls / Java" "Dataflow"
        r0570 = besu.a2.sync -> besu.a2.blockprocessor "Submits downloaded blocks for validation" "In-process calls / Java" "Dataflow"
        r0571 = besu.a2.txpool -> besu.a2.qbft "Supplies transactions for proposed blocks" "In-process calls / Java" "Dataflow"
        r0572 = besu.a2.qbft -> besu.a2.keys "Signs proposals and consensus votes" "In-process calls / Java" "Dataflow"
        r0573 = besu.a2.qbft -> besu.a2.blockprocessor "Commits quorum-approved blocks" "In-process calls / Java" "Dataflow"
        r0574 = besu.a2.blockprocessor -> besu.a2.evm "Executes transactions and validates results" "In-process calls / Java" "Dataflow"
        r0575 = besu.a2.evm -> besu.a2.worldstate "Reads and updates contract and account state" "EVM execution" "Dataflow"
        r0576 = besu.a2.worldstate -> besu.a2.storage "Persists world-state updates" "In-process calls / Java" "Dataflow"
        r0577 = besu.a2.blockprocessor -> besu.a2.storage "Persists blocks, receipts and logs" "In-process calls / Java" "Dataflow"
        r0578 = besu.a2.evm -> besu.a2.fireflycontract "Executes batch pinning calls" "EVM execution" "Dataflow"
        r0579 = besu.a2.evm -> besu.a2.tokencontracts "Executes standard token operations" "EVM execution" "Dataflow"
        r0580 = besu.a2.evm -> besu.a2.businesscontracts "Executes application business calls" "EVM execution" "Dataflow"
        r0581 = besu.a2.fireflycontract -> besu.a2.worldstate "Writes pinning state and log results" "In-process calls / Java" "Dataflow"
        r0582 = besu.a2.tokencontracts -> besu.a2.worldstate "Writes token balances and log results" "In-process calls / Java" "Dataflow"
        r0583 = besu.a2.businesscontracts -> besu.a2.worldstate "Writes application state and log results" "In-process calls / Java" "Dataflow"
        r0584 = besu.a2.qbft -> besu.a2.metrics "Records rounds and committed block measurements" "In-process calls / Java" "Dataflow"
        r0585 = besu.a2.p2p -> besu.a2.metrics "Records peer connectivity measurements" "In-process calls / Java" "Dataflow"
        r0586 = besu.rpc1.rpc -> besu.rpc1.permissioning "Checks transaction sender admission" "In-process calls / Java" "Dataflow"
        r0587 = besu.rpc1.rpc -> besu.rpc1.txpool "Submits signed transactions" "In-process calls / Java" "Dataflow"
        r0588 = besu.rpc1.rpc -> besu.rpc1.worldstate "Queries account and contract state" "In-process calls / Java" "Dataflow"
        r0589 = besu.rpc1.rpc -> besu.rpc1.blockprocessor "Reads receipts and contract logs" "In-process calls / Java" "Dataflow"
        r0590 = besu.rpc1.discovery -> besu.rpc1.p2p "Provides discovered peer endpoints" "In-process calls / Java" "Dataflow"
        r0591 = besu.rpc1.p2p -> besu.rpc1.permissioning "Checks connecting node admission" "In-process calls / Java" "Dataflow"
        r0592 = besu.rpc1.p2p -> besu.rpc1.txpool "Gossips pending transactions" "In-process calls / Java" "Dataflow"
        r0593 = besu.rpc1.p2p -> besu.rpc1.sync "Delivers requested blocks and state" "In-process calls / Java" "Dataflow"
        r0594 = besu.rpc1.sync -> besu.rpc1.blockprocessor "Submits downloaded blocks for validation" "In-process calls / Java" "Dataflow"
        r0595 = besu.rpc1.blockprocessor -> besu.rpc1.evm "Executes transactions and validates results" "In-process calls / Java" "Dataflow"
        r0596 = besu.rpc1.evm -> besu.rpc1.worldstate "Reads and updates contract and account state" "EVM execution" "Dataflow"
        r0597 = besu.rpc1.worldstate -> besu.rpc1.storage "Persists world-state updates" "In-process calls / Java" "Dataflow"
        r0598 = besu.rpc1.blockprocessor -> besu.rpc1.storage "Persists blocks, receipts and logs" "In-process calls / Java" "Dataflow"
        r0599 = besu.rpc1.evm -> besu.rpc1.fireflycontract "Executes batch pinning calls" "EVM execution" "Dataflow"
        r0600 = besu.rpc1.evm -> besu.rpc1.tokencontracts "Executes standard token operations" "EVM execution" "Dataflow"
        r0601 = besu.rpc1.evm -> besu.rpc1.businesscontracts "Executes application business calls" "EVM execution" "Dataflow"
        r0602 = besu.rpc1.fireflycontract -> besu.rpc1.worldstate "Writes pinning state and log results" "In-process calls / Java" "Dataflow"
        r0603 = besu.rpc1.tokencontracts -> besu.rpc1.worldstate "Writes token balances and log results" "In-process calls / Java" "Dataflow"
        r0604 = besu.rpc1.businesscontracts -> besu.rpc1.worldstate "Writes application state and log results" "In-process calls / Java" "Dataflow"
        r0605 = besu.rpc1.p2p -> besu.rpc1.metrics "Records peer connectivity measurements" "In-process calls / Java" "Dataflow"
        r0606 = besu.rpc1.p2p -> besu.rpc1.keys "Authenticates node transport identity" "In-process calls / Java" "Dataflow"
        r0607 = besu.rpc2.rpc -> besu.rpc2.permissioning "Checks transaction sender admission" "In-process calls / Java" "Dataflow"
        r0608 = besu.rpc2.rpc -> besu.rpc2.txpool "Submits signed transactions" "In-process calls / Java" "Dataflow"
        r0609 = besu.rpc2.rpc -> besu.rpc2.worldstate "Queries account and contract state" "In-process calls / Java" "Dataflow"
        r0610 = besu.rpc2.rpc -> besu.rpc2.blockprocessor "Reads receipts and contract logs" "In-process calls / Java" "Dataflow"
        r0611 = besu.rpc2.discovery -> besu.rpc2.p2p "Provides discovered peer endpoints" "In-process calls / Java" "Dataflow"
        r0612 = besu.rpc2.p2p -> besu.rpc2.permissioning "Checks connecting node admission" "In-process calls / Java" "Dataflow"
        r0613 = besu.rpc2.p2p -> besu.rpc2.txpool "Gossips pending transactions" "In-process calls / Java" "Dataflow"
        r0614 = besu.rpc2.p2p -> besu.rpc2.sync "Delivers requested blocks and state" "In-process calls / Java" "Dataflow"
        r0615 = besu.rpc2.sync -> besu.rpc2.blockprocessor "Submits downloaded blocks for validation" "In-process calls / Java" "Dataflow"
        r0616 = besu.rpc2.blockprocessor -> besu.rpc2.evm "Executes transactions and validates results" "In-process calls / Java" "Dataflow"
        r0617 = besu.rpc2.evm -> besu.rpc2.worldstate "Reads and updates contract and account state" "EVM execution" "Dataflow"
        r0618 = besu.rpc2.worldstate -> besu.rpc2.storage "Persists world-state updates" "In-process calls / Java" "Dataflow"
        r0619 = besu.rpc2.blockprocessor -> besu.rpc2.storage "Persists blocks, receipts and logs" "In-process calls / Java" "Dataflow"
        r0620 = besu.rpc2.evm -> besu.rpc2.fireflycontract "Executes batch pinning calls" "EVM execution" "Dataflow"
        r0621 = besu.rpc2.evm -> besu.rpc2.tokencontracts "Executes standard token operations" "EVM execution" "Dataflow"
        r0622 = besu.rpc2.evm -> besu.rpc2.businesscontracts "Executes application business calls" "EVM execution" "Dataflow"
        r0623 = besu.rpc2.fireflycontract -> besu.rpc2.worldstate "Writes pinning state and log results" "In-process calls / Java" "Dataflow"
        r0624 = besu.rpc2.tokencontracts -> besu.rpc2.worldstate "Writes token balances and log results" "In-process calls / Java" "Dataflow"
        r0625 = besu.rpc2.businesscontracts -> besu.rpc2.worldstate "Writes application state and log results" "In-process calls / Java" "Dataflow"
        r0626 = besu.rpc2.p2p -> besu.rpc2.metrics "Records peer connectivity measurements" "In-process calls / Java" "Dataflow"
        r0627 = besu.rpc2.p2p -> besu.rpc2.keys "Authenticates node transport identity" "In-process calls / Java" "Dataflow"
        r0628 = besu.rpc3.rpc -> besu.rpc3.permissioning "Checks transaction sender admission" "In-process calls / Java" "Dataflow"
        r0629 = besu.rpc3.rpc -> besu.rpc3.txpool "Submits signed transactions" "In-process calls / Java" "Dataflow"
        r0630 = besu.rpc3.rpc -> besu.rpc3.worldstate "Queries account and contract state" "In-process calls / Java" "Dataflow"
        r0631 = besu.rpc3.rpc -> besu.rpc3.blockprocessor "Reads receipts and contract logs" "In-process calls / Java" "Dataflow"
        r0632 = besu.rpc3.discovery -> besu.rpc3.p2p "Provides discovered peer endpoints" "In-process calls / Java" "Dataflow"
        r0633 = besu.rpc3.p2p -> besu.rpc3.permissioning "Checks connecting node admission" "In-process calls / Java" "Dataflow"
        r0634 = besu.rpc3.p2p -> besu.rpc3.txpool "Gossips pending transactions" "In-process calls / Java" "Dataflow"
        r0635 = besu.rpc3.p2p -> besu.rpc3.sync "Delivers requested blocks and state" "In-process calls / Java" "Dataflow"
        r0636 = besu.rpc3.sync -> besu.rpc3.blockprocessor "Submits downloaded blocks for validation" "In-process calls / Java" "Dataflow"
        r0637 = besu.rpc3.blockprocessor -> besu.rpc3.evm "Executes transactions and validates results" "In-process calls / Java" "Dataflow"
        r0638 = besu.rpc3.evm -> besu.rpc3.worldstate "Reads and updates contract and account state" "EVM execution" "Dataflow"
        r0639 = besu.rpc3.worldstate -> besu.rpc3.storage "Persists world-state updates" "In-process calls / Java" "Dataflow"
        r0640 = besu.rpc3.blockprocessor -> besu.rpc3.storage "Persists blocks, receipts and logs" "In-process calls / Java" "Dataflow"
        r0641 = besu.rpc3.evm -> besu.rpc3.fireflycontract "Executes batch pinning calls" "EVM execution" "Dataflow"
        r0642 = besu.rpc3.evm -> besu.rpc3.tokencontracts "Executes standard token operations" "EVM execution" "Dataflow"
        r0643 = besu.rpc3.evm -> besu.rpc3.businesscontracts "Executes application business calls" "EVM execution" "Dataflow"
        r0644 = besu.rpc3.fireflycontract -> besu.rpc3.worldstate "Writes pinning state and log results" "In-process calls / Java" "Dataflow"
        r0645 = besu.rpc3.tokencontracts -> besu.rpc3.worldstate "Writes token balances and log results" "In-process calls / Java" "Dataflow"
        r0646 = besu.rpc3.businesscontracts -> besu.rpc3.worldstate "Writes application state and log results" "In-process calls / Java" "Dataflow"
        r0647 = besu.rpc3.p2p -> besu.rpc3.metrics "Records peer connectivity measurements" "In-process calls / Java" "Dataflow"
        r0648 = besu.rpc3.p2p -> besu.rpc3.keys "Authenticates node transport identity" "In-process calls / Java" "Dataflow"
        r0649 = besu.a1 -> besu.b1 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0650 = besu.a1 -> besu.b2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0651 = besu.a1 -> besu.c1 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0652 = besu.a1 -> besu.c2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0653 = besu.a1 -> besu.a2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0654 = besu.a1 -> besu.rpc1 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0655 = besu.a1 -> besu.rpc2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0656 = besu.a1 -> besu.rpc3 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0657 = besu.b1 -> besu.b2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0658 = besu.b1 -> besu.c1 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0659 = besu.b1 -> besu.c2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0660 = besu.b1 -> besu.a2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0661 = besu.b1 -> besu.rpc1 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0662 = besu.b1 -> besu.rpc2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0663 = besu.b1 -> besu.rpc3 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0664 = besu.b2 -> besu.c1 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0665 = besu.b2 -> besu.c2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0666 = besu.b2 -> besu.a2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0667 = besu.b2 -> besu.rpc1 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0668 = besu.b2 -> besu.rpc2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0669 = besu.b2 -> besu.rpc3 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0670 = besu.c1 -> besu.c2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0671 = besu.c1 -> besu.a2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0672 = besu.c1 -> besu.rpc1 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0673 = besu.c1 -> besu.rpc2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0674 = besu.c1 -> besu.rpc3 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0675 = besu.c2 -> besu.a2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0676 = besu.c2 -> besu.rpc1 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0677 = besu.c2 -> besu.rpc2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0678 = besu.c2 -> besu.rpc3 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0679 = besu.a2 -> besu.rpc1 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0680 = besu.a2 -> besu.rpc2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0681 = besu.a2 -> besu.rpc3 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0682 = besu.rpc1 -> besu.rpc2 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0683 = besu.rpc1 -> besu.rpc3 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0684 = besu.rpc2 -> besu.rpc3 "Gossips transactions, blocks and peer messages" "DevP2P / TCP" "BlockchainFlow"
        r0685 = besu.rpc1 -> besu.a1 "Propagates submitted transactions" "DevP2P / TCP" "BlockchainFlow"
        r0686 = besu.rpc2 -> besu.a1 "Propagates submitted transactions" "DevP2P / TCP" "BlockchainFlow"
        r0687 = besu.rpc3 -> besu.a1 "Propagates submitted transactions" "DevP2P / TCP" "BlockchainFlow"
        r0688 = a -> besu "Submits transactions and consumes finalized events" "Ethereum JSON-RPC + events" "Dataflow"
        r0689 = operator -> a "Inspects and administers member state" "HTTPS / Explorer + Admin API" "Operational"
        r0690 = a.signer -> besu.rpc1 "Submits signed transactions and queries state" "HTTP JSON-RPC" "Dataflow"
        r0691 = a.signer.backend -> besu.rpc1 "Submits raw transactions and reads" "HTTP JSON-RPC" "Dataflow"
        r0692 = a.signer -> besu.rpc2 "Submits signed transactions and queries state" "HTTP JSON-RPC" "Dataflow"
        r0693 = a.signer.backend -> besu.rpc2 "Submits raw transactions and reads" "HTTP JSON-RPC" "Dataflow"
        r0694 = a.signer -> besu.rpc3 "Submits signed transactions and queries state" "HTTP JSON-RPC" "Dataflow"
        r0695 = a.signer.backend -> besu.rpc3 "Submits raw transactions and reads" "HTTP JSON-RPC" "Dataflow"
        r0696 = a -> b "Exchanges private data and shared content references" "mTLS + IPFS" "Dataflow"
        r0697 = a.dx -> b.dx "Transfers private envelopes and blobs; receives ACKs" "HTTPS / mutual TLS" "PrivateFlow"
        r0698 = a.ipfs -> b.ipfs "Retrieves shared content blocks by CID" "IPFS / libp2p" "SharedFlow"
        r0699 = a -> c "Exchanges private data and shared content references" "mTLS + IPFS" "Dataflow"
        r0700 = a.dx -> c.dx "Transfers private envelopes and blobs; receives ACKs" "HTTPS / mutual TLS" "PrivateFlow"
        r0701 = a.ipfs -> c.ipfs "Retrieves shared content blocks by CID" "IPFS / libp2p" "SharedFlow"
        r0702 = b -> besu "Submits transactions and consumes finalized events" "Ethereum JSON-RPC + events" "Dataflow"
        r0703 = operator -> b "Inspects and administers member state" "HTTPS / Explorer + Admin API" "Operational"
        r0704 = b.signer -> besu.rpc1 "Submits signed transactions and queries state" "HTTP JSON-RPC" "Dataflow"
        r0705 = b.signer.backend -> besu.rpc1 "Submits raw transactions and reads" "HTTP JSON-RPC" "Dataflow"
        r0706 = b.signer -> besu.rpc2 "Submits signed transactions and queries state" "HTTP JSON-RPC" "Dataflow"
        r0707 = b.signer.backend -> besu.rpc2 "Submits raw transactions and reads" "HTTP JSON-RPC" "Dataflow"
        r0708 = b.signer -> besu.rpc3 "Submits signed transactions and queries state" "HTTP JSON-RPC" "Dataflow"
        r0709 = b.signer.backend -> besu.rpc3 "Submits raw transactions and reads" "HTTP JSON-RPC" "Dataflow"
        r0710 = b.dx -> a.dx "Transfers private envelopes and blobs; receives ACKs" "HTTPS / mutual TLS" "PrivateFlow"
        r0711 = b.ipfs -> a.ipfs "Retrieves shared content blocks by CID" "IPFS / libp2p" "SharedFlow"
        r0712 = b -> c "Exchanges private data and shared content references" "mTLS + IPFS" "Dataflow"
        r0713 = b.dx -> c.dx "Transfers private envelopes and blobs; receives ACKs" "HTTPS / mutual TLS" "PrivateFlow"
        r0714 = b.ipfs -> c.ipfs "Retrieves shared content blocks by CID" "IPFS / libp2p" "SharedFlow"
        r0715 = c -> besu "Submits transactions and consumes finalized events" "Ethereum JSON-RPC + events" "Dataflow"
        r0716 = operator -> c "Inspects and administers member state" "HTTPS / Explorer + Admin API" "Operational"
        r0717 = c.signer -> besu.rpc1 "Submits signed transactions and queries state" "HTTP JSON-RPC" "Dataflow"
        r0718 = c.signer.backend -> besu.rpc1 "Submits raw transactions and reads" "HTTP JSON-RPC" "Dataflow"
        r0719 = c.signer -> besu.rpc2 "Submits signed transactions and queries state" "HTTP JSON-RPC" "Dataflow"
        r0720 = c.signer.backend -> besu.rpc2 "Submits raw transactions and reads" "HTTP JSON-RPC" "Dataflow"
        r0721 = c.signer -> besu.rpc3 "Submits signed transactions and queries state" "HTTP JSON-RPC" "Dataflow"
        r0722 = c.signer.backend -> besu.rpc3 "Submits raw transactions and reads" "HTTP JSON-RPC" "Dataflow"
        r0723 = c.dx -> a.dx "Transfers private envelopes and blobs; receives ACKs" "HTTPS / mutual TLS" "PrivateFlow"
        r0724 = c.ipfs -> a.ipfs "Retrieves shared content blocks by CID" "IPFS / libp2p" "SharedFlow"
        r0725 = c.dx -> b.dx "Transfers private envelopes and blobs; receives ACKs" "HTTPS / mutual TLS" "PrivateFlow"
        r0726 = c.ipfs -> b.ipfs "Retrieves shared content blocks by CID" "IPFS / libp2p" "SharedFlow"
        r0727 = business -> apps.a "Submits business actions" "HTTPS" "Dataflow"
        r0728 = apps.a -> a.core "Submits member-scoped commands and queries" "HTTPS / REST" "Dataflow"
        r0729 = a.core -> apps.a "Delivers subscribed events and accepts ACKs" "WebSocket / webhook / HTTPS" "Dataflow"
        r0730 = apps.a -> a.core.api "Submits API commands and queries" "HTTPS / REST" "Dataflow"
        r0731 = a.core.eventplugin -> apps.a "Delivers events through configured transports" "WebSocket / webhook / HTTPS" "Dataflow"
        r0732 = apps -> a "Submits member requests and consumes events" "HTTPS + WebSocket" "Dataflow"
        r0733 = business -> apps.b "Submits business actions" "HTTPS" "Dataflow"
        r0734 = apps.b -> b.core "Submits member-scoped commands and queries" "HTTPS / REST" "Dataflow"
        r0735 = b.core -> apps.b "Delivers subscribed events and accepts ACKs" "WebSocket / webhook / HTTPS" "Dataflow"
        r0736 = apps.b -> b.core.api "Submits API commands and queries" "HTTPS / REST" "Dataflow"
        r0737 = b.core.eventplugin -> apps.b "Delivers events through configured transports" "WebSocket / webhook / HTTPS" "Dataflow"
        r0738 = apps -> b "Submits member requests and consumes events" "HTTPS + WebSocket" "Dataflow"
        r0739 = business -> apps.c "Submits business actions" "HTTPS" "Dataflow"
        r0740 = apps.c -> c.core "Submits member-scoped commands and queries" "HTTPS / REST" "Dataflow"
        r0741 = c.core -> apps.c "Delivers subscribed events and accepts ACKs" "WebSocket / webhook / HTTPS" "Dataflow"
        r0742 = apps.c -> c.core.api "Submits API commands and queries" "HTTPS / REST" "Dataflow"
        r0743 = c.core.eventplugin -> apps.c "Delivers events through configured transports" "WebSocket / webhook / HTTPS" "Dataflow"
        r0744 = apps -> c "Submits member requests and consumes events" "HTTPS + WebSocket" "Dataflow"
        r0745 = business -> apps "Submits consortium business actions" "HTTPS" "Dataflow"
        r0746 = tools.sandbox.frontend -> tools.sandbox.backend "Submits selected sample actions" "HTTP / JSON" "Dataflow"
        r0747 = tools.sandbox.backend -> tools.sandbox.sdk "Submits SDK requests" "In-process calls / TypeScript" "Dataflow"
        r0748 = tools.sandbox.sdk -> a.core "Invokes member APIs and consumes events" "HTTPS + WebSocket" "Dataflow"
        r0749 = tools.sandbox -> a.core "Exercises APIs and subscriptions" "HTTPS + WebSocket" "Dataflow"
        r0750 = tools.cli -> a.core "Registers and inspects development stacks" "HTTP / Admin API" "Dataflow"
        r0751 = developer -> tools "Develops and tests integrations" "CLI + HTTPS" "Dataflow"
        r0752 = developer -> tools.cli "Creates local test stacks" "Local process invocation" "Dataflow"
        r0753 = developer -> tools.sandbox "Exercises sample workflows" "HTTPS" "Dataflow"
        r0754 = tools -> a "Exercises the selected member API" "HTTPS + WebSocket" "Dataflow"
        r0755 = operator -> ops "Monitors availability and coordinates recovery" "HTTPS" "Operational"
        r0756 = operator -> ops.grafana "Reviews quorum and recovery measurements" "HTTPS" "Operational"
        r0757 = ops.grafana -> ops.prometheus "Queries operational time series" "HTTP / PromQL" "Operational"
        r0758 = ops -> a "Routes API requests and observes health" "HTTPS + metrics" "Operational"
        r0759 = ops.gateway -> a.core "Routes authenticated API requests" "HTTPS / REST + WebSocket" "Operational"
        r0760 = ops.gateway -> a.dx "Passes peer TLS sessions without terminating mTLS" "TCP / TLS passthrough" "PrivateFlow"
        r0761 = ops.cnpg -> a.pg "Reconciles primary role and health" "Kubernetes API / operator control" "Operational"
        r0762 = ops.cnpg -> a.pgReplica "Reconciles replication and failover candidates" "Kubernetes API / operator control" "Operational"
        r0763 = ops.prometheus -> a.core "Scrapes member runtime measurements" "HTTP / Prometheus metrics" "Operational"
        r0764 = ops -> b "Routes API requests and observes health" "HTTPS + metrics" "Operational"
        r0765 = ops.gateway -> b.core "Routes authenticated API requests" "HTTPS / REST + WebSocket" "Operational"
        r0766 = ops.gateway -> b.dx "Passes peer TLS sessions without terminating mTLS" "TCP / TLS passthrough" "PrivateFlow"
        r0767 = ops.cnpg -> b.pg "Reconciles primary role and health" "Kubernetes API / operator control" "Operational"
        r0768 = ops.cnpg -> b.pgReplica "Reconciles replication and failover candidates" "Kubernetes API / operator control" "Operational"
        r0769 = ops.prometheus -> b.core "Scrapes member runtime measurements" "HTTP / Prometheus metrics" "Operational"
        r0770 = ops -> c "Routes API requests and observes health" "HTTPS + metrics" "Operational"
        r0771 = ops.gateway -> c.core "Routes authenticated API requests" "HTTPS / REST + WebSocket" "Operational"
        r0772 = ops.gateway -> c.dx "Passes peer TLS sessions without terminating mTLS" "TCP / TLS passthrough" "PrivateFlow"
        r0773 = ops.cnpg -> c.pg "Reconciles primary role and health" "Kubernetes API / operator control" "Operational"
        r0774 = ops.cnpg -> c.pgReplica "Reconciles replication and failover candidates" "Kubernetes API / operator control" "Operational"
        r0775 = ops.prometheus -> c.core "Scrapes member runtime measurements" "HTTP / Prometheus metrics" "Operational"
        r0776 = ops.prometheus -> besu.a1 "Scrapes peer, block and consensus measurements" "HTTP / Prometheus metrics" "Operational"
        r0777 = ops.prometheus -> besu.b1 "Scrapes peer, block and consensus measurements" "HTTP / Prometheus metrics" "Operational"
        r0778 = ops.prometheus -> besu.b2 "Scrapes peer, block and consensus measurements" "HTTP / Prometheus metrics" "Operational"
        r0779 = ops.prometheus -> besu.c1 "Scrapes peer, block and consensus measurements" "HTTP / Prometheus metrics" "Operational"
        r0780 = ops.prometheus -> besu.c2 "Scrapes peer, block and consensus measurements" "HTTP / Prometheus metrics" "Operational"
        r0781 = ops.prometheus -> besu.a2 "Scrapes peer, block and consensus measurements" "HTTP / Prometheus metrics" "Operational"
        r0782 = ops.prometheus -> besu.rpc1 "Scrapes peer, block and consensus measurements" "HTTP / Prometheus metrics" "Operational"
        r0783 = ops.prometheus -> besu.rpc2 "Scrapes peer, block and consensus measurements" "HTTP / Prometheus metrics" "Operational"
        r0784 = ops.prometheus -> besu.rpc3 "Scrapes peer, block and consensus measurements" "HTTP / Prometheus metrics" "Operational"
        r0785 = ops -> besu "Observes peer and quorum health" "HTTP / metrics" "Operational"
        r0786 = a -> ethconnect "Can route blockchain operations here when configured instead" "Connector API / backend-specific transport" "Alternative"
        r0787 = a.core -> ethconnect "Can bind the blockchain plugin to this alternative" "Connector API / backend-specific transport" "Alternative"
        r0788 = a -> fabric "Can route blockchain operations here when configured instead" "Connector API / backend-specific transport" "Alternative"
        r0789 = a.core -> fabric "Can bind the blockchain plugin to this alternative" "Connector API / backend-specific transport" "Alternative"
        r0790 = a -> tezos "Can route blockchain operations here when configured instead" "Connector API / backend-specific transport" "Alternative"
        r0791 = a.core -> tezos "Can bind the blockchain plugin to this alternative" "Connector API / backend-specific transport" "Alternative"
        r0792 = a -> cardano "Can route blockchain operations here when configured instead" "Connector API / backend-specific transport" "Alternative"
        r0793 = a.core -> cardano "Can bind the blockchain plugin to this alternative" "Connector API / backend-specific transport" "Alternative"
        r0794 = a -> corda "Can route blockchain operations here when configured instead" "Connector API / backend-specific transport" "Alternative"
        r0795 = a.core -> corda "Can bind the blockchain plugin to this alternative" "Connector API / backend-specific transport" "Alternative"
        production = deploymentEnvironment "AKS reference" {
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
                                instance = containerInstance ops.gateway {
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
                                instance = containerInstance ops.cnpg {
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
                                instance = containerInstance ops.prometheus {
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
                                instance = containerInstance ops.grafana {
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
                                    instance = containerInstance a.core {
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
                                    instance = containerInstance a.evm {
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
                                    instance = containerInstance a.signer {
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
                                    instance = containerInstance a.dx {
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
                                    instance = containerInstance a.erc20 {
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
                                    instance = containerInstance a.erc1155 {
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
                                    instance = containerInstance a.ipfs {
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
                                    store = containerInstance a.blobs {
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
                                    store = containerInstance a.ipfsRepo {
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
                                instance = containerInstance a.pg {
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
                                instance = containerInstance b.pgReplica {
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
                                instance = containerInstance c.pgReplica {
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
                            besua1 = deploymentNode "Besu validator A1 pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az1.data.besua1"
                                }
                                instance = containerInstance besu.a1 {
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
                            besub1 = deploymentNode "Besu validator B1 pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az1.data.besub1"
                                }
                                instance = containerInstance besu.b1 {
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
                            besurpc1 = deploymentNode "Besu RPC node 1 pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az1.data.besurpc1"
                                }
                                instance = containerInstance besu.rpc1 {
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
                                instance = containerInstance ops.gateway {
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
                                instance = containerInstance ops.cnpg {
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
                                instance = containerInstance ops.prometheus {
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
                                    instance = containerInstance b.core {
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
                                    instance = containerInstance b.evm {
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
                                    instance = containerInstance b.signer {
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
                                    instance = containerInstance b.dx {
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
                                    instance = containerInstance b.erc20 {
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
                                    instance = containerInstance b.erc1155 {
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
                                    instance = containerInstance b.ipfs {
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
                                    store = containerInstance b.blobs {
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
                                    store = containerInstance b.ipfsRepo {
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
                                instance = containerInstance a.pgReplica {
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
                                instance = containerInstance b.pg {
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
                                instance = containerInstance c.pgReplica {
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
                            besub2 = deploymentNode "Besu validator B2 pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az2.data.besub2"
                                }
                                instance = containerInstance besu.b2 {
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
                            besuc1 = deploymentNode "Besu validator C1 pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az2.data.besuc1"
                                }
                                instance = containerInstance besu.c1 {
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
                            besurpc2 = deploymentNode "Besu RPC node 2 pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az2.data.besurpc2"
                                }
                                instance = containerInstance besu.rpc2 {
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
                                instance = containerInstance ops.gateway {
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
                                instance = containerInstance ops.cnpg {
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
                                instance = containerInstance ops.prometheus {
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
                                    instance = containerInstance c.core {
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
                                    instance = containerInstance c.evm {
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
                                    instance = containerInstance c.signer {
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
                                    instance = containerInstance c.dx {
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
                                    instance = containerInstance c.erc20 {
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
                                    instance = containerInstance c.erc1155 {
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
                                    instance = containerInstance c.ipfs {
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
                                    store = containerInstance c.blobs {
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
                                    store = containerInstance c.ipfsRepo {
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
                                instance = containerInstance a.pgReplica {
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
                                instance = containerInstance b.pgReplica {
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
                                instance = containerInstance c.pg {
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
                            besuc2 = deploymentNode "Besu validator C2 pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az3.data.besuc2"
                                }
                                instance = containerInstance besu.c2 {
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
                            besua2 = deploymentNode "Besu validator A2 pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az3.data.besua2"
                                }
                                instance = containerInstance besu.a2 {
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
                            besurpc3 = deploymentNode "Besu RPC node 3 pod" "Unique node key and data directory; node anti-affinity; private P2P." "Kubernetes StatefulSet" {
                                tags "Blockchain"
                                properties {
                                    "architecture.id" "azure.cluster.az3.data.besurpc3"
                                }
                                instance = containerInstance besu.rpc3 {
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
                }
                lb = infrastructureNode "Zone-redundant load balancer" "Exposes private member API and passthrough peer endpoints." "Azure Standard Load Balancer" {
                    tags "Operational"
                    properties {
                        "architecture.id" "azure.lb"
                    }
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
                }
                secretStores = deploymentNode "Member secret stores" "Separate namespace objects containing encrypted keystores and credentials." "Kubernetes Secrets" {
                    properties {
                        "architecture.id" "azure.secretStores"
                    }
                    a = containerInstance a.secrets {
                        properties {
                            "architecture.id" "azure.secretStores.a"
                            "member" "a"
                            "zone" "regional"
                            "role" "projected configuration"
                        }
                    }
                    b = containerInstance b.secrets {
                        properties {
                            "architecture.id" "azure.secretStores.b"
                            "member" "b"
                            "zone" "regional"
                            "role" "projected configuration"
                        }
                    }
                    c = containerInstance c.secrets {
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
                }
            }
            d0001 = azure.control -> azure.secrets "Stores and projects namespace configuration" "Kubernetes API / TLS" "Operational"
            d0002 = azure.control -> azure.csi "Reconciles volume attachments" "Kubernetes API / TLS" "Operational"
            d0003 = azure.control -> azure.cluster.az1.system.agent "Schedules and reconciles system workloads" "Kubernetes API / TLS" "Operational"
            d0004 = azure.lb -> azure.cluster.az1.apps.gateway.instance "Routes HTTPS and peer TLS sessions" "TCP / TLS" "Operational"
            d0005 = azure.cluster.az1.apps.cnpg.instance -> azure.control "Watches clusters and updates primary Services" "Kubernetes API / TLS" "Operational"
            d0006 = azure.control -> azure.cluster.az2.system.agent "Schedules and reconciles system workloads" "Kubernetes API / TLS" "Operational"
            d0007 = azure.lb -> azure.cluster.az2.apps.gateway.instance "Routes HTTPS and peer TLS sessions" "TCP / TLS" "Operational"
            d0008 = azure.cluster.az2.apps.cnpg.instance -> azure.control "Watches clusters and updates primary Services" "Kubernetes API / TLS" "Operational"
            d0009 = azure.control -> azure.cluster.az3.system.agent "Schedules and reconciles system workloads" "Kubernetes API / TLS" "Operational"
            d0010 = azure.lb -> azure.cluster.az3.apps.gateway.instance "Routes HTTPS and peer TLS sessions" "TCP / TLS" "Operational"
            d0011 = azure.cluster.az3.apps.cnpg.instance -> azure.control "Watches clusters and updates primary Services" "Kubernetes API / TLS" "Operational"
            d0012 = azure.cluster.az1.apps.memberA.core.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0013 = azure.cluster.az1.apps.memberA.evm.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0014 = azure.cluster.az1.apps.memberA.signer.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0015 = azure.cluster.az1.apps.memberA.dx.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0016 = azure.cluster.az1.apps.memberA.erc20.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0017 = azure.cluster.az1.apps.memberA.erc1155.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0018 = azure.cluster.az1.apps.memberA.ipfs.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0019 = azure.csi -> azure.cluster.az1.apps.memberA.blobs.store "Provisions and safely attaches member storage" "CSI / Azure ARM" "Operational"
            d0020 = azure.csi -> azure.cluster.az1.apps.memberA.ipfsRepo.store "Provisions and safely attaches member storage" "CSI / Azure ARM" "Operational"
            d0021 = azure.cluster.az1.data.pgA.instance -> azure.cluster.az1.data.pgA.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
            d0022 = azure.csi -> azure.cluster.az1.data.pgA.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
            d0023 = azure.cluster.az2.data.pgA.instance -> azure.cluster.az2.data.pgA.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
            d0024 = azure.csi -> azure.cluster.az2.data.pgA.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
            d0025 = azure.cluster.az3.data.pgA.instance -> azure.cluster.az3.data.pgA.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
            d0026 = azure.csi -> azure.cluster.az3.data.pgA.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
            d0027 = azure.cluster.az2.apps.memberB.core.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0028 = azure.cluster.az2.apps.memberB.evm.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0029 = azure.cluster.az2.apps.memberB.signer.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0030 = azure.cluster.az2.apps.memberB.dx.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0031 = azure.cluster.az2.apps.memberB.erc20.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0032 = azure.cluster.az2.apps.memberB.erc1155.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0033 = azure.cluster.az2.apps.memberB.ipfs.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0034 = azure.csi -> azure.cluster.az2.apps.memberB.blobs.store "Provisions and safely attaches member storage" "CSI / Azure ARM" "Operational"
            d0035 = azure.csi -> azure.cluster.az2.apps.memberB.ipfsRepo.store "Provisions and safely attaches member storage" "CSI / Azure ARM" "Operational"
            d0036 = azure.cluster.az1.data.pgB.instance -> azure.cluster.az1.data.pgB.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
            d0037 = azure.csi -> azure.cluster.az1.data.pgB.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
            d0038 = azure.cluster.az2.data.pgB.instance -> azure.cluster.az2.data.pgB.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
            d0039 = azure.csi -> azure.cluster.az2.data.pgB.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
            d0040 = azure.cluster.az3.data.pgB.instance -> azure.cluster.az3.data.pgB.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
            d0041 = azure.csi -> azure.cluster.az3.data.pgB.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
            d0042 = azure.cluster.az3.apps.memberC.core.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0043 = azure.cluster.az3.apps.memberC.evm.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0044 = azure.cluster.az3.apps.memberC.signer.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0045 = azure.cluster.az3.apps.memberC.dx.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0046 = azure.cluster.az3.apps.memberC.erc20.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0047 = azure.cluster.az3.apps.memberC.erc1155.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0048 = azure.cluster.az3.apps.memberC.ipfs.instance -> azure.secrets "Reads projected member configuration" "Read-only projected files" "Operational"
            d0049 = azure.csi -> azure.cluster.az3.apps.memberC.blobs.store "Provisions and safely attaches member storage" "CSI / Azure ARM" "Operational"
            d0050 = azure.csi -> azure.cluster.az3.apps.memberC.ipfsRepo.store "Provisions and safely attaches member storage" "CSI / Azure ARM" "Operational"
            d0051 = azure.cluster.az1.data.pgC.instance -> azure.cluster.az1.data.pgC.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
            d0052 = azure.csi -> azure.cluster.az1.data.pgC.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
            d0053 = azure.cluster.az2.data.pgC.instance -> azure.cluster.az2.data.pgC.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
            d0054 = azure.csi -> azure.cluster.az2.data.pgC.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
            d0055 = azure.cluster.az3.data.pgC.instance -> azure.cluster.az3.data.pgC.volume "Reads and writes database pages and WAL" "Filesystem I/O" "Operational"
            d0056 = azure.csi -> azure.cluster.az3.data.pgC.volume "Provisions a dedicated PGDATA volume" "CSI / Azure ARM" "Operational"
            d0057 = azure.cluster.az1.data.besua1.instance -> azure.cluster.az1.data.besua1.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            d0058 = azure.cluster.az1.data.besua1.instance -> azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
            d0059 = azure.csi -> azure.cluster.az1.data.besua1.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
            d0060 = azure.cluster.az1.data.besub1.instance -> azure.cluster.az1.data.besub1.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            d0061 = azure.cluster.az1.data.besub1.instance -> azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
            d0062 = azure.csi -> azure.cluster.az1.data.besub1.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
            d0063 = azure.cluster.az2.data.besub2.instance -> azure.cluster.az2.data.besub2.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            d0064 = azure.cluster.az2.data.besub2.instance -> azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
            d0065 = azure.csi -> azure.cluster.az2.data.besub2.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
            d0066 = azure.cluster.az2.data.besuc1.instance -> azure.cluster.az2.data.besuc1.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            d0067 = azure.cluster.az2.data.besuc1.instance -> azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
            d0068 = azure.csi -> azure.cluster.az2.data.besuc1.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
            d0069 = azure.cluster.az3.data.besuc2.instance -> azure.cluster.az3.data.besuc2.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            d0070 = azure.cluster.az3.data.besuc2.instance -> azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
            d0071 = azure.csi -> azure.cluster.az3.data.besuc2.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
            d0072 = azure.cluster.az3.data.besua2.instance -> azure.cluster.az3.data.besua2.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            d0073 = azure.cluster.az3.data.besua2.instance -> azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
            d0074 = azure.csi -> azure.cluster.az3.data.besua2.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
            d0075 = azure.cluster.az1.data.besurpc1.instance -> azure.cluster.az1.data.besurpc1.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            d0076 = azure.cluster.az1.data.besurpc1.instance -> azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
            d0077 = azure.csi -> azure.cluster.az1.data.besurpc1.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
            d0078 = azure.cluster.az2.data.besurpc2.instance -> azure.cluster.az2.data.besurpc2.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            d0079 = azure.cluster.az2.data.besurpc2.instance -> azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
            d0080 = azure.csi -> azure.cluster.az2.data.besurpc2.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
            d0081 = azure.cluster.az3.data.besurpc3.instance -> azure.cluster.az3.data.besurpc3.volume "Persists ledger, receipts and world state" "Filesystem I/O" "Operational"
            d0082 = azure.cluster.az3.data.besurpc3.instance -> azure.secrets "Reads its unique Besu node key" "Read-only projected secret" "Operational"
            d0083 = azure.csi -> azure.cluster.az3.data.besurpc3.volume "Provisions a node-specific ledger volume" "CSI / Azure ARM" "Operational"
            d0084 = azure.cluster.az1.apps.memberA.signer.instance -> azure.rpc "Sends signed transactions and queries" "HTTP JSON-RPC" "Operational"
            d0085 = azure.cluster.az2.apps.memberB.signer.instance -> azure.rpc "Sends signed transactions and queries" "HTTP JSON-RPC" "Operational"
            d0086 = azure.cluster.az3.apps.memberC.signer.instance -> azure.rpc "Sends signed transactions and queries" "HTTP JSON-RPC" "Operational"
            d0087 = azure.rpc -> azure.cluster.az1.data.besurpc1.instance "Routes pinned JSON-RPC sessions" "HTTP JSON-RPC" "Operational"
            d0088 = azure.rpc -> azure.cluster.az2.data.besurpc2.instance "Routes pinned JSON-RPC sessions" "HTTP JSON-RPC" "Operational"
            d0089 = azure.rpc -> azure.cluster.az3.data.besurpc3.instance "Routes pinned JSON-RPC sessions" "HTTP JSON-RPC" "Operational"
        }
    }
    views {
        systemLandscape "01-landscape" "System Landscape - three-member consortium" {
            title "System Landscape - three-member consortium"
            include business developer operator apps tools a b c besu ops
            exclude *->*
            include r0688 r0689 r0696 r0699 r0702 r0703 r0712 r0715 r0716 r0732 r0738 r0744 r0745 r0751 r0754 r0755 r0758 r0764 r0770 r0785
            autoLayout lr 360 200
        }
        systemContext a "02-context-a" "System Context - Member A" {
            title "System Context - Member A"
            include a apps operator besu ops b c tools
            exclude *->*
            include r0688 r0689 r0696 r0699 r0702 r0703 r0712 r0715 r0716 r0732 r0738 r0744 r0754 r0755 r0758 r0764 r0770 r0785
            autoLayout lr 360 200
        }
        systemContext b "02-context-b" "System Context - Member B" {
            title "System Context - Member B"
            include b apps operator besu ops a c
            exclude *->*
            include r0688 r0689 r0696 r0699 r0702 r0703 r0712 r0715 r0716 r0732 r0738 r0744 r0755 r0758 r0764 r0770 r0785
            autoLayout lr 360 200
        }
        systemContext c "02-context-c" "System Context - Member C" {
            title "System Context - Member C"
            include c apps operator besu ops a b
            exclude *->*
            include r0688 r0689 r0696 r0699 r0702 r0703 r0712 r0715 r0716 r0732 r0738 r0744 r0755 r0758 r0764 r0770 r0785
            autoLayout lr 360 200
        }
        systemContext besu "03-context-besu" "System Context - private Besu network" {
            title "System Context - private Besu network"
            include a b c besu ops
            exclude *->*
            include r0688 r0696 r0699 r0702 r0712 r0715 r0758 r0764 r0770 r0785
            autoLayout lr 360 200
        }
        systemLandscape "04-alternatives" "System Landscape - alternative blockchain integrations" {
            title "System Landscape - alternative blockchain integrations"
            include a ethconnect fabric tezos cardano corda
            exclude *->*
            include r0786 r0788 r0790 r0792 r0794
            autoLayout lr 360 200
        }
        container a "10-a-runtime" "Container - Member A orchestration and connectors" {
            title "Container - Member A orchestration and connectors"
            include a.core a.evm a.signer a.dx a.erc20 a.erc1155 a.ipfs a.pg apps.a besu.rpc1 b.dx c.dx
            exclude *->*
            include r0106 r0107 r0108 r0109 r0110 r0111 r0112 r0113 r0114 r0115 r0116 r0117 r0118 r0120 r0690 r0697 r0700 r0710 r0713 r0723 r0725 r0728 r0729
            autoLayout lr 360 200
        }
        container a "11-a-state" "Container - Member A private state and shared storage" {
            title "Container - Member A private state and shared storage"
            include a.core a.evm a.signer a.dx a.ipfs a.pg a.pgReplica a.blobs a.ipfsRepo a.secrets b.ipfs c.ipfs
            exclude *->*
            include r0106 r0107 r0108 r0109 r0116 r0117 r0118 r0119 r0120 r0121 r0122 r0123 r0124 r0125 r0126 r0698 r0701 r0711 r0714 r0724 r0726
            autoLayout lr 360 200
        }
        component a.core "20-a-core-api" "Component - Member A Core: API, tenancy and Explorer" {
            title "Component - Member A Core: API, tenancy and Explorer"
            include a.core.explorer a.core.api a.core.auth a.core.namespaces a.core.orchestrator a.core.syncasync a.core.spievents a.core.eventplugin apps.a
            exclude *->*
            include r0001 r0002 r0003 r0004 r0005 r0006 r0050 r0051 r0730 r0731
            autoLayout lr 360 200
        }
        component a.core "20-a-core-identity" "Component - Member A Core: Identity and multiparty coordination" {
            title "Component - Member A Core: Identity and multiparty coordination"
            include a.core.orchestrator a.core.identity a.core.identityplugin a.core.networkmap a.core.definitions a.core.broadcast a.core.multiparty a.core.blockchain
            exclude *->*
            include r0007 r0008 r0009 r0010 r0011 r0012 r0013 r0023
            autoLayout lr 360 200
        }
        component a.core "20-a-core-messaging" "Component - Member A Core: Payloads and outbound messaging" {
            title "Component - Member A Core: Payloads and outbound messaging"
            include a.core.orchestrator a.core.data a.core.schema a.core.batch a.core.batchprocessor a.core.broadcast a.core.private a.core.dataexchange a.core.sharedstorage a.core.multiparty a.dx a.ipfs
            exclude *->*
            include r0012 r0014 r0015 r0017 r0018 r0019 r0020 r0021 r0022 r0023 r0024 r0025 r0130 r0131
            autoLayout lr 360 200
        }
        component a.core "20-a-core-contracts" "Component - Member A Core: Contracts, tokens and operations" {
            title "Component - Member A Core: Contracts, tokens and operations"
            include a.core.orchestrator a.core.contracts a.core.assets a.core.tokens a.core.blockchain a.core.operations a.core.txhelper a.core.txwriter a.core.database a.evm a.erc20 a.erc1155
            exclude *->*
            include r0027 r0028 r0029 r0030 r0031 r0032 r0033 r0034 r0035 r0036 r0037 r0114 r0115 r0127 r0132 r0133
            autoLayout lr 360 200
        }
        component a.core "20-a-core-events" "Component - Member A Core: Inbound sequencing and event delivery" {
            title "Component - Member A Core: Inbound sequencing and event delivery"
            include a.core.blockchain a.core.dataexchange a.core.tokens a.core.aggregator a.core.download a.core.subscriptions a.core.dispatcher a.core.eventplugin a.core.syncasync a.core.database apps.a
            exclude *->*
            include r0038 r0039 r0040 r0041 r0044 r0045 r0046 r0047 r0048 r0049 r0731
            autoLayout lr 360 200
        }
        component a.core "20-a-core-persistence" "Component - Member A Core: Persistence and operational support" {
            title "Component - Member A Core: Persistence and operational support"
            include a.core.orchestrator a.core.data a.core.download a.core.sharedstorage a.core.contracts a.core.operations a.core.txwriter a.core.database a.core.cache a.core.metrics a.pg a.ipfs
            exclude *->*
            include r0014 r0016 r0027 r0032 r0036 r0037 r0042 r0043 r0052 r0053 r0054 r0055 r0129 r0131
            autoLayout lr 360 200
        }
        component a.evm "30-a-evm-transactions" "Component - Member A EVMConnect: Transaction submission" {
            title "Component - Member A EVMConnect: Transaction submission"
            include a.evm.api a.evm.manager a.evm.handler a.evm.nonce a.evm.abi a.evm.rpc a.evm.persistence a.pg a.signer
            exclude *->*
            include r0056 r0057 r0058 r0059 r0060 r0061 r0072 r0134 r0135
            autoLayout lr 360 200
        }
        component a.evm "30-a-evm-events" "Component - Member A EVMConnect: Block tracking and events" {
            title "Component - Member A EVMConnect: Block tracking and events"
            include a.evm.manager a.evm.blocks a.evm.receipts a.evm.rpc a.evm.confirmations a.evm.streams a.evm.delivery a.evm.persistence a.pg a.signer a.core
            exclude *->*
            include r0063 r0064 r0065 r0066 r0067 r0068 r0069 r0070 r0071 r0072 r0117 r0128 r0134 r0135
            autoLayout lr 360 200
        }
        component a.signer "40-a-signer" "Component - Member A transaction signing" {
            title "Component - Member A transaction signing"
            include a.signer.proxy a.signer.wallet a.signer.keystore a.signer.signing a.signer.backend a.secrets besu.rpc1
            exclude *->*
            include r0073 r0074 r0075 r0076 r0077 r0078 r0136 r0691
            autoLayout lr 360 200
        }
        component a.dx "40-a-dx" "Component - Member A private data exchange" {
            title "Component - Member A private data exchange"
            include a.dx.api a.dx.peers a.dx.p2p a.dx.messages a.dx.blobs a.dx.events a.blobs a.secrets
            exclude *->*
            include r0079 r0080 r0081 r0082 r0083 r0084 r0085 r0086 r0087 r0088 r0089 r0137 r0138 r0139
            autoLayout lr 360 200
        }
        component a.erc20 "40-a-erc20" "Component - Member A ERC-20 / ERC-721" {
            title "Component - Member A ERC-20 / ERC-721"
            include a.erc20.api a.erc20.service a.erc20.mapper a.erc20.blockchain a.erc20.listener a.erc20.stream a.erc20.proxy a.core a.evm
            exclude *->*
            include r0090 r0091 r0092 r0093 r0094 r0095 r0096 r0097 r0106 r0107 r0140 r0141 r0142
            autoLayout lr 360 200
        }
        component a.erc1155 "40-a-erc1155" "Component - Member A ERC-1155" {
            title "Component - Member A ERC-1155"
            include a.erc1155.api a.erc1155.service a.erc1155.mapper a.erc1155.blockchain a.erc1155.listener a.erc1155.stream a.erc1155.proxy a.core a.evm
            exclude *->*
            include r0098 r0099 r0100 r0101 r0102 r0103 r0104 r0105 r0106 r0107 r0143 r0144 r0145
            autoLayout lr 360 200
        }
        container b "10-b-runtime" "Container - Member B orchestration and connectors" {
            title "Container - Member B orchestration and connectors"
            include b.core b.evm b.signer b.dx b.erc20 b.erc1155 b.ipfs b.pg apps.b besu.rpc1 a.dx c.dx
            exclude *->*
            include r0251 r0252 r0253 r0254 r0255 r0256 r0257 r0258 r0259 r0260 r0261 r0262 r0263 r0265 r0697 r0700 r0704 r0710 r0713 r0723 r0725 r0734 r0735
            autoLayout lr 360 200
        }
        container b "11-b-state" "Container - Member B private state and shared storage" {
            title "Container - Member B private state and shared storage"
            include b.core b.evm b.signer b.dx b.ipfs b.pg b.pgReplica b.blobs b.ipfsRepo b.secrets a.ipfs c.ipfs
            exclude *->*
            include r0251 r0252 r0253 r0254 r0261 r0262 r0263 r0264 r0265 r0266 r0267 r0268 r0269 r0270 r0271 r0698 r0701 r0711 r0714 r0724 r0726
            autoLayout lr 360 200
        }
        component b.core "20-b-core-api" "Component - Member B Core: API, tenancy and Explorer" {
            title "Component - Member B Core: API, tenancy and Explorer"
            include b.core.explorer b.core.api b.core.auth b.core.namespaces b.core.orchestrator b.core.syncasync b.core.spievents b.core.eventplugin apps.b
            exclude *->*
            include r0146 r0147 r0148 r0149 r0150 r0151 r0195 r0196 r0736 r0737
            autoLayout lr 360 200
        }
        component b.core "20-b-core-identity" "Component - Member B Core: Identity and multiparty coordination" {
            title "Component - Member B Core: Identity and multiparty coordination"
            include b.core.orchestrator b.core.identity b.core.identityplugin b.core.networkmap b.core.definitions b.core.broadcast b.core.multiparty b.core.blockchain
            exclude *->*
            include r0152 r0153 r0154 r0155 r0156 r0157 r0158 r0168
            autoLayout lr 360 200
        }
        component b.core "20-b-core-messaging" "Component - Member B Core: Payloads and outbound messaging" {
            title "Component - Member B Core: Payloads and outbound messaging"
            include b.core.orchestrator b.core.data b.core.schema b.core.batch b.core.batchprocessor b.core.broadcast b.core.private b.core.dataexchange b.core.sharedstorage b.core.multiparty b.dx b.ipfs
            exclude *->*
            include r0157 r0159 r0160 r0162 r0163 r0164 r0165 r0166 r0167 r0168 r0169 r0170 r0275 r0276
            autoLayout lr 360 200
        }
        component b.core "20-b-core-contracts" "Component - Member B Core: Contracts, tokens and operations" {
            title "Component - Member B Core: Contracts, tokens and operations"
            include b.core.orchestrator b.core.contracts b.core.assets b.core.tokens b.core.blockchain b.core.operations b.core.txhelper b.core.txwriter b.core.database b.evm b.erc20 b.erc1155
            exclude *->*
            include r0172 r0173 r0174 r0175 r0176 r0177 r0178 r0179 r0180 r0181 r0182 r0259 r0260 r0272 r0277 r0278
            autoLayout lr 360 200
        }
        component b.core "20-b-core-events" "Component - Member B Core: Inbound sequencing and event delivery" {
            title "Component - Member B Core: Inbound sequencing and event delivery"
            include b.core.blockchain b.core.dataexchange b.core.tokens b.core.aggregator b.core.download b.core.subscriptions b.core.dispatcher b.core.eventplugin b.core.syncasync b.core.database apps.b
            exclude *->*
            include r0183 r0184 r0185 r0186 r0189 r0190 r0191 r0192 r0193 r0194 r0737
            autoLayout lr 360 200
        }
        component b.core "20-b-core-persistence" "Component - Member B Core: Persistence and operational support" {
            title "Component - Member B Core: Persistence and operational support"
            include b.core.orchestrator b.core.data b.core.download b.core.sharedstorage b.core.contracts b.core.operations b.core.txwriter b.core.database b.core.cache b.core.metrics b.pg b.ipfs
            exclude *->*
            include r0159 r0161 r0172 r0177 r0181 r0182 r0187 r0188 r0197 r0198 r0199 r0200 r0274 r0276
            autoLayout lr 360 200
        }
        component b.evm "30-b-evm-transactions" "Component - Member B EVMConnect: Transaction submission" {
            title "Component - Member B EVMConnect: Transaction submission"
            include b.evm.api b.evm.manager b.evm.handler b.evm.nonce b.evm.abi b.evm.rpc b.evm.persistence b.pg b.signer
            exclude *->*
            include r0201 r0202 r0203 r0204 r0205 r0206 r0217 r0279 r0280
            autoLayout lr 360 200
        }
        component b.evm "30-b-evm-events" "Component - Member B EVMConnect: Block tracking and events" {
            title "Component - Member B EVMConnect: Block tracking and events"
            include b.evm.manager b.evm.blocks b.evm.receipts b.evm.rpc b.evm.confirmations b.evm.streams b.evm.delivery b.evm.persistence b.pg b.signer b.core
            exclude *->*
            include r0208 r0209 r0210 r0211 r0212 r0213 r0214 r0215 r0216 r0217 r0262 r0273 r0279 r0280
            autoLayout lr 360 200
        }
        component b.signer "40-b-signer" "Component - Member B transaction signing" {
            title "Component - Member B transaction signing"
            include b.signer.proxy b.signer.wallet b.signer.keystore b.signer.signing b.signer.backend b.secrets besu.rpc1
            exclude *->*
            include r0218 r0219 r0220 r0221 r0222 r0223 r0281 r0705
            autoLayout lr 360 200
        }
        component b.dx "40-b-dx" "Component - Member B private data exchange" {
            title "Component - Member B private data exchange"
            include b.dx.api b.dx.peers b.dx.p2p b.dx.messages b.dx.blobs b.dx.events b.blobs b.secrets
            exclude *->*
            include r0224 r0225 r0226 r0227 r0228 r0229 r0230 r0231 r0232 r0233 r0234 r0282 r0283 r0284
            autoLayout lr 360 200
        }
        component b.erc20 "40-b-erc20" "Component - Member B ERC-20 / ERC-721" {
            title "Component - Member B ERC-20 / ERC-721"
            include b.erc20.api b.erc20.service b.erc20.mapper b.erc20.blockchain b.erc20.listener b.erc20.stream b.erc20.proxy b.core b.evm
            exclude *->*
            include r0235 r0236 r0237 r0238 r0239 r0240 r0241 r0242 r0251 r0252 r0285 r0286 r0287
            autoLayout lr 360 200
        }
        component b.erc1155 "40-b-erc1155" "Component - Member B ERC-1155" {
            title "Component - Member B ERC-1155"
            include b.erc1155.api b.erc1155.service b.erc1155.mapper b.erc1155.blockchain b.erc1155.listener b.erc1155.stream b.erc1155.proxy b.core b.evm
            exclude *->*
            include r0243 r0244 r0245 r0246 r0247 r0248 r0249 r0250 r0251 r0252 r0288 r0289 r0290
            autoLayout lr 360 200
        }
        container c "10-c-runtime" "Container - Member C orchestration and connectors" {
            title "Container - Member C orchestration and connectors"
            include c.core c.evm c.signer c.dx c.erc20 c.erc1155 c.ipfs c.pg apps.c besu.rpc1 a.dx b.dx
            exclude *->*
            include r0396 r0397 r0398 r0399 r0400 r0401 r0402 r0403 r0404 r0405 r0406 r0407 r0408 r0410 r0697 r0700 r0710 r0713 r0717 r0723 r0725 r0740 r0741
            autoLayout lr 360 200
        }
        container c "11-c-state" "Container - Member C private state and shared storage" {
            title "Container - Member C private state and shared storage"
            include c.core c.evm c.signer c.dx c.ipfs c.pg c.pgReplica c.blobs c.ipfsRepo c.secrets a.ipfs b.ipfs
            exclude *->*
            include r0396 r0397 r0398 r0399 r0406 r0407 r0408 r0409 r0410 r0411 r0412 r0413 r0414 r0415 r0416 r0698 r0701 r0711 r0714 r0724 r0726
            autoLayout lr 360 200
        }
        component c.core "20-c-core-api" "Component - Member C Core: API, tenancy and Explorer" {
            title "Component - Member C Core: API, tenancy and Explorer"
            include c.core.explorer c.core.api c.core.auth c.core.namespaces c.core.orchestrator c.core.syncasync c.core.spievents c.core.eventplugin apps.c
            exclude *->*
            include r0291 r0292 r0293 r0294 r0295 r0296 r0340 r0341 r0742 r0743
            autoLayout lr 360 200
        }
        component c.core "20-c-core-identity" "Component - Member C Core: Identity and multiparty coordination" {
            title "Component - Member C Core: Identity and multiparty coordination"
            include c.core.orchestrator c.core.identity c.core.identityplugin c.core.networkmap c.core.definitions c.core.broadcast c.core.multiparty c.core.blockchain
            exclude *->*
            include r0297 r0298 r0299 r0300 r0301 r0302 r0303 r0313
            autoLayout lr 360 200
        }
        component c.core "20-c-core-messaging" "Component - Member C Core: Payloads and outbound messaging" {
            title "Component - Member C Core: Payloads and outbound messaging"
            include c.core.orchestrator c.core.data c.core.schema c.core.batch c.core.batchprocessor c.core.broadcast c.core.private c.core.dataexchange c.core.sharedstorage c.core.multiparty c.dx c.ipfs
            exclude *->*
            include r0302 r0304 r0305 r0307 r0308 r0309 r0310 r0311 r0312 r0313 r0314 r0315 r0420 r0421
            autoLayout lr 360 200
        }
        component c.core "20-c-core-contracts" "Component - Member C Core: Contracts, tokens and operations" {
            title "Component - Member C Core: Contracts, tokens and operations"
            include c.core.orchestrator c.core.contracts c.core.assets c.core.tokens c.core.blockchain c.core.operations c.core.txhelper c.core.txwriter c.core.database c.evm c.erc20 c.erc1155
            exclude *->*
            include r0317 r0318 r0319 r0320 r0321 r0322 r0323 r0324 r0325 r0326 r0327 r0404 r0405 r0417 r0422 r0423
            autoLayout lr 360 200
        }
        component c.core "20-c-core-events" "Component - Member C Core: Inbound sequencing and event delivery" {
            title "Component - Member C Core: Inbound sequencing and event delivery"
            include c.core.blockchain c.core.dataexchange c.core.tokens c.core.aggregator c.core.download c.core.subscriptions c.core.dispatcher c.core.eventplugin c.core.syncasync c.core.database apps.c
            exclude *->*
            include r0328 r0329 r0330 r0331 r0334 r0335 r0336 r0337 r0338 r0339 r0743
            autoLayout lr 360 200
        }
        component c.core "20-c-core-persistence" "Component - Member C Core: Persistence and operational support" {
            title "Component - Member C Core: Persistence and operational support"
            include c.core.orchestrator c.core.data c.core.download c.core.sharedstorage c.core.contracts c.core.operations c.core.txwriter c.core.database c.core.cache c.core.metrics c.pg c.ipfs
            exclude *->*
            include r0304 r0306 r0317 r0322 r0326 r0327 r0332 r0333 r0342 r0343 r0344 r0345 r0419 r0421
            autoLayout lr 360 200
        }
        component c.evm "30-c-evm-transactions" "Component - Member C EVMConnect: Transaction submission" {
            title "Component - Member C EVMConnect: Transaction submission"
            include c.evm.api c.evm.manager c.evm.handler c.evm.nonce c.evm.abi c.evm.rpc c.evm.persistence c.pg c.signer
            exclude *->*
            include r0346 r0347 r0348 r0349 r0350 r0351 r0362 r0424 r0425
            autoLayout lr 360 200
        }
        component c.evm "30-c-evm-events" "Component - Member C EVMConnect: Block tracking and events" {
            title "Component - Member C EVMConnect: Block tracking and events"
            include c.evm.manager c.evm.blocks c.evm.receipts c.evm.rpc c.evm.confirmations c.evm.streams c.evm.delivery c.evm.persistence c.pg c.signer c.core
            exclude *->*
            include r0353 r0354 r0355 r0356 r0357 r0358 r0359 r0360 r0361 r0362 r0407 r0418 r0424 r0425
            autoLayout lr 360 200
        }
        component c.signer "40-c-signer" "Component - Member C transaction signing" {
            title "Component - Member C transaction signing"
            include c.signer.proxy c.signer.wallet c.signer.keystore c.signer.signing c.signer.backend c.secrets besu.rpc1
            exclude *->*
            include r0363 r0364 r0365 r0366 r0367 r0368 r0426 r0718
            autoLayout lr 360 200
        }
        component c.dx "40-c-dx" "Component - Member C private data exchange" {
            title "Component - Member C private data exchange"
            include c.dx.api c.dx.peers c.dx.p2p c.dx.messages c.dx.blobs c.dx.events c.blobs c.secrets
            exclude *->*
            include r0369 r0370 r0371 r0372 r0373 r0374 r0375 r0376 r0377 r0378 r0379 r0427 r0428 r0429
            autoLayout lr 360 200
        }
        component c.erc20 "40-c-erc20" "Component - Member C ERC-20 / ERC-721" {
            title "Component - Member C ERC-20 / ERC-721"
            include c.erc20.api c.erc20.service c.erc20.mapper c.erc20.blockchain c.erc20.listener c.erc20.stream c.erc20.proxy c.core c.evm
            exclude *->*
            include r0380 r0381 r0382 r0383 r0384 r0385 r0386 r0387 r0396 r0397 r0430 r0431 r0432
            autoLayout lr 360 200
        }
        component c.erc1155 "40-c-erc1155" "Component - Member C ERC-1155" {
            title "Component - Member C ERC-1155"
            include c.erc1155.api c.erc1155.service c.erc1155.mapper c.erc1155.blockchain c.erc1155.listener c.erc1155.stream c.erc1155.proxy c.core c.evm
            exclude *->*
            include r0388 r0389 r0390 r0391 r0392 r0393 r0394 r0395 r0396 r0397 r0433 r0434 r0435
            autoLayout lr 360 200
        }
        container besu "50-besu-network" "Container - Besu validators and private RPC" {
            title "Container - Besu validators and private RPC"
            include besu.a1 besu.b1 besu.b2 besu.c1 besu.c2 besu.a2 besu.rpc1 besu.rpc2 besu.rpc3
            exclude *->*
            include r0649 r0650 r0651 r0652 r0653 r0654 r0655 r0656 r0657 r0658 r0659 r0660 r0661 r0662 r0663 r0664 r0665 r0666 r0667 r0668 r0669 r0670 r0671 r0672 r0673 r0674 r0675 r0676 r0677 r0678 r0679 r0680 r0681 r0682 r0683 r0684 r0685 r0686 r0687
            autoLayout lr 360 200
        }
        component besu.a1 "51-a1-network" "Component - Besu A1: Network and admission" {
            title "Component - Besu A1: Network and admission"
            include besu.a1.rpc besu.a1.permissioning besu.a1.discovery besu.a1.p2p besu.a1.txpool besu.a1.sync
            exclude *->*
            include r0436 r0437 r0440 r0441 r0442 r0443
            autoLayout lr 360 200
        }
        component besu.a1 "51-a1-consensus" "Component - Besu A1: Consensus and block processing" {
            title "Component - Besu A1: Consensus and block processing"
            include besu.a1.p2p besu.a1.txpool besu.a1.qbft besu.a1.keys besu.a1.blockprocessor besu.a1.sync besu.a1.metrics
            exclude *->*
            include r0442 r0443 r0444 r0445 r0446 r0447 r0448 r0459 r0460
            autoLayout lr 360 200
        }
        component besu.a1 "51-a1-execution" "Component - Besu A1: Execution, contracts and storage" {
            title "Component - Besu A1: Execution, contracts and storage"
            include besu.a1.rpc besu.a1.blockprocessor besu.a1.evm besu.a1.worldstate besu.a1.storage besu.a1.fireflycontract besu.a1.tokencontracts besu.a1.businesscontracts
            exclude *->*
            include r0438 r0439 r0449 r0450 r0451 r0452 r0453 r0454 r0455 r0456 r0457 r0458
            autoLayout lr 360 200
        }
        component besu.b1 "51-b1-network" "Component - Besu B1: Network and admission" {
            title "Component - Besu B1: Network and admission"
            include besu.b1.rpc besu.b1.permissioning besu.b1.discovery besu.b1.p2p besu.b1.txpool besu.b1.sync
            exclude *->*
            include r0461 r0462 r0465 r0466 r0467 r0468
            autoLayout lr 360 200
        }
        component besu.b1 "51-b1-consensus" "Component - Besu B1: Consensus and block processing" {
            title "Component - Besu B1: Consensus and block processing"
            include besu.b1.p2p besu.b1.txpool besu.b1.qbft besu.b1.keys besu.b1.blockprocessor besu.b1.sync besu.b1.metrics
            exclude *->*
            include r0467 r0468 r0469 r0470 r0471 r0472 r0473 r0484 r0485
            autoLayout lr 360 200
        }
        component besu.b1 "51-b1-execution" "Component - Besu B1: Execution, contracts and storage" {
            title "Component - Besu B1: Execution, contracts and storage"
            include besu.b1.rpc besu.b1.blockprocessor besu.b1.evm besu.b1.worldstate besu.b1.storage besu.b1.fireflycontract besu.b1.tokencontracts besu.b1.businesscontracts
            exclude *->*
            include r0463 r0464 r0474 r0475 r0476 r0477 r0478 r0479 r0480 r0481 r0482 r0483
            autoLayout lr 360 200
        }
        component besu.b2 "51-b2-network" "Component - Besu B2: Network and admission" {
            title "Component - Besu B2: Network and admission"
            include besu.b2.rpc besu.b2.permissioning besu.b2.discovery besu.b2.p2p besu.b2.txpool besu.b2.sync
            exclude *->*
            include r0486 r0487 r0490 r0491 r0492 r0493
            autoLayout lr 360 200
        }
        component besu.b2 "51-b2-consensus" "Component - Besu B2: Consensus and block processing" {
            title "Component - Besu B2: Consensus and block processing"
            include besu.b2.p2p besu.b2.txpool besu.b2.qbft besu.b2.keys besu.b2.blockprocessor besu.b2.sync besu.b2.metrics
            exclude *->*
            include r0492 r0493 r0494 r0495 r0496 r0497 r0498 r0509 r0510
            autoLayout lr 360 200
        }
        component besu.b2 "51-b2-execution" "Component - Besu B2: Execution, contracts and storage" {
            title "Component - Besu B2: Execution, contracts and storage"
            include besu.b2.rpc besu.b2.blockprocessor besu.b2.evm besu.b2.worldstate besu.b2.storage besu.b2.fireflycontract besu.b2.tokencontracts besu.b2.businesscontracts
            exclude *->*
            include r0488 r0489 r0499 r0500 r0501 r0502 r0503 r0504 r0505 r0506 r0507 r0508
            autoLayout lr 360 200
        }
        component besu.c1 "51-c1-network" "Component - Besu C1: Network and admission" {
            title "Component - Besu C1: Network and admission"
            include besu.c1.rpc besu.c1.permissioning besu.c1.discovery besu.c1.p2p besu.c1.txpool besu.c1.sync
            exclude *->*
            include r0511 r0512 r0515 r0516 r0517 r0518
            autoLayout lr 360 200
        }
        component besu.c1 "51-c1-consensus" "Component - Besu C1: Consensus and block processing" {
            title "Component - Besu C1: Consensus and block processing"
            include besu.c1.p2p besu.c1.txpool besu.c1.qbft besu.c1.keys besu.c1.blockprocessor besu.c1.sync besu.c1.metrics
            exclude *->*
            include r0517 r0518 r0519 r0520 r0521 r0522 r0523 r0534 r0535
            autoLayout lr 360 200
        }
        component besu.c1 "51-c1-execution" "Component - Besu C1: Execution, contracts and storage" {
            title "Component - Besu C1: Execution, contracts and storage"
            include besu.c1.rpc besu.c1.blockprocessor besu.c1.evm besu.c1.worldstate besu.c1.storage besu.c1.fireflycontract besu.c1.tokencontracts besu.c1.businesscontracts
            exclude *->*
            include r0513 r0514 r0524 r0525 r0526 r0527 r0528 r0529 r0530 r0531 r0532 r0533
            autoLayout lr 360 200
        }
        component besu.c2 "51-c2-network" "Component - Besu C2: Network and admission" {
            title "Component - Besu C2: Network and admission"
            include besu.c2.rpc besu.c2.permissioning besu.c2.discovery besu.c2.p2p besu.c2.txpool besu.c2.sync
            exclude *->*
            include r0536 r0537 r0540 r0541 r0542 r0543
            autoLayout lr 360 200
        }
        component besu.c2 "51-c2-consensus" "Component - Besu C2: Consensus and block processing" {
            title "Component - Besu C2: Consensus and block processing"
            include besu.c2.p2p besu.c2.txpool besu.c2.qbft besu.c2.keys besu.c2.blockprocessor besu.c2.sync besu.c2.metrics
            exclude *->*
            include r0542 r0543 r0544 r0545 r0546 r0547 r0548 r0559 r0560
            autoLayout lr 360 200
        }
        component besu.c2 "51-c2-execution" "Component - Besu C2: Execution, contracts and storage" {
            title "Component - Besu C2: Execution, contracts and storage"
            include besu.c2.rpc besu.c2.blockprocessor besu.c2.evm besu.c2.worldstate besu.c2.storage besu.c2.fireflycontract besu.c2.tokencontracts besu.c2.businesscontracts
            exclude *->*
            include r0538 r0539 r0549 r0550 r0551 r0552 r0553 r0554 r0555 r0556 r0557 r0558
            autoLayout lr 360 200
        }
        component besu.a2 "51-a2-network" "Component - Besu A2: Network and admission" {
            title "Component - Besu A2: Network and admission"
            include besu.a2.rpc besu.a2.permissioning besu.a2.discovery besu.a2.p2p besu.a2.txpool besu.a2.sync
            exclude *->*
            include r0561 r0562 r0565 r0566 r0567 r0568
            autoLayout lr 360 200
        }
        component besu.a2 "51-a2-consensus" "Component - Besu A2: Consensus and block processing" {
            title "Component - Besu A2: Consensus and block processing"
            include besu.a2.p2p besu.a2.txpool besu.a2.qbft besu.a2.keys besu.a2.blockprocessor besu.a2.sync besu.a2.metrics
            exclude *->*
            include r0567 r0568 r0569 r0570 r0571 r0572 r0573 r0584 r0585
            autoLayout lr 360 200
        }
        component besu.a2 "51-a2-execution" "Component - Besu A2: Execution, contracts and storage" {
            title "Component - Besu A2: Execution, contracts and storage"
            include besu.a2.rpc besu.a2.blockprocessor besu.a2.evm besu.a2.worldstate besu.a2.storage besu.a2.fireflycontract besu.a2.tokencontracts besu.a2.businesscontracts
            exclude *->*
            include r0563 r0564 r0574 r0575 r0576 r0577 r0578 r0579 r0580 r0581 r0582 r0583
            autoLayout lr 360 200
        }
        component besu.rpc1 "51-rpc1-network" "Component - Besu RPC1: Network and admission" {
            title "Component - Besu RPC1: Network and admission"
            include besu.rpc1.rpc besu.rpc1.permissioning besu.rpc1.discovery besu.rpc1.p2p besu.rpc1.txpool besu.rpc1.sync
            exclude *->*
            include r0586 r0587 r0590 r0591 r0592 r0593
            autoLayout lr 360 200
        }
        component besu.rpc1 "51-rpc1-consensus" "Component - Besu RPC1: Non-validator block processing" {
            title "Component - Besu RPC1: Non-validator block processing"
            include besu.rpc1.p2p besu.rpc1.sync besu.rpc1.blockprocessor besu.rpc1.keys besu.rpc1.discovery besu.rpc1.metrics
            exclude *->*
            include r0590 r0593 r0594 r0605 r0606
            autoLayout lr 360 200
        }
        component besu.rpc1 "51-rpc1-execution" "Component - Besu RPC1: Execution, contracts and storage" {
            title "Component - Besu RPC1: Execution, contracts and storage"
            include besu.rpc1.rpc besu.rpc1.blockprocessor besu.rpc1.evm besu.rpc1.worldstate besu.rpc1.storage besu.rpc1.fireflycontract besu.rpc1.tokencontracts besu.rpc1.businesscontracts
            exclude *->*
            include r0588 r0589 r0595 r0596 r0597 r0598 r0599 r0600 r0601 r0602 r0603 r0604
            autoLayout lr 360 200
        }
        component besu.rpc2 "51-rpc2-network" "Component - Besu RPC2: Network and admission" {
            title "Component - Besu RPC2: Network and admission"
            include besu.rpc2.rpc besu.rpc2.permissioning besu.rpc2.discovery besu.rpc2.p2p besu.rpc2.txpool besu.rpc2.sync
            exclude *->*
            include r0607 r0608 r0611 r0612 r0613 r0614
            autoLayout lr 360 200
        }
        component besu.rpc2 "51-rpc2-consensus" "Component - Besu RPC2: Non-validator block processing" {
            title "Component - Besu RPC2: Non-validator block processing"
            include besu.rpc2.p2p besu.rpc2.sync besu.rpc2.blockprocessor besu.rpc2.keys besu.rpc2.discovery besu.rpc2.metrics
            exclude *->*
            include r0611 r0614 r0615 r0626 r0627
            autoLayout lr 360 200
        }
        component besu.rpc2 "51-rpc2-execution" "Component - Besu RPC2: Execution, contracts and storage" {
            title "Component - Besu RPC2: Execution, contracts and storage"
            include besu.rpc2.rpc besu.rpc2.blockprocessor besu.rpc2.evm besu.rpc2.worldstate besu.rpc2.storage besu.rpc2.fireflycontract besu.rpc2.tokencontracts besu.rpc2.businesscontracts
            exclude *->*
            include r0609 r0610 r0616 r0617 r0618 r0619 r0620 r0621 r0622 r0623 r0624 r0625
            autoLayout lr 360 200
        }
        component besu.rpc3 "51-rpc3-network" "Component - Besu RPC3: Network and admission" {
            title "Component - Besu RPC3: Network and admission"
            include besu.rpc3.rpc besu.rpc3.permissioning besu.rpc3.discovery besu.rpc3.p2p besu.rpc3.txpool besu.rpc3.sync
            exclude *->*
            include r0628 r0629 r0632 r0633 r0634 r0635
            autoLayout lr 360 200
        }
        component besu.rpc3 "51-rpc3-consensus" "Component - Besu RPC3: Non-validator block processing" {
            title "Component - Besu RPC3: Non-validator block processing"
            include besu.rpc3.p2p besu.rpc3.sync besu.rpc3.blockprocessor besu.rpc3.keys besu.rpc3.discovery besu.rpc3.metrics
            exclude *->*
            include r0632 r0635 r0636 r0647 r0648
            autoLayout lr 360 200
        }
        component besu.rpc3 "51-rpc3-execution" "Component - Besu RPC3: Execution, contracts and storage" {
            title "Component - Besu RPC3: Execution, contracts and storage"
            include besu.rpc3.rpc besu.rpc3.blockprocessor besu.rpc3.evm besu.rpc3.worldstate besu.rpc3.storage besu.rpc3.fireflycontract besu.rpc3.tokencontracts besu.rpc3.businesscontracts
            exclude *->*
            include r0630 r0631 r0637 r0638 r0639 r0640 r0641 r0642 r0643 r0644 r0645 r0646
            autoLayout lr 360 200
        }
        container apps "60-applications" "Container - member business applications" {
            title "Container - member business applications"
            include apps.a apps.b apps.c business a.core b.core c.core
            exclude *->*
            include r0727 r0728 r0729 r0733 r0734 r0735 r0739 r0740 r0741
            autoLayout lr 360 200
        }
        container tools "61-tools" "Container - developer tooling" {
            title "Container - developer tooling"
            include tools.cli tools.sandbox developer a.core
            exclude *->*
            include r0749 r0750 r0752 r0753
            autoLayout lr 360 200
        }
        component tools.sandbox "62-sandbox" "Component - Sandbox sample application" {
            title "Component - Sandbox sample application"
            include tools.sandbox.frontend tools.sandbox.backend tools.sandbox.sdk a.core
            exclude *->*
            include r0746 r0747 r0748
            autoLayout lr 360 200
        }
        container ops "63-operations" "Container - platform operations" {
            title "Container - platform operations"
            include ops.gateway ops.cnpg ops.prometheus ops.grafana operator a.core b.core c.core a.pg b.pg c.pg besu.a1
            exclude *->*
            include r0117 r0262 r0407 r0756 r0757 r0759 r0761 r0763 r0765 r0767 r0769 r0771 r0773 r0775 r0776
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
