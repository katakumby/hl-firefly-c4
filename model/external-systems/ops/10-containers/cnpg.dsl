!element ops {
    cnpg = container "PostgreSQL operator" "Reconciles database roles, endpoints and fenced failover." "CloudNativePG" {
        url "https://cloudnative-pg.io/docs/1.28/replication/"
        properties {
            "architecture.id" "ops.cnpg"
            "evidence" "Reference choice"
            "architecture.sources" "[\"https://cloudnative-pg.io/docs/1.28/replication/\"]"
        }
    }
}
