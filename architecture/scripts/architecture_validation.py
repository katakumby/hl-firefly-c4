"""Semantic checks for reference catalogs and focused initiative workspaces."""
from pathlib import Path
import re
from urllib.parse import unquote
from audit_logical_boundaries import audit_logical_boundaries
from audit_security_catalog import audit_security_catalog
from workspace_paths import ROOT

PLACEHOLDER_VIEW = 'ignition-dapp-platform-context'


def raw_elements(workspace):
    def walk(items):
        for item in items:
            yield item
            yield from walk(item.get('containers', []))
            yield from walk(item.get('components', []))
    return list(walk(workspace['model'].get('people', []))) + list(walk(workspace['model'].get('softwareSystems', [])))


def audit(workspace, catalog, sources, reference=True):
    checks = []
    def check(value, message): checks.append({'check': message, 'passed': bool(value)})
    elements = {e['id']: e for e in catalog['elements']}
    relationships = {r['id']: r for r in catalog['relationships']}
    views = catalog['views']
    check(len(elements)==len(catalog['elements']), 'Unique architecture identifiers')
    check(len(relationships)==len(catalog['relationships']), 'Unique relationship definitions')
    check(len({v['key'] for v in views})==len(views), 'Unique view keys')
    check(not workspace['model'].get('deploymentNodes'), 'No deployment content in static workspace')
    for e in elements.values():
        check(e['name'] and e['description'] and e['classification'], e['id']+': identity, responsibility and evidence classification')
        if e['kind'] in ('container','component'):
            check(e['technology'], e['id']+': technology present')
            parent_kind = 'softwareSystem' if e['kind']=='container' else 'container'
            check(elements.get(e['parent'],{}).get('kind')==parent_kind, e['id']+': correct C4 parent')
        if e['classification']!='Proposed architecture':
            check(e['source'] and e['source'] in e['sources'], e['id']+': primary evidence retained')
    for r in relationships.values():
        check(r['source'] in elements and r['destination'] in elements, r['id']+': valid endpoints')
        check(r['description'] and r['technology'] and r['classification'] and r['evidence'], r['id']+': labeled mechanism and evidence')
        if 'in-process' in r['technology'].lower():
            def runtime(identifier):
                e=elements[identifier]
                return e['id'] if e['kind']=='container' else e['parent'] if e['kind']=='component' else None
            check(runtime(r['source']) is not None and runtime(r['source'])==runtime(r['destination']), r['id']+': in-process flow stays within its runtime')
    visible=set()
    for v in views:
        key=v['key']; ids=set(v['elements']); visible.update(ids)
        edges=[relationships[r] for r in v['relationships'] if r in relationships]
        check(ids and ids<=elements.keys(), key+': valid visible elements')
        check(len(edges)==len(v['relationships']), key+': valid visible relationships')
        check(all(r['source'] in ids and r['destination'] in ids for r in edges), key+': arrow endpoints visible')
        placeholder=(not reference and key==PLACEHOLDER_VIEW and v['kind']=='systemContext'
                     and v['scope']=='dapp_platform' and ids=={'dapp_platform'} and not edges)
        if not placeholder:
            check(edges, key+': visible static dataflow exists')
            pending=[next(iter(ids))] if ids else []
            reached=set(pending)
            while pending:
                current=pending.pop()
                for r in edges:
                    if current in (r['source'],r['destination']):
                        for endpoint in (r['source'],r['destination']):
                            if endpoint not in reached: reached.add(endpoint); pending.append(endpoint)
            check(reached==ids and {x for r in edges for x in (r['source'],r['destination'])}==ids,
                  key+': connected diagram without unrelated boxes')
        if v['kind'] in ('systemLandscape','systemContext'):
            check(all(elements[i]['kind'] in ('person','softwareSystem') for i in ids),key+': C4 level 1')
        elif v['kind']=='container':
            check(elements.get(v['scope'],{}).get('kind')=='softwareSystem',key+': container scope')
            check(all(elements[i]['kind']!='component' for i in ids),key+': C4 level 2')
        elif v['kind']=='component':
            check(elements.get(v['scope'],{}).get('kind')=='container',key+': component scope')
            check(all(elements[i]['parent']==v['scope'] for i in ids if elements[i]['kind']=='component'),key+': components belong to scope')
        if v['kind']=='systemContext':
            check(elements.get(v['scope'],{}).get('kind')=='softwareSystem' and v['scope'] in ids,key+': context scope')
    # Prevent broad inspection downgrades from masking new quality failures.
    objects=[workspace, workspace.get('model',{}), workspace.get('views',{}), *raw_elements(workspace)]
    for element in raw_elements(workspace): objects.extend(element.get('relationships',[]))
    for name,items in workspace.get('views',{}).items():
        if name.endswith('Views'): objects.extend(items)
    for obj in objects:
        p=obj.get('properties',{}); identifier=p.get('architecture.id')
        for key,value in p.items():
            if not key.startswith('structurizr.inspection.'): continue
            # Export adds numeric inspection totals; these are results, not severity overrides.
            if obj is workspace and key in {f'structurizr.inspection.{s}' for s in ('error','warning','info','ignore')} and str(value).isdigit():
                continue
            allowed=(key=='structurizr.inspection.workspace.scope' and value=='info' and obj is workspace)
            allowed |= (not reference and identifier is not None and identifier!='dapp_platform'
                        and key=='structurizr.inspection.model.element.noview' and value=='info')
            allowed |= (not reference and identifier=='dapp_platform' and key=='structurizr.inspection.model.element.disconnected' and value=='info')
            check(allowed, f'{identifier or "workspace/view"}: narrowly scoped inspection policy {key}')
    if reference:
        check(set(elements)<=visible,'Every reference element appears in a view')
        for kind, view_kind in (('person','systemLandscape'),('softwareSystem','systemLandscape'),('container','container'),('component','component')):
            kinds = ('systemLandscape','systemContext') if kind in ('person','softwareSystem') else (view_kind,)
            shown={i for v in views if v['kind'] in kinds for i in v['elements']}
            check({i for i,e in elements.items() if e['kind']==kind}<=shown,kind+': full reference view coverage')
        checks.extend(audit_logical_boundaries(catalog))
        checks.extend(audit_security_catalog(catalog,sources))
    if 'dapp_platform' in elements:
        dapp=elements['dapp_platform']
        check(not reference and dapp['kind']=='softwareSystem' and dapp['name']=='DApp Platform', 'DApp proposal belongs only to an initiative')
        check(not any(e['parent']=='dapp_platform' for e in elements.values()),'Initial DApp has no children')
        check(not any('dapp_platform' in (r['source'],r['destination']) for r in relationships.values()),'Initial DApp has no integrations')
        raw=next(e for e in raw_elements(workspace) if e.get('properties',{}).get('architecture.id')=='dapp_platform')
        check(raw['properties'].get('architecture.status')=='proposed' and 'Proposed' in dapp['tags'].split(','),'DApp is explicitly proposed')
        check(any(v['key']==PLACEHOLDER_VIEW and v['elements']==['dapp_platform'] for v in views),'DApp has its focused view')
    return {'passed':all(c['passed'] for c in checks), 'elements':len(elements),
            'relationships':len(relationships),'views':len(views),'assertions':len(checks),
            'errors':[c['check'] for c in checks if not c['passed']], 'checks':checks}


def check_local_links(root=ROOT):
    """Check authored Markdown destinations. Generated build links need not exist yet."""
    root=Path(root).resolve(); errors=[]
    legacy = root/'architecture/references/legacy'
    files=[root/'README.md', legacy/'README.md']
    files += [path for path in (root/'architecture').rglob('*.md') if not path.is_relative_to(legacy)]
    for path in files:
        if not path.exists(): errors.append(f'Missing document: {path}'); continue
        content=re.sub(r'```.*?```','',path.read_text(encoding='utf-8'),flags=re.S)
        for match in re.finditer(r'\]\(([^)]+)\)',content):
            link=match[1]
            if re.match(r'[A-Za-z][A-Za-z0-9+.-]*:',link) or link.startswith('#'): continue
            target=(path.parent/unquote(link.split('#',1)[0].strip('<>'))).resolve()
            try: relative=target.relative_to(root)
            except ValueError: errors.append(f'{path}: link escapes checkout: {link}'); continue
            if relative.parts[0]!='build' and not target.exists(): errors.append(f'{path}: broken link: {link}')
    return errors
