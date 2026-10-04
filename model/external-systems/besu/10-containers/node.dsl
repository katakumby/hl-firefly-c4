!element besu {
    node = container "Besu node" "Runs the selected validator or non-validator RPC/discovery role; each instance owns its key and ledger." "Java / Besu / RocksDB" {
        url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1"
        properties {
            "architecture.id" "besu.node"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
        }
        rpc = component "JSON-RPC and subscriptions" "Accepts private-network queries and signed transactions." "Java" {
            group "Besu client implementation"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/api"
            properties {
                "architecture.id" "besu.node.rpc"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/api\"]"
            }
        }
        permissioning = component "Node and account permissioning" "Applies local peer and account allowlists." "Java" {
            group "Besu client implementation"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/permissioning"
            properties {
                "architecture.id" "besu.node.permissioning"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/permissioning\"]"
            }
        }
        discovery = component "Peer discovery" "Discovers peers through configured bootnodes." "Java" {
            group "Besu client implementation"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/p2p"
            properties {
                "architecture.id" "besu.node.discovery"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/p2p\"]"
            }
        }
        p2p = component "DevP2P transport" "Exchanges transactions, blocks and consensus messages." "Java" {
            group "Besu client implementation"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/p2p"
            properties {
                "architecture.id" "besu.node.p2p"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/p2p\"]"
            }
        }
        txpool = component "Transaction pool" "Validates and queues pending transactions." "Java" {
            group "Besu client implementation"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/eth"
            properties {
                "architecture.id" "besu.node.txpool"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/eth\"]"
            }
        }
        sync = component "Chain synchronization" "Downloads and validates missing blocks and state." "Java" {
            group "Besu client implementation"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/eth"
            properties {
                "architecture.id" "besu.node.sync"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/eth\"]"
            }
        }
        blockprocessor = component "Block processor" "Validates blocks and applies state transitions." "Java" {
            group "Besu client implementation"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core"
            properties {
                "architecture.id" "besu.node.blockprocessor"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core\"]"
            }
        }
        qbft = component "QBFT consensus" "Proposes blocks and verifies validator votes. Active only on validator instances." "Java" {
            group "Besu client implementation"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/consensus/qbft"
            properties {
                "architecture.id" "besu.node.qbft"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/consensus/qbft\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/consensus/qbft-core\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/consensus/common\"]"
            }
        }
        evm = component "EVM execution" "Executes smart-contract bytecode deterministically." "Java" {
            group "Besu client implementation"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/evm"
            properties {
                "architecture.id" "besu.node.evm"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/evm\"]"
            }
        }
        worldstate = component "World state and trie" "Tracks account balances, storage and contract state." "Java" {
            group "Besu client implementation"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core/src/main/java/org/hyperledger/besu/ethereum/worldstate"
            properties {
                "architecture.id" "besu.node.worldstate"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core/src/main/java/org/hyperledger/besu/ethereum/worldstate\"]"
            }
        }
        storage = component "Storage provider" "Persists blockchain data and world-state records." "Java" {
            group "Besu client implementation"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/plugins/rocksdb"
            properties {
                "architecture.id" "besu.node.storage"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/plugins/rocksdb\"]"
            }
        }
        keys = component "Node key and security module" "Signs node identity and validator consensus messages." "Java" {
            group "Besu client implementation"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/crypto/plugin-api/src/main/java/org/hyperledger/besu/plugin/services/securitymodule"
            properties {
                "architecture.id" "besu.node.keys"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/crypto/plugin-api/src/main/java/org/hyperledger/besu/plugin/services/securitymodule\"]"
            }
        }
        metrics = component "Metrics and health" "Exposes node, peer and consensus measurements." "Java" {
            group "Besu client implementation"
            url "https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/metrics"
            properties {
                "architecture.id" "besu.node.metrics"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/metrics\"]"
            }
        }
        fireflycontract = component "FireFly multiparty contract" "Executes batch pinning and emits sequencing events." "Solidity / EVM" {
            group "Hosted application contracts"
            url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
            properties {
                "architecture.id" "besu.node.fireflycontract"
                "evidence" "Deployed contract responsibility (reference mapping into EVM host)"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol\"]"
            }
        }
        tokencontracts = component "Token contracts" "Executes ERC-20, ERC-721 and ERC-1155 application contracts; not a Besu implementation module." "Solidity / EVM" {
            group "Hosted application contracts"
            url "https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi"
            properties {
                "architecture.id" "besu.node.tokencontracts"
                "evidence" "Deployed contract responsibility (reference mapping into EVM host)"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi\",\"https://github.com/hyperledger-firefly/tokens-erc1155/tree/0355a0eb11fd12e311829a41bcbfea6148e52469/src/abi\"]"
            }
        }
        businesscontracts = component "Application contracts" "Executes member-defined business rules; example extension." "Solidity / EVM" {
            group "Hosted application contracts"
            url "https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/"
            properties {
                "architecture.id" "besu.node.businesscontracts"
                "evidence" "Deployed contract responsibility (reference mapping into EVM host)"
                "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
            }
        }
    }
}
