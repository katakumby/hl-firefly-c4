"""Rebuild the reusable logical DSL and coverage inventory from official-source mappings."""
from pathlib import Path
import json,csv
from dsl_relationships import relationship_name, relationship_selectors
from model_data import *
ROOT=Path(__file__).resolve().parents[1]
SOURCES=json.loads((ROOT/"sources.json").read_text(encoding="utf-8"))
E={};R=[];V=[]
def source(repo,path=""):
    if repo=="reference": return SOURCES["pages"]["firefly-architecture"]["url"]
    if repo in SOURCES["pages"]: return SOURCES["pages"][repo]["url"]
    s=SOURCES["repositories"][repo]
    if path and path not in s["paths"]: raise ValueError(f"Unverified path {repo}:{path}")
    return f"https://github.com/{s['repository']}/tree/{s['commit']}"+("/"+path if path else "")
def add(id,kind,name,desc,tech="",repo="firefly",path="",tags="",classification="Implementation"):
    assert id not in E
    if repo=="reference" and classification=="Implementation":classification="Reference choice"
    E[id]=dict(id=id,kind=kind,name=name,description=desc,technology=tech,parent=id.rsplit(".",1)[0] if "." in id else None,
        source=source(repo,path),classification=classification,tags=tags)
def rel(a,b,desc,tech="In-process calls / Go",tag="Dataflow"):
    assert a in E and b in E,(a,b)
    if any(x["source"]==a and x["destination"]==b and x["description"]==desc for x in R): return
    R.append(dict(id=f"{a}->{b}:{desc}",source=a,destination=b,description=desc,technology=tech,tags=tag,
                  evidence=list(dict.fromkeys([E[a]["source"], E[b]["source"]])),
                  classification="Architecture flow inferred from documented responsibilities"))
def view(kind,scope,key,title,ids,direction="lr"):
    ids=list(dict.fromkeys(ids))
    assert all(x in E for x in ids),(key,[x for x in ids if x not in E])
    edges=[r["id"] for r in R if r["source"] in ids and r["destination"] in ids and r["source"]!=r["destination"]]
    assert edges,(key,"No static flow")
    V.append(dict(kind=kind,scope=scope,key=key,title=title,elements=ids,relationships=edges,direction=direction))
def comps(parent,items,repo,tech):
    for row in items:
        if len(row)==5: ident,name,desc,r,p=row
        else: ident,name,desc,p=row;r=repo
        add(parent+"."+ident,"component",name,desc,tech,r,p)
def flows(parent,items,tech):
    for a,b,desc in items: rel(parent+"."+a,parent+"."+b,desc,tech)
