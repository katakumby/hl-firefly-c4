component unleash.server "110-unleash-server-supporting-services" "Component - Unleash server: supporting services" {
    title "Component - Unleash server: supporting services"
    include unleash.server.persistence unleash.database unleash.server.metrics unleash.server.adminApi unleash.server.audit unleash.server.insights unleash.server.evaluation unleash.server.flags unleash.server.addons unleash.server.jobs unleash.server.identity unleash.server.health
    exclude *->*
    include unleash_databaseAccess
    include unleash_metricsStore
    include unleash_adminHistory
    include unleash_adminInsights
    include unleash_adminUsage
    include unleash_adminPlayground
    include unleash_playgroundFlags
    include unleash_playgroundSegments
    include unleash_adminSettings
    include unleash_insightsStore
    include unleash_metricsLifecycle
    include unleash_auditLifecycle
    include unleash_lifecycleAudit
    include unleash_lifecycleMeasurements
    include unleash_auditStore
    include unleash_auditAddons
    include unleash_addonStore
    include unleash_identityNotification
    include unleash_settingsStore
    include unleash_jobPublication
    include unleash_jobMetrics
    include unleash_jobInsights
    include unleash_jobIdentity
    include unleash_healthStore
    include unleash_jobMeasurements
    include unleash_jobFlagMaintenance
    include unleash_jobAddonCleanup
    autoLayout lr 360 200
}
