"""Source-backed additions and corrections for the logical C4 model.

Components group runtime responsibilities, not every class or helper. Optional
connector configurations get separate views; infrastructure internals stop at
their public integration boundary except for the worked Besu example.
"""
from model_data import rows


def extend_model(E, R, V, add, rel, view, comps, flows, kids, source):
    def component(parent, ident, name, description, repo, path, tech='Go', tags=''):
        add(parent+'.'+ident, 'component', name, description, tech, repo, path, tags)

    def runtime(ident, name, description, tech, repo, path=''):
        add('firefly.'+ident, 'container', name, description, tech, repo, path, 'Optional')

    def storage(ident, name, description, tech, repo, path=''):
        add('firefly.'+ident, 'container', name, description, tech, repo, path, 'Database,Optional')

    def external(ident, name, description, repo, path=''):
        add(ident, 'softwareSystem', name, description, repo=repo, path=path, tags='Optional', classification='External integration boundary')

    def link(a, b, label, tech='In-process calls / Go'):
        rel(a, b, label, tech)

    def replace_source(ident, repo, path):
        E[ident]['source'] = source(repo, path)

    # Configuration and initialization are components; factories are part of
    # their owning plugin boundary. The identity factory explicitly says TBD.
    E['firefly.core.identityplugin']['name'] = 'Identity extension placeholder'
    E['firefly.core.identityplugin']['description'] = 'Registers the onchain compatibility placeholder; external identity resolution is not implemented.'
    E['firefly.core.identityplugin']['classification'] = 'Unfinished extension'
    replace_source('firefly.core.identityplugin', 'firefly', 'internal/identity/tbd')
    for r in R:
        if r['source']=='firefly.core.identity' and r['destination']=='firefly.core.identityplugin':
            r['description']='Initializes the configured onchain placeholder'
            r['id']=r['source']+'->'+r['destination']+':'+r['description']
    E['firefly.core.blockchain']['description'] = 'Defines blockchain operations and dispatches to the configured chain adapter.'
    E['firefly.core.database']['description'] = 'Defines transactional persistence and dispatches to the selected SQL adapter.'
    E['firefly.core.eventplugin']['name'] = 'Event transport interface'
    E['firefly.core.eventplugin']['description'] = 'Binds subscriber delivery to a configured event transport.'
    E['firefly.secrets']['description'] = 'Stores signing keystores, mTLS material and configuration; Kubernetes projection belongs to the deferred deployment reference.'
    E['firefly.blobs']['description'] = 'Stores private binary payloads and peer metadata; storage-class placement is deferred.'
    E['firefly.ipfsRepo']['description'] = 'Stores Kubo identity, pins and content blocks; storage-class placement is deferred.'
    E['firefly.blobs']['technology'] = 'Filesystem'
    E['firefly.ipfsRepo']['technology'] = 'Filesystem'
    E['firefly.secrets']['technology'] = 'Configuration and key files'
    replace_source('firefly.core.auth', 'common', 'pkg/auth')
    adapters = rows('''
config|Configuration and plugin initialization|Loads namespace settings and initializes plugin factories.|firefly|internal/coreconfig
basicAuth|HTTP Basic authentication|Verifies htpasswd bcrypt credentials for configured namespaces.|common|pkg/auth/basic
ethereum|Ethereum blockchain adapter|Maps Core operations to EVMConnect or legacy EthConnect.|firefly|internal/blockchain/ethereum
fabricAdapter|Fabric blockchain adapter|Maps chaincode operations and ledger events to FabConnect.|firefly|internal/blockchain/fabric
tezosAdapter|Tezos blockchain adapter|Maps FireFly contract operations to TezosConnect.|firefly|internal/blockchain/tezos
cardanoAdapter|Cardano blockchain adapter|Maps transactions and contract operations to CardanoConnect.|firefly|internal/blockchain/cardano
postgres|PostgreSQL adapter|Implements Core persistence through the shared SQL layer.|firefly|internal/database/postgres
sqlite|SQLite adapter|Implements Core persistence in an embedded SQLite database.|firefly|internal/database/sqlite3
sql|SQL persistence implementation|Builds resource queries and transactions for SQL backends.|firefly|internal/database/sqlcommon
ffdx|HTTPS Data Exchange adapter|Maps private envelopes, blobs, peers and acknowledgements to FFDX.|firefly|internal/dataexchange/ffdx
ipfs|IPFS shared-storage adapter|Adds and retrieves broadcast content by CID.|firefly|internal/sharedstorage/ipfs
fftokens|Token connector adapter|Maps token operations and events to standard remote token APIs.|firefly|internal/tokens/fftokens
websockets|WebSocket event transport|Delivers subscription batches and consumes acknowledgements.|firefly|internal/events/websockets
webhooks|Webhook event transport|Posts event batches to configured callback endpoints.|firefly|internal/events/webhooks
systemEvents|System event transport|Delivers internal subscriptions to Core event consumers.|firefly|internal/events/system
''')
    for ident,name,desc,repo,path in adapters:
        component('firefly.core',ident,name,desc,repo,path)
    for a,b,label in rows('''
namespaces|config|Loads namespace configuration and plugin selections
auth|basicAuth|Verifies configured Basic credentials
blockchain|ethereum|Dispatches EVM operations when configured
blockchain|fabricAdapter|Dispatches Fabric operations when configured
blockchain|tezosAdapter|Dispatches Tezos operations when configured
blockchain|cardanoAdapter|Dispatches Cardano operations when configured
database|postgres|Dispatches PostgreSQL persistence when configured
database|sqlite|Dispatches embedded SQLite persistence when configured
postgres|sql|Executes PostgreSQL resource queries and transactions
sqlite|sql|Executes SQLite resource queries and transactions
dataexchange|ffdx|Dispatches private data-transfer operations
sharedstorage|ipfs|Dispatches shared-content operations
tokens|fftokens|Dispatches standard token operations
eventplugin|websockets|Delivers WebSocket subscription batches
eventplugin|webhooks|Delivers webhook subscription batches
eventplugin|systemEvents|Delivers internal subscription batches
systemEvents|aggregator|Routes internal subscription notifications
'''):
        link('firefly.core.'+a,'firefly.core.'+b,label)
    # Keep generic interface relationships for higher-level component views;
    # add concrete adapter paths in the dedicated plugin views.
    for src,dst,label,tech in [
        ('ethereum','evm','Submits EVM calls, transactions and listeners','HTTP REST / JSON'),
        ('postgres','pg','Reads and writes the Core SQL database','PostgreSQL wire protocol'),
        ('ffdx','dx','Transfers messages, blobs and peer configuration','HTTP REST + WebSocket'),
        ('ipfs','ipfs','Publishes and retrieves shared CIDs','IPFS HTTP RPC'),
        ('fftokens','erc20','Submits ERC-20 and ERC-721 operations','HTTP REST + WebSocket'),
        ('fftokens','erc1155','Submits ERC-1155 operations','HTTP REST + WebSocket')]:
        link('firefly.core.'+src,'firefly.'+dst,label,tech)
    for ident in ('websockets','webhooks'):
        link('firefly.core.'+ident,'apps.client','Delivers subscribed event batches','WebSocket / JSON' if ident=='websockets' else 'HTTP POST / JSON')
    link('apps.client','firefly.core.websockets','Acknowledges consumed event batches','WebSocket / JSON')
    storage('sqlite','Core SQLite file','Optional embedded Core database; no independent database server.','SQLite / filesystem','firefly','internal/database/sqlite3')
    storage('leveldb','FFTM LevelDB files','Optional embedded transaction and stream persistence.','LevelDB / filesystem','fftm','internal/persistence/leveldb')
    link('firefly.core','firefly.sqlite','Persists Core state when SQLite is selected','Embedded SQLite / filesystem')
    link('firefly.core.sqlite','firefly.sqlite','Reads and writes embedded database pages','SQLite API / filesystem')
    link('firefly.evm','firefly.leveldb','Persists transaction state when LevelDB is selected','Embedded LevelDB / filesystem')
    for ident,name,desc,repo,path in rows('''
postgres|PostgreSQL persistence|Persists managed transactions and streams in SQL tables.|fftm|internal/persistence/postgres
leveldb|LevelDB persistence|Persists transactions and stream state in local key-value files.|fftm|internal/persistence/leveldb
blocklistener|Durable block notifications|Coordinates block updates for listeners and confirmations.|fftm|internal/blocklistener
metrics|Transaction and stream metrics|Records transaction and event-processing measurements.|fftm|internal/metrics
webhook|Webhook batch delivery|Delivers event batches using configured HTTP callbacks.|fftm|internal/events
'''):
        component('firefly.evm',ident,name,desc,repo,path)
    for a,b,label in rows('''
persistence|postgres|Writes state through the selected PostgreSQL backend
persistence|leveldb|Writes state through the selected LevelDB backend
blocks|blocklistener|Supplies blockchain head notifications
blocklistener|confirmations|Updates tracked canonical block history
streams|webhook|Dispatches batches when webhook delivery is selected
manager|metrics|Records transaction processing measurements
streams|metrics|Records event-processing measurements
'''):
        link('firefly.evm.'+a,'firefly.evm.'+b,label)
    link('firefly.evm.postgres','firefly.fftmDb','Persists the separate FFTM SQL database','PostgreSQL wire protocol')
    link('firefly.evm.leveldb','firefly.leveldb','Reads and writes local transaction state','LevelDB API / filesystem')
    link('firefly.evm.webhook','apps.client','Posts configured blockchain event batches','HTTP POST / JSON')

    # Peer boundaries make the static private/shared data paths visible without
    # duplicating deployment members in the logical model.
    external('peerMembers','Other FireFly members','Peer supernodes exchanging private envelopes and shared content.','firefly','doc-site/docs/overview/multiparty/multiparty_flow.md')
    link('firefly','peerMembers','Exchanges private payloads and shared content references','HTTPS / mTLS + IPFS')
    link('peerMembers','firefly','Delivers peer payloads and transfer acknowledgements','HTTPS / mTLS')
    link('firefly.dx','peerMembers','Sends private envelopes and blobs to selected peers','HTTPS / mTLS')
    link('peerMembers','firefly.dx','Delivers private envelopes, blobs and transfer results','HTTPS / mTLS')
    link('firefly.dx.p2p','peerMembers','Transfers authenticated private envelopes and blobs','HTTPS / mTLS')
    link('peerMembers','firefly.dx.p2p','Transfers inbound private envelopes and blobs','HTTPS / mTLS')
    link('firefly.dx.events','firefly.core','Delivers message and blob transfer notifications','WebSocket / JSON')
    link('firefly.core','firefly.dx.events','Acknowledges consumed transfer notifications','WebSocket / JSON')
    link('firefly.ipfs','peerMembers','Fetches and serves shared content blocks by CID','IPFS / libp2p')

    # Existing system IDs now denote external networks, not opaque boxes that
    # conflate an in-process adapter, a connector, and a ledger.
    for ident,name,desc,repo in [
        ('ethconnect','Other EVM networks','Optional public or permissioned EVM-compatible networks; share the Ethereum adapter implementation.','evmconnect'),
        ('fabric','Hyperledger Fabric network','External Fabric peer, ordering, discovery and chaincode services.','fabconnect'),
        ('tezos','Tezos network','External Tezos node RPC and chain-monitoring endpoints.','tezosconnect'),
        ('cardano','Cardano network','External Cardano ledger accessed through Blockfrost or node-to-client protocols.','cardano'),
        ('corda','Corda network','External Corda node with application-specific CorDapps; starter integration requires customization.','cordaconnect')]:
        E[ident].update(name=name,description=desc,source=source(repo,'README.md'),classification='External integration boundary')
    R[:] = [r for r in R if not (r['source'] in ('firefly','firefly.core') and r['destination'] in ('ethconnect','fabric','tezos','cardano','corda'))]
    # Root IDs must not shadow a child named ethconnect in hierarchical DSL.
    E['evmNetworks']=E.pop('ethconnect')
    E['evmNetworks']['id']='evmNetworks'
    for existing_view in V:
        existing_view['elements']=['evmNetworks' if i=='ethconnect' else i for i in existing_view['elements']]
    for target,tech in [('evmNetworks','Ethereum JSON-RPC'),('fabric','Fabric connector API'),('tezos','Tezos connector API'),('cardano','Cardano connector API')]:
        link('firefly',target,'Submits ledger operations and consumes events when configured',tech)
    link('developer','corda','Customizes the CorDapp and Core binding required by the starter','Development toolchain')

    runtime('ethconnect','EthConnect (legacy option)','Original Ethereum connector; REST/direct and optional Kafka bridge configurations.','Go','ethconnect')
    comps('firefly.ethconnect', rows('''
rest|REST gateway and authorization|Accepts requests and dispatches direct or asynchronous processing.|internal/rest
auth|Authorization extension|Applies configured request authorization hooks.|internal/auth
contracts|Contract gateway|Builds ABI-backed REST APIs and routes contract operations.|internal/contractgateway
registry|Contract registry and ABI metadata|Stores deployed contract interfaces and resolves contract addresses.|internal/contractregistry
openapi|OpenAPI generation|Generates request schemas from contract ABIs.|internal/openapi
transactions|Transaction processor|Allocates nonces, submits transactions and waits for receipts.|internal/tx
rpc|Ethereum RPC and ABI binding|Encodes transactions, calls RPC and supports external signing.|internal/eth
events|Event subscriptions and confirmations|Polls contract logs, confirms and batches them for delivery.|internal/events
websockets|WebSocket delivery|Maintains event clients and acknowledgements.|internal/ws
kafka|Kafka bridge|Consumes transaction requests and publishes replies in Kafka mode.|internal/kafka
receipts|Receipt store|Persists transaction outcomes in a configured receipt backend.|internal/receipts
kv|Embedded key-value storage|Stores event subscriptions and registry data in LevelDB.|internal/kvstore
'''),'ethconnect','Go')
    flows('firefly.ethconnect',rows('''
rest|auth|Checks configured authorization hooks
rest|contracts|Routes ABI-backed contract requests
contracts|registry|Resolves contract addresses and interfaces
contracts|openapi|Generates contract request schemas
contracts|transactions|Dispatches transaction requests
rest|transactions|Dispatches direct transaction requests
rest|kafka|Publishes requests in Kafka bridge mode
kafka|transactions|Dispatches consumed transaction requests
transactions|rpc|Encodes and submits Ethereum transactions
transactions|receipts|Persists completed transaction outcomes
events|rpc|Polls blocks and contract logs
events|websockets|Delivers confirmed event batches
events|kv|Persists subscriptions and checkpoints
registry|kv|Persists contract metadata
'''),'In-process calls / Go')
    storage('ethconnectState','EthConnect local state','Optional LevelDB receipts, subscriptions and contract metadata.','LevelDB / filesystem','ethconnect','internal/kvstore')
    external('kafkaBroker','Apache Kafka','Optional transaction request/reply broker for legacy connector configurations.','ethconnect','internal/kafka')
    external('mongo','MongoDB receipt service','Optional receipt persistence for legacy Ethereum and Fabric connectors.','ethconnect','internal/receipts/mongoreceipts.go')
    for a,b,label,tech in [
        ('firefly.core.ethereum','firefly.ethconnect','Submits Ethereum requests in the legacy configuration','HTTP REST + WebSocket'),
        ('firefly.core','firefly.ethconnect','Submits calls and consumes events in the legacy configuration','HTTP REST + WebSocket'),
        ('firefly.ethconnect','firefly.signer','Submits unsigned transactions and read requests','HTTP JSON-RPC'),
        ('firefly.ethconnect.rpc','firefly.signer','Requests Ethereum transaction signing and RPC forwarding','HTTP JSON-RPC'),
        ('firefly.evm','evmNetworks','Submits transactions and polls an alternative EVM network','HTTP JSON-RPC'),
        ('firefly.ethconnect','firefly.core','Delivers confirmed contract events and transaction results','WebSocket / JSON'),
        ('firefly.ethconnect.websockets','firefly.core','Delivers confirmed contract event batches','WebSocket / JSON'),
        ('firefly.ethconnect','firefly.ethconnectState','Persists connector state in local files','LevelDB / filesystem'),
        ('firefly.ethconnect.kv','firefly.ethconnectState','Reads and writes event and registry records','LevelDB API / filesystem'),
        ('firefly.ethconnect.receipts','firefly.ethconnectState','Persists receipts when LevelDB is selected','LevelDB API / filesystem'),
        ('firefly.ethconnect.receipts','mongo','Stores receipts when MongoDB is selected','MongoDB wire protocol'),
        ('firefly.ethconnect','kafkaBroker','Publishes requests and consumes transaction work in Kafka mode','Kafka protocol'),
        ('firefly.ethconnect.kafka','kafkaBroker','Consumes transaction requests and publishes replies','Kafka protocol')]: link(a,b,label,tech)

    runtime('fabconnect','FabConnect','Fabric transaction, identity and ledger-event connector.','Go / Fabric SDK','fabconnect')
    comps('firefly.fabconnect', rows('''
rest|REST gateway and dispatch|Routes identity, transaction and receipt requests.|internal/rest
auth|Authorization extension|Applies configured API authorization hooks.|internal/auth
identity|Identity enrollment API|Registers and enrolls Fabric signing identities.|internal/rest/identity
transactions|Transaction processor|Submits chaincode transactions and tracks completion.|internal/tx
client|Fabric clients and wallet|Uses connection profiles or discovery to access peers and ordering services.|internal/fabric/client
events|Event subscriptions and checkpoints|Filters Fabric events and manages delivery checkpoints.|internal/events
websockets|WebSocket delivery|Delivers event batches and consumes acknowledgements.|internal/ws
kafka|Kafka bridge|Supports optional asynchronous transaction request/reply messaging.|internal/kafka
receipts|Receipt persistence|Stores transaction results in configured receipt backends.|internal/rest/receipt
kv|Key-value persistence|Persists connector event state in LevelDB.|internal/kvstore
'''),'fabconnect','Go')
    flows('firefly.fabconnect',rows('''
rest|auth|Checks configured authorization hooks
rest|identity|Routes identity enrollment requests
identity|client|Registers and enrolls signing identities
rest|transactions|Dispatches chaincode transaction requests
rest|kafka|Publishes requests in asynchronous Kafka mode
kafka|transactions|Dispatches consumed transaction requests
transactions|client|Submits chaincode invocations
transactions|receipts|Persists transaction results
events|client|Subscribes to Fabric ledger events
events|websockets|Delivers filtered ledger event batches
events|kv|Persists subscriptions and checkpoints
'''),'In-process calls / Go')
    storage('fabricState','FabConnect local state','Connector LevelDB state and Fabric wallet identity material.','LevelDB + wallet files','fabconnect','internal/fabric/client/store.go')
    external('fabricCA','Fabric certificate authority','Registers and enrolls client identities used by FabConnect.','fabconnect','internal/fabric/client/identity.go')
    for a,b,label,tech in [
        ('firefly.core.fabricAdapter','firefly.fabconnect','Submits chaincode calls and event subscriptions','HTTP REST + WebSocket'),
        ('firefly.core','firefly.fabconnect','Submits Fabric requests when configured','HTTP REST + WebSocket'),
        ('firefly.fabconnect','fabric','Submits endorsed transactions and receives ledger events','Fabric SDK / gRPC + TLS'),
        ('firefly.fabconnect.client','fabric','Invokes chaincode and consumes peer ledger events','Fabric SDK / gRPC + TLS'),
        ('firefly.fabconnect.client','fabricCA','Registers and enrolls Fabric identities','Fabric CA / HTTPS'),
        ('firefly.fabconnect','fabricCA','Registers and enrolls client identities','Fabric CA / HTTPS'),
        ('firefly.fabconnect.websockets','firefly.core','Delivers acknowledged Fabric event batches','WebSocket / JSON'),
        ('firefly.fabconnect','firefly.core','Delivers Fabric events and transaction results','WebSocket / JSON'),
        ('firefly.fabconnect','firefly.fabricState','Persists wallet and event state','Filesystem / LevelDB'),
        ('firefly.fabconnect.client','firefly.fabricState','Reads and writes wallet identities','Filesystem I/O'),
        ('firefly.fabconnect.kv','firefly.fabricState','Persists event checkpoints','LevelDB API / filesystem'),
        ('firefly.fabconnect.receipts','firefly.fabricState','Persists receipts when LevelDB is selected','LevelDB API / filesystem'),
        ('firefly.fabconnect.receipts','mongo','Persists receipts when MongoDB is selected','MongoDB wire protocol'),
        ('firefly.fabconnect.kafka','kafkaBroker','Consumes transaction requests and publishes replies','Kafka protocol'),
        ('firefly.fabconnect','kafkaBroker','Processes requests through the optional Kafka bridge','Kafka protocol')]: link(a,b,label,tech)

    runtime('tezosconnect','TezosConnect + FFTM','Tezos connector with its dependency-pinned embedded transaction manager.','Go','tezosconnect')
    for ident,name,desc,repo,path in rows('''
api|Connector API and transaction manager|Accepts and manages durable transaction and stream requests.|tezosfftm|pkg/fftm
policy|Transaction policy and nonce management|Schedules Tezos operation submission, retries and counter allocation.|tezosfftm|pkg/txhandler
adapter|Tezos operation adapter|Prepares, queries, estimates and submits Tezos operations.|tezosconnect|internal/tezos
signing|Remote signing client|Requests operation signatures from Signatory.|tezosconnect|internal/tezos/send_transaction.go
blocks|Tezos block listener|Monitors chain heads for events and receipts.|tezosconnect|internal/tezos/blocklistener.go
events|Event listener and stream adapter|Converts Tezos contract events to connector events.|tezosconnect|internal/tezos/event_stream.go
streams|FFTM confirmations and event delivery|Confirms and delivers checkpointed event batches.|tezosfftm|internal/events
persistence|FFTM persistence|Stores managed transactions and event checkpoints.|tezosfftm|internal/persistence
'''): component('firefly.tezosconnect',ident,name,desc,repo,path)
    flows('firefly.tezosconnect',rows('''
api|policy|Schedules durable operation submission
policy|adapter|Prepares and submits Tezos operations
adapter|signing|Requests a signature for encoded operations
blocks|events|Supplies observed Tezos blocks
events|streams|Supplies decoded contract events
api|streams|Configures event streams
api|persistence|Persists managed transaction state
streams|persistence|Persists acknowledged checkpoints
'''),'In-process calls / Go')
    external('signatory','Signatory','Remote Tezos signing service; backend key management is external.','tezosconnect','README.md')
    storage('tezosState','TezosConnect state','Optional PostgreSQL or LevelDB persistence for the embedded FFTM.','PostgreSQL or LevelDB','tezosfftm','internal/persistence')
    for a,b,label,tech in [
        ('firefly.core.tezosAdapter','firefly.tezosconnect','Submits Tezos operations and listeners','HTTP REST + WebSocket'),
        ('firefly.core','firefly.tezosconnect','Submits Tezos operations when configured','HTTP REST + WebSocket'),
        ('firefly.tezosconnect','tezos','Queries chain state and injects signed operations','Tezos HTTP RPC'),
        ('firefly.tezosconnect.adapter','tezos','Queries state and injects signed operations','Tezos HTTP RPC'),
        ('firefly.tezosconnect.blocks','tezos','Monitors chain heads and retrieves blocks','Tezos HTTP RPC / streaming'),
        ('firefly.tezosconnect','signatory','Requests signatures for encoded operations','HTTP / Signatory API'),
        ('firefly.tezosconnect.signing','signatory','Requests an operation signature for a Tezos address','HTTP / Signatory API'),
        ('firefly.tezosconnect','firefly.tezosState','Persists transaction and stream state','PostgreSQL wire or LevelDB API'),
        ('firefly.tezosconnect.persistence','firefly.tezosState','Reads and writes managed state','PostgreSQL wire or LevelDB API'),
        ('firefly.tezosconnect','firefly.core','Delivers confirmed Tezos events','WebSocket / JSON'),
        ('firefly.tezosconnect.streams','firefly.core','Delivers confirmed event batches','WebSocket / JSON')]: link(a,b,label,tech)

    runtime('cardanoconnect','CardanoConnect','Native Cardano connector with operation, contract and event managers.','Rust / Axum','cardano','firefly-cardanoconnect')
    runtime('cardanosigner','Cardano Signer','Signs CBOR transaction bodies using separately stored Cardano keys.','Rust / Axum','cardano','firefly-cardanosigner')
    comps('firefly.cardanoconnect',rows('''
api|HTTP and WebSocket API|Routes transaction, contract, operation and stream requests.|firefly-cardanoconnect/src/routes
operations|Operations manager|Coordinates transaction construction, signing and submission.|firefly-cardanoconnect/src/operations
blockchain|Blockchain client|Selects Blockfrost or direct node-to-client ledger access.|firefly-cardanoconnect/src/blockchain
blockfrost|Blockfrost adapter|Reads chain data and submits transactions through Blockfrost.|firefly-cardanoconnect/src/blockchain/blockfrost
n2c|Node-to-client adapter|Reads local node state and chain synchronization through Pallas.|firefly-cardanoconnect/src/blockchain/n2c
signer|Signer service client|Obtains transaction witnesses from the separate signer.|firefly-cardanoconnect/src/signer.rs
contracts|Contract manager and Balius runtime|Runs optional application WASM workers over Cardano ledger data.|firefly-cardanoconnect/src/contracts
balius|FireFly Balius worker SDK|Implements WASM worker logic, monitoring and contract events.|firefly-balius/src
streams|Stream manager and event multiplexer|Orders operation and blockchain notifications for consumers.|firefly-cardanoconnect/src/streams
persistence|SQLite persistence|Persists operations, checkpoints and contract key-value state.|firefly-cardanoconnect/src/persistence
server|Shared HTTP server and instrumentation|Hosts routes, configuration and tracing; an embedded library.|firefly-server/src
'''),'cardano','Rust')
    flows('firefly.cardanoconnect',rows('''
server|api|Hosts connector HTTP and WebSocket routes
api|operations|Submits operation requests
api|streams|Creates streams and consumes notifications
operations|blockchain|Builds and submits ledger transactions
blockchain|blockfrost|Dispatches requests when Blockfrost is configured
blockchain|n2c|Dispatches requests when direct node access is configured
operations|signer|Requests transaction witnesses
operations|contracts|Invokes configured contract workers
contracts|balius|Loads FireFly-compatible WASM worker logic
contracts|blockchain|Retrieves ledger data for contract workers
operations|persistence|Persists operation lifecycle state
streams|blockchain|Tracks ledger updates
streams|contracts|Consumes application contract events
streams|persistence|Persists stream checkpoints
contracts|persistence|Persists contract worker state
'''),'In-process calls / Rust')
    comps('firefly.cardanosigner',rows('''
api|Signing HTTP API|Accepts signing requests and returns CBOR witness sets.|firefly-cardanosigner/src/routes.rs
keys|Address-indexed key store|Loads configured key files and resolves signing addresses.|firefly-cardanosigner/src/keys.rs
crypto|Ed25519 signing|Signs Cardano transaction-body hashes.|firefly-cardanosigner/src/private_key.rs
server|Shared HTTP server|Hosts signer routes and instrumentation.|firefly-server/src
'''),'cardano','Rust')
    flows('firefly.cardanosigner',rows('''
server|api|Hosts signing API requests
api|keys|Looks up the requested address key
api|crypto|Signs the transaction-body hash
keys|crypto|Supplies the resolved private key
'''),'In-process calls / Rust')
    storage('cardanoState','CardanoConnect SQLite files','Operation, checkpoint and optional contract worker state.','SQLite / filesystem','cardano','firefly-cardanoconnect/src/persistence')
    storage('cardanoKeys','Cardano signing keys','Address-indexed signing key files held by the Cardano Signer.','Filesystem keystore','cardano','firefly-cardanosigner/src/keys.rs')
    external('blockfrostService','Blockfrost API','Hosted or self-managed Cardano ledger API; alternative to direct node access.','cardano','README.md')
    for a,b,label,tech in [
        ('firefly.core.cardanoAdapter','firefly.cardanoconnect','Submits Cardano operations and subscriptions','HTTP REST + WebSocket'),
        ('firefly.core','firefly.cardanoconnect','Submits Cardano operations when configured','HTTP REST + WebSocket'),
        ('firefly.cardanoconnect','firefly.cardanosigner','Requests transaction witnesses','HTTP / JSON'),
        ('firefly.cardanoconnect.signer','firefly.cardanosigner','Requests transaction witnesses','HTTP / JSON'),
        ('firefly.cardanoconnect','blockfrostService','Queries ledger data and submits transactions in Blockfrost mode','HTTPS / Blockfrost API'),
        ('firefly.cardanoconnect.blockfrost','blockfrostService','Queries blocks and submits signed transactions','HTTPS / Blockfrost API'),
        ('blockfrostService','cardano','Reads the ledger and relays submitted transactions','Cardano integration / service boundary'),
        ('firefly.cardanoconnect','cardano','Synchronizes ledger state in direct-node mode','Cardano node-to-client / local socket'),
        ('firefly.cardanoconnect.n2c','cardano','Synchronizes chain and queries ledger state','Cardano node-to-client / local socket'),
        ('firefly.cardanoconnect','firefly.cardanoState','Persists operation and stream state','SQLite / filesystem'),
        ('firefly.cardanoconnect.persistence','firefly.cardanoState','Reads and writes operation and checkpoint records','SQLite API / filesystem'),
        ('firefly.cardanosigner','firefly.cardanoKeys','Loads Cardano signing keys','Filesystem I/O'),
        ('firefly.cardanosigner.keys','firefly.cardanoKeys','Loads address-indexed signing key files','Filesystem I/O'),
        ('firefly.cardanoconnect','firefly.core','Delivers Cardano operation and contract events','WebSocket / JSON'),
        ('firefly.cardanoconnect.streams','firefly.core','Delivers ordered operation and contract events','WebSocket / JSON')]: link(a,b,label,tech)

    runtime('cordaconnect','Corda connector starter','Spring Boot reference starter; application CorDapps and a Core binding require customization.','Java / Spring Boot','cordaconnect','connector')
    E['firefly.cordaconnect']['classification']='Starter requiring customization'
    root='connector/src/main/java/io/kaleido/cordaconnector/'
    for ident,name,desc,path in rows('''
api|REST controllers|Accepts FireFly flow, subscription and stream requests.|controller
flows|CorDapp service and RPC client|Starts application-specific flows through Corda RPC.|rpc
events|Event streams and subscriptions|Collects vault events and batches them for subscribers.|service
websockets|WebSocket delivery|Delivers event batches to connector clients.|ws
persistence|JPA repositories|Persists event-stream and subscription definitions.|db
'''): component('firefly.cordaconnect',ident,name,desc,'cordaconnect',root+path,'Java')
    flows('firefly.cordaconnect',rows('''
api|flows|Submits configured CorDapp flow requests
api|events|Configures event streams and subscriptions
flows|events|Supplies observed CorDapp state changes
events|websockets|Publishes event batches
events|persistence|Persists stream and subscription definitions
'''),'In-process calls / Java')
    storage('cordaState','Corda starter database','Embedded H2/JPA persistence for the connector starter.','H2 / JPA','cordaconnect','connector/src/main/resources')
    link('developer','firefly.cordaconnect','Exercises the starter after application-specific customization','HTTP REST + WebSocket')
    link('firefly.cordaconnect','corda','Invokes custom CorDapps and consumes vault updates','Corda RPC')
    link('firefly.cordaconnect.flows','corda','Invokes custom flows and subscribes to vault updates','Corda RPC')
    link('firefly.cordaconnect','firefly.cordaState','Persists starter stream definitions','JPA / embedded H2')
    link('firefly.cordaconnect.persistence','firefly.cordaState','Reads and writes subscription definitions','JPA / embedded H2')
    link('firefly.cordaconnect.websockets','developer','Delivers starter event batches to an integration developer','WebSocket / JSON')

    # CLI is an executable; the Node.js SDK remains inside the Sandbox server.
    replace_source('tools.cli','cli','README.md')
    replace_source('tools.sandbox.sdk','sdk','lib/firefly.ts')
    replace_source('tools.sandbox.backend','sandbox','server/src')
    comps('tools.cli',rows('''
commands|CLI commands|Accepts stack creation, start, stop and administration commands.|cmd
stacks|Stack configuration and manifests|Assembles member stack configuration and state.|internal/stacks
docker|Docker integration|Invokes Docker Compose to manage local development runtimes.|internal/docker
blockchains|Blockchain setup adapters|Configures selected Ethereum, Fabric, Tezos or Cardano backends.|internal/blockchain
tokens|Token setup adapters|Configures optional ERC token connectors.|internal/tokens
core|Core administration client|Registers identities and configures Core namespaces.|internal/core
'''),'cli','Go')
    flows('tools.cli',rows('''
commands|stacks|Requests development stack lifecycle changes
stacks|docker|Supplies generated runtime manifests
stacks|blockchains|Selects and configures the blockchain backend
stacks|tokens|Selects optional token services
stacks|core|Configures member Core instances
'''),'In-process calls / Go')
    external('dockerEngine','Developer Docker engine','Local container engine used by FireFly CLI; no network is provisioned by this architecture task.','cli','internal/docker')
    link('tools.cli.docker','dockerEngine','Starts and stops local stack services','Docker Compose CLI')
    link('tools.cli','dockerEngine','Manages local development stack services','Docker Compose CLI')
    link('tools.cli.core','firefly.core','Configures and inspects development members','HTTP / REST + Admin API')
    add('tools.perf','container','FireFly Performance CLI','Generates workloads and reports timings against configured FireFly members.','Go','perf','README.md','Optional')
    comps('tools.perf',rows('''
commands|Workload CLI|Loads test configuration and starts performance scenarios.|cmd
runner|Scenario runner|Submits message, blob, token and contract workloads.|internal/perf
server|Control and observation server|Exposes run control and measurements.|internal/server
report|Result reporting|Builds workload timing and throughput reports.|internal/util
'''),'perf','Go')
    flows('tools.perf',rows('''
commands|runner|Starts selected workload scenarios
server|runner|Controls workload execution
runner|report|Supplies measured workload results
'''),'In-process calls / Go')
    link('developer','tools.perf','Runs configured performance workloads','Local process invocation')
    link('tools.perf','firefly.core','Submits workloads and consumes completion events','HTTP REST + WebSocket')
    link('tools.perf.runner','firefly.core','Submits workloads and consumes completion events','HTTP REST + WebSocket')
    add('tools.eventAudit','container','FireFly event auditor','Audits recorded blockchain-event ordering through the Core API.','Go / CLI','firefly','auditevents','Optional')
    component('tools.eventAudit','reader','Event API reader','Pages through recorded blockchain events.','firefly','auditevents/main.go')
    component('tools.eventAudit','ordering','Ordering auditor','Checks increasing protocol identifiers and reports inconsistencies.','firefly','auditevents/main.go')
    link('developer','tools.eventAudit','Audits recorded blockchain-event ordering','Local process invocation')
    link('tools.eventAudit','firefly.core','Retrieves namespace status and recorded blockchain events','HTTP REST / JSON')
    link('tools.eventAudit.reader','firefly.core','Pages through status and enriched event records','HTTP REST / JSON')
    link('tools.eventAudit.reader','tools.eventAudit.ordering','Supplies ordered event pages')
    link('tools.eventAudit.ordering','developer','Reports ordering failures and checked event counts','Console output')
    add('tools.config','container','FireFly configuration migrator','Migrates configuration files between supported FireFly versions.','Go / CLI','firefly','ffconfig','Optional')
    component('tools.config','commands','Configuration CLI','Reads input configuration and requested versions.','firefly','ffconfig/main.go')
    component('tools.config','migration','Configuration migrations','Transforms configuration to the selected schema version.','firefly','ffconfig/migrate')
    link('developer','tools.config','Supplies configuration and migration versions','CLI / file input')
    link('developer','tools.config.commands','Supplies configuration and target version','CLI / file input')
    link('tools.config.commands','tools.config.migration','Submits parsed configuration for migration')
    link('tools.config.migration','developer','Writes migrated configuration for review','YAML / standard output')
    for ident,path in [('sdkHttp','lib/http.ts'),('sdkEvents','lib/websocket.ts')]:
        component('tools.sandbox',ident,'SDK HTTP client' if ident=='sdkHttp' else 'SDK WebSocket client',
                  'Embedded SDK transport for member requests and events.','sdk',path,'TypeScript')
        link('tools.sandbox.sdk','tools.sandbox.'+ident,'Dispatches SDK transport operations','In-process calls / TypeScript')
    link('tools.sandbox.sdkHttp','firefly.core','Sends namespace-scoped API requests','HTTP REST / JSON')
    link('tools.sandbox.sdkEvents','firefly.core','Subscribes to events and sends acknowledgements','WebSocket / JSON')

    # Contracts execute under the EVM but are application artifacts, not Java
    # modules delivered in Besu's source distribution.
    for ident in ('fireflycontract','tokencontracts','businesscontracts'):
        E['besu.node.'+ident]['classification']='Deployed contract responsibility (reference mapping into EVM host)'
    E['besu.node.tokencontracts']['description']='Executes ERC-20, ERC-721 and ERC-1155 application contracts; not a Besu implementation module.'
    E['besu.node.tokencontracts']['sources']=[source('erc20','src/abi'),source('erc1155','src/abi')]
    replace_source('besu.node.keys','besu','crypto/plugin-api/src/main/java/org/hyperledger/besu/plugin/services/securitymodule')
    replace_source('besu.node.worldstate','besu','ethereum/core/src/main/java/org/hyperledger/besu/ethereum/worldstate')
    E['besu.node.qbft']['sources']=[source('besu',path) for path in ('consensus/qbft','consensus/qbft-core','consensus/common')]
    # Expose the actual request entrypoints, not just connector-level arrows.
    for ident,api in [('ethconnect','rest'),('fabconnect','rest'),('tezosconnect','api'),('cardanoconnect','api')]:
        link('firefly.core','firefly.'+ident+'.'+api,'Submits configured ledger requests','HTTP REST / JSON')
    link('firefly.cardanoconnect','firefly.cardanosigner.api','Requests a CBOR transaction witness set','HTTP / JSON')
    link('developer','tools.cli.commands','Invokes development stack commands','Local process invocation')
    link('developer','tools.perf.commands','Invokes configured workload scenarios','Local process invocation')
    link('developer','firefly.cordaconnect.api','Exercises customized starter operations','HTTP REST / JSON')
    # Explicit system-level counterparts preserve ecosystem context when
    # component/container endpoints are hidden in C4 level 1.
    for a,b,label,tech in [
        ('firefly','apps','Delivers subscribed business events and transaction outcomes','WebSocket / webhook / HTTPS'),
        ('developer','firefly','Exercises customized Corda starter operations','HTTP REST / JSON'),
        ('firefly','developer','Returns customized starter event batches','WebSocket / JSON'),
        ('firefly','corda','Invokes custom CorDapps and consumes vault updates through the optional starter','Corda RPC'),
        ('tools','developer','Returns audit results and migrated configuration for review','Local process output'),
        ('firefly','signatory','Requests Tezos operation signatures in the optional configuration','HTTP / Signatory API'),
        ('firefly','blockfrostService','Queries Cardano data and submits transactions in Blockfrost mode','HTTPS / Blockfrost API'),
        ('firefly','fabricCA','Registers and enrolls signing identities through FabConnect','Fabric CA / HTTPS'),
        ('firefly','kafkaBroker','Exchanges legacy connector transaction requests and replies','Kafka protocol'),
        ('firefly','mongo','Persists legacy connector receipts when configured','MongoDB wire protocol'),
        ('tools','dockerEngine','Creates and manages local development stack services','Docker Compose CLI')]:
        link(a,b,label,tech)
    # The bundled starter defaults to in-memory H2; it does not promise durability.
    E['firefly.cordaState']['description']='Starter JPA database; the supplied configuration uses in-memory H2 and is not durable.'
    E['firefly.cordaState']['technology']='H2 / in-memory default'

    # Expand existing focused views and create separate optional configurations.
    bykey={v['key']:v for v in V}
    def extend(key, ids):
        bykey[key]['elements'] += [i for i in ids if i not in bykey[key]['elements']]
    extend('01-landscape',['peerMembers'])
    extend('02-context-firefly',['peerMembers'])
    extend('04-alternatives',['developer','signatory','blockfrostService','kafkaBroker','mongo','fabricCA','tools','dockerEngine'])
    extend('10-firefly-runtime',['peerMembers'])
    extend('11-firefly-state',['peerMembers'])
    extend('20-firefly-core-api',['firefly.core.config','firefly.core.basicAuth'])
    extend('20-firefly-core-messaging',['firefly.core.identity'])
    extend('30-firefly-evm-transactions',['firefly.evm.receipts'])
    extend('40-firefly-dx',['peerMembers','firefly.core'])
    extend('61-tools',['tools.perf','tools.eventAudit','tools.config','dockerEngine'])
    extend('62-sandbox',['tools.sandbox.sdkHttp','tools.sandbox.sdkEvents'])
    # Adapter views include only the selected configuration's runtimes.
    view('component','firefly.core','21-core-blockchain-adapters','Component - Core blockchain adapters',
         ['firefly.core.'+x for x in ('blockchain','ethereum','fabricAdapter','tezosAdapter','cardanoAdapter')]+
         ['firefly.'+x for x in ('evm','ethconnect','fabconnect','tezosconnect','cardanoconnect')])
    view('component','firefly.core','22-core-storage-adapters','Component - Core storage and exchange adapters',
         ['firefly.core.'+x for x in ('data','broadcast','database','postgres','sqlite','sql','dataexchange','ffdx','sharedstorage','ipfs','private','batchprocessor')]+
         ['firefly.'+x for x in ('pg','sqlite','dx','ipfs')])
    view('component','firefly.core','23-core-event-token-adapters','Component - Core token and event adapters',
         ['firefly.core.'+x for x in ('tokens','fftokens','eventplugin','websockets','webhooks','systemEvents','aggregator')]+
         ['firefly.erc20','firefly.erc1155','apps.client'])
    extend('30-firefly-evm-events',['firefly.evm.blocklistener','firefly.evm.metrics'])
    view('component','firefly.evm','31-evm-persistence-delivery','Component - EVMConnect persistence and delivery options',
         ['firefly.evm.'+x for x in ('manager','persistence','postgres','leveldb','streams','delivery','webhook','metrics')]+
         ['firefly.fftmDb','firefly.leveldb','apps.client'])
    view('container','firefly','77-other-evm-network','Container - Optional external EVM network',
         ['firefly.core','firefly.evm','evmNetworks'])
    view('container','firefly','12-embedded-storage-options','Container - Optional embedded Core and EVM persistence',
         ['firefly.core','firefly.sqlite','firefly.evm','firefly.leveldb'])
    configurations=[
        ('ethconnect',['firefly.core','firefly.signer','besu.node','firefly.ethconnectState']),
        ('fabconnect',['firefly.core','fabric','fabricCA','firefly.fabricState']),
        ('tezosconnect',['firefly.core','tezos','signatory','firefly.tezosState']),
        ('cardanoconnect',['firefly.core','firefly.cardanosigner','firefly.cardanoState','firefly.cardanoKeys','cardano','blockfrostService']),
        ('cordaconnect',['developer','corda','firefly.cordaState'])]
    for index,(ident,externals) in enumerate(configurations,70):
        parent='firefly.'+ident
        view('container','firefly',f'{index}-option-{ident}','Container - Optional '+E[parent]['name'],[parent]+externals)
    for ident,groups in {
        'ethconnect':[
            ('requests','rest auth contracts registry openapi transactions rpc receipts kv',['firefly.core','firefly.signer','firefly.ethconnectState','mongo']),
            ('events','rest transactions rpc events websockets kafka kv',['firefly.core','firefly.signer','kafkaBroker','firefly.ethconnectState'])],
        'fabconnect':[
            ('transactions','rest auth identity transactions client receipts',['firefly.core','fabric','fabricCA','firefly.fabricState','mongo']),
            ('events','rest transactions client events websockets kafka kv',['firefly.core','fabric','kafkaBroker','firefly.fabricState'])],
        'tezosconnect':[
            ('transactions','api policy adapter signing persistence',['firefly.core','tezos','signatory','firefly.tezosState']),
            ('events','api blocks events streams persistence',['tezos','firefly.core','firefly.tezosState'])],
        'cardanoconnect':[
            ('operations','server api operations blockchain blockfrost n2c signer persistence',['firefly.core','firefly.cardanosigner','blockfrostService','cardano','firefly.cardanoState']),
            ('contracts-events','api operations contracts balius blockchain streams persistence',['firefly.core','firefly.cardanoState'])],
        'cardanosigner':[('signing','server api keys crypto',['firefly.cardanoconnect','firefly.cardanoKeys'])],
        'cordaconnect':[('starter','api flows events websockets persistence',['developer','corda','firefly.cordaState'])]
    }.items():
        for suffix,components,externals in groups:
            parent='firefly.'+ident
            view('component',parent,'75-'+ident+'-'+suffix,'Component - '+E[parent]['name']+': '+suffix,
                 [parent+'.'+c for c in components.split()]+externals)
    view('container','firefly','76-legacy-broker-options','Container - Legacy connector broker and receipt options',
         ['firefly.ethconnect','firefly.fabconnect','kafkaBroker','mongo'])
    link('firefly.ethconnect','mongo','Stores receipts in the optional MongoDB backend','MongoDB wire protocol')
    link('firefly.fabconnect','mongo','Stores receipts in the optional MongoDB backend','MongoDB wire protocol')
    view('component','tools.cli','64-cli','Component - FireFly CLI',kids('tools.cli')+['developer','dockerEngine','firefly.core'])
    view('component','tools.perf','65-performance','Component - FireFly Performance CLI',kids('tools.perf')+['developer','firefly.core'])
    view('component','tools.eventAudit','66-event-audit','Component - FireFly event auditor',kids('tools.eventAudit')+['developer','firefly.core'])
    view('component','tools.config','67-config-migration','Component - FireFly configuration migrator',kids('tools.config')+['developer'])

    # Recompute views after corrections, including self-relationships that
    # denote communication among instances of one reusable logical container.
    # External context that has no dataflow in a focused view is omitted.
    for v in V:
        elements=set(v['elements'])
        eligible=[r for r in R if r['source'] in elements and r['destination'] in elements]
        connected={r[k] for r in eligible for k in ('source','destination')}
        v['elements']=[x for x in dict.fromkeys(v['elements']) if x in connected]
        v['relationships']=[r['id'] for r in eligible]
        assert eligible, v['key']
    for r in R:
        r['evidence']=list(dict.fromkeys([E[r['source']]['source'], E[r['destination']]['source']]))
    # Hierarchy and view coverage must remain independently auditable.
    for e in E.values():
        e['sources']=e.get('sources',[e['source']])
