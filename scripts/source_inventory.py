"""Create a readable source inventory and audit Core package coverage."""
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1]
s=json.loads((ROOT/"sources.json").read_text(encoding="utf-8"))
m=json.loads((ROOT/"model-catalog.json").read_text(encoding="utf-8"))
out=["# Official sources and coverage","","## Repository snapshots","","| Source | Captured revision | Documents read |","|---|---|---|"]
for key,r in s["repositories"].items():
    out.append(f"| {key} | [{r['commit'][:12]}]({r['url']}) | {len(r['documents'])} |")
out+=["","Snapshot timestamps and SHA-256 fingerprints for retrieved documents are in sources.json. Element URLs point to these revisions, not a moving main branch.",
"","## Official documentation","","| Topic | Source |","|---|---|"]
for key,d in s["pages"].items():out.append(f"| {key} | [Official documentation]({d['url']}) |")
out+=["","## FireFly Core source-package audit","","Every top-level runtime package is represented by a component group. Non-runtime support packages are explicitly classified below.",
"","| Source package | Representation |","|---|---|"]
support={
"internal/coreconfig":"Configuration definitions consumed by namespace/plugin initialization.",
"internal/coremsgs":"Shared message/error constants consumed by the modeled subsystems.",
"internal/reference":"API/configuration reference generation; build/documentation support."
}
unmapped=[]
for path in s["repositories"]["firefly"]["paths"]:
    if path.startswith("internal/") and path.count("/")==1:
        found=[e["id"] for e in m["elements"] if e["id"].startswith("a.core.") and ("/"+path in e["source"])]
        result=", ".join(found) if found else support.get(path)
        if not result:unmapped.append(path);result="UNMAPPED"
        out.append(f"| {path} | {result} |")
out+=["","## Alternatives and boundaries","",
"- Ethereum/EthConnect, Fabric/FabConnect, Tezos, Cardano and the Corda starter appear as alternatives; Corda requires application-specific development.",
"- PostgreSQL is selected. SQLite is the implemented embedded database alternative, represented by the database-plugin responsibility; no SQLite server is implied.",
"- Core event adapters cover WebSocket, webhook and system events; authentication and identity resolution remain configurable interfaces.",
"- Early architectural prose mentioning possible backends such as CouchDB is not evidence of a currently implemented backend.",
"- EIP-712, ABI, RLP and cryptography libraries are not separately deployed signing services. Runtime diagrams show their owning responsibility.",
"- Logging, retry utilities, public types and tests are grouped under their owning subsystem rather than represented as code-level diagrams.",
"- coverage.csv maps all elements to sources and views. The parsed JSON audit verifies component-view coverage.",
"","## Relationship evidence","",
"Relationships describe architecture-level information flow, not a complete call graph. In-process arrows group the responsibilities shown in official architecture and source modules; each arrow need not be a single direct method invocation. Deployment, application examples and operational choices are proposed reference design."
]
(ROOT/"docs/workspace/04-sources.md").write_text("\n".join(out)+"\n",encoding="utf-8")
report={"unmapped_core_packages":unmapped,"captured_repositories":len(s["repositories"]),"captured_documents":sum(len(r["documents"]) for r in s["repositories"].values()),"official_pages":len(s["pages"])}
(ROOT/"reports/source-audit.json").write_text(json.dumps(report,indent=2)+"\n",encoding="utf-8")
print(json.dumps(report))
if unmapped:raise SystemExit(1)

