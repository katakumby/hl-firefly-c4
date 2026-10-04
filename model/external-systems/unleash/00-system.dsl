unleash = softwareSystem "Unleash" "Open-source feature management reference: Admin UI, server, PostgreSQL and optional OSS Edge. No consumer integrations are selected." {
    url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0"
    !docs ../../../documentation/system/unleash
    properties {
        "architecture.id" "unleash"
        "evidence" "Implementation; logical C4 grouping"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0\",\"https://github.com/Unleash/unleash-edge/tree/c947878de70214235c79eeb5ebe5f35b77ecc075\"]"
        "architecture.version" "Unleash 8.2.0; OSS Edge 20.5.0"
        "architecture.edition" "Open Source"
        "architecture.edge.eol" "2026-12-31"
        // Intentionally reusable and isolated; future initiatives choose their own integrations.
        "structurizr.inspection.model.element.disconnected" "info"
        // The system is rendered as the boundary of its container views; no context view is requested.
        "structurizr.inspection.model.element.noview" "info"
    }
}
