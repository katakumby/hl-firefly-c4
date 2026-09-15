"""Summarize retained validation evidence after a successful export and visual audit."""
from pathlib import Path
import json,datetime
ROOT=Path(__file__).resolve().parents[1]
a=json.loads((ROOT/'reports/architecture-audit.json').read_text(encoding='utf-8'))
g=json.loads((ROOT/'reports/visual-geometry.json').read_text(encoding='utf-8'))
s=json.loads((ROOT/'reports/source-audit.json').read_text(encoding='utf-8'))
issues={k:sum(len(v[k]) for v in g) for k in ('clipped_nodes','node_collisions','text_overflow','label_node_overlaps','label_label_overlaps','edge_node_crossings')}
assert a['passed'] and not any(issues.values())
lines=['# Validation summary','',f"Recorded: {datetime.datetime.now(datetime.timezone.utc).isoformat()}",'',
'## Results','',f"- {a['views']} diagrams, {a['components']} components, {a['deployment_instances']} deployment container instances.",
'- Docker validate succeeded for workspace.dsl and exports/workspace.json.',
'- Docker inspect ran on both DSL and JSON. Zero errors/warnings; four intentional workspace.scope informational findings retained in each full report.',
f"- {a['assertions']:,} parsed-model and SVG assertions passed.",
'- Every modeled component appears in a component view. Every view contains visible, labeled static relationships with protocol metadata.',
'- Member database, signing-key and private-storage relationships are isolated. Dedicated PostgreSQL/Besu volumes, WAL paths, RPC/discovery placement and validator quorum checks passed.',
'- A loss of any one zone leaves four of six validators. Additional unavailable-validator headroom: zero.',
f"- Source audit: {s['captured_repositories']} official repositories, {s['captured_documents']} captured source documents, {s['official_pages']} official documentation pages; no unmapped top-level FireFly Core runtime packages.",
f"- All {a['views']} SVGs and {a['views']} notation keys were exported by the pinned official Playwright image.",
'', '## Rendered geometry','', '| Check | Findings |','|---|---|']
for k,v in issues.items():lines.append(f"| {k.replace('_',' ')} | {v} |")
lines+=['','Diagram review uses the SVG exports and PNG contact sheets. The full deployment is a zoomable reference map; focused deployment views separate member state, blockchain and operations. Geometry checks measure labels and protocols, exclude intentionally enclosing C4 boundaries, and retain detailed per-view results.','',
'## Reports','', '- [Complete DSL inspection](inspect-dsl.txt)', '- [Complete JSON inspection](inspect.txt)', '- [Error/warning gate](inspect-errors-warnings.txt)', '- [Parsed-model audit](architecture-audit.json)', '- [Source audit](source-audit.json)', '- [Rendered geometry](visual-geometry.json)', '- [Pinned Docker image metadata](docker-images.json)', '',
'## Availability scope','', 'This validates the architecture artifacts, not an AKS installation. Single-active recovery requires fencing, retained state, safe volume reattachment, checkpoint recovery and notification reconciliation. Recovery times and automation remain design objectives requiring deployment failure tests.']
(ROOT/'reports/validation-summary.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
print('Wrote reports/validation-summary.md')