def kids(parent): return [i for i,e in E.items() if e["parent"]==parent]
add("developer","person","Application developer","Builds and tests member business integrations.",repo="reference")
add("operator","person","Consortium operator","Operates member namespaces, recovery and the Besu network.",repo="reference")
add("business","person","Business user","Submits consortium business actions through a member application.",repo="reference")
add("firefly","softwareSystem","Hyperledger FireFly","Reusable supernode architecture; each consortium member deploys an isolated instance.")
data=[
("core","FireFly Core","Exposes member APIs and bundled Explorer; orchestrates multiparty operations.","Go + React","firefly","internal/orchestrator",""),
("evm","EVMConnect + FFTM","Submits Ethereum transactions and streams confirmed events; one nonce writer.","Go","evmconnect","cmd/evmconnect.go",""),
("signer","FireFly Signer","Signs member transactions and proxies Ethereum RPC calls.","Go","signer","internal/rpcserver",""),
("dx","HTTPS Data Exchange","Exchanges private envelopes and blobs with authenticated members.","TypeScript / Node.js","dx","src","Private"),
("erc20","ERC-20 / ERC-721 connector","Maps fungible and non-fungible token APIs to EVM contracts.","TypeScript / NestJS","erc20","src",""),
("erc1155","ERC-1155 connector","Maps multi-token operations and events to FireFly.","TypeScript / NestJS","erc1155","src",""),
("ipfs","IPFS Kubo","Publishes and retrieves consortium-shared content.","Go / Kubo","ipfs","","Shared"),
("pg","PostgreSQL primary","Stores Core and FFTM in separate databases with separate credentials.","PostgreSQL / CloudNativePG","cnpg","","Database,Private"),
("pgReplica","PostgreSQL standby","Replicates this member's primary; eligible for fenced promotion.","PostgreSQL / CloudNativePG","cnpg","","Database,Private"),
("blobs","Private blob and peer store","Stores private blobs and mutable peer metadata.","Filesystem / Premium SSD ZRS","dx","src/handlers/blobs.ts","Database,Private"),
("ipfsRepo","IPFS repository","Stores this member's Kubo identity, pins and content blocks.","Filesystem / Premium SSD ZRS","ipfs","","Database,Shared"),
("secrets","Member keys and configuration","Holds signing keystores, mTLS keys and configuration.","Kubernetes Secrets","signer","pkg/fswallet","Database,Private"),
]
for id,name,desc,tech,repo,path,tags in data: add(f"firefly.{id}","container",name,desc,tech,repo,path,tags)
comps("firefly.core",CORE,"firefly","Go");flows("firefly.core",CORE_FLOWS,"In-process calls / Go")
E["firefly.core.explorer"]["technology"]="React / TypeScript"
comps("firefly.evm",EVM,"evmconnect","Go");flows("firefly.evm",EVM_FLOWS,"In-process calls / Go")
comps("firefly.signer",[r for r in SIGNER if r[0]!="typeddata"],"signer","Go")
flows("firefly.signer",[r for r in SIGNER_FLOWS if r[0]!="typeddata"],"In-process calls / Go")
comps("firefly.dx",DX,"dx","TypeScript / Node.js");flows("firefly.dx",DX_FLOWS,"In-process calls / TypeScript")
for token in ("erc20","erc1155"):
    comps("firefly."+token,TOKENS,token,"TypeScript / NestJS");flows("firefly."+token,TOKEN_FLOWS,"In-process calls / TypeScript")
