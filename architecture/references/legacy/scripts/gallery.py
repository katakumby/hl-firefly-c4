"""Generate an offline, searchable gallery of native Structurizr SVG exports."""
from pathlib import Path
import json,html
ROOT=Path(__file__).resolve().parents[1]
w=json.loads((ROOT/"exports/workspace.json").read_text(encoding="utf-8"))
vs=sorted([v for k,rows in w["views"].items() if k.endswith("Views") for v in rows],key=lambda v:v["key"])
options="".join(f'<option value="{v["key"]}">{html.escape(v["title"])}</option>' for v in vs)
page="""<!doctype html><html lang="en"><meta charset="utf-8"><meta name="viewport" content="width=device-width">
<title>FireFly + Besu — Architecture</title><style>
*{box-sizing:border-box}body{margin:0;background:#f5f8fa;color:#16334a;font:15px system-ui}
header{background:#173f5f;color:white;padding:22px 28px}h1{margin:0 0 6px;font-size:26px}header p{margin:0;opacity:.8}
nav{display:flex;gap:12px;align-items:center;flex-wrap:wrap;padding:16px 28px;background:white;border-bottom:1px solid #d4e0e8}
select{max-width:650px;flex:1;min-width:280px}input,select,button{font:inherit;padding:9px;border:1px solid #b6c7d3;border-radius:5px}
button{cursor:pointer;background:#e8f0f5;color:#173f5f}a{color:#176b87}main{padding:12px 24px}
#viewport{overflow:auto;max-height:78vh;background:white;border:1px solid #c9d7e1;border-radius:6px}
#diagram{display:block;max-width:none}details{margin:16px 0}summary{cursor:pointer}#legend{max-width:100%}
.hint{font-size:13px;color:#526d80}#filter{width:180px}#zoom{width:150px;padding:0}#name{font-size:18px;margin:10px 0}
</style><header><h1>FireFly + Besu architecture</h1><p>C4 levels 1–3 · Three members · Three availability zones · Official-source traceability</p></header>
<nav><input id="filter" placeholder="Filter diagrams" aria-label="Filter diagrams"><select id="views" aria-label="Diagram">OPTIONS</select>
<button id="fit">Fit width</button><label>Zoom <input id="zoom" type="range" min="10" max="150" value="30"></label>
<a id="download" target="_blank">Open SVG</a><a href="../README.md">Guide</a></nav>
<main><h2 id="name"></h2><p class="hint">Scroll to explore large views. Start with deployment details 80–82 before the complete map 99. Private payloads travel off-chain; hashes and contract state use the shared ledger.</p>
<div id="viewport"><img id="diagram" alt="Architecture diagram"></div><details><summary>Diagram notation key</summary><img id="legend" alt="Notation key"></details>
<p class="hint">Reference design: safe fencing, state recovery and failure drills are required. Diagram validation does not prove live-service availability.</p></main>
<script>
const sel=document.getElementById('views'),img=document.getElementById('diagram'),zoom=document.getElementById('zoom');
const original=Array.from(sel.options).map(x=>({value:x.value,text:x.text}));
function size(){img.style.width=(img.naturalWidth*Number(zoom.value)/100)+'px'}
function fit(){zoom.value=Math.min(150,Math.max(10,(document.getElementById('viewport').clientWidth/img.naturalWidth)*100));size()}
function show(){let k=sel.value;img.onload=fit;img.src='svg/'+k+'.svg';document.getElementById('legend').src='svg/'+k+'-key.svg';document.getElementById('name').textContent=sel.selectedOptions[0].text;document.getElementById('download').href=img.src;history.replaceState(null,'','#'+k)}
sel.onchange=show;zoom.oninput=size;document.getElementById('fit').onclick=fit;
document.getElementById('filter').oninput=e=>{let s=e.target.value.toLowerCase();sel.replaceChildren(...original.filter(x=>x.text.toLowerCase().includes(s)||x.value.includes(s)).map(x=>new Option(x.text,x.value)));if(sel.options.length)show()};
if(original.some(x=>x.value===location.hash.slice(1)))sel.value=location.hash.slice(1);show();
</script></html>""".replace("OPTIONS",options)
(ROOT/"exports/index.html").write_text(page,encoding="utf-8")
print("Generated offline gallery for",len(vs),"views.")

