"""Semantic checks against the parsed Structurizr workspace, not just generator data."""
from pathlib import Path
import json,math,collections,sys,xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parents[1]
w=json.loads((ROOT/"exports/workspace.json").read_text(encoding="utf-8"))
catalog=json.loads((ROOT/"model-catalog.json").read_text(encoding="utf-8"))
elements={};rels={};types={};errors=[];checks=[]
def check(test,msg):
    checks.append({"check":msg,"passed":bool(test)})
    if not test:errors.append(msg)
def walk(x,kind=""):
    if isinstance(x,dict):
        if "id" in x and ("name" in x or "containerId" in x):
            elements[x["id"]]=x;types[x["id"]]=kind
        for r in x.get("relationships",[]):
            if "sourceId" in r:rels[r["id"]]=r
        for k,v in x.items():
            if k!="relationships":walk(v,k)
    elif isinstance(x,list):
        for v in x:walk(v,kind)
walk(w["model"])
arch=lambda id:elements[id].get("properties",{}).get("architecture.id","")
logical=lambda id:arch(elements[id]["containerId"]) if "containerId" in elements[id] else arch(id)
views=[v for k,vs in w["views"].items() if k.endswith("Views") for v in vs]
check(len(views)==len(catalog["views"]),"All authored views survive DSL parsing")
check(not w["views"].get("dynamicViews"),"All diagrams use static relationships")
component_ids={id for id,t in types.items() if t=="components"}
component_visible={e["id"] for v in w["views"]["componentViews"] for e in v["elements"]}
check(component_ids<=component_visible,"Every modeled component appears in a component view")
for v in views:
    vis={e["id"] for e in v["elements"]}
    check(bool(v.get("relationships")),v["key"]+": contains visible static dataflow")
    for rref in v.get("relationships",[]):
        r=rels[rref["id"]]
        check(r["sourceId"] in vis and r["destinationId"] in vis,v["key"]+":"+r["id"]+": endpoints visible")
        check(bool(r.get("description")) and bool(r.get("technology")),v["key"]+":"+r["id"]+": action and protocol present")
inst=[x for x in elements.values() if "containerId" in x]
member=lambda x:x.get("properties",{}).get("member")
def member_instances(owner,container):
    return [x for x in inst if member(x)==owner and arch(x["containerId"])=="firefly."+container]
for r in rels.values():
    src,dst=elements[r["sourceId"]],elements[r["destinationId"]]
    if "containerId" in src and "containerId" in dst:
        source_logical,dest_logical=logical(src["id"]),logical(dst["id"])
        if source_logical.startswith("firefly.") and dest_logical.startswith("firefly."):
            peer=source_logical==dest_logical and source_logical in ("firefly.dx","firefly.ipfs")
            check(peer or member(src)==member(dst),f"Isolated member runtime/state: {arch(src['id'])} -> {arch(dst['id'])}")
        if source_logical=="firefly.signer" and dest_logical=="besu.node":
            check(dst["properties"]["role"].startswith("rpc"),"Signer connections target RPC nodes only")
for m in "abc":
    for c in ("core","evm","signer","dx","erc20","erc1155","ipfs"):
        matches=member_instances(m,c)
        check(len(matches)==1,f"Member {m}: one active {c} instance")
    pg=member_instances(m,"pg")+member_instances(m,"pgReplica")
    check(len(pg)==3 and {x["properties"]["zone"] for x in pg}=={"1","2","3"},f"Member {m}: PostgreSQL spans all zones")
    check(sum(x["properties"]["role"]=="primary" for x in pg)==1,f"Member {m}: exactly one PostgreSQL primary")
validators=[x for x in inst if x.get("properties",{}).get("role")=="validator"]
check(len(validators)==6,"Six distinct validator deployment instances")
for m in "abc":
    own=[x for x in validators if x["properties"]["member"]==m]
    check(len(own)==2 and len({x["properties"]["zone"] for x in own})==2,f"Member {m}: two validators in different zones")
quorum=math.ceil(2*len(validators)/3);failures=[]
for z in ("1","2","3"):
    remain=[x for x in validators if x["properties"]["zone"]!=z]
    failures.append({"failed_zone":z,"remaining":len(remain),"quorum":quorum,"additional_outage_headroom":len(remain)-quorum})
    check(len(remain)>=quorum,f"AZ {z} loss leaves a valid QBFT quorum")
full=next(v for v in views if v["key"]=="99-deployment-complete")
check({x["id"] for x in inst}<={e["id"] for e in full["elements"]},"Final deployment includes every deployed container instance")
for v in w["views"]["deploymentViews"]:
    leaves=[e for e in v["elements"] if types[e["id"]] in ("containerInstances","infrastructureNodes")]
    coords=[(e.get("x",0),e.get("y",0)) for e in leaves]
    check(len(coords)==len(set(coords)),v["key"]+": unique leaf positions")