for src,dst,label,tech in [
("core","evm","Submits contract calls, pins and listeners","HTTP REST / JSON"),
("evm","core","Streams confirmed events and transaction results","WebSocket / JSON"),
("core","dx","Submits private messages, blobs and peer configuration","HTTP REST / JSON + binary"),
("dx","core","Delivers transfer notifications and awaits ACKs","WebSocket / JSON"),
("core","erc20","Submits ERC-20 and ERC-721 operations","HTTP REST / JSON"),
("core","erc1155","Submits ERC-1155 operations","HTTP REST / JSON"),
("erc20","core","Delivers normalized token events","WebSocket / JSON"),
("erc1155","core","Delivers normalized token events","WebSocket / JSON"),
("erc20","evm","Submits contract calls and consumes event streams","HTTP REST + WebSocket"),
("erc1155","evm","Submits contract calls and consumes event streams","HTTP REST + WebSocket"),
("evm","signer","Submits Ethereum calls and unsigned transactions","HTTP JSON-RPC"),
("core","pg","Reads and writes the private Core database","PostgreSQL wire / TLS"),
("evm","pg","Reads and writes the separate FFTM database","PostgreSQL wire / TLS"),
("pg","pgReplica","Streams WAL and awaits one synchronous standby","PostgreSQL replication / TLS"),
("core","ipfs","Adds shared content and retrieves CIDs","IPFS HTTP RPC / gateway"),
("dx","blobs","Reads and writes private blobs and peer records","Filesystem I/O"),
("ipfs","ipfsRepo","Reads and writes Kubo keys, pins and blocks","Filesystem I/O"),
("signer","secrets","Loads member signing keystore files","Read-only projected files"),
("dx","secrets","Loads member mTLS certificate and key","Read-only projected files"),
("core","secrets","Loads namespace and plugin configuration","Read-only projected files"),
("evm","secrets","Loads connector endpoints and credentials","Read-only projected files"),
("core.blockchain","evm","Submits blockchain operations","HTTP REST / JSON"),
("evm.delivery","core","Delivers confirmed event batches","WebSocket / JSON"),
("core.database","pg","Persists Core resources and offsets","PostgreSQL wire / TLS"),
("core.dataexchange","dx","Exchanges private data and notifications","HTTP + WebSocket"),
("core.sharedstorage","ipfs","Publishes and retrieves CIDs","IPFS HTTP RPC"),
("core.tokens","erc20","Submits ERC-20 and ERC-721 operations","HTTP REST / JSON"),
("core.tokens","erc1155","Submits ERC-1155 operations","HTTP REST / JSON"),
("evm.persistence","pg","Persists FFTM transactions and checkpoints","PostgreSQL wire / TLS"),
("evm.rpc","signer","Forwards transactions and read calls","HTTP JSON-RPC"),
("signer.wallet","secrets","Loads encrypted account keystores","Read-only projected files"),
("dx.blobs","blobs","Stores durable private blobs","Filesystem I/O"),
("dx.peers","blobs","Persists endpoints and peer certificates","Filesystem I/O"),
("dx.p2p","secrets","Loads the member mTLS identity","Read-only projected files"),
]: rel("firefly."+src,"firefly."+dst,label,tech)
for t in ("erc20","erc1155"):
    rel(f"firefly.{t}.blockchain","firefly.evm","Submits contract calls and listeners","HTTP REST / JSON")
    rel("firefly.evm",f"firefly.{t}.stream","Streams confirmed token logs","WebSocket / JSON")
    rel(f"firefly.{t}.proxy","firefly.core","Delivers token events and receives ACKs","WebSocket / JSON")
add("besu","softwareSystem","Private Besu network","Permissioned Ethereum network with QBFT validators, private RPC and contracts.",repo="besu",tags="Blockchain")
p="besu.node"
add(p,"container","Besu node","Runs the selected validator or non-validator RPC/discovery role; each instance owns its key and ledger.","Java / Besu / RocksDB","besu",tags="Blockchain")
for id,name,desc,path in BESU:
    if path=="@firefly":repo,path="firefly","smart_contracts/ethereum/solidity_firefly/contracts/Firefly.sol"
    elif path=="@tokens":repo,path="erc20","src/abi"
    elif path=="@reference":repo,path="reference",""
    else:repo="besu"
    contract=id.endswith(("contract","contracts"))
    add(p+"."+id,"component",name,desc,"Solidity / EVM" if contract else "Java",repo,path,
        tags="Contract" if contract else "",classification="Reference choice" if repo=="reference" else "Implementation")
for a,b,label in BESU_FLOWS:
    if p+"."+a in E and p+"."+b in E:rel(p+"."+a,p+"."+b,label,"EVM execution" if a=="evm" else "In-process calls / Java")
rel("besu.node.p2p","besu.node.keys","Authenticates node transport identity","In-process calls / Java")

E["besu.node.qbft"]["description"] += " Active only on validator instances."
rel("besu.node","besu.node","Gossips transactions, blocks and QBFT peer messages","DevP2P / TCP","BlockchainFlow")
rel("firefly","besu","Submits transactions and consumes finalized events","Ethereum JSON-RPC + events")
rel("operator","firefly","Inspects and administers member state","HTTPS / Explorer + Admin API","Operational")
rel("firefly.signer","besu.node","Submits signed transactions and queries RPC nodes","HTTP JSON-RPC")
rel("firefly.signer.backend","besu.node","Submits raw transactions and reads to RPC nodes","HTTP JSON-RPC")
rel("firefly.dx","firefly.dx","Transfers private envelopes and blobs to peers; receives ACKs","HTTPS / mutual TLS","PrivateFlow")
rel("firefly.ipfs","firefly.ipfs","Retrieves shared content blocks from peers by CID","IPFS / libp2p","SharedFlow")


