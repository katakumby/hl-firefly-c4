"""Semantic review checks beyond successful Structurizr parsing."""
from collections import Counter


def audit_logical_boundaries(catalog):
    checks = []
    def check(value, message):
        checks.append({'check': 'Logical review: '+message, 'passed': bool(value)})

    elements = {e['id']: e for e in catalog['elements']}
    relationships = catalog['relationships']
    by_id = {r['id']: r for r in relationships}
    views = catalog['views']
    check(len(elements)==len(catalog['elements']), 'element identifiers are unique')
    check(len(by_id)==len(relationships), 'relationship identifiers are unique')
    check(all(count==1 for count in Counter((r['source'], r['destination'], r['description'])
                                           for r in relationships).values()), 'no duplicate directed relationship definitions')
    check(all(count==1 for count in Counter((e['parent'], e['kind'], e['name'].casefold())
                                           for e in elements.values()).values()), 'no duplicate names within the same C4 owner')
    check(all(r['id']==r['source']+'->'+r['destination']+':'+r['description'] for r in relationships),
          'catalog relationship identifiers match their current meaning')
    check(set(by_id)<={r for v in views for r in v['relationships']}, 'every authored relationship appears in a static view')
    signatures=[(v['kind'],v['scope'],tuple(sorted(v['elements'])),tuple(sorted(v['relationships']))) for v in views]
    check(len(signatures)==len(set(signatures)), 'no duplicate view selections within one scope')

    def runtime(identifier):
        element=elements[identifier]
        return element['id'] if element['kind']=='container' else element['parent'] if element['kind']=='component' else None
    check(all(runtime(r['source']) is not None and runtime(r['source'])==runtime(r['destination'])
              for r in relationships if 'in-process' in r['technology'].lower()),
          'in-process relationships stay within one runtime container')
    for v in views:
        remaining=set(v['elements'])
        pending=[remaining.pop()] if remaining else []
        while pending:
            current=pending.pop()
            for identifier in v['relationships']:
                r=by_id.get(identifier)
                if r and current in (r['source'],r['destination']):
                    for endpoint in (r['source'],r['destination']):
                        if endpoint in remaining:
                            remaining.remove(endpoint)
                            pending.append(endpoint)
        check(not remaining, v['key']+' is one connected diagram')
    for e in elements.values():
        if e['kind']=='softwareSystem' and any(child['parent']==e['id'] for child in elements.values()):
            check(any(v['kind']=='systemContext' and v['scope']==e['id'] for v in views),
                  e['id']+' has a context view for its decomposed system boundary')
    check('firefly.pgReplica' not in elements, 'replica deployment instances do not duplicate logical databases')
    check(elements.get('firefly.pg',{}).get('kind')=='container' and elements.get('firefly.fftmDb',{}).get('kind')=='container',
          'Core and FFTM have separate logical database boundaries')
    check(not any(r['destination']=='firefly.pg' and r['source'].startswith('firefly.evm') for r in relationships),
          'FFTM does not persist into the Core database')
    for browser in ('firefly.explorer','tools.sandboxUi'):
        check(elements.get(browser,{}).get('kind')=='container', browser+' has its own browser runtime boundary')
    return checks
