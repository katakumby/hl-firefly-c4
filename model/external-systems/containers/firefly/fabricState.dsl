fabricState = container "FabConnect local state" "Connector LevelDB state and Fabric wallet identity material." "LevelDB + wallet files" {
    tags "Database"
    url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client/store.go"
    properties {
        "architecture.id" "firefly.fabricState"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client/store.go\"]"
    }
}
