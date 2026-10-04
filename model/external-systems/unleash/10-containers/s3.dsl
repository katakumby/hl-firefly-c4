!element unleash {
    s3 = container "Edge S3 storage (optional)" "Stores feature/token recovery snapshots; an alternative to file or Redis persistence." "Amazon S3 API / JSON objects" {
        tags "Database"
        url "https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/s3.rs"
        properties {
            "architecture.id" "unleash.s3"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/s3.rs\"]"
        }
    }
}
