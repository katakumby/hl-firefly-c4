firefly.explorer -> firefly.core "Requests Explorer assets and queries member resources" "HTTP(S) / REST + static assets" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5/src\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}

firefly.explorer -> firefly.core.api "Queries messages, operations and network state" "HTTP(S) / REST / JSON" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5/src\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/apiserver\"]"
    }
}

firefly.explorer.app -> firefly.core "Requests member resources and renders returned state" "HTTP(S) / REST / JSON" {
    properties {
        "evidence" "Architecture flow inferred from documented responsibilities"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5/src\",\"https://github.com/hyperledger-firefly/firefly/tree/9d20f3081c9074d5b012427e5572ebc03da8d95d/internal/orchestrator\"]"
    }
}
