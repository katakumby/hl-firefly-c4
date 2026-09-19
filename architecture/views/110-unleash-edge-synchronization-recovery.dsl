component unleash.edge "110-unleash-edge-synchronization-recovery" "Component - Unleash Edge: synchronization and recovery" {
    title "Component - Unleash Edge: synchronization and recovery"
    include unleash.edge.tokens unleash.edge.upstream unleash.edge.refresh unleash.edge.cache unleash.edge.evaluation unleash.edge.metrics unleash.server unleash.edge.persistence unleash.files unleash.redis unleash.s3 unleash.edge.offline
    exclude *->*
    include unleash_edgeTokenUpstream
    include unleash_edgeTokenRefresh
    include unleash_edgePoll
    include unleash_edgeRefreshCache
    include unleash_edgeRefreshEngine
    include unleash_edgeSendUsage
    include unleash_edgeUpstreamFeatures
    include unleash_edgeUpstreamTokens
    include unleash_edgeUpstreamUsage
    include unleash_edgeTokenSnapshot
    include unleash_edgeSnapshotTokens
    include unleash_edgeSnapshotFeatures
    include unleash_edgeRecoveredEngine
    include unleash_edgePersistenceFiles
    include unleash_edgePersistenceRedis
    include unleash_edgePersistenceS3
    include unleash_edgeOfflineFiles
    include unleash_edgeOfflineTokens
    include unleash_edgeOfflineCache
    include unleash_edgeOfflineEngine
    autoLayout tb 420 260
}
