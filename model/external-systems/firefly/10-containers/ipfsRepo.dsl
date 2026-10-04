!element firefly {
    ipfsRepo = container "IPFS repository" "Stores Kubo identity, pins and content blocks; storage-class placement is deferred." "Filesystem" {
        tags "Database"
        url "https://docs.ipfs.tech/concepts/how-ipfs-works/"
        properties {
            "architecture.id" "firefly.ipfsRepo"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://docs.ipfs.tech/concepts/how-ipfs-works/\"]"
        }
    }
}
