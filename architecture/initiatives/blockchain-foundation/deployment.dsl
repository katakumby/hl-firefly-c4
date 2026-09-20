// Snapshot of normal placement. AZ numbers are illustrative, not a selected Azure region.
// Pod-to-pod links model selected Besu peering; views hide the automatically replicated generic mesh.
// FireFly instances share a group and inherit their reference container dependencies.
production = deploymentEnvironment "Production - three AZ" {
    deploymentGroup isolated
    deploymentGroup besu1
    deploymentGroup besu2
    deploymentGroup besu3
    deploymentGroup besu4
    deploymentGroup besu5
    deploymentGroup besu6
    deploymentGroup besu7
    deploymentGroup besu8
    deploymentGroup besu9
    region = deploymentNode "Azure region - selection pending" "One region with three AZs and qualified service SKUs. HSM zone resilience remains admission gate H1." "Microsoft Azure" {
        network = deploymentNode "Regional networking and AKS control" "VNet and subnets span zones; Azure subnets are not zonal." "Azure VNet / private AKS Standard" {
            control = infrastructureNode "Private AKS control plane" "Standard tier; zone-resilient API server; OIDC and Workload Identity enabled." "Azure-managed Kubernetes" "FoundationPlatform"
            ingress = infrastructureNode "Private member ingress" "Zone-redundant Standard internal LB; three mTLS gateway replicas, one per AZ. Core API and DX peer endpoints have separate routes." "Azure Standard LB / Gateway API" "FoundationPlatform,FoundationMiddleware"
            dns = infrastructureNode "Private DNS and egress" "Azure private zones; CoreDNS spread across AZs; zone-redundant firewall path for allowed Azure endpoints." "Azure Private DNS / CoreDNS / Azure Firewall" "FoundationPlatform"
            signing = infrastructureNode "Transaction signing service" "Three stateless gateway replicas across AZ1/2/3; detail in view 04. FFTM remains the sole nonce owner." "ClusterIP / mTLS JSON-RPC" "FoundationMiddleware"
            rpc = infrastructureNode "Besu RPC routing service" "Three proxy replicas, one per AZ. Pin connector filter sessions to one healthy backend; rebuild filters after failover." "ClusterIP / session-aware JSON-RPC proxy" "FoundationBesu,FoundationMiddleware"
        }
        aks = deploymentNode "Private AKS cluster - one member" "System, ledger and middleware pools; explicit zonal capacity and separate Kubernetes namespaces." "AKS Standard / Azure CNI Overlay + Cilium" {
            az1 = deploymentNode "Availability Zone 1" "Independent power, cooling and network failure domain." "Azure AZ 1" {
                capacity = infrastructureNode "AZ1 node-pool capacity" "1 system node; 3 ledger nodes; 2 middleware nodes initially. On-demand VMs; reserve measured recovery capacity." "Zonal AKS pools / VM scale sets" "FoundationPlatform"
                ledger = deploymentNode "Ledger pool - AZ1" "Three separate hosts: two validators and one RPC node. No Spot; no automatic validator scaling." "AKS user pool" {
                    v1pod = deploymentNode "Validator V1 pod" "Unique node identity; dedicated RWO Premium SSD LRS PVC. Pin to AZ1; lost-zone volumes are not on the surviving write path." "StatefulSet / Besu security-module plugin" {
                        node = containerInstance besu.node besu1 {
                            description "V1: one of six QBFT validators; HSM key V1; local RocksDB ledger; private P2P only. HSM qualification gate H1."
                            tags "FoundationBesu,FoundationValidator"
                        }
                    }
                    v2pod = deploymentNode "Validator V2 pod" "Unique node identity; dedicated RWO Premium SSD LRS PVC. Pin to AZ1; lost-zone volumes are not on the surviving write path." "StatefulSet / Besu security-module plugin" {
                        node = containerInstance besu.node besu2 {
                            description "V2: one of six QBFT validators; HSM key V2; local RocksDB ledger; private P2P only. HSM qualification gate H1."
                            tags "FoundationBesu,FoundationValidator"
                        }
                    }
                    rpcpod = deploymentNode "RPC R1 pod" "Non-validator full node, stable P2P endpoint, own RWO Premium SSD LRS PVC. Also serves static peer bootstrap." "StatefulSet / Besu" {
                        node = containerInstance besu.node besu3 {
                            description "R1: non-validator JSON-RPC and event access; readiness checks chain identity, peers and block freshness."
                            tags "FoundationBesu,FoundationRpc"
                        }
                    }
                }
                middleware = deploymentNode "Middleware pool - AZ1" "Separate taint and namespace. mTLS gateway, RPC proxy and stateless signer have one replica per zone." "AKS user pool" {
                    signerpod = deploymentNode "Signing gateway replica 1" "Stateless transaction signing only; the connector owns nonces." "Deployment / one replica per AZ" {
                        signer = containerInstance foundation.signer isolated {
                            description "Replica 1: key allowlist, fixed chain ID, low-s and recovery-parity checks; EC-HSM transaction keys. Integration gate H2."
                            tags "FoundationMiddleware,FoundationSecurity,FoundationSignerReplica"
                        }
                    }
                    recoverypod = deploymentNode "Recovery controller candidate - AZ1" "One of three candidates; only the elected leader coordinates recovery. Gate F1." "Deployment / one replica per AZ" {
                        controller = containerInstance foundation.recovery isolated {
                            description "AZ1 candidate; Kubernetes Lease election. Requires Azure-confirmed old-host fencing before starting a replacement member. Gate F1."
                            tags "FoundationMiddleware,FoundationSecurity,FoundationRecoveryReplica"
                        }
                    }
                    member = deploymentNode "Member A - active recovery unit" "One active pod, four product containers. Baseline moves this unit after fencing; no unqualified active-active workers." "Singleton StatefulSet / replicas 1" {
                        core = containerInstance firefly.core isolated {
                            description "One active Core for member A. PostgreSQL-backed state; API readiness gated on recovered dependencies."
                            tags "FoundationMiddleware"
                        }
                        evm = containerInstance firefly.evm isolated {
                            description "One active EVMConnect + FFTM; sole nonce writer; PostgreSQL-backed transactions and event checkpoints."
                            tags "FoundationMiddleware,FoundationSecurity"
                        }
                        dx = containerInstance firefly.dx isolated {
                            description "One active HTTPS DX; multiparty private messaging; mTLS peer identity and durable blob/peer files."
                            tags "FoundationMiddleware"
                        }
                        ipfs = containerInstance firefly.ipfs isolated {
                            description "One active Kubo; consortium-only shared content; stable identity and pins on its own ZRS volume."
                            tags "FoundationMiddleware"
                        }
                    }
                }
            }
            az2 = deploymentNode "Availability Zone 2" "Independent power, cooling and network failure domain." "Azure AZ 2" {
                capacity = infrastructureNode "AZ2 node-pool capacity" "1 system node; 3 ledger nodes; 2 middleware nodes initially. On-demand VMs; reserve measured recovery capacity." "Zonal AKS pools / VM scale sets" "FoundationPlatform"
                ledger = deploymentNode "Ledger pool - AZ2" "Three separate hosts: two validators and one RPC node. No Spot; no automatic validator scaling." "AKS user pool" {
                    v3pod = deploymentNode "Validator V3 pod" "Unique node identity; dedicated RWO Premium SSD LRS PVC. Pin to AZ2; lost-zone volumes are not on the surviving write path." "StatefulSet / Besu security-module plugin" {
                        node = containerInstance besu.node besu4 {
                            description "V3: one of six QBFT validators; HSM key V3; local RocksDB ledger; private P2P only. HSM qualification gate H1."
                            tags "FoundationBesu,FoundationValidator"
                        }
                    }
                    v4pod = deploymentNode "Validator V4 pod" "Unique node identity; dedicated RWO Premium SSD LRS PVC. Pin to AZ2; lost-zone volumes are not on the surviving write path." "StatefulSet / Besu security-module plugin" {
                        node = containerInstance besu.node besu5 {
                            description "V4: one of six QBFT validators; HSM key V4; local RocksDB ledger; private P2P only. HSM qualification gate H1."
                            tags "FoundationBesu,FoundationValidator"
                        }
                    }
                    rpcpod = deploymentNode "RPC R2 pod" "Non-validator full node, stable P2P endpoint, own RWO Premium SSD LRS PVC. Also serves static peer bootstrap." "StatefulSet / Besu" {
                        node = containerInstance besu.node besu6 {
                            description "R2: non-validator JSON-RPC and event access; readiness checks chain identity, peers and block freshness."
                            tags "FoundationBesu,FoundationRpc"
                        }
                    }
                }
                middleware = deploymentNode "Middleware pool - AZ2" "Separate taint and namespace. mTLS gateway, RPC proxy and stateless signer have one replica per zone." "AKS user pool" {
                    signerpod = deploymentNode "Signing gateway replica 2" "Stateless transaction signing only; the connector owns nonces." "Deployment / one replica per AZ" {
                        signer = containerInstance foundation.signer isolated {
                            description "Replica 2: key allowlist, fixed chain ID, low-s and recovery-parity checks; EC-HSM transaction keys. Integration gate H2."
                            tags "FoundationMiddleware,FoundationSecurity,FoundationSignerReplica"
                        }
                    }
                    recoverypod = deploymentNode "Recovery controller candidate - AZ2" "One of three candidates; only the elected leader coordinates recovery. Gate F1." "Deployment / one replica per AZ" {
                        controller = containerInstance foundation.recovery isolated {
                            description "AZ2 candidate; Kubernetes Lease election. Requires Azure-confirmed old-host fencing before starting a replacement member. Gate F1."
                            tags "FoundationMiddleware,FoundationSecurity,FoundationRecoveryReplica"
                        }
                    }
                    spare = infrastructureNode "Member A recovery slot - AZ2" "Reserved capacity, not a running FireFly replica. Start the same member identity only after old-node fencing and volume reattachment." "AKS scheduling capacity" "FoundationMiddleware,FoundationStandby"
                }
            }
            az3 = deploymentNode "Availability Zone 3" "Independent power, cooling and network failure domain." "Azure AZ 3" {
                capacity = infrastructureNode "AZ3 node-pool capacity" "1 system node; 3 ledger nodes; 2 middleware nodes initially. On-demand VMs; reserve measured recovery capacity." "Zonal AKS pools / VM scale sets" "FoundationPlatform"
                ledger = deploymentNode "Ledger pool - AZ3" "Three separate hosts: two validators and one RPC node. No Spot; no automatic validator scaling." "AKS user pool" {
                    v5pod = deploymentNode "Validator V5 pod" "Unique node identity; dedicated RWO Premium SSD LRS PVC. Pin to AZ3; lost-zone volumes are not on the surviving write path." "StatefulSet / Besu security-module plugin" {
                        node = containerInstance besu.node besu7 {
                            description "V5: one of six QBFT validators; HSM key V5; local RocksDB ledger; private P2P only. HSM qualification gate H1."
                            tags "FoundationBesu,FoundationValidator"
                        }
                    }
                    v6pod = deploymentNode "Validator V6 pod" "Unique node identity; dedicated RWO Premium SSD LRS PVC. Pin to AZ3; lost-zone volumes are not on the surviving write path." "StatefulSet / Besu security-module plugin" {
                        node = containerInstance besu.node besu8 {
                            description "V6: one of six QBFT validators; HSM key V6; local RocksDB ledger; private P2P only. HSM qualification gate H1."
                            tags "FoundationBesu,FoundationValidator"
                        }
                    }
                    rpcpod = deploymentNode "RPC R3 pod" "Non-validator full node, stable P2P endpoint, own RWO Premium SSD LRS PVC. Also serves static peer bootstrap." "StatefulSet / Besu" {
                        node = containerInstance besu.node besu9 {
                            description "R3: non-validator JSON-RPC and event access; readiness checks chain identity, peers and block freshness."
                            tags "FoundationBesu,FoundationRpc"
                        }
                    }
                }
                middleware = deploymentNode "Middleware pool - AZ3" "Separate taint and namespace. mTLS gateway, RPC proxy and stateless signer have one replica per zone." "AKS user pool" {
                    signerpod = deploymentNode "Signing gateway replica 3" "Stateless transaction signing only; the connector owns nonces." "Deployment / one replica per AZ" {
                        signer = containerInstance foundation.signer isolated {
                            description "Replica 3: key allowlist, fixed chain ID, low-s and recovery-parity checks; EC-HSM transaction keys. Integration gate H2."
                            tags "FoundationMiddleware,FoundationSecurity,FoundationSignerReplica"
                        }
                    }
                    recoverypod = deploymentNode "Recovery controller candidate - AZ3" "One of three candidates; only the elected leader coordinates recovery. Gate F1." "Deployment / one replica per AZ" {
                        controller = containerInstance foundation.recovery isolated {
                            description "AZ3 candidate; Kubernetes Lease election. Requires Azure-confirmed old-host fencing before starting a replacement member. Gate F1."
                            tags "FoundationMiddleware,FoundationSecurity,FoundationRecoveryReplica"
                        }
                    }
                    spare = infrastructureNode "Member A recovery slot - AZ3" "Reserved capacity, not a running FireFly replica. Start the same member identity only after old-node fencing and volume reattachment." "AKS scheduling capacity" "FoundationMiddleware,FoundationStandby"
                }
            }
        }
        data = deploymentNode "Managed persistence - outside AKS" "Azure-managed resources; ZRS disks are region-scoped. Database engines occupy two AZs." "Azure data services" {
            pg = deploymentNode "PostgreSQL Flexible Server - primary AZ2" "General Purpose or Memory Optimized; zone-redundant HA; stable private server FQDN." "Azure Database for PostgreSQL" {
                core = containerInstance firefly.pg isolated {
                    description "firefly_core logical database; separate role; one migration job. Primary AZ2, synchronous standby AZ3."
                    tags "FoundationMiddleware"
                }
                tx = containerInstance firefly.fftmDb isolated {
                    description "fftm logical database; separate role; sole connector state and nonce history. Same HA server as Core."
                    tags "FoundationMiddleware"
                }
            }
            standby = infrastructureNode "PostgreSQL standby - AZ3" "Synchronous standby for both logical databases; automatic promotion behind the same FQDN; no client reads." "Azure-managed PostgreSQL standby" "FoundationMiddleware,FoundationStandby"
            pgsummary = infrastructureNode "PostgreSQL HA pair" "Same server shown in detail: primary AZ2, synchronous standby AZ3; two isolated logical databases." "Azure PostgreSQL Flexible Server" "FoundationPlatform"
            zrs = deploymentNode "Member state disks - ZRS across AZ1/2/3" "Two separate Premium_ZRS data PVCs; one writer and one attachment each. Retain policy; tested CSI detach/attach." "Azure Disk CSI" {
                blobs = containerInstance firefly.blobs isolated {
                    description "DX blob and peer files; dedicated Premium_ZRS RWO volume; recover only after fencing."
                    tags "FoundationMiddleware"
                }
                ipfs = containerInstance firefly.ipfsRepo isolated {
                    description "Kubo identity, pins and blocks; separate Premium_ZRS RWO volume; never share one live repo between Kubo processes."
                    tags "FoundationMiddleware"
                }
            }
            backup = infrastructureNode "Protected recovery storage" "Blob ZRS backups plus database PITR; versioned genesis, configs, volume snapshots and HSM recovery material under separate access." "Azure Blob / Backup / snapshots" "FoundationPlatform,FoundationSecurity"
        }
        security = deploymentNode "Azure key services - outside AKS" "Separate validator, transaction and TLS/secrets key domains." "Azure HSM services / Entra" {
            validatorhsm = infrastructureNode "Validator HSM cluster - GATE H1" "Azure Cloud HSM candidate: three service nodes, AZ placement NOT established. Require secp256k1 signing + ECDH, PKCS#11 and AZ-outage proof." "Candidate Azure Cloud HSM / PKCS#11" "FoundationPlatform,FoundationBesu,FoundationSecurity,FoundationGate"
            vault = infrastructureNode "Key Vault Premium" "AZ-redundant in a supported region. EC-HSM transaction keys; separate secrets/certificates vault. Private endpoints and least-privilege roles." "Azure Key Vault Premium / HTTPS" "FoundationPlatform,FoundationSecurity"
            identity = infrastructureNode "Microsoft Entra ID" "Federates AKS service-account tokens; authorizes Key Vault and scoped Azure recovery operations. No Keycloak." "AKS OIDC / Workload Identity" "FoundationSecurity"
        }
        operations = deploymentNode "Platform operations" "Supporting services are not consensus participants." "Azure managed services" {
            registry = infrastructureNode "Private image registry" "ACR Premium; admit only a region/SKU with documented zone resilience; pin and pre-pull approved images in every AZ." "Azure Container Registry" "FoundationPlatform"
            monitor = infrastructureNode "Metrics, logs and alerts" "Managed Prometheus, Azure Monitor and Grafana; alert on quorum, block age, nonce backlog, replay lag, disk and HSM failures." "Azure Monitor" "FoundationPlatform"
        }
    }
}
// Explicit proposed deployment dependencies, independent of broad reference relationships.
production.region.network.control -> production.region.aks.az1.capacity "Schedules workloads and reconciles node pools" "Kubernetes API"
production.region.aks.az1.capacity -> production.region.network.dns "Resolves private services and reaches permitted Azure endpoints" "DNS / TLS"
production.region.aks.az1.capacity -> production.region.operations.registry "Pulls approved pinned images" "HTTPS 443"
production.region.aks.az1.capacity -> production.region.operations.monitor "Exports metrics and operational logs" "HTTPS 443"
production.region.network.rpc -> production.region.aks.az1.ledger.rpcpod.node "Routes a pinned session to a healthy RPC node" "HTTP JSON-RPC 8545 / optional WS 8546"
production.region.aks.az1.ledger.v1pod.node -> production.region.security.validatorhsm "Signs QBFT payloads and performs node-key ECDH with key V1" "PKCS#11 / vendor encrypted channel" "FoundationHsmFlow"
production.region.aks.az1.ledger.v2pod.node -> production.region.security.validatorhsm "Signs QBFT payloads and performs node-key ECDH with key V2" "PKCS#11 / vendor encrypted channel" "FoundationHsmFlow"
production.region.aks.az1.middleware.signerpod.signer -> production.region.security.vault "Signs Ethereum digests with allowed EC-HSM transaction keys" "HTTPS 443 / digest signing" "FoundationSigningFlow"
production.region.aks.az1.middleware.signerpod.signer -> production.region.security.identity "Exchanges its projected service-account token" "OIDC / OAuth2 over HTTPS"
production.region.aks.az1.middleware.signerpod.signer -> production.region.network.rpc "Forwards reads and submits eth_sendRawTransaction" "JSON-RPC / private TLS"
production.region.network.control -> production.region.aks.az2.capacity "Schedules workloads and reconciles node pools" "Kubernetes API"
production.region.aks.az2.capacity -> production.region.network.dns "Resolves private services and reaches permitted Azure endpoints" "DNS / TLS"
production.region.aks.az2.capacity -> production.region.operations.registry "Pulls approved pinned images" "HTTPS 443"
production.region.aks.az2.capacity -> production.region.operations.monitor "Exports metrics and operational logs" "HTTPS 443"
production.region.network.rpc -> production.region.aks.az2.ledger.rpcpod.node "Routes a pinned session to a healthy RPC node" "HTTP JSON-RPC 8545 / optional WS 8546"
production.region.aks.az2.ledger.v3pod.node -> production.region.security.validatorhsm "Signs QBFT payloads and performs node-key ECDH with key V3" "PKCS#11 / vendor encrypted channel" "FoundationHsmFlow"
production.region.aks.az2.ledger.v4pod.node -> production.region.security.validatorhsm "Signs QBFT payloads and performs node-key ECDH with key V4" "PKCS#11 / vendor encrypted channel" "FoundationHsmFlow"
production.region.aks.az2.middleware.signerpod.signer -> production.region.security.vault "Signs Ethereum digests with allowed EC-HSM transaction keys" "HTTPS 443 / digest signing" "FoundationSigningFlow"
production.region.aks.az2.middleware.signerpod.signer -> production.region.security.identity "Exchanges its projected service-account token" "OIDC / OAuth2 over HTTPS"
production.region.aks.az2.middleware.signerpod.signer -> production.region.network.rpc "Forwards reads and submits eth_sendRawTransaction" "JSON-RPC / private TLS"
production.region.network.control -> production.region.aks.az3.capacity "Schedules workloads and reconciles node pools" "Kubernetes API"
production.region.aks.az3.capacity -> production.region.network.dns "Resolves private services and reaches permitted Azure endpoints" "DNS / TLS"
production.region.aks.az3.capacity -> production.region.operations.registry "Pulls approved pinned images" "HTTPS 443"
production.region.aks.az3.capacity -> production.region.operations.monitor "Exports metrics and operational logs" "HTTPS 443"
production.region.network.rpc -> production.region.aks.az3.ledger.rpcpod.node "Routes a pinned session to a healthy RPC node" "HTTP JSON-RPC 8545 / optional WS 8546"
production.region.aks.az3.ledger.v5pod.node -> production.region.security.validatorhsm "Signs QBFT payloads and performs node-key ECDH with key V5" "PKCS#11 / vendor encrypted channel" "FoundationHsmFlow"
production.region.aks.az3.ledger.v6pod.node -> production.region.security.validatorhsm "Signs QBFT payloads and performs node-key ECDH with key V6" "PKCS#11 / vendor encrypted channel" "FoundationHsmFlow"
production.region.aks.az3.middleware.signerpod.signer -> production.region.security.vault "Signs Ethereum digests with allowed EC-HSM transaction keys" "HTTPS 443 / digest signing" "FoundationSigningFlow"
production.region.aks.az3.middleware.signerpod.signer -> production.region.security.identity "Exchanges its projected service-account token" "OIDC / OAuth2 over HTTPS"
production.region.aks.az3.middleware.signerpod.signer -> production.region.network.rpc "Forwards reads and submits eth_sendRawTransaction" "JSON-RPC / private TLS"
production.region.network.ingress -> production.region.aks.az1.middleware.member.core "Routes authenticated member API requests and event sessions" "HTTPS / WebSocket"
production.region.network.ingress -> production.region.aks.az1.middleware.member.dx "Passes through peer-authenticated private exchange traffic" "mTLS / HTTPS"
production.region.data.pg.core -> production.region.data.standby "Replicates Core WAL before commit acknowledgement" "Managed synchronous replication"
production.region.data.pg.tx -> production.region.data.standby "Replicates FFTM WAL before commit acknowledgement" "Managed synchronous replication"
production.region.aks.az1.middleware.recoverypod.controller -> production.region.network.control "Participates in leader election; reconciles recovery only while leader" "Kubernetes API / Lease"
production.region.aks.az1.middleware.recoverypod.controller -> production.region.aks.az2.middleware.spare "Activates one slot only as leader after fencing and volume attachment" "Controller reconciliation" "FoundationRecoveryFlow"
production.region.aks.az1.middleware.recoverypod.controller -> production.region.aks.az3.middleware.spare "Activates one slot only as leader after fencing and volume attachment" "Controller reconciliation" "FoundationRecoveryFlow"
production.region.aks.az1.middleware.recoverypod.controller -> production.region.security.identity "Obtains scoped credentials for fencing and recovery" "Workload Identity / HTTPS"
production.region.aks.az2.middleware.recoverypod.controller -> production.region.network.control "Participates in leader election; reconciles recovery only while leader" "Kubernetes API / Lease"
production.region.aks.az2.middleware.recoverypod.controller -> production.region.aks.az2.middleware.spare "Activates one slot only as leader after fencing and volume attachment" "Controller reconciliation" "FoundationRecoveryFlow"
production.region.aks.az2.middleware.recoverypod.controller -> production.region.aks.az3.middleware.spare "Activates one slot only as leader after fencing and volume attachment" "Controller reconciliation" "FoundationRecoveryFlow"
production.region.aks.az2.middleware.recoverypod.controller -> production.region.security.identity "Obtains scoped credentials for fencing and recovery" "Workload Identity / HTTPS"
production.region.aks.az3.middleware.recoverypod.controller -> production.region.network.control "Participates in leader election; reconciles recovery only while leader" "Kubernetes API / Lease"
production.region.aks.az3.middleware.recoverypod.controller -> production.region.aks.az2.middleware.spare "Activates one slot only as leader after fencing and volume attachment" "Controller reconciliation" "FoundationRecoveryFlow"
production.region.aks.az3.middleware.recoverypod.controller -> production.region.aks.az3.middleware.spare "Activates one slot only as leader after fencing and volume attachment" "Controller reconciliation" "FoundationRecoveryFlow"
production.region.aks.az3.middleware.recoverypod.controller -> production.region.security.identity "Obtains scoped credentials for fencing and recovery" "Workload Identity / HTTPS"
production.region.security.vault -> production.region.data.backup "Stores protected key and secret recovery artifacts" "Controlled backup job"
production.region.security.validatorhsm -> production.region.data.backup "Exports vendor-protected recovery material after qualification" "Encrypted HSM backup"
production.region.network.ingress -> production.region.data.pgsummary "Depends on durable member state through Core" "Dependency summary" "FoundationSummaryFlow"
production.region.data.pgsummary -> production.region.data.backup "Maintains database point-in-time recovery" "Azure-managed backup"
production.region.aks.az1.middleware.member.evm -> production.region.network.signing "Sends nonce-assigned transactions and RPC requests" "JSON-RPC / mTLS"
production.region.network.signing -> production.region.network.rpc "Submits signed transactions and forwards pinned reads" "JSON-RPC / private TLS"
production.region.network.signing -> production.region.security.vault "Signs with authorized EC-HSM transaction keys" "HTTPS 443"
