"""Apply deterministic manual deployment layouts to parsed Structurizr JSON.
Logical DSL remains directly usable. The viewer serves this laid-out JSON.
"""
from pathlib import Path
import json,re,math
from route_deployment import route
ROOT=Path(__file__).resolve().parents[1]
p=ROOT/"exports/workspace.json"
w=json.loads(p.read_text(encoding="utf-8"))
elements={}; relationships={}
def walk(x):
    if isinstance(x,dict):
        if "id" in x and ("name" in x or "containerId" in x):elements[x["id"]]=x
        for r in x.get("relationships",[]):
            if "sourceId" in r:relationships[r["id"]]=r
        for key,value in x.items():
            if key!="relationships":walk(value)
    elif isinstance(x,list):
        for value in x:walk(value)
walk(w["model"])
def arch(id):return elements[id].get("properties",{}).get("architecture.id","")
def logical(id):
    e=elements[id]
    if "containerId" not in e:return arch(id)
    container=arch(e["containerId"])
    if container.startswith("firefly."):return e["properties"]["member"]+container[len("firefly"):]
    if container=="besu.node":return "besu."+re.search(r"\.besu([^.]+)\.",arch(id))[1]
    return container
def full_position(a):
    common={"azure.control":(450,400),"azure.lb":(1650,400),"azure.secrets":(2850,400),"azure.csi":(4050,400),"azure.rpc":(5250,400)}
    if a in common:return common[a]
    if a.startswith("azure.secretStores."):return (6500+900*"abc".index(a[-1]),600)
    match=re.search(r"\.az([123])\.",a)
    if not match:return None
    z=int(match[1]);base=400+(z-1)*3300
    if ".system.agent" in a:return base+1200,2200
    for c,col in [("gateway",0),("cnpg",1),("prometheus",2)]:
        if f".apps.{c}.instance" in a:return base+200+col*950,3400
    if ".apps.grafana." in a:return base+200,4200
    if ".apps.member" in a:
        c=a.split(".")[-2]
        seq=["core","evm","signer","dx","erc20","erc1155","ipfs","blobs","ipfsRepo"]
        i=seq.index(c);return base+200+(i%3)*950,5400+(i//3)*1100
    match=re.search(r"\.data\.pg([ABC])\.",a)
    if match:return base+200+"ABC".index(match[1])*950,9600+(850 if a.endswith(".volume") else 0)
    match=re.search(r"\.data\.besu([^\.]+)\.",a)
    if match:
        n=match[1]; seq={1:["a1","b1","rpc1"],2:["b2","c1","rpc2"],3:["c2","a2","rpc3"]}[z]
        return base+200+seq.index(n)*950,11300+(850 if a.endswith(".volume") else 0)
def detail_position(a,key):
    match=re.search(r"\.az([123])\.",a)
    z=int(match[1]) if match else None
    if key.startswith("80-"):
        # Three narrow zone columns; the active member runtime occupies its normal zone.
        if z:
            base=500+(z-1)*2200
            if ".apps.member" in a:
                seq=["core","evm","signer","dx","erc20","erc1155","ipfs","blobs","ipfsRepo"]
                i=seq.index(a.split(".")[-2]);return base+200+(i%2)*950,2300+(i//2)*950
            if ".data.pg" in a:return base+700,7600+(850 if a.endswith(".volume") else 0)
        seq=["azure.control","azure.secrets","azure.csi","azure.rpc"]
        if a in seq:return 500+1600*seq.index(a),400
        if a.startswith("azure.secretStores."):return 6700,500
    if key=="81-deployment-besu":
        if z:
            base=500+(z-1)*2800
            n=re.search(r"\.besu([^\.]+)\.",a)[1]
            seq={1:["a1","b1","rpc1"],2:["b2","c1","rpc2"],3:["c2","a2","rpc3"]}[z]
            return base+500,2200+seq.index(n)*1500+(850 if a.endswith(".volume") else 0)
        return (500 if a=="azure.rpc" else 5500),400
    if key=="82-deployment-operations":
        if z:
            base=500+(z-1)*2600
            if ".system." in a:return base+600,2000
            c=a.split(".")[-2]
            seq=["gateway","cnpg","prometheus","grafana"]
            i=seq.index(c);return base+200+(i%2)*1000,3300+(i//2)*1200
        seq=["azure.control","azure.lb","azure.secrets","azure.csi"]
        if a in seq:return 500+1800*seq.index(a),400
    return full_position(a)
for v in w["views"].get("deploymentViews",[]):
    v.pop("automaticLayout",None)
    for el in v["elements"]:
        if "instances" in elements[el["id"]]: continue
        a=arch(el["id"]);pos=full_position(a) if v["key"].startswith("99-") else detail_position(a,v["key"])
        if pos:el["x"],el["y"]=pos
    v["dimensions"]={"width":max(e.get("x",0) for e in v["elements"])+1000,"height":max(e.get("y",0) for e in v["elements"])+1000}
    # Operational detail is shown in dedicated views. Keep core dataflow readable in the complete map.
    if v["key"]=="99-deployment-complete":
        kept=[]
        for rv in v["relationships"]:
            r=relationships[rv["id"]];src=logical(r["sourceId"]);dst=logical(r["destinationId"])
            sa=arch(r["sourceId"]);da=arch(r["destinationId"])
            if src=="ops.prometheus" and (dst.startswith("besu.") or dst[0:2] in ("a.","b.","c.")):continue
            if src=="ops.cnpg" and dst.endswith((".pg",".pgReplica")):continue
            if src=="ops.gateway" and dst.endswith(".core"):
                # Each gateway can route all members; overview shows the zone-local route.
                zone=elements[r["sourceId"]]["properties"]["zone"]
                if dst[0]!="abc"[int(zone)-1]:continue
            if sa.endswith(".instance") and da=="azure.secrets":
                # Show this mount pattern on one pod of each member and each Besu node.
                if ".apps.member" in sa and not sa.endswith(".core.instance"):continue
            if src.endswith(".signer") and dst.startswith("besu."):continue # private RPC Service path is explicit
            if src.startswith("besu.") and dst.startswith("besu."):
                # Show a connected gossip ring plus RPC attachment; full mesh remains in L2.
                allowed={("a1","b1"),("b1","b2"),("b2","c1"),("c1","c2"),("c2","a2"),("a1","a2"),
                         ("a1","rpc1"),("b2","rpc2"),("c2","rpc3"),("rpc1","a1"),("rpc2","a1"),("rpc3","a1")}
                if (src.split(".")[1],dst.split(".")[1]) not in allowed:continue
            kept.append(rv)
        v["relationships"]=kept
    route(v,elements,relationships)
# Freeze selected Graphviz node placements and route around unrelated boxes.
static=json.loads((ROOT/"scripts/static-layouts.json").read_text(encoding="utf-8"))
for group,vs in w["views"].items():
    if not group.endswith("Views"):continue
    for v in vs:
        if v["key"] in static:
            v.pop("automaticLayout",None)
            for el in v["elements"]:el["x"],el["y"]=static[v["key"]][arch(el["id"])]
            v["dimensions"]={"width":max(e["x"] for e in v["elements"])+1000,"height":max(e["y"] for e in v["elements"])+1000}
            route(v,elements,relationships)
        for rv in v["relationships"]:
            r=relationships[rv["id"]]
            if v["key"]=="99-deployment-complete" and arch(r["sourceId"])=="azure.cluster.az3.apps.memberC.dx.instance" and arch(r["destinationId"])=="azure.secretStores.c":rv["position"]=38
p.write_text(json.dumps(w,indent=2)+"\n",encoding="utf-8")
print("Applied manual zone-column layouts to",len(w["views"]["deploymentViews"]),"deployment views.")