# Verify the actual persistent-state paths, not only element naming/placement.
for m in "abc":
    for runtime,store in (("core","pg"),("evm","pg"),("dx","blobs"),("ipfs","ipfsRepo"),("signer","secrets")):
        src=member_instances(m,runtime)[0]
        targets=[r["destinationId"] for r in rels.values() if r["sourceId"]==src["id"] and logical(r["destinationId"])=="firefly."+store]
        check(len(targets)==1 and member(elements[targets[0]])==m,f"Member {m}: deployed {runtime} has one member-owned {store} persistence path")
    primary=member_instances(m,"pg")[0]
    replicas={x["id"] for x in member_instances(m,"pgReplica")}
    replication={r["destinationId"] for r in rels.values() if r["sourceId"]==primary["id"] and "replication" in r.get("technology","")}
    check(replicas<=replication,f"Member {m}: primary WAL reaches both independent standbys")
volumes=[]
for x in inst:
    logical_id=arch(x["containerId"])
    if logical_id.startswith("besu.") or logical_id.endswith((".pg",".pgReplica")):
        paths=[r for r in rels.values() if r["sourceId"]==x["id"] and r.get("technology")=="Filesystem I/O" and types[r["destinationId"]]=="infrastructureNodes"]
        check(len(paths)==1,arch(x["id"])+": one durable state volume")
        for r in paths:
            volume=elements[r["destinationId"]];volumes.append(volume["id"])
            check("ZRS" in volume.get("technology","") and "CSI" in volume.get("technology",""),arch(x["id"])+": state uses zone-redundant CSI storage")
check(len(volumes)==len(set(volumes)),"PostgreSQL and Besu instances never share a writable volume")
rpcs=[x for x in inst if x["properties"]["role"].startswith("rpc")]
check(len(rpcs)==3 and {x["properties"]["zone"] for x in rpcs}=={"1","2","3"},"Non-validator RPC endpoints span three zones")
boot=[x for x in rpcs if "bootnode" in x["properties"]["role"]]
check(len({x["properties"]["zone"] for x in boot})>=2,"Discovery endpoints survive any one zone loss")

# Reuse is structural: every member instantiates the same container definitions.
check(len([e for e in w["model"]["softwareSystems"] if arch(e["id"])=="firefly"])==1,"Exactly one logical FireFly software system")
check(not any(arch(e["id"]) in ("a","b","c") for e in w["model"]["softwareSystems"]),"No copied member software systems")
for c in ("core","evm","signer","dx","erc20","erc1155","ipfs","pg","pgReplica","blobs","ipfsRepo","secrets"):
    check(len({member_instances(m,c)[0]["containerId"] for m in "abc"})==1,f"Three members reuse one {c} definition")
check(len({x["containerId"] for x in inst if logical(x["id"])=="besu.node"})==1,"Nine Besu deployments reuse one node definition")
for c in ("dx","ipfs"):
    for m in "abc":
        src=member_instances(m,c)[0]
        peers={member(elements[r["destinationId"]]) for r in rels.values() if r["sourceId"]==src["id"] and logical(r["destinationId"])=="firefly."+c and r["destinationId"]!=src["id"]}
        check(peers==set("abc")-{m},f"Member {m}: {c} reaches both consortium peers")
besu_nodes=[x for x in inst if logical(x["id"])=="besu.node"]
for src in besu_nodes:
    peers={r["destinationId"] for r in rels.values() if r["sourceId"]==src["id"] and logical(r["destinationId"])=="besu.node" and r["destinationId"]!=src["id"]}
    check(len(peers)==8,arch(src["id"])+": Besu peer connectivity retained")
import re
dsl=(ROOT/"workspace.dsl").read_text(encoding="utf-8")
check(not re.search(r"^\s*[rd]\d+\s*=",dsl,re.M),"DSL has no numbered relationship aliases")
check(not re.search(r"^\s*\w+(?:\.\w+)*\s*->",dsl,re.M),"DSL relationships use the source element scope")
if "--svg" in sys.argv:
    for v in views:
        path=ROOT/"exports/svg"/(v["key"]+".svg")
        check(path.is_file(),v["key"]+": SVG exists")
        if path.is_file():
            svg=ET.parse(path).getroot()
            texts=" ".join(svg.itertext())
            check(len(texts)>200,v["key"]+": SVG contains rendered labels")
            check(len(list(svg.iter("{http://www.w3.org/2000/svg}path")))>0,v["key"]+": SVG contains rendered paths")
out={"passed":not errors,"logical_elements":len(catalog["elements"]),"components":len(component_ids),"views":len(views),
     "deployment_instances":len(inst),"assertions":len(checks),"errors":errors,"zone_failures":failures,"checks":checks}
(ROOT/"reports").mkdir(exist_ok=True)
(ROOT/"reports/architecture-audit.json").write_text(json.dumps(out,indent=2)+"\n",encoding="utf-8")
print(json.dumps({k:v for k,v in out.items() if k!="checks"},indent=2))
sys.exit(1 if errors else 0)

