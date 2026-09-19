dockerEngine = softwareSystem "Developer Docker engine" "Local container engine used by FireFly CLI; no network is provisioned by this architecture task." {
    tags "Optional"
    url "https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/docker"
    properties {
        "architecture.id" "dockerEngine"
        "evidence" "External integration boundary"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cli/tree/9b868d3326ba4fbadd01c74a36c7e5a92a8c2609/internal/docker\"]"
    }
}
