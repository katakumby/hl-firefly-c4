"""Presentation comparison, separate from historical model semantics."""
from architecture_validation import raw_elements
from workspace_catalog import normalize


def normalize_presentation(workspace):
    catalog = normalize(workspace)
    identities = {e['id']: e['properties']['architecture.id'] for e in raw_elements(workspace)}
    for element in raw_elements(workspace):
        for relation in element.get('relationships', []):
            identities[relation['id']] = (identities[relation['sourceId']] + '->' +
                identities[relation['destinationId']] + ':' + relation.get('description', ''))
    def clean(value, key=''):
        if isinstance(value, dict):
            return {k: clean(v, k) for k, v in value.items()
                    if k not in ('order', 'structurizr.dsl')
                    and not (k in {f'structurizr.inspection.{s}' for s in ('error', 'warning', 'info', 'ignore')} and str(v).isdigit())}
        if isinstance(value, list):
            items = [clean(v) for v in value]
            # View selections are sets; style cascades, vertices and animation steps are ordered.
            if key in ('elements', 'relationships') and all(isinstance(v, dict) and 'id' in v for v in items):
                return sorted(items, key=lambda v: v['id'])
            return items
        if key in ('id', 'sourceId', 'destinationId', 'softwareSystemId', 'containerId'):
            return identities.get(value, value)
        return value
    elements, relations = {}, {}
    for raw in raw_elements(workspace):
        identifier = identities[raw['id']]
        elements[identifier] = clean({k: v for k, v in raw.items() if k not in ('containers', 'components', 'relationships')})
        for relation in raw.get('relationships', []):
            relations[identities[relation['id']]] = clean(relation)
    views = {v['key']: clean(v) for kind, entries in workspace.get('views', {}).items()
             if kind.endswith('Views') for v in entries}
    return {'workspace': clean({k: workspace[k] for k in ('name', 'description', 'properties', 'configuration') if k in workspace}),
            'model_properties': clean(workspace.get('model', {}).get('properties', {})),
            'elements': elements, 'relationships': relations, 'views': views,
            'view_configuration': clean(workspace.get('views', {}).get('configuration', {})),
            'view_properties': clean(workspace.get('views', {}).get('properties', {}))}


def presentation_difference(before, after):
    differences = []
    for section in sorted(before.keys() | after.keys()):
        if section in ('elements', 'relationships', 'views'):
            a, b = before.get(section, {}), after.get(section, {})
            differences.extend(section + ': ' + key for key in sorted(a.keys() | b.keys()) if a.get(key) != b.get(key))
        elif before.get(section) != after.get(section):
            differences.append(section)
    return differences
