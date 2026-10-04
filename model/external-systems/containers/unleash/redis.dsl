redis = container "Edge Redis storage (optional)" "Stores feature/token recovery snapshots; an alternative to file or S3 persistence." "Redis / serialized JSON" {
    tags "Database"
    url "https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/redis.rs"
    properties {
        "architecture.id" "unleash.redis"
        "evidence" "Implementation; logical C4 grouping"
        "architecture.sources" "[\"https://github.com/Unleash/unleash-edge/blob/c947878de70214235c79eeb5ebe5f35b77ecc075/crates/oss/unleash-edge-persistence/src/redis.rs\"]"
    }
}
