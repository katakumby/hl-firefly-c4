"""Readable relationship selection without generated opaque DSL identifiers."""
from collections import defaultdict

# Names are needed only when a view selects some of the arrows sharing the
# same endpoints. Ordinary relationships stay anonymous in the DSL.
NAMED_RELATIONSHIPS = {
    ('apps.client', 'entraId.authentication',
     'Authenticates workload identity and requests HSM-audience access token'): 'hsmWorkloadTokenRequest',
    ('entraId.authentication', 'apps.client',
     'Returns HSM-audience workload access token'): 'hsmWorkloadTokenResponse',
}


def relationship_name(relationship):
    return NAMED_RELATIONSHIPS.get(tuple(relationship[k] for k in ('source', 'destination', 'description')))


def relationship_selectors(relationships, selected_ids):
    selected_ids = set(selected_ids)
    by_pair = defaultdict(list)
    for relationship in relationships:
        by_pair[(relationship['source'], relationship['destination'])].append(relationship)
    selectors = []
    for (source, destination), candidates in by_pair.items():
        selected = [r for r in candidates if r['id'] in selected_ids]
        if not selected:
            continue
        if len(selected) == len(candidates):
            selectors.append(source+'->'+destination)
        else:
            for relationship in selected:
                name = relationship_name(relationship)
                if name is None:
                    raise ValueError('Partial arrow selection requires a descriptive relationship name: '+relationship['id'])
                selectors.append(name)
    return selectors