add("apps","softwareSystem","Member applications","Independently owned applications and event consumers.",repo="reference")
add("apps.client","container","Member business application","Submits requests and consumes acknowledged FireFly events.","Example application / REST client","reference")
rel("business","apps.client","Submits business actions","HTTPS")
rel("apps.client","firefly.core","Submits member-scoped commands and queries","HTTPS / REST")
rel("firefly.core","apps.client","Delivers subscribed events and accepts ACKs","WebSocket / webhook / HTTPS")
rel("apps.client","firefly.core.api","Submits API commands and queries","HTTPS / REST")
rel("firefly.core.eventplugin","apps.client","Delivers events through configured transports","WebSocket / webhook / HTTPS")
rel("apps","firefly","Submits member requests and consumes events","HTTPS + WebSocket")
rel("business","apps","Submits consortium business actions","HTTPS")
add("tools","softwareSystem","FireFly developer tools","Development utilities and optional sample applications.",repo="firefly",path="doc-site/docs/overview/key_components/tools.md",tags="Optional")
add("tools.cli","container","FireFly CLI","Creates local stacks and performs development administration.","Go / CLI","firefly","doc-site/docs/overview/key_components/tools.md",tags="Optional")
add("tools.sandbox","container","FireFly Sandbox","Provides a sample web app calling a selected member API.","React + Node.js / TypeScript","sandbox",tags="Optional")
for id,name,desc,tech in [
("frontend","Sandbox frontend","Collects sample messages and token actions.","React / TypeScript"),
("backend","Sandbox backend","Maps UI actions into SDK requests.","Node.js / TypeScript"),
("sdk","FireFly Node.js SDK","Calls the selected API and consumes events.","TypeScript library")]:
    add("tools.sandbox."+id,"component",name,desc,tech,"sandbox")
rel("tools.sandbox.frontend","tools.sandbox.backend","Submits selected sample actions","HTTP / JSON")
rel("tools.sandbox.backend","tools.sandbox.sdk","Submits SDK requests","In-process calls / TypeScript")
rel("tools.sandbox.sdk","firefly.core","Invokes member APIs and consumes events","HTTPS + WebSocket")
rel("tools.sandbox","firefly.core","Exercises APIs and subscriptions","HTTPS + WebSocket")
rel("tools.cli","firefly.core","Registers and inspects development stacks","HTTP / Admin API")
rel("developer","tools","Develops and tests integrations","CLI + HTTPS")
rel("developer","tools.cli","Creates local test stacks","Local process invocation")
rel("developer","tools.sandbox","Exercises sample workflows","HTTPS")
rel("tools","firefly","Exercises the selected member API","HTTPS + WebSocket")
add("ops","softwareSystem","Platform operations","Reference ingress, database operations and metrics on AKS.",repo="reference",classification="Reference choice")
for id,name,desc,tech,repo in [
("gateway","Gateway / ingress","Routes API traffic; preserves peer mTLS with TLS passthrough.","Envoy Gateway / Kubernetes","reference"),
("cnpg","PostgreSQL operator","Reconciles database roles, endpoints and fenced failover.","CloudNativePG","cnpg"),
("prometheus","Metrics collector","Scrapes runtime metrics and evaluates availability alerts.","Prometheus","reference"),
("grafana","Operations dashboard","Displays metrics, replication lag and quorum health.","Grafana","reference")]:
    add("ops."+id,"container",name,desc,tech,repo,classification="Reference choice",tags="Operational")
