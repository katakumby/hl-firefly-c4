dx = container "HTTPS Data Exchange" "Exchanges private envelopes and blobs with authenticated members." "TypeScript / Node.js" {
    url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src"
    properties {
        "architecture.id" "firefly.dx"
        "evidence" "Implementation"
        "architecture.sources" "[\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src\"]"
    }
    api = component "Internal REST API" "Accepts private messages, blobs and peer configuration." "TypeScript / Node.js" {
        url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/api.ts"
        properties {
            "architecture.id" "firefly.dx.api"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/api.ts\"]"
        }
    }
    peers = component "Peer and certificate registry" "Resolves remote endpoints and trusted peer certificates." "TypeScript / Node.js" {
        url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/lib"
        properties {
            "architecture.id" "firefly.dx.peers"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/lib\"]"
        }
    }
    p2p = component "Mutual TLS peer endpoint" "Authenticates remote members and transfers private data." "TypeScript / Node.js" {
        url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/p2p.ts"
        properties {
            "architecture.id" "firefly.dx.p2p"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/routers/p2p.ts\"]"
        }
    }
    messages = component "Message transfer handler" "Sends and receives recipient-scoped message envelopes." "TypeScript / Node.js" {
        url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/messages.ts"
        properties {
            "architecture.id" "firefly.dx.messages"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/messages.ts\"]"
        }
    }
    blobs = component "Blob transfer handler" "Streams binary content to durable member storage." "TypeScript / Node.js" {
        url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts"
        properties {
            "architecture.id" "firefly.dx.blobs"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/blobs.ts\"]"
        }
    }
    events = component "Event queue and acknowledgements" "Queues delivery notifications in memory and processes acknowledgements." "TypeScript / Node.js" {
        url "https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/events.ts"
        properties {
            "architecture.id" "firefly.dx.events"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/dataexchange-https/tree/b6a212d531da1ff1c24e762e7156e2593c73d052/src/handlers/events.ts\"]"
        }
    }
}
