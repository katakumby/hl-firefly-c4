database = container "Keycloak database" "Persists realm configuration, users, credentials and persistent session state." "PostgreSQL (reference choice)" {
    tags "Database"
    url "https://www.keycloak.org/server/db"
    properties {
        "architecture.id" "keycloak.database"
        "evidence" "Documented product capability"
        "architecture.sources" "[\"https://www.keycloak.org/server/db\"]"
    }
}
