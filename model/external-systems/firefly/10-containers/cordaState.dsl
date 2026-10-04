!element firefly {
    cordaState = container "Corda starter database" "Starter JPA database; the supplied configuration uses in-memory H2 and is not durable." "H2 / in-memory default" {
        tags "Database"
        url "https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/resources"
        properties {
            "architecture.id" "firefly.cordaState"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/cordaconnect/tree/6579ca46e0d46c9c330c8b2b95f1dd83f0804640/connector/src/main/resources\"]"
        }
    }
}
