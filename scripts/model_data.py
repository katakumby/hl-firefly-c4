"""Architectural components and flows, reconciled with sources.json.
Rows describe logical components, not every class or implementation helper.
"""
def rows(text):
    return [tuple(x.strip() for x in line.split("|")) for line in text.strip().splitlines() if line.strip()]
CORE = rows("""
api|REST API and routing|Accepts namespace-scoped commands and queries.|internal/apiserver
auth|API authentication|Applies configured namespace authorization; Basic Auth reference plugin.|doc-site/docs/overview/key_components/security.md
namespaces|Namespace manager|Initializes isolated orchestrators and configured plugins.|internal/namespace
orchestrator|Orchestrator|Coordinates API operations and subsystem lifecycles.|internal/orchestrator
identity|Identity manager|Resolves organizations, nodes and transaction signing identities.|internal/identity
networkmap|Network map|Indexes registered members, nodes and their endpoints.|internal/networkmap
definitions|Definition exchange|Publishes and processes schemas, interfaces and token definitions.|internal/definitions
data|Data manager|Validates, hashes and retrieves structured data and blob references.|internal/data
schema|Schema validation|Checks JSON payloads against registered datatype definitions.|internal/data
batch|Batch manager|Selects outbound messages and dispatches recoverable batches.|internal/batch
batchprocessor|Batch processor|Assembles ordered message batches and aggregate hashes.|internal/batch
broadcast|Broadcast manager|Publishes shared payloads and orchestrates ledger pinning.|internal/broadcast
private|Private messaging and groups|Routes messages to recipient groups and coordinates delivery.|internal/privatemessaging
multiparty|Multiparty manager|Coordinates network actions and FireFly contract pinning.|internal/multiparty
download|Shared download manager|Retrieves referenced broadcast batches and blobs.|internal/shareddownload
contracts|Contract manager|Maps FFIs and APIs to contract calls and event listeners.|internal/contracts
assets|Asset manager|Coordinates token pools, balances and transfers.|internal/assets
operations|Operations manager|Tracks asynchronous connector requests and results.|internal/operations
txhelper|Transaction helper|Correlates operations, messages and blockchain transactions.|internal/txcommon
txwriter|Transaction writer|Batches transaction persistence and submission work.|internal/txwriter
aggregator|Inbound event aggregator|Correlates ledger pins with payloads and sequences confirmed messages.|internal/events/aggregator.go
subscriptions|Subscription manager|Filters events and persists subscriber offsets.|internal/events/subscription_manager.go
dispatcher|Event dispatcher|Delivers ordered event batches and processes acknowledgements.|internal/events/event_dispatcher.go
syncasync|Sync/async bridge|Correlates asynchronous completion with waiting API requests.|internal/syncasync
cache|Cache manager|Caches reusable namespace resources and lookups.|internal/cache
metrics|Metrics|Exposes runtime and operation measurements.|internal/metrics
spievents|SPI event manager|Publishes internal lifecycle and namespace change events.|internal/spievents
blockchain|Blockchain plugin|Binds Ethereum operations to EVMConnect; other chains are alternatives.|internal/blockchain
database|Database plugin|Maps logical resources to PostgreSQL; SQLite is an alternative.|internal/database
dataexchange|Data exchange plugin|Binds message, blob and peer operations to the HTTPS connector.|internal/dataexchange
sharedstorage|Shared storage plugin|Publishes and retrieves content through IPFS APIs.|internal/sharedstorage
tokens|Token plugin|Binds standard token operations to remote token connectors.|internal/tokens
identityplugin|Identity plugin|Resolves external identity claims through the configured resolver.|pkg/identity
eventplugin|Event transport plugins|Provides WebSocket, webhook and system-event delivery.|internal/events
""")
CORE_FLOWS = rows("""
api|auth|Passes request credentials for authorization
api|namespaces|Resolves the requested namespace
namespaces|orchestrator|Initializes namespace resources and plugins
api|orchestrator|Submits validated commands and queries
orchestrator|syncasync|Waits for asynchronous request completion
orchestrator|identity|Resolves signing identities
identity|identityplugin|Resolves configured identity claims
identity|networkmap|Looks up members and node endpoints
networkmap|definitions|Registers shared member definitions
definitions|broadcast|Publishes network definitions
orchestrator|multiparty|Submits consortium network actions
multiparty|blockchain|Submits contract pinning transactions
orchestrator|data|Submits payloads and datatype definitions
data|schema|Validates structured payloads
data|database|Persists payload metadata and hashes
orchestrator|batch|Queues outbound messages
batch|batchprocessor|Assigns messages to recoverable batches
batchprocessor|data|Loads payloads for batch assembly
batchprocessor|broadcast|Dispatches broadcast batches
batchprocessor|private|Dispatches recipient-scoped batches
broadcast|sharedstorage|Uploads broadcast payloads
broadcast|multiparty|Pins batch hashes on the ledger
private|dataexchange|Sends private payloads to recipient nodes
private|multiparty|Pins private batch hashes when requested
private|identity|Resolves group recipients and endpoints
orchestrator|contracts|Submits contract queries and invocations
orchestrator|assets|Submits token pool and transfer requests
contracts|blockchain|Submits ABI-backed calls and listeners
assets|tokens|Requests standard token operations
assets|contracts|Resolves token contract interfaces
contracts|operations|Tracks contract operation completion
assets|operations|Tracks token operation completion
operations|txhelper|Correlates operation and transaction identifiers
txhelper|txwriter|Queues transaction records for persistence
txwriter|database|Flushes transaction records
operations|database|Persists operation state and retries
blockchain|aggregator|Delivers confirmed ledger events
dataexchange|aggregator|Delivers received payload notifications
tokens|aggregator|Delivers token creation and transfer events
aggregator|download|Requests missing shared data
download|sharedstorage|Fetches content-addressed batches and blobs
download|data|Validates downloaded data and stores metadata
aggregator|database|Persists sequenced events and message state
aggregator|subscriptions|Publishes locally ordered events
subscriptions|database|Persists subscriptions and acknowledged offsets
subscriptions|dispatcher|Dispatches filtered event batches
dispatcher|eventplugin|Delivers events via configured transports
dispatcher|syncasync|Completes waiting requests
namespaces|spievents|Publishes namespace lifecycle changes
spievents|eventplugin|Publishes system notifications
data|cache|Caches reusable data and schema lookups
contracts|cache|Caches contract definitions
orchestrator|metrics|Records API and subsystem measurements
operations|metrics|Records operation outcomes
""")
CORE_VIEWS = [
("api","API and tenancy","api auth namespaces orchestrator syncasync spievents eventplugin"),
("identity","Identity and multiparty coordination","orchestrator identity identityplugin networkmap definitions broadcast multiparty blockchain"),
("messaging","Payloads and outbound messaging","orchestrator data schema batch batchprocessor broadcast private dataexchange sharedstorage multiparty"),
("contracts","Contracts, tokens and operations","orchestrator contracts assets tokens blockchain operations txhelper txwriter database"),
("events","Inbound sequencing and event delivery","blockchain dataexchange tokens aggregator download subscriptions dispatcher eventplugin syncasync database"),
("persistence","Persistence and operational support","orchestrator data download sharedstorage contracts operations txwriter database cache metrics"),
]
EVM = rows("""
api|Connector REST API|Accepts transaction, query and event-stream requests.|evmconnect|cmd/evmconnect.go
manager|Transaction manager|Coordinates durable transaction and stream lifecycles.|fftm|pkg/fftm
handler|Transaction policy handler|Schedules signing, submission, gas and retry policy.|fftm|pkg/txhandler
nonce|Nonce allocation|Assigns and persists ordered nonces per signing address.|fftm|internal/persistence
abi|EVM API adapter|Encodes ABIs and implements the blockchain connector API.|evmconnect|internal/ethereum
rpc|Ethereum JSON-RPC client|Submits calls and transactions through the signing proxy.|evmconnect|pkg/ethrpc
blocks|Block listener|Tracks chain heads and block/filter updates.|evmconnect|pkg/ethblocklistener
receipts|Receipt tracking|Polls receipt status for submitted transactions.|fftm|pkg/fftm
confirmations|Confirmation manager|Confirms receipts and events against the observed chain.|fftm|internal/confirmations
streams|Event streams|Orders and batches confirmed listener events.|fftm|internal/events
delivery|WebSocket batch delivery|Delivers WebSocket batches and accepts consumer acknowledgements.|fftm|internal/ws
persistence|Persistence adapter|Stores transactions, nonces, streams and checkpoints.|fftm|internal/persistence
""")
EVM_FLOWS = rows("""
api|manager|Submits transaction and stream requests
manager|handler|Schedules managed transaction processing
handler|nonce|Allocates the next sender nonce
nonce|persistence|Persists sender transaction ordering
handler|abi|Prepares calls and encoded transactions
abi|rpc|Issues Ethereum JSON-RPC requests
handler|receipts|Tracks submitted transaction receipts
receipts|rpc|Queries transaction receipt status
rpc|blocks|Returns block and filter responses
blocks|confirmations|Publishes chain head updates
receipts|confirmations|Submits receipts for confirmation
confirmations|streams|Releases confirmed blockchain events
manager|streams|Configures listeners and stream lifecycle
streams|delivery|Delivers ordered event batches
delivery|streams|Acknowledges consumed batches
streams|persistence|Persists acknowledged checkpoints
manager|persistence|Persists transaction lifecycle state
""")
EVM_VIEWS=[
("transactions","Transaction submission","api manager handler nonce abi rpc persistence"),
("events","Block tracking and events","manager blocks receipts rpc confirmations streams delivery persistence"),
]
SIGNER=rows("""
proxy|JSON-RPC proxy|Intercepts transaction requests and forwards read calls.|internal/rpcserver
wallet|Filesystem wallet|Loads member keystore files and resolves signing accounts.|pkg/fswallet
keystore|Keystore V3 decoder|Decrypts encrypted account key files.|pkg/keystorev3
signing|Ethereum signing|Encodes and signs EIP-155 and EIP-1559 transactions.|pkg/ethsigner
typeddata|Typed data utilities|Provides EIP-712 signing utilities; library capability.|pkg/eip712
backend|RPC backend|Forwards signed raw transactions to Besu.|pkg/rpcbackend
""")
SIGNER_FLOWS=rows("""
proxy|wallet|Resolves requested signing accounts
wallet|keystore|Decrypts selected key material
proxy|signing|Submits transactions for signing
signing|wallet|Retrieves the selected signing key
typeddata|wallet|Retrieves keys for library-level typed data signing
signing|backend|Submits signed raw transactions
proxy|backend|Forwards unmodified RPC read requests
""")
DX=rows("""
api|Internal REST API|Accepts private messages, blobs and peer configuration.|src/routers/api.ts
peers|Peer and certificate registry|Resolves remote endpoints and trusted peer certificates.|src/lib
p2p|Mutual TLS peer endpoint|Authenticates remote members and transfers private data.|src/routers/p2p.ts
messages|Message transfer handler|Sends and receives recipient-scoped message envelopes.|src/handlers/messages.ts
blobs|Blob transfer handler|Streams binary content to durable member storage.|src/handlers/blobs.ts
events|Event queue and acknowledgements|Queues delivery notifications in memory and processes acknowledgements.|src/handlers/events.ts
""")
DX_FLOWS=rows("""
api|peers|Updates peer endpoints and certificates
api|messages|Submits recipient-scoped messages
api|blobs|Uploads private binary content
messages|peers|Resolves destination and trust material
messages|p2p|Transfers private message envelopes
blobs|p2p|Transfers encrypted blob streams
p2p|messages|Delivers authenticated inbound messages
p2p|blobs|Stores authenticated inbound blobs
messages|events|Enqueues message delivery results
blobs|events|Enqueues blob delivery results
events|api|Delivers notifications and receives acknowledgements
""")
TOKENS=rows("""
api|Token REST controller|Accepts pool, mint, burn, transfer and approval requests.|src/tokens/tokens.controller.ts
service|Token service|Applies token-specific behavior and tracks pools.|src/tokens/tokens.service.ts
mapper|ABI and standard adapters|Maps token operations to contract ABIs.|src/tokens
blockchain|Blockchain connector client|Submits contract calls through EVMConnect.|src/tokens/blockchain.service.ts
listener|Token event listener|Interprets contract logs as standard token events.|src/tokens/tokens.listener.ts
stream|Connector event stream|Receives ordered blockchain events and acknowledges batches.|src/event-stream
proxy|Core event proxy|Delivers token events to Core over WebSocket.|src/eventstream-proxy
""")
TOKEN_FLOWS=rows("""
api|service|Submits standard token operations
service|mapper|Encodes token contract calls
mapper|blockchain|Passes encoded contract requests
blockchain|stream|Registers contract event listeners
stream|listener|Delivers token contract logs
listener|service|Updates token pool state
listener|proxy|Publishes normalized token events
proxy|stream|Acknowledges consumed event batches
""")
BESU=rows("""
rpc|JSON-RPC and subscriptions|Accepts private-network queries and signed transactions.|ethereum/api
permissioning|Node and account permissioning|Applies local peer and account allowlists.|ethereum/permissioning
discovery|Peer discovery|Discovers peers through configured bootnodes.|ethereum/p2p
p2p|DevP2P transport|Exchanges transactions, blocks and consensus messages.|ethereum/p2p
txpool|Transaction pool|Validates and queues pending transactions.|ethereum/eth
sync|Chain synchronization|Downloads and validates missing blocks and state.|ethereum/eth
blockprocessor|Block processor|Validates blocks and applies state transitions.|ethereum/core
qbft|QBFT consensus|Proposes blocks and verifies validator votes.|consensus/qbft
evm|EVM execution|Executes smart-contract bytecode deterministically.|evm
worldstate|World state and trie|Tracks account balances, storage and contract state.|ethereum/trie
storage|Storage provider|Persists blockchain data and world-state records.|plugins/rocksdb
keys|Node key and security module|Signs node identity and validator consensus messages.|plugin-api
metrics|Metrics and health|Exposes node, peer and consensus measurements.|metrics
fireflycontract|FireFly multiparty contract|Executes batch pinning and emits sequencing events.|@firefly
tokencontracts|Token contracts|Executes ERC-20, ERC-721 and ERC-1155 state changes.|@tokens
businesscontracts|Application contracts|Executes member-defined business rules; example extension.|@reference
""")
BESU_FLOWS=rows("""
rpc|permissioning|Checks transaction sender admission
rpc|txpool|Submits signed transactions
rpc|worldstate|Queries account and contract state
rpc|blockprocessor|Reads receipts and contract logs
discovery|p2p|Provides discovered peer endpoints
p2p|permissioning|Checks connecting node admission
p2p|txpool|Gossips pending transactions
p2p|sync|Delivers requested blocks and state
p2p|qbft|Delivers consensus protocol messages
sync|blockprocessor|Submits downloaded blocks for validation
txpool|qbft|Supplies transactions for proposed blocks
qbft|keys|Signs proposals and consensus votes
qbft|blockprocessor|Commits quorum-approved blocks
blockprocessor|evm|Executes transactions and validates results
evm|worldstate|Reads and updates contract and account state
worldstate|storage|Persists world-state updates
blockprocessor|storage|Persists blocks, receipts and logs
evm|fireflycontract|Executes batch pinning calls
evm|tokencontracts|Executes standard token operations
evm|businesscontracts|Executes application business calls
fireflycontract|worldstate|Writes pinning state and log results
tokencontracts|worldstate|Writes token balances and log results
businesscontracts|worldstate|Writes application state and log results
qbft|metrics|Records rounds and committed block measurements
p2p|metrics|Records peer connectivity measurements
""")
BESU_VIEWS=[
("network","Network and admission","rpc permissioning discovery p2p txpool sync"),
("consensus","Consensus and block processing","p2p txpool qbft keys blockprocessor sync metrics"),
("execution","Execution, contracts and storage","rpc blockprocessor evm worldstate storage fireflycontract tokencontracts businesscontracts"),
]

