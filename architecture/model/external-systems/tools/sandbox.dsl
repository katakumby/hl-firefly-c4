sandbox = container "Sandbox server" "Serves Sandbox browser assets and maps UI requests to a selected FireFly API." "Node.js / TypeScript" {
    tags "Optional"
    url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/server/src"
    properties {
        "architecture.id" "tools.sandbox"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/server/src\"]"
    }
    backend = component "Sandbox backend" "Maps UI actions into SDK requests." "Node.js / TypeScript" {
        url "https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/server/src"
        properties {
            "architecture.id" "tools.sandbox.backend"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/sandbox/tree/ef7f240b8acf9c79c8fdf5a8bccb73e9de482069/server/src\"]"
        }
    }
    sdk = component "FireFly Node.js SDK" "Calls the selected API and consumes events." "TypeScript library" {
        url "https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/firefly.ts"
        properties {
            "architecture.id" "tools.sandbox.sdk"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/firefly.ts\"]"
        }
    }
    sdkHttp = component "SDK HTTP client" "Embedded SDK transport for member requests and events." "TypeScript" {
        url "https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/http.ts"
        properties {
            "architecture.id" "tools.sandbox.sdkHttp"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/http.ts\"]"
        }
    }
    sdkEvents = component "SDK WebSocket client" "Embedded SDK transport for member requests and events." "TypeScript" {
        url "https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/websocket.ts"
        properties {
            "architecture.id" "tools.sandbox.sdkEvents"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/sdk-nodejs/tree/c4e813bc611ff2c6222ff84adf1cceabfd929172/lib/websocket.ts\"]"
        }
    }
}
