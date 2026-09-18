"""Audit actual parsed C4 dataflows and preservation; never inspect deployments."""
from pathlib import Path
import hashlib
import json
import re

ROOT=Path(__file__).resolve().parents[1]
REPORT=ROOT/'reports/static'

def deferred_blocks(text):
    """Extract only unchanged deferred blocks, respecting quoted DSL braces."""
    starts=re.finditer(r'^\s*(?:production = deploymentEnvironment|!element production\.|deployment \* production)[^\n]*\{',text,re.M)
    blocks=[]
    for match in starts:
        start=match.start();opening=text.index('{',match.start());depth=0;quoted=False;escaped=False
        for index in range(opening,len(text)):
            char=text[index]
            if escaped:escaped=False;continue
            if quoted and char=='\\':escaped=True;continue
            if char=='"':quoted=not quoted
            if not quoted:
                if char=='{':depth+=1
                elif char=='}':depth-=1
                if depth==0:
                    blocks.append(text[start:index+1]);break
    return blocks

def audit(parsed_path, write_report=True, verbose=True):
    w=json.loads(Path(parsed_path).read_text(encoding='utf-8-sig'))
    catalog=json.loads((ROOT/'model-catalog-static.json').read_text(encoding='utf-8'))
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
        if kind=='containerViews':
            container_visible.update(ids)
            check(all(types[id]!='component' for id in ids),f'{key}: correct level-2 abstraction')
        if kind=='componentViews':
            component_visible.update(id for id in ids if types[id]=='component')
            check(all(types[id]!='component' or parents[id]==v['containerId'] for id in ids),f'{key}: components belong to the scoped container')
    check(set(elements)<=visible,'Every logical element appears in a view')
    check({id for id,t in types.items() if t in ('person','softwareSystem')}<=system_visible,'Every system and actor appears at C4 level 1')
    check({id for id,t in types.items() if t=='container'}<=container_visible,'Every container appears at C4 level 2')
    check({id for id,t in types.items() if t=='component'}<=component_visible,'Every component appears in a component view')
    # These compare preserved definitions only; they do not assess deployment
    # topology, availability, placement, quorum, layouts or runtime behavior.
    baseline=ROOT/'.cache/static-baseline'
    old=json.loads((baseline/'model-catalog.json').read_text(encoding='utf-8'))
    full=json.loads((ROOT/'model-catalog.json').read_text(encoding='utf-8'))
    for key in ('deployment_elements','deployment_relationships','node_placement'):
        check(old[key]==full[key],f'Preservation only: {key} is unchanged')
    check([v for v in old['views'] if v['kind']=='deployment']==[v for v in full['views'] if v['kind']=='deployment'],'Preservation only: deployment view definitions unchanged')
    check(deferred_blocks((baseline/'workspace.dsl').read_text(encoding='utf-8'))==deferred_blocks((ROOT/'workspace.dsl').read_text(encoding='utf-8')),'Preservation only: emitted deployment DSL blocks are unchanged')
    check(all(full[k]==catalog[k] for k in ('elements','relationships')),'Full and static entrypoints share the identical logical model')
    check([v for v in full['views'] if v['kind']!='deployment']==catalog['views'],'Full and static entrypoints share identical logical views')
    hashes=json.loads((baseline/'exports-hashes.json').read_text())
    now={str(f):hashlib.sha256(f.read_bytes()).hexdigest() for f in (ROOT/'exports').rglob('*') if f.is_file()}
    now={str(Path(k).relative_to(ROOT)):v for k,v in now.items()}
    check(now==hashes,'Existing exports are byte-for-byte unchanged')
    text=(ROOT/'workspace-static.dsl').read_text(encoding='utf-8')
    check(not re.search(r'^\s*(?:\w+\s*=\s*)?(?:deploymentEnvironment|deploymentNode|containerInstance|deployment)\s',text,re.M),'Static DSL excludes deployment declarations')
    result={'passed':all(c['passed'] for c in checks),'elements':len(elements),'components':sum(t=='component' for t in types.values()),
            'relationships':len(rels),'views':len(views),'assertions':len(checks),'errors':[c['check'] for c in checks if not c['passed']],
            'deployment_validation':'DEFERRED (preservation comparisons only)','diagram_exports':'NOT RUN','checks':checks}
    if write_report:
        REPORT.mkdir(parents=True,exist_ok=True)
        (REPORT/'architecture-audit.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
    if verbose:print(json.dumps({k:v for k,v in result.items() if k!='checks'},indent=2))
    return result

if __name__=='__main__':
    import sys
    result=audit(sys.argv[1])
    raise SystemExit(0 if result['passed'] else 1)
