component unleash.server "110-unleash-server-configuration-delivery" "Component - Unleash server: configuration delivery" {
    title "Component - Unleash server: configuration delivery"
    include unleash.server.tokens unleash.server.persistence unleash.database unleash.edge unleash.server.clientApi unleash.server.edgeApi unleash.server.frontendApi unleash.server.configuration unleash.server.evaluation unleash.server.metrics unleash.server.jobs unleash.server.health
    exclude *->*
    include unleash_tokenStore
    include unleash_databaseAccess
    include unleash_edgeClientFetch
    include unleash_edgeClientMetrics
    include unleash_edgeTokenValidation
    include unleash_clientTokenCheck
    include unleash_frontendTokenCheck
    include unleash_edgeTokenLookup
    include unleash_clientProjection
    include unleash_projectionStore
    include unleash_frontendEvaluate
    include unleash_evaluationConfiguration
    include unleash_clientUsage
    include unleash_frontendUsage
    include unleash_metricsStore
    include unleash_jobRevision
    include unleash_jobTokens
    include unleash_jobFrontendSettings
    include unleash_evaluationSettings
    include unleash_healthEvaluation
    autoLayout lr 360 200
}
