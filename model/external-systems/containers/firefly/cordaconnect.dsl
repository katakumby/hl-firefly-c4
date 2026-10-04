cordaconnect = container "Corda connector starter" "Spring Boot reference starter; application CorDapps and a Core binding require customization." "Java / Spring Boot" {
    url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector"
    properties {
        "architecture.id" "firefly.cordaconnect"
        "evidence" "Starter requiring customization"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector\"]"
    }
    api = component "REST controllers" "Accepts FireFly flow, subscription and stream requests." "Java" {
        url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/controller"
        properties {
            "architecture.id" "firefly.cordaconnect.api"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/controller\"]"
        }
    }
    flows = component "CorDapp service and RPC client" "Starts application-specific flows through Corda RPC." "Java" {
        url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/rpc"
        properties {
            "architecture.id" "firefly.cordaconnect.flows"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/rpc\"]"
        }
    }
    events = component "Event streams and subscriptions" "Collects vault events and batches them for subscribers." "Java" {
        url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/service"
        properties {
            "architecture.id" "firefly.cordaconnect.events"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/service\"]"
        }
    }
    websockets = component "WebSocket delivery" "Delivers event batches to connector clients." "Java" {
        url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/ws"
        properties {
            "architecture.id" "firefly.cordaconnect.websockets"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/ws\"]"
        }
    }
    persistence = component "JPA repositories" "Persists event-stream and subscription definitions." "Java" {
        url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/db"
        properties {
            "architecture.id" "firefly.cordaconnect.persistence"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/java/io/kaleido/cordaconnector/db\"]"
        }
    }
}
