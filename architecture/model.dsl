workspace "Shared architecture model" "Reusable external reference systems; accepted platform modules are added separately." {
    !identifiers hierarchical
    !impliedRelationships false
    properties {
        "structurizr.inspection.workspace.scope" "info"
        // Add system-specific documentation and decisions when meaningful content exists.
        "structurizr.inspection.model.softwaresystem.documentation" "info"
        "structurizr.inspection.model.softwaresystem.decisions" "info"
    }
    model {
        !include model/people.dsl
        group "FireFly ecosystem" {
            !include model/external-systems/firefly/system.dsl
            !include model/external-systems/tools/system.dsl
            !include model/external-systems/peerMembers/system.dsl
        }
        group "EVM ledger networks" {
            !include model/external-systems/besu/system.dsl
            !include model/external-systems/evmNetworks/system.dsl
        }
        !include model/external-systems/apps/system.dsl
        !include model/external-systems/ops/system.dsl
        group "Fabric ecosystem" {
            !include model/external-systems/fabric/system.dsl
            !include model/external-systems/fabricCA/system.dsl
        }
        group "Tezos ecosystem" {
            !include model/external-systems/tezos/system.dsl
            !include model/external-systems/signatory/system.dsl
        }
        group "Cardano ecosystem" {
            !include model/external-systems/cardano/system.dsl
            !include model/external-systems/blockfrostService/system.dsl
        }
        !include model/external-systems/corda/system.dsl
        group "Legacy connector infrastructure" {
            !include model/external-systems/kafkaBroker/system.dsl
            !include model/external-systems/mongo/system.dsl
        }
        !include model/external-systems/dockerEngine/system.dsl
        !include model/external-systems/managedTarget/system.dsl
        group "Azure cryptographic services" {
            !include model/external-systems/azureManagement/system.dsl
            !include model/external-systems/managedHsm/system.dsl
        }
        group "Identity and federation" {
            !include model/external-systems/keycloak/system.dsl
            !include model/external-systems/entraId/system.dsl
            !include model/external-systems/adDs/system.dsl
            !include model/external-systems/adFs/system.dsl
        }
        group "Privileged access and secrets" {
            !include model/external-systems/cyberarkPam/system.dsl
            !include model/external-systems/conjur/system.dsl
        }
        !include model/relationships/firefly.dsl
        !include model/relationships/integrations.dsl
        !include model/relationships/besu.dsl
        !include model/relationships/tools.dsl
        !include model/relationships/ops.dsl
        !include model/relationships/keycloak.dsl
        !include model/relationships/managedHsm.dsl
        !include model/relationships/cyberarkPam.dsl
        !include model/relationships/conjur.dsl
        !include model/relationships/entraId.dsl
        !include model/relationships/adDs.dsl
        !include model/relationships/adFs.dsl
        !include model/relationships/apps.dsl
    }
    views {
        !include views/styles.dsl
        properties {
            "structurizr.sort" "key"
        }
    }
    configuration {
        scope none
    }
}
