firefly.ipfs -> firefly.ipfsRepo "Reads and writes Kubo keys, pins and blocks" "Filesystem I/O" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://docs.ipfs.tech/concepts/how-ipfs-works/\"]"
    }
}

firefly.ipfs -> firefly.ipfs "Retrieves shared content blocks from peers by CID" "IPFS / libp2p" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://docs.ipfs.tech/concepts/how-ipfs-works/\"]"
    }
}
