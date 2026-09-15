"""Capture an immutable official-source inventory; no third-party sources."""
from pathlib import Path
import json, urllib.request, hashlib, datetime
ROOT = Path(__file__).resolve().parents[1]
CACHE = ROOT / ".cache" / "sources"
CACHE.mkdir(parents=True, exist_ok=True)
REPOS = {
"firefly": ("hyperledger-firefly/firefly", ["README.md","Dockerfile","internal/orchestrator/orchestrator.go","internal/namespace/namespace.go","doc-site/docs/architecture/node_component_architecture.md","doc-site/docs/architecture/plugin_architecture.md","doc-site/docs/architecture/blockchain_connector_framework.md","doc-site/docs/architecture/internal_event_sequencing.md","doc-site/docs/architecture/multiparty_event_sequencing.md","doc-site/docs/overview/key_components/tools.md","doc-site/docs/overview/key_components/security.md","doc-site/docs/overview/key_components/connectors.md","doc-site/docs/overview/public_vs_permissioned.md"]),
"evmconnect": ("hyperledger-firefly/evmconnect", ["README.md","cmd/evmconnect.go","config.md"]),
"fftm": ("hyperledger-firefly/transaction-manager", ["README.md","config.md"]),
"signer": ("hyperledger-firefly/signer", ["README.md"]),
"dx": ("hyperledger-firefly/dataexchange-https", ["README.md","src/app.ts","src/handlers/events.ts","src/handlers/blobs.ts","src/handlers/messages.ts"]),
"erc20": ("hyperledger-firefly/tokens-erc20-erc721", ["README.md"]),
"erc1155": ("hyperledger-firefly/tokens-erc1155", ["README.md"]),
"charts": ("hyperledger-firefly/helm-charts", ["README.md","charts/firefly/templates/core/statefulset.yaml","charts/firefly/values.yaml","charts/firefly-evmconnect/values.yaml","charts/firefly-signer/values.yaml"]),
"besu": ("besu-eth/besu", ["README.md","consensus/common/src/main/java/org/hyperledger/besu/consensus/common/bft/BftHelpers.java"]),
"ui": ("hyperledger-firefly/ui", ["README.md"]),
"sandbox": ("hyperledger-firefly/sandbox", ["README.md"]),
}
PAGES = {
"qbft":"https://docs.besu-eth.org/private-networks/how-to/configure/consensus/qbft",
"permissioning":"https://docs.besu-eth.org/private-networks/concepts/permissioning",
"besu-production":"https://docs.besu-eth.org/private-networks/how-to/configure/bootnodes",
"aks":"https://learn.microsoft.com/en-us/azure/aks/reliability-availability-zones-configure",
"aks-reliability":"https://learn.microsoft.com/en-us/azure/reliability/reliability-aks",
"disks":"https://learn.microsoft.com/en-us/azure/virtual-machines/disks-redundancy",
"cnpg":"https://cloudnative-pg.io/docs/1.28/replication/",
"kubernetes-fencing":"https://kubernetes.io/docs/concepts/cluster-administration/node-shutdown/",
"ipfs":"https://docs.ipfs.tech/concepts/how-ipfs-works/",
"structurizr":"https://docs.structurizr.com/binaries",
"inspect":"https://docs.structurizr.com/inspect",
}
def get(url):
    req=urllib.request.Request(url, headers={"User-Agent":"FireFly-Architecture-Documentation"})
    return urllib.request.urlopen(req,timeout=60).read()
def capture(key,url):
    raw=get(url)
    (CACHE/(key+".txt")).write_bytes(raw)
    return {"url":url,"sha256":hashlib.sha256(raw).hexdigest(),"bytes":len(raw)}
out={"retrieved_at":datetime.datetime.now(datetime.timezone.utc).isoformat(),"repositories":{},"pages":{}}
for key,(repo,paths) in REPOS.items():
    tree=json.loads(get(f"https://api.github.com/repos/{repo}/git/trees/main?recursive=1"))
    entry={"repository":repo,"commit":tree["sha"],"url":f"https://github.com/{repo}/tree/{tree['sha']}","paths":[x["path"] for x in tree["tree"]],"documents":{}}
    (CACHE/(key+"-tree.json")).write_text(json.dumps(tree),encoding="utf-8")
    for path in paths:
        if path not in entry["paths"]:
            continue
        url=f"https://raw.githubusercontent.com/{repo}/{tree['sha']}/{path}"
        entry["documents"][path]=capture(key+"-"+path.replace("/","_"),url)
    out["repositories"][key]=entry
    print(key,tree["sha"],len(entry["documents"]),"documents")
for key,url in PAGES.items():
    out["pages"][key]=capture(key,url)
(ROOT/"sources.json").write_text(json.dumps(out,indent=2)+"\n",encoding="utf-8")
print("Captured sources.json")

