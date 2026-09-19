ui = container "Admin UI" "Runs management screens in the browser; the server distributes its static assets." "React / TypeScript / browser" {
    tags "UnleashCatalog"
    url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src"
    properties {
        "architecture.id" "unleash.ui"
        "evidence" "Implementation; logical C4 grouping"
        "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src\"]"
    }

    shell = component "Application shell and session" "Routes screens and shares authenticated user, permissions and UI configuration." "React / TypeScript / browser" {
        tags "UnleashCatalog"
        url "https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/ApplicationRoot.tsx"
        properties {
            "architecture.id" "unleash.ui.shell"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/ApplicationRoot.tsx\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/App.tsx\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/contexts\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/providers\"]"
        }
    }

    flags = component "Flag and project screens" "Edits flags, strategies, variants, segments, context fields, projects and environments." "React / TypeScript / browser" {
        tags "UnleashCatalog"
        url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/feature"
        properties {
            "architecture.id" "unleash.ui.flags"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/feature\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/project\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/segments\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/context\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/strategies\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/environments\"]"
        }
    }

    admin = component "Administration screens" "Manages OSS user, token, settings, import/export and add-on configuration." "React / TypeScript / browser" {
        tags "UnleashCatalog"
        url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/admin"
        properties {
            "architecture.id" "unleash.ui.admin"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/admin\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/user\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/integrations\"]"
        }
    }

    reports = component "Reporting and playground screens" "Displays audit history, SDK usage and lifecycle insights; submits evaluation experiments." "React / TypeScript / browser" {
        tags "UnleashCatalog"
        url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/events"
        properties {
            "architecture.id" "unleash.ui.reports"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/events\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/application\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/insights\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/playground\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/component/personalDashboard\"]"
        }
    }

    api = component "API clients and query cache" "Sends authenticated requests and caches or invalidates resource queries after mutations." "React / TypeScript / browser" {
        tags "UnleashCatalog"
        url "https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/hooks/api"
        properties {
            "architecture.id" "unleash.ui.api"
            "evidence" "Implementation; logical C4 grouping"
            "architecture.sources" "[\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/hooks/api\",\"https://github.com/Unleash/unleash/tree/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/openapi\",\"https://github.com/Unleash/unleash/blob/66d4a45c1d24c4bc8a08d8c75d205bd61dc3aed0/frontend/src/hooks/useClearSWRCache.ts\"]"
        }
    }
}
