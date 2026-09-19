"""Check rendered geometry, then create contact sheets for human visual review."""
from pathlib import Path
import json,re,math,sys,xml.etree.ElementTree as ET
ROOT=Path(__file__).resolve().parents[1]
NS="{http://www.w3.org/2000/svg}"
def numbers(s):return [float(n) for n in re.findall(r"-?\d+(?:\.\d+)?",s)]
def overlap(a,b,pad=0):
    return min(a[2],b[2])-max(a[0],b[0])>pad and min(a[3],b[3])-max(a[1],b[1])>pad
results=[]
for p in sorted((ROOT/"exports/svg").glob("*.svg")):
    if p.stem.endswith("-key"):continue
    root=ET.parse(p).getroot();width=float(root.get("width"));height=float(root.get("height"))
    nodes=[];labels=[];overflow=[]
    for g in root.iter(NS+"g"):
        if not g.get("id","").startswith("j_") or not g.get("transform","").startswith("translate"):continue
        if g.get("style")!="":continue # deployment/system boundaries are intentionally enclosing
        tx,ty=numbers(g.get("transform"))[:2]
        texts=list(g.iter(NS+"text"))
        if not texts:continue
        name=" ".join(texts[0].itertext())
        if len(texts)>1 and "[Deployment Node:" in " ".join(texts[1].itertext()):continue
        rects=[r for r in g.iter(NS+"rect") if float(r.get("width",0))>=200 and float(r.get("height",0))>=100]
        if not rects:continue
        rect=rects[0];rw=float(rect.get("width"));rh=float(rect.get("y",0))+float(rect.get("height")) # full shape including caps / head
        nodes.append((name,(tx,ty,tx+rw,ty+rh)))
        for text in texts:
            if text.get("display")=="none" or "display: none" in text.get("style",""):continue
            if text.get("dominant-baseline")!="hanging":continue
            fs=float(text.get("font-size","0").replace("px",""))
            yy=float(text.get("y","0"));dy=0
            for t in text.findall(NS+"tspan"):
                d=t.get("dy","0");dy+=float(d[:-2])*fs if d.endswith("em") else float(d)
            if yy+dy+fs>rh+6:overflow.append(name)
    for parent in root.iter(NS+"g"):
        group=[g for g in parent if g.tag==NS+"g" and g.get("label-idx") is not None]
        if not group:continue
        bbs=[];words=[]
        for g in group:
            mat=numbers(g.get("transform",""))
            rect=g.find(NS+"rect")
            if len(mat)!=6 or rect is None:continue
            if rect.get("display")=="none" or float(rect.get("width",0))<=0 or float(rect.get("height",0))<=0:continue
            x=mat[4]+float(rect.get("x","0"));y=mat[5]+float(rect.get("y","0"))
            bbs.append((x,y,x+float(rect.get("width",0)),y+float(rect.get("height",0))))
            words.append(" ".join(g.itertext()))
        if bbs:labels.append((" / ".join(words),(min(b[0] for b in bbs),min(b[1] for b in bbs),max(b[2] for b in bbs),max(b[3] for b in bbs))))
    def inside(point,box,pad=0):return box[0]-pad<point[0]<box[2]+pad and box[1]-pad<point[1]<box[3]+pad
    def crosses(a,b,box):
        l,t,r,d=box;l+=8;t+=8;r-=8;d-=8
        if a[0]==b[0]:return l<a[0]<r and min(a[1],b[1])<d and max(a[1],b[1])>t
        if a[1]==b[1]:return t<a[1]<d and min(a[0],b[0])<r and max(a[0],b[0])>l
        return False
    parents={child:parent for parent in root.iter() for child in parent};edge_nodes=[]
    for path in root.iter(NS+"path"):
        if path.get("joint-selector")!="line":continue
        pts=[]
        for command,values in re.findall(r"([MLC])\s*([^MLCAZ]+)",path.get("d","")):
            ns=numbers(values)
            if len(ns)>=2:pts.append(tuple(ns[-2:]))
        if len(pts)<2:continue
        for name,box in nodes:
            start_node=inside(pts[0],box,12);end_node=inside(pts[-1],box,12)
            if any(crosses(a,b,box) for j,(a,b) in enumerate(zip(pts,pts[1:])) if not (start_node and j==0) and not (end_node and j==len(pts)-2)):
                descriptions=[g for g in parents[path].iter(NS+"g") if g.get("label-idx")=="0"]
                edge_nodes.append((" ".join(descriptions[0].itertext()) if descriptions else "",name))
    clipping=[name for name,b in nodes if b[0]<0 or b[1]<0 or b[2]>width or b[3]>height]
    collision=[(n1,n2) for i,(n1,b1) in enumerate(nodes) for n2,b2 in nodes[i+1:] if overlap(b1,b2,3)]
    label_nodes=[(text,name) for text,b in labels for name,nb in nodes if overlap(b,nb,3)]
    label_labels=[(t1,t2) for i,(t1,b1) in enumerate(labels) for t2,b2 in labels[i+1:] if overlap(b1,b2,3)]
    results.append({"view":p.stem,"width":width,"height":height,"nodes":len(nodes),"clipped_nodes":clipping,
        "node_collisions":collision,"text_overflow":sorted(set(overflow)),"label_node_overlaps":label_nodes,
        "label_label_overlaps":label_labels,"edge_node_crossings":edge_nodes})
(ROOT/"reports/visual-geometry.json").write_text(json.dumps(results,indent=2)+"\n",encoding="utf-8")
if "--contact-sheets" in sys.argv:
    from PIL import Image,ImageDraw,ImageFont
    previews=[ROOT/".cache/previews"/(v["view"]+".png") for v in results]
    out=ROOT/".cache/contact-sheets";out.mkdir(parents=True,exist_ok=True)
    font=ImageFont.truetype("C:/Windows/Fonts/arial.ttf",22)
    for start in range(0,len(previews),8):
        sheet=Image.new("RGB",(2200,1800),"#e9eff3");draw=ImageDraw.Draw(sheet)
        for j,p in enumerate(previews[start:start+8]):
            col=j%2;row=j//2;x=col*1100;y=row*450
            draw.rectangle((x+8,y+8,x+1092,y+442),fill="white")
            draw.text((x+20,y+15),p.stem,fill="#173f5f",font=font)
            im=Image.open(p).convert("RGB");im.thumbnail((1060,385))
            sheet.paste(im,(x+(1100-im.width)//2,y+50+(385-im.height)//2))
        sheet.save(out/f"sheet-{start//8+1:02}.png")
print(json.dumps({"views":len(results),"clipped_nodes":sum(len(r["clipped_nodes"]) for r in results),
"node_collisions":sum(len(r["node_collisions"]) for r in results),"text_overflow":sum(len(r["text_overflow"]) for r in results),
"label_node_overlaps":sum(len(r["label_node_overlaps"]) for r in results),
"label_label_overlaps":sum(len(r["label_label_overlaps"]) for r in results),
"edge_node_crossings":sum(len(r["edge_node_crossings"]) for r in results)},indent=2))
print("Flagged:",[(r["view"],len(r["label_node_overlaps"]),len(r["label_label_overlaps"]),r["text_overflow"]) for r in results if r["label_node_overlaps"] or r["text_overflow"] or r["label_label_overlaps"]])


issues=sum(len(r[k]) for r in results for k in ("clipped_nodes","node_collisions","text_overflow","label_node_overlaps","label_label_overlaps","edge_node_crossings"))
sys.exit(1 if issues else 0)
