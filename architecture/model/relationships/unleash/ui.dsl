// Named internal flows. Request/response results are documented on the initiating arrow.
// Container and component projections describe the same exchanges at different C4 levels.

unleash_uiAssets = unleash.ui -> unleash.server "Requests the Admin UI document and assets" "HTTP(S) / HTML, JS, CSS" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.uiAssets"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\"]"
    }
}

unleash_uiManagement = unleash.ui -> unleash.server "Submits login, configuration and reporting requests" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.uiManagement"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\"]"
    }
}

unleash_uiShellQueries = unleash.ui.shell -> unleash.ui.api "Requests session, permissions and UI configuration" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.uiShellQueries"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/ApplicationRoot.tsx\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/App.tsx\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/hooks/api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/openapi\"]"
    }
}

unleash_uiFlagCommands = unleash.ui.flags -> unleash.ui.api "Queries and edits flag configuration" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.uiFlagCommands"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/feature\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/project\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/hooks/api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/openapi\"]"
    }
}

unleash_uiAdminCommands = unleash.ui.admin -> unleash.ui.api "Queries and changes administration resources" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.uiAdminCommands"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/admin\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/user\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/hooks/api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/openapi\"]"
    }
}

unleash_uiReportQueries = unleash.ui.reports -> unleash.ui.api "Requests history, usage and evaluation results" "In-process" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.uiReportQueries"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/events\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/application\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/hooks/api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/openapi\"]"
    }
}

unleash_uiComponentAssets = unleash.ui.shell -> unleash.server "Loads the application document and bundle" "HTTP(S) / HTML, JS, CSS" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.uiComponentAssets"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/ApplicationRoot.tsx\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/App.tsx\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\"]"
    }
}

unleash_uiComponentSession = unleash.ui.api -> unleash.server "Submits credentials and resolves session state" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.uiComponentSession"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/hooks/api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/openapi\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\"]"
    }
}

unleash_uiComponentAdmin = unleash.ui.api -> unleash.server "Calls management, reporting and playground APIs" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.uiComponentAdmin"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/hooks/api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/openapi\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/server-impl.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\"]"
    }
}

unleash_serverServeAssets = unleash.ui -> unleash.server.assets "Requests entry HTML and browser assets" "HTTP(S) / HTML, JS, CSS" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.serverServeAssets"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/app.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/index.js\"]"
    }
}

unleash_serverLogin = unleash.ui -> unleash.server.identity "Submits credentials and session requests" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.serverLogin"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/oss-authentication.ts\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/middleware/session-db.ts\"]"
    }
}

unleash_serverAdminRequests = unleash.ui -> unleash.server.adminApi "Submits resource commands and report queries" "HTTP(S) / JSON" "Dataflow,UnleashCatalog" {
    properties {
        "architecture.id" "unleash.flow.serverAdminRequests"
        "evidence" "Architecture dataflow inferred from pinned implementation"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/routes/admin-api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/src/lib/openapi\"]"
    }
}