rel("operator","ops","Monitors availability and coordinates recovery","HTTPS","Operational")
rel("operator","ops.grafana","Reviews quorum and recovery measurements","HTTPS","Operational")
rel("ops.grafana","ops.prometheus","Queries operational time series","HTTP / PromQL","Operational")
rel("ops","firefly","Routes API requests and observes health","HTTPS + metrics","Operational")
rel("ops.gateway","firefly.core","Routes authenticated API requests","HTTPS / REST + WebSocket","Operational")
rel("ops.gateway","firefly.dx","Passes peer TLS sessions without terminating mTLS","TCP / TLS passthrough","PrivateFlow")
rel("ops.cnpg","firefly.pg","Reconciles primary role and health","Kubernetes API / operator control","Operational")
rel("ops.cnpg","firefly.pgReplica","Reconciles replication and failover candidates","Kubernetes API / operator control","Operational")
rel("ops.prometheus","firefly.core","Scrapes member runtime measurements","HTTP / Prometheus metrics","Operational")
rel("ops.prometheus","besu.node","Scrapes peer, block and consensus measurements","HTTP / Prometheus metrics","Operational")
rel("ops","besu","Observes peer and quorum health","HTTP / metrics","Operational")
alternatives=[
("ethconnect","EthConnect / Ethereum","Alternative Ethereum connector; different transaction-management architecture.","README.md"),
("fabric","Fabric / FabConnect","Alternative permissioned-ledger adapter and network.","internal/blockchain/fabric"),
("tezos","Tezos connector / network","Alternative supported blockchain adapter.","internal/blockchain/tezos"),
("cardano","Cardano connector / network","Alternative supported blockchain adapter.","internal/blockchain/cardano"),
("corda","Corda connector starter","Extension starter requiring CorDapp customization; not turnkey.","README.md")]
for id,name,desc,path in alternatives:
    add(id,"softwareSystem",name,desc,path=path,tags="Optional",classification="Alternative")
    rel("firefly",id,"Can route blockchain operations here when configured instead","Connector API / backend-specific transport","Alternative")
    rel("firefly.core",id,"Can bind the blockchain plugin to this alternative","Connector API / backend-specific transport","Alternative")
view("systemLandscape","","01-landscape","System Landscape - FireFly consortium architecture",["business","developer","operator","apps","tools","firefly","besu","ops"])
view("systemContext","firefly","02-context-firefly","System Context - Hyperledger FireFly",["firefly","apps","operator","besu","ops","tools"])
view("systemContext","besu","03-context-besu","System Context - private Besu network",["firefly","besu","ops"])
view("systemLandscape","","04-alternatives","System Landscape - alternative blockchain integrations",["firefly"]+[x[0] for x in alternatives])
view("container","firefly","10-firefly-runtime","Container - FireFly orchestration and connectors",
    ["firefly."+x for x in ("core","evm","signer","dx","erc20","erc1155","ipfs","pg")]+["apps.client","besu.node"])
view("container","firefly","11-firefly-state","Container - FireFly private state and shared storage",
    ["firefly."+x for x in ("core","evm","signer","dx","ipfs","pg","pgReplica","blobs","ipfsRepo","secrets")])
for key,title,ids in CORE_VIEWS:
    suffix=["apps.client"] if key in ("api","events") else []
    if key=="contracts":suffix += ["firefly.evm","firefly.erc20","firefly.erc1155"]
    if key=="messaging":suffix += ["firefly.dx","firefly.ipfs"]
    if key=="persistence":suffix += ["firefly.pg","firefly.ipfs"]
    view("component","firefly.core",f"20-firefly-core-{key}",f"Component - FireFly Core: {title}",["firefly.core."+x for x in ids.split()]+suffix)
for key,title,ids in EVM_VIEWS:
    view("component","firefly.evm",f"30-firefly-evm-{key}",f"Component - FireFly EVMConnect: {title}",
        ["firefly.evm."+x for x in ids.split()]+["firefly.pg","firefly.signer"]+(["firefly.core"] if key=="events" else []))
