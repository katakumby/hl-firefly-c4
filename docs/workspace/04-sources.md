# Official sources and coverage

## Repository snapshots

| Source | Captured revision | Documents read |
|---|---|---|
| firefly | [2acb871a5a85](https://github.com/hyperledger-firefly/firefly/tree/2acb871a5a85eca774fd49d07ac9b925218f3d7d) | 12 |
| evmconnect | [cd3115124c50](https://github.com/hyperledger-firefly/evmconnect/tree/cd3115124c50f8215df1423749f22b558f83b559) | 3 |
| fftm | [35e3ade41cb2](https://github.com/hyperledger-firefly/transaction-manager/tree/35e3ade41cb20b3c778dd5b60ab6af2d56e1b286) | 2 |
| signer | [cfafd71fb4d2](https://github.com/hyperledger-firefly/signer/tree/cfafd71fb4d2c3061a946f6466269877c3f04d9d) | 1 |
| dx | [b6a212d531da](https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052) | 5 |
| erc20 | [7993b308284a](https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9) | 1 |
| erc1155 | [0355a0eb11fd](https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469) | 1 |
| charts | [4fa264c16779](https://github.com/hyperledger-firefly/helm-charts/tree/4fa264c1677914ca32c090641622e4b7c14200f4) | 5 |
| besu | [18c4d62e446c](https://github.com/besu-eth/besu/tree/18c4d62e446cea67050756b001d92fdbc97d01cc) | 2 |
| ui | [658bae40220f](https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5) | 1 |
| sandbox | [ef7f240b8acf](https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069) | 1 |

Snapshot timestamps and SHA-256 fingerprints for retrieved documents are in sources.json. Element URLs point to these revisions, not a moving main branch.

## Official documentation

| Topic | Source |
|---|---|
| qbft | [Official documentation](https://docs.besu-eth.org/private-networks/how-to/configure/consensus/qbft) |
| permissioning | [Official documentation](https://docs.besu-eth.org/private-networks/concepts/permissioning) |
| besu-production | [Official documentation](https://docs.besu-eth.org/private-networks/how-to/configure/bootnodes) |
| aks | [Official documentation](https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure) |
| aks-reliability | [Official documentation](https://learn.microsoft.com/en-us/azure/reliability/reliability-aks) |
| disks | [Official documentation](https://learn.microsoft.com/en-us/azure/virtual-machines/disks-redundancy) |
| cnpg | [Official documentation](https://cloudnative-pg.io/docs/1.28/replication/) |
| kubernetes-fencing | [Official documentation](https://kubernetes.io/docs/concepts/cluster-administration/node-shutdown/) |
| ipfs | [Official documentation](https://docs.ipfs.tech/concepts/how-ipfs-works/) |
| structurizr | [Official documentation](https://docs.structurizr.com/binaries) |
| inspect | [Official documentation](https://docs.structurizr.com/inspect) |

## FireFly Core source-package audit

Every top-level runtime package is represented by a component group. Non-runtime support packages are explicitly classified below.

| Source package | Representation |
|---|---|
| internal/apiserver | firefly.core.api |
| internal/assets | firefly.core.assets |
| internal/batch | firefly.core.batch, firefly.core.batchprocessor |
| internal/blockchain | firefly.core.blockchain |
| internal/broadcast | firefly.core.broadcast |
| internal/cache | firefly.core.cache |
| internal/contracts | firefly.core.contracts |
| internal/coreconfig | Configuration definitions consumed by namespace/plugin initialization. |
| internal/coremsgs | Shared message/error constants consumed by the modeled subsystems. |
| internal/data | firefly.core.data, firefly.core.schema, firefly.core.database, firefly.core.dataexchange |
| internal/database | firefly.core.database |
| internal/dataexchange | firefly.core.dataexchange |
| internal/definitions | firefly.core.definitions |
| internal/events | firefly.core.aggregator, firefly.core.subscriptions, firefly.core.dispatcher, firefly.core.eventplugin |
| internal/identity | firefly.core.identity |
| internal/metrics | firefly.core.metrics |
| internal/multiparty | firefly.core.multiparty |
| internal/namespace | firefly.core.namespaces |
| internal/networkmap | firefly.core.networkmap |
| internal/operations | firefly.core.operations |
| internal/orchestrator | firefly.core.orchestrator |
| internal/privatemessaging | firefly.core.private |
| internal/reference | API/configuration reference generation; build/documentation support. |
| internal/shareddownload | firefly.core.download |
| internal/sharedstorage | firefly.core.sharedstorage |
| internal/spievents | firefly.core.spievents |
| internal/syncasync | firefly.core.syncasync |
| internal/tokens | firefly.core.tokens |
| internal/txcommon | firefly.core.txhelper |
| internal/txwriter | firefly.core.txwriter |

## Alternatives and boundaries

- Ethereum/EthConnect, Fabric/FabConnect, Tezos, Cardano and the Corda starter appear as alternatives; Corda requires application-specific development.
- PostgreSQL is selected. SQLite is the implemented embedded database alternative, represented by the database-plugin responsibility; no SQLite server is implied.
- Core event adapters cover WebSocket, webhook and system events; authentication and identity resolution remain configurable interfaces.
- Early architectural prose mentioning possible backends such as CouchDB is not evidence of a currently implemented backend.
- EIP-712, ABI, RLP and cryptography libraries are not separately deployed signing services. Runtime diagrams show their owning responsibility.
- Logging, retry utilities, public types and tests are grouped under their owning subsystem rather than represented as code-level diagrams.
- coverage.csv maps all elements to sources and views. The parsed JSON audit verifies component-view coverage.

## Relationship evidence

Relationships describe architecture-level information flow, not a complete call graph. In-process arrows group the responsibilities shown in official architecture and source modules; each arrow need not be a single direct method invocation. Deployment, application examples and operational choices are proposed reference design.
