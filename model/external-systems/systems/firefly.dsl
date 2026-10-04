group "FireFly ecosystem" {
    firefly = softwareSystem "Hyperledger FireFly" "Reusable supernode architecture; each consortium member deploys an isolated instance." {
        url "https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d"
        properties {
            "architecture.id" "firefly"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d\"]"
        }
        !include ../containers/firefly
    }
}
