// Separate snapshot after AZ1 fails and the fenced member has recovered in AZ2.
outage = deploymentEnvironment "AZ1 outage - recovered" {
    region = deploymentNode "Same Azure region - AZ1 unavailable" "Recovery snapshot, not additional infrastructure. H1/H2/F1 remain prerequisites." "Microsoft Azure" {
        failed = deploymentNode "AZ1 - unavailable" "Do not start duplicate V1/V2 or a second member identity." "Failed availability zone" {
            loss = infrastructureNode "Lost V1, V2, R1 and active member" "Ledger disks in AZ1 are temporarily inaccessible. Healthy validators do not depend on them." "Failed compute" {
                // A failed node deliberately has no live data path in this snapshot.
                properties {
                    "structurizr.inspection.model.element.disconnected" "info"
                }
            }
        }
        az2 = deploymentNode "AZ2 - surviving" "One surviving fault domain." "Azure AZ2" {
            validators = infrastructureNode "V3 and V4" "Two existing validators; same identities and on-chain validator set." "Besu QBFT"
            rpc = infrastructureNode "R2 and routing replica" "Healthy non-validator access; recreate backend-local filters and resume from durable checkpoints." "Besu / RPC proxy"
            member = infrastructureNode "Member A recovered" "Core + EVMConnect + DX + Kubo restart once; use existing DBs, keys and reattached ZRS volumes." "Singleton StatefulSet"
            db = infrastructureNode "PostgreSQL primary" "Primary was in AZ2, so this scenario needs reconnection but no database promotion." "Azure PostgreSQL" "Microsoft Azure - Azure Database PostgreSQL Server"
        }
        az3 = deploymentNode "AZ3 - surviving" "Second surviving fault domain." "Azure AZ3" {
            validators = infrastructureNode "V5 and V6" "Four validators survive in total; Besu quorum remains 4 of 6." "Besu QBFT"
            rpc = infrastructureNode "R3 and routing replica" "Healthy non-validator; enough capacity for loss of one zone." "Besu / RPC proxy"
            standby = infrastructureNode "PostgreSQL synchronous standby" "Remains in AZ3. If AZ2 had failed, this standby would instead be promoted." "Azure PostgreSQL" "Microsoft Azure - Azure Database PostgreSQL Server"
        }
        shared = deploymentNode "Surviving regional dependencies" "These resources must retain their data and remain reachable." "Azure regional services" {
            fence = infrastructureNode "Fencing and recovery control" "Confirm old host shutdown via Azure before detach/reattach and replacement. Fail closed if exclusivity cannot be established." "Proposed automation - gate F1"
            keys = infrastructureNode "Qualified HSM + Key Vault" "Validator key operations must survive AZ1 loss. Cloud HSM placement/compatibility still requires gate H1." "External key services"
            disks = infrastructureNode "DX and Kubo ZRS volumes" "Same two disks; single attachment each. Recover filesystem state before marking the member ready." "Premium_ZRS data disks" "Microsoft Azure - Disks"
        }
    }
}
outage.region.az2.validators -> outage.region.az3.validators "Exchange proposals and votes among all four survivors" "devp2p TCP 30303"
outage.region.az2.rpc -> outage.region.az2.validators "Receives finalized blocks and relays transactions" "devp2p TCP 30303"
outage.region.az3.rpc -> outage.region.az3.validators "Receives finalized blocks and relays transactions" "devp2p TCP 30303"
outage.region.az2.member -> outage.region.az2.rpc "Resumes transactions and replays unacknowledged events" "Signing gateway / JSON-RPC"
outage.region.az2.member -> outage.region.az2.db "Loads durable state, nonces and checkpoints" "PostgreSQL TLS"
outage.region.az2.db -> outage.region.az3.standby "Continues synchronous WAL replication" "Azure-managed replication"
outage.region.shared.fence -> outage.region.az2.member "Allows one replacement after old-host fencing" "Kubernetes API"
outage.region.az2.member -> outage.region.shared.disks "Mounts existing member data volumes" "Azure Disk CSI"
outage.region.az2.validators -> outage.region.shared.keys "Uses surviving validator HSM access" "PKCS#11"
outage.region.az3.validators -> outage.region.shared.keys "Uses surviving validator HSM access" "PKCS#11"
outage.region.az2.member -> outage.region.shared.keys "Requests transaction signatures through surviving gateways" "HTTPS"
