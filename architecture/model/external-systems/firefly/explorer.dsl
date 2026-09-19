explorer = container "FireFly Explorer" "Browser application served by Core; queries member state through the Core API." "React / TypeScript / browser" {
    url "https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5/src"
    properties {
        "architecture.id" "firefly.explorer"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5/src\"]"
    }
    app = component "Explorer screens and API client" "Displays member resources and queries Core through browser HTTP requests." "React / TypeScript" {
        url "https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5/src"
        properties {
            "architecture.id" "firefly.explorer.app"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/ui/tree/658bae40220f124e0e20182cc48b231473e754c5/src\"]"
        }
    }
}
