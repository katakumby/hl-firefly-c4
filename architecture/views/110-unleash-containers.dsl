container unleash "110-unleash-containers" "Container - Unleash: core and optional Edge" {
    title "Container - Unleash: core and optional Edge"
    include unleash.ui unleash.server unleash.database unleash.edge
    exclude *->*
    include unleash_uiAssets
    include unleash_uiManagement
    include unleash_serverDatabase
    include unleash_edgeFeatures
    include unleash_edgeValidation
    include unleash_edgeUsage
    autoLayout lr 360 200
}
