!element tools {
    perf = container "FireFly Performance CLI" "Generates workloads and reports timings against configured FireFly members." "Go" {
        url "https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/README.md"
        properties {
            "architecture.id" "tools.perf"
            "evidence" "Implementation"
            "architecture.sources" "[\"https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/README.md\"]"
        }
        commands = component "Workload CLI" "Loads test configuration and starts performance scenarios." "Go" {
            url "https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/cmd"
            properties {
                "architecture.id" "tools.perf.commands"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/cmd\"]"
            }
        }
        runner = component "Scenario runner" "Submits message, blob, token and contract workloads." "Go" {
            url "https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/internal/perf"
            properties {
                "architecture.id" "tools.perf.runner"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/internal/perf\"]"
            }
        }
        server = component "Control and observation server" "Exposes run control and measurements." "Go" {
            url "https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/internal/server"
            properties {
                "architecture.id" "tools.perf.server"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/internal/server\"]"
            }
        }
        report = component "Result reporting" "Builds workload timing and throughput reports." "Go" {
            url "https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/internal/util"
            properties {
                "architecture.id" "tools.perf.report"
                "evidence" "Implementation"
                "architecture.sources" "[\"https://github.com/hyperledger-firefly/perf-cli/tree/3d3ec0242b23b30fea41362eb60f0c190dfedde9/internal/util\"]"
            }
        }
    }
}
