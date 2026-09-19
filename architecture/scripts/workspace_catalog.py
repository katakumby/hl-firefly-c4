"""Normalize fresh Structurizr JSON; DSL remains the only active model source."""
import csv
import json
from pathlib import Path

VIEW_KINDS = {'systemLandscapeViews': 'systemLandscape', 'systemContextViews': 'systemContext',
              'containerViews': 'container', 'componentViews': 'component'}
DIRECTIONS = {'LeftRight': 'lr', 'RightLeft': 'rl', 'TopBottom': 'tb', 'BottomTop': 'bt'}
BUILTIN_TAGS = {'Element', 'Person', 'Software System', 'Container', 'Component', 'Relationship'}


def source_list(properties):
    values = json.loads(properties.get('architecture.sources', '[]'))
    if not isinstance(values, list) or not all(isinstance(value, str) for value in values):
        raise ValueError('architecture.sources must be a JSON array of strings')
    return values


def normalize(workspace):
    elements, raw_relationships, identifiers = [], [], {}
    def collect(items, kind, parent=None):
        for item in items:
            properties = item.get('properties', {})
            identifier = properties.get('architecture.id')
            if not identifier:
                raise ValueError(f'Missing architecture.id: {item.get("name")}')
            if identifier in identifiers.values() or item['id'] in identifiers:
                raise ValueError(f'Duplicate architecture.id or parsed identifier: {identifier}')
            identifiers[item['id']] = identifier
            element = dict(id=identifier, kind=kind, name=item.get('name',''),
                           description=item.get('description',''), technology=item.get('technology',''),
                           parent=parent, source=item.get('url',''),
                           classification=properties.get('evidence',''),
                           sources=source_list(properties),
                           tags=','.join(t for t in item.get('tags','').split(',') if t not in BUILTIN_TAGS))
            if item.get('group'): element['group'] = item['group']
            elements.append(element)
            raw_relationships.extend(item.get('relationships', []))
            collect(item.get('containers', []), 'container', identifier)
            collect(item.get('components', []), 'component', identifier)
    collect(workspace['model'].get('people', []), 'person')
    collect(workspace['model'].get('softwareSystems', []), 'softwareSystem')
    relationships, relation_ids = [], {}
    for item in raw_relationships:
        source, destination = identifiers[item['sourceId']], identifiers[item['destinationId']]
        identifier = source+'->'+destination+':'+item.get('description','')
        if item['id'] in relation_ids or identifier in relation_ids.values():
            raise ValueError(f'Duplicate relationship: {identifier}')
        relation_ids[item['id']] = identifier
        properties = item.get('properties', {})
        relationships.append(dict(id=identifier, source=source, destination=destination,
            description=item.get('description',''), technology=item.get('technology',''),
            tags=','.join(t for t in item.get('tags','').split(',') if t not in BUILTIN_TAGS),
            evidence=source_list(properties), classification=properties.get('evidence','')))
    views = []
    for kind, items in workspace.get('views', {}).items():
        if not kind.endswith('Views'): continue
        if kind not in VIEW_KINDS and items:
            raise ValueError(f'Only static C4 views are supported: {kind}')
        for item in items:
            scope = item.get('containerId', item.get('softwareSystemId'))
            views.append(dict(kind=VIEW_KINDS[kind], key=item['key'], scope=identifiers[scope] if scope else '',
                title=item.get('title',item.get('description','')),
                direction=DIRECTIONS.get(item.get('automaticLayout',{}).get('rankDirection'),'lr'),
                elements=[identifiers[e['id']] for e in item.get('elements',[])],
                relationships=[relation_ids[r['id']] for r in item.get('relationships',[])]))
    return dict(elements=elements, relationships=relationships, views=views)


def write_catalog(workspace, directory):
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    catalog = normalize(workspace)
    (directory/'model-catalog.json').write_text(json.dumps(catalog,indent=2)+'\n',encoding='utf-8')
    with (directory/'coverage.csv').open('w',encoding='utf-8',newline='') as stream:
        writer = csv.writer(stream)
        writer.writerow(['element','level','name','source','classification','views'])
        for e in catalog['elements']:
            writer.writerow([e['id'],e['kind'],e['name'],e['source'],e['classification'],
                             ';'.join(v['key'] for v in catalog['views'] if e['id'] in v['elements'])])
    return catalog


def semantic_difference(before, after):
    """Order-independent migration comparison; view selections remain exact."""
    differences = []
    for section in ('elements','relationships','views'):
        key = 'key' if section=='views' else 'id'
        def canonical(items):
            result = {}
            for item in items:
                item = dict(item)
                for field in ('elements','relationships','sources','evidence'):
                    if isinstance(item.get(field),list): item[field] = sorted(item[field])
                if 'tags' in item: item['tags'] = sorted(filter(None,item['tags'].split(',')))
                result[item[key]] = item
            return result
        left, right = canonical(before[section]), canonical(after[section])
        for identifier in sorted(left.keys() | right.keys()):
            if left.get(identifier) != right.get(identifier): differences.append(section+': '+identifier)
    return differences