for container,title,externals in [
    ("signer","transaction signing",["firefly.secrets","besu.node"]),
    ("dx","private data exchange",["firefly.blobs","firefly.secrets"]),
    ("erc20","ERC-20 / ERC-721",["firefly.core","firefly.evm"]),
    ("erc1155","ERC-1155",["firefly.core","firefly.evm"])]:
    view("component","firefly."+container,f"40-firefly-{container}",f"Component - FireFly {title}",kids("firefly."+container)+externals)
view("container","besu","50-besu-network","Container - reusable Besu node and RPC integration",["besu.node","firefly.signer","ops.prometheus"])
for key,title,ids in BESU_VIEWS:
    selected=["besu.node."+x for x in ids.split() if "besu.node."+x in E]
    view("component","besu.node",f"51-besu-{key}",f"Component - Besu node: {title}",selected)
view("container","apps","60-applications","Container - member business applications",kids("apps")+["business","firefly.core"])
view("container","tools","61-tools","Container - developer tooling",kids("tools")+["developer","firefly.core"])
view("component","tools.sandbox","62-sandbox","Component - Sandbox sample application",kids("tools.sandbox")+["firefly.core"])
view("container","ops","63-operations","Container - platform operations",kids("ops")+["operator","firefly.core","firefly.pg","besu.node"])

from ecosystem_model import extend_model
extend_model(E, R, V, add, rel, view, comps, flows, kids, source)
from security_model import extend_security_model
extend_security_model(E, R, V, add, rel, view, kids, source)


def q(s):return json.dumps(str(s),ensure_ascii=False)
lines=[];defined=set();emitted_relationships=set()
def w(s="",level=0):lines.append("    "*level+s)
def props(values,level):
    w("properties {",level)
    for k,v in values.items():w(q(k)+" "+q(v),level+1)
    w("}",level)

def emit_outgoing(id,relationships,level):
    for r in relationships:
        if r["source"]==id and r["destination"] in defined and r["id"] not in emitted_relationships:
            destination=r["destination"]
            name = relationship_name(r)
            prefix = name+' = '+id+' ' if name else ''
            w(f"{prefix}-> {destination} {q(r['description'])} {q(r['technology'])} {q(r['tags'])}",level)
            emitted_relationships.add(r["id"])

def emit_pending(prefix,relationships,level):
    sources=dict.fromkeys(r["source"] for r in relationships if
        (not prefix or r["source"].startswith(prefix+".")) and r["source"] in defined and
        r["destination"] in defined and r["id"] not in emitted_relationships)
    for id in sources:
        identifier=id
        w(f"!element {identifier} {{",level)
        emit_outgoing(id,relationships,level+1)
        w("}",level)
def emit_element(id,level):
    e=E[id];kind=e["kind"];args=q(e["name"])+" "+q(e["description"])
    if kind in ("container","component"):args+=" "+q(e["technology"])
    w(f"{id.split('.')[-1]} = {kind} {args} {{",level)
    if e["tags"]:w("tags "+q(e["tags"]),level+1)
    w("url "+q(e["source"]),level+1)
    props({"architecture.id":id,"evidence":e["classification"]},level+1)
    if kind=="softwareSystem" and kids(id):
        w("!docs docs/static/system",level+1);w("!adrs docs/static/decisions",level+1)
    for child in kids(id):emit_element(child,level+1)
    emit_pending(id,R,level+1)
    emit_outgoing(id,R,level+1)
    w("}",level)
    defined.add(id)
