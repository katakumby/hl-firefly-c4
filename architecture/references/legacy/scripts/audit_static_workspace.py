"""Audit actual parsed C4 dataflows and preservation; never inspect deployments."""
from pathlib import Path
import hashlib
import json
import re
from audit_security_catalog import audit_security_catalog
from audit_logical_boundaries import audit_logical_boundaries

ROOT=Path(__file__).resolve().parents[1]
REPORT=ROOT/'reports/static'

def audit(parsed_path, write_report=True, verbose=True):
    w=json.loads(Path(parsed_path).read_text(encoding='utf-8-sig'))
    catalog=json.loads((ROOT/'model-catalog.json').read_text(encoding='utf-8'))
    elements={};types={};parents={};rels={};checks=[]
    def check(test,message):checks.append({'check':message,'passed':bool(test)})
    def collect(items,kind,parent=None):
        for e in items:
            elements[e['id']]=e;types[e['id']]=kind;parents[e['id']]=parent
            for r in e.get('relationships',[]):rels[r['id']]=r
            collect(e.get('containers',[]),'container',e['id'])
            collect(e.get('components',[]),'component',e['id'])
    collect(w['model'].get('people',[]),'person')
    collect(w['model'].get('softwareSystems',[]),'softwareSystem')
    arch=lambda id:elements[id].get('properties',{}).get('architecture.id')
    byarch={arch(id):id for id in elements}
    check(None not in byarch,'Every parsed element retains its architecture identifier')
    check(len(byarch)==len(elements),'Parsed architecture identifiers are unique')
    check(set(byarch)=={e['id'] for e in catalog['elements']},'Every authored logical element survives parsing')
    authored_elements={e['id']:e for e in catalog['elements']}
    check(all(e.get('group')==authored_elements[arch(id)].get('group') for id,e in elements.items()),
          'Parsed groups exactly match authored navigation groups')
    check(not w['model'].get('deploymentNodes'),'Static input contains no deployment nodes')
    check(not any(w['views'].get(k) for k in ('deploymentViews','dynamicViews','imageViews','customViews','filteredViews')),'Only static C4 view types are present')
    for id,e in elements.items():
        check(bool(e.get('name')) and bool(e.get('description')),f'{arch(id)}: name and responsibility present')
        if types[id] in ('container','component'):
            check(bool(e.get('technology')),f'{arch(id)}: implementation technology present')
            check(types.get(parents[id])==('softwareSystem' if types[id]=='container' else 'container'),f'{arch(id)}: correct C4 parent')
    signature=lambda r:(arch(r['sourceId']),arch(r['destinationId']),r.get('description',''),r.get('technology',''))
    expected=lambda r:(r['source'],r['destination'],r['description'],r['technology'])
    check({signature(r) for r in rels.values()}=={expected(r) for r in catalog['relationships']},'Parsed relationships exactly match authored endpoints, labels and mechanisms')
    check(all(r.get('evidence') and r.get('classification') for r in catalog['relationships']),'Every relationship has source evidence and an inference classification')
    views=[(kind,v) for kind,vs in w['views'].items() if kind.endswith('Views') for v in vs]
    authored={v['key']:v for v in catalog['views']}
    check({v['key'] for _,v in views}==set(authored),'All authored static view keys survive parsing')
    check(len(views)==len(authored),'Static view keys are unique')
    visible=set();component_visible=set();system_visible=set();container_visible=set()
    for kind,v in views:
        key=v['key'];ids={e['id'] for e in v.get('elements',[])};visible.update(ids)
        edges=[rels[r['id']] for r in v.get('relationships',[])]
        check(bool(edges),f'{key}: visible static dataflow exists')
        check(all(r['sourceId'] in ids and r['destinationId'] in ids for r in edges),f'{key}: every arrow has visible endpoints')
        check(all(r.get('description') and r.get('technology') for r in edges),f'{key}: every arrow names its action and mechanism')
        connected={r[k] for r in edges for k in ('sourceId','destinationId')}
        check(ids<=connected,f'{key}: no disconnected boxes')
        check({arch(id) for id in ids}==set(authored[key]['elements']),f'{key}: parsed view includes exactly its intended elements')
        selected=set(authored[key]['relationships'])
        check({signature(r) for r in edges}=={expected(r) for r in catalog['relationships'] if r['id'] in selected},f'{key}: every selected dataflow survives view filtering')
        if kind in ('systemLandscapeViews','systemContextViews'):
            system_visible.update(ids)
            check(all(types[id] in ('person','softwareSystem') for id in ids),f'{key}: correct level-1 abstraction')
        if kind=='systemContextViews':
            check(arch(v['softwareSystemId'])==authored[key]['scope'],f'{key}: parsed system-context scope matches catalog')
        if kind=='containerViews':
            container_visible.update(ids)
            check(all(types[id]!='component' for id in ids),f'{key}: correct level-2 abstraction')
            check(arch(v['softwareSystemId'])==authored[key]['scope'],f'{key}: parsed container scope matches catalog')
        if kind=='componentViews':
            component_visible.update(id for id in ids if types[id]=='component')
            check(all(types[id]!='component' or parents[id]==v['containerId'] for id in ids),f'{key}: components belong to the scoped container')
            check(arch(v['containerId'])==authored[key]['scope'],f'{key}: parsed component scope matches catalog')
    check(set(elements)<=visible,'Every logical element appears in a view')
    check({id for id,t in types.items() if t in ('person','softwareSystem')}<=system_visible,'Every system and actor appears at C4 level 1')
    check({id for id,t in types.items() if t=='container'}<=container_visible,'Every container appears at C4 level 2')
    check({id for id,t in types.items() if t=='component'}<=component_visible,'Every component appears in a component view')
    checks.extend(audit_security_catalog(catalog, json.loads((ROOT/'sources.json').read_text(encoding='utf-8'))))
    checks.extend(audit_logical_boundaries(catalog))
    # Compare immutable historical material, not an active second workspace.
    baseline=ROOT/'.cache/static-preservation.json'
    hashes=json.loads(baseline.read_text(encoding='utf-8'))
    now={f.relative_to(ROOT).as_posix():hashlib.sha256(f.read_bytes()).hexdigest()
         for directory in ('exports','archive') for f in (ROOT/directory).rglob('*') if f.is_file()}
    check(now==hashes,'Archived deployment material and historical exports are byte-for-byte unchanged')
    check({p.name for p in ROOT.glob('*.dsl')}=={'workspace.dsl'},'Exactly one canonical DSL workspace exists')
    check(not (ROOT/'model-catalog-static.json').exists(),'No redundant static model catalog exists')
    check(set(catalog)=={'elements','relationships','views'},'Canonical catalog contains only the logical model')
    text=(ROOT/'workspace.dsl').read_text(encoding='utf-8')
    check(not re.search(r'\bflow_[0-9a-f]{16,}\b',text),'DSL contains no opaque generated relationship identifiers')
    check(not re.search(r'^\s*(?:\w+\s*=\s*)?(?:deploymentEnvironment|deploymentNode|containerInstance|deployment)\s',text,re.M),'Static DSL excludes deployment declarations')
    result={'passed':all(c['passed'] for c in checks),'elements':len(elements),'components':sum(t=='component' for t in types.values()),
            'relationships':len(rels),'views':len(views),'assertions':len(checks),'errors':[c['check'] for c in checks if not c['passed']],
            'deployment_validation':'NOT RUN (legacy material archived)','diagram_exports':'NOT RUN','checks':checks}
    if write_report:
        REPORT.mkdir(parents=True,exist_ok=True)
        (REPORT/'architecture-audit.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
    if verbose:print(json.dumps({k:v for k,v in result.items() if k!='checks'},indent=2))
    return result

if __name__=='__main__':
    import sys
    result=audit(sys.argv[1])
    raise SystemExit(0 if result['passed'] else 1)
