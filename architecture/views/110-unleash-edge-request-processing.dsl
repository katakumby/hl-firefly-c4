component unleash.edge "110-unleash-edge-request-processing" "Component - Unleash Edge: request processing" {
    title "Component - Unleash Edge: request processing"
    include unleash.edge.http unleash.edge.tokens unleash.edge.cache unleash.edge.evaluation unleash.edge.metrics unleash.edge.health
    exclude *->*
    include unleash_edgeRequestAuth
    include unleash_edgeRequestFeatures
    include unleash_edgeRequestEvaluation
    include unleash_edgeRequestUsage
    include unleash_edgeRequestHealth
    include unleash_edgeFilterScope
    include unleash_edgeEvaluationScope
    include unleash_edgeReadyCache
    include unleash_edgeReadyTokens
    include unleash_edgeHealthMetrics
    autoLayout lr 360 200
}
