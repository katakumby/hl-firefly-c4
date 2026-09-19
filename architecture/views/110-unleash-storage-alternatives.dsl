container unleash "110-unleash-storage-alternatives" "Container - Unleash Edge: storage alternatives" {
    title "Container - Unleash Edge: storage alternatives"
    include unleash.edge unleash.files unleash.redis unleash.s3
    exclude *->*
    include unleash_edgeFileSnapshots
    include unleash_edgeRedisSnapshots
    include unleash_edgeS3Snapshots
    include unleash_edgeBootstrapFiles
    autoLayout lr 360 200
}
