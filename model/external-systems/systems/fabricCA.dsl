group "Fabric ecosystem" {
    fabricCA = softwareSystem "Fabric certificate authority" "Registers and enrolls client identities used by FabConnect." {
        tags "Optional"
        url "https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client/identity.go"
        properties {
            "architecture.id" "fabricCA"
            "evidence" "External integration boundary"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/fabconnect/tree/efab8a2b0ff11863bbd9c5eb8a566820f560546b/internal/fabric/client/identity.go\"]"
        }
    }
}