def emit_workspace():
    global lines, defined, emitted_relationships
    lines=[]; defined=set(); emitted_relationships=set()
    w("// Generated from scripts/build_workspace.py and its logical model extensions. Rebuild after editing source definitions.")
    w('workspace "FireFly ecosystem + private Besu + security catalog" '+q('C4 levels 1-3 with security product references and static dataflows; no deployments.')+' {')
    w("!identifiers hierarchical",1);w("!impliedRelationships false",1)
    props({"structurizr.inspection.workspace.scope":"info"},1)
    w("!docs docs/static/workspace",1);w("!adrs docs/static/decisions",1);w("model {",1)
    for id,e in E.items():
        if e["parent"] is None:emit_element(id,2)
    emit_pending("",R,2)
    assert len(emitted_relationships)==len(R),"Every authored relationship must be emitted exactly once"
    w("}",1);w("views {",1)
    for v in V:
        assert v['kind'] in ('systemLandscape', 'systemContext', 'container', 'component')
        prefix=v['kind']+(' '+v['scope'] if v['scope'] else '')
        w(prefix+' '+q(v['key'])+' '+q(v['title'])+' {',2)
        w('title '+q(v['title']),3)
        w('include '+' '.join(v['elements']),3)
        w('exclude *->*',3)
        for selector in relationship_selectors(R, v['relationships']):
            w('include '+selector,3)
        w('autoLayout '+v['direction']+' 360 200',3);w('}',2)
    w("styles {",2)
    styles=[
    ("Element",{"color":"#122C43","stroke":"#57718A","strokeWidth":"2","fontSize":"22","width":"360","height":"220"}),
    ("Person",{"shape":"Person","background":"#173F5F","color":"#FFFFFF"}),
    ("Software System",{"background":"#176B87","color":"#FFFFFF"}),
    ("Container",{"background":"#DCECF7"}),
    ("Component",{"background":"#EEF5FA"}),
    ("Database",{"shape":"Cylinder","background":"#E8E4F5"}),
    ("Private",{"stroke":"#8C4966"}),("Shared",{"stroke":"#237A69"}),
    ("Blockchain",{"background":"#EFE4C8","stroke":"#9B782E","color":"#122C43"}),
    ("Contract",{"background":"#FFF3D3"}),
    ("Optional",{"background":"#F0F0F0","stroke":"#7A7A7A","border":"Dashed","color":"#122C43"}),
    ("Operational",{"background":"#E8EEEE","stroke":"#59736C"}),
    ("LogicalReference",{"stroke":"#566C82","border":"Dashed"}),
    ("ReferenceIntegration",{"stroke":"#8A6623","border":"Dashed"})]
    for tag,attributes in styles:
        w("element "+q(tag)+" {",3)
        for k,val in attributes.items():w(k+" "+val,4)
        w("}",3)
    for tag,color,dashed in [("Relationship","#476177",False),("PrivateFlow","#8C4966",False),("SharedFlow","#237A69",False),("BlockchainFlow","#967228",False),("Operational","#6D817A",True),("Alternative","#888888",True),('IdentityFlow','#285D9F',False),('DirectoryFlow','#277668',False),('SecretFlow','#874C84',False),('KeyFlow','#946B20',False),('PrivilegedFlow','#A34532',False),('SecurityAdminFlow','#607080',False),('ReferenceIntegration','#8A6623',True)]:
        w("relationship "+q(tag)+" {",3);w("color "+color,4);w("fontSize 18",4);w("thickness 2",4)
        w("routing Orthogonal",4);w("dashed "+str(dashed).lower(),4);w("}",3)
    w("}",2)
    w("properties {",2);w('"structurizr.sort" "key"',3);w("}",2)
    w("}",1);w("configuration {",1);w("scope none",2);w("}",1);w("}")
    (ROOT/"workspace.dsl").write_text("\n".join(lines)+"\n",encoding="utf-8")

emit_workspace()
catalog={"elements":list(E.values()),"relationships":R,"views":V}
(ROOT/"model-catalog.json").write_text(json.dumps(catalog,indent=2)+"\n",encoding="utf-8")
with (ROOT/"coverage.csv").open("w",encoding="utf-8",newline="") as f:
    writer=csv.writer(f);writer.writerow(["element","level","name","source","classification","views"])
    for id,e in E.items():writer.writerow([id,e["kind"],e["name"],e["source"],e["classification"],";".join(v["key"] for v in V if id in v["elements"])])
print(f"Generated workspace.dsl: {len(E)} logical elements, {len(R)} relationships, {len(V)} static views.")

