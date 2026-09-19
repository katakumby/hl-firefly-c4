besu.node.rpc -> besu.node.permissioning "Checks transaction sender admission" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/api\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/permissioning\"]"
    }
}

besu.node.rpc -> besu.node.txpool "Submits signed transactions" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/api\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/eth\"]"
    }
}

besu.node.rpc -> besu.node.worldstate "Queries account and contract state" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/api\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core/src/main/java/org/hyperledger/besu/ethereum/worldstate\"]"
    }
}

besu.node.rpc -> besu.node.blockprocessor "Reads receipts and contract logs" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/api\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core\"]"
    }
}

besu.node.discovery -> besu.node.p2p "Provides discovered peer endpoints" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/p2p\"]"
    }
}

besu.node.p2p -> besu.node.permissioning "Checks connecting node admission" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/p2p\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/permissioning\"]"
    }
}

besu.node.p2p -> besu.node.txpool "Gossips pending transactions" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/p2p\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/eth\"]"
    }
}

besu.node.p2p -> besu.node.sync "Delivers requested blocks and state" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/p2p\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/eth\"]"
    }
}

besu.node.p2p -> besu.node.qbft "Delivers consensus protocol messages" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/p2p\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/consensus/qbft\"]"
    }
}

besu.node.sync -> besu.node.blockprocessor "Submits downloaded blocks for validation" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/eth\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core\"]"
    }
}

besu.node.txpool -> besu.node.qbft "Supplies transactions for proposed blocks" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/eth\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/consensus/qbft\"]"
    }
}

besu.node.qbft -> besu.node.keys "Signs proposals and consensus votes" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/consensus/qbft\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/crypto/plugin-api/src/main/java/org/hyperledger/besu/plugin/services/securitymodule\"]"
    }
}

besu.node.qbft -> besu.node.blockprocessor "Commits quorum-approved blocks" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/consensus/qbft\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core\"]"
    }
}

besu.node.blockprocessor -> besu.node.evm "Executes transactions and validates results" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/evm\"]"
    }
}

besu.node.evm -> besu.node.worldstate "Reads and updates contract and account state" "EVM execution" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/evm\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core/src/main/java/org/hyperledger/besu/ethereum/worldstate\"]"
    }
}

besu.node.worldstate -> besu.node.storage "Persists world-state updates" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core/src/main/java/org/hyperledger/besu/ethereum/worldstate\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/plugins/rocksdb\"]"
    }
}

besu.node.blockprocessor -> besu.node.storage "Persists blocks, receipts and logs" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/plugins/rocksdb\"]"
    }
}

besu.node.evm -> besu.node.fireflycontract "Executes batch pinning calls" "EVM execution" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/evm\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol\"]"
    }
}

besu.node.evm -> besu.node.tokencontracts "Executes standard token operations" "EVM execution" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/evm\",\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi\"]"
    }
}

besu.node.evm -> besu.node.businesscontracts "Executes application business calls" "EVM execution" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/evm\",\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\"]"
    }
}

besu.node.fireflycontract -> besu.node.worldstate "Writes pinning state and log results" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core/src/main/java/org/hyperledger/besu/ethereum/worldstate\"]"
    }
}

besu.node.tokencontracts -> besu.node.worldstate "Writes token balances and log results" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/tokens-erc20-erc721/tree/7993b308284a396950587b5206370f7f254073d9/src/abi\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core/src/main/java/org/hyperledger/besu/ethereum/worldstate\"]"
    }
}

besu.node.businesscontracts -> besu.node.worldstate "Writes application state and log results" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://hyperledger-firefly.github.io/firefly/head/architecture/node_component_architecture/\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/core/src/main/java/org/hyperledger/besu/ethereum/worldstate\"]"
    }
}

besu.node.qbft -> besu.node.metrics "Records rounds and committed block measurements" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/consensus/qbft\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/metrics\"]"
    }
}

besu.node.p2p -> besu.node.metrics "Records peer connectivity measurements" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/p2p\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/metrics\"]"
    }
}

besu.node.p2p -> besu.node.keys "Authenticates node transport identity" "In-process calls / Java" "Dataflow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/ethereum/p2p\",\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1/crypto/plugin-api/src/main/java/org/hyperledger/besu/plugin/services/securitymodule\"]"
    }
}

besu.node -> besu.node "Gossips transactions, blocks and QBFT peer messages" "DevP2P / TCP" "BlockchainFlow" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/besu-eth/besu/tree/7e05c2342404d27bd06a992e336c5e0c86a5d8d1\"]"
    }
}
