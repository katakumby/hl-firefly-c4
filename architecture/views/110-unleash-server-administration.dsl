component unleash.server "110-unleash-server-administration" "Component - Unleash server: administration" {
    title "Component - Unleash server: administration"
    include unleash.ui unleash.server.assets unleash.server.identity unleash.server.adminApi unleash.server.tokens unleash.server.flags unleash.server.targeting unleash.server.importExport unleash.server.persistence unleash.server.audit unleash.server.addons unleash.database
    exclude *->*
    include unleash_serverServeAssets
    include unleash_serverLogin
    include unleash_serverAdminRequests
    include unleash_adminAccess
    include unleash_adminTokens
    include unleash_adminFlags
    include unleash_adminTargeting
    include unleash_adminTransfer
    include unleash_identityStore
    include unleash_tokenStore
    include unleash_flagStore
    include unleash_targetingStore
    include unleash_flagTargeting
    include unleash_flagAudit
    include unleash_targetingAudit
    include unleash_identityAudit
    include unleash_tokenAudit
    include unleash_transferStore
    include unleash_transferAudit
    include unleash_databaseAccess
    include unleash_adminAddons
    include unleash_addonAudit
    autoLayout lr 360 200
}
