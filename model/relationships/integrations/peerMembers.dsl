peerMembers -> firefly "Delivers peer payloads and transfer acknowledgements" "HTTPS / mTLS" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/multiparty/multiparty_flow.md\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
    }
}

peerMembers -> firefly.dx "Delivers private envelopes, blobs and transfer results" "HTTPS / mTLS" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/multiparty/multiparty_flow.md\",\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src\"]"
    }
}

peerMembers -> firefly.dx.p2p "Transfers inbound private envelopes and blobs" "HTTPS / mTLS" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/doc-site/docs/overview/multiparty/multiparty_flow.md\",\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/p2p.ts\"]"
    }
}
