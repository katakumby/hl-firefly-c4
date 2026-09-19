"""Local dependency boundaries and provenance derived from parsed ancestors."""
from pathlib import Path
import re
from architecture_validation import raw_elements
from workspace_paths import ROOT, ARCHITECTURE, SHARED, REFERENCE


def uncomment(text):
    # Quoted URLs, escaped evidence JSON and braces are not DSL comments.
    token = r'"(?:\\.|[^"\\])*"|//[^\n]*|/\*[\s\S]*?\*/'
    return re.sub(token, lambda m: m[0] if m[0].startswith('"') else '\n' * m[0].count('\n'), text)


def epic_owner(path):
    try:
        parts = Path(path).resolve().relative_to(ARCHITECTURE / 'initiatives').parts
        return parts[0] if parts else None
    except ValueError:
        return None


def directives(path):
    text = uncomment(Path(path).read_text(encoding='utf-8'))
    pattern = r'^\s*(workspace\s+extends|!include|!docs|!adrs)\s+("[^"]+"|\S+)'
    for match in re.finditer(pattern, text, re.M):
        token = match[2].strip('"')
        if '://' in token:
            raise ValueError(f'Use same-checkout dependencies, not URLs: {path}: {token}')
        child = (Path(path).parent / token).resolve()
        child.relative_to(ROOT)
        if not child.exists():
            raise ValueError(f'Missing DSL/document dependency: {path}: {token}')
        yield match[1], child


def dependencies(path, active=None, seen=None):
    active = set() if active is None else active
    seen = set() if seen is None else seen
    path = Path(path).resolve()
    path.relative_to(ROOT)
    if path in active:
        raise ValueError(f'Cyclic DSL dependency: {path}')
    if path in seen:
        return seen
    active.add(path)
    seen.add(path)
    for kind, child in directives(path):
        owner, target = epic_owner(path), epic_owner(child)
        if target and owner != target:
            raise ValueError(f'Invalid shared/cross-initiative dependency: {path} -> {child}')
        if kind in ('!docs', '!adrs'):
            continue
        if child.is_dir():
            raise ValueError(f'Use explicit ordered file includes: {path}: {child}')
        dependencies(child, active, seen)
    active.remove(path)
    return seen


def parent_workspace(path):
    parents = [child for kind, child in directives(path) if kind == 'workspace extends']
    if len(parents) > 1:
        raise ValueError(f'Multiple workspace parents: {path}')
    return parents[0] if parents else None


def workspace_profile(path):
    path = Path(path).resolve()
    if path in (SHARED, REFERENCE):
        return {'epic': None, 'variant': None, 'prefix': None, 'placeholder': False}
    parts = path.relative_to(ARCHITECTURE / 'initiatives').parts
    if len(parts) == 2 and parts[1] == 'workspace.dsl':
        epic, variant, expected = parts[0], None, SHARED
    elif len(parts) == 4 and parts[1] == 'variants' and parts[3] == 'workspace.dsl':
        epic, variant = parts[0], parts[2]
        expected = ARCHITECTURE / 'initiatives' / epic / 'workspace.dsl'
    else:
        raise ValueError(f'Unsupported initiative entrypoint: {path}')
    if not re.fullmatch(r'[a-z0-9]+(?:-[a-z0-9]+)*', epic) or (variant and not re.fullmatch(r'[a-z0-9]+(?:-[a-z0-9]+)*', variant)):
        raise ValueError('Epic and variant names must use lowercase letters, digits and hyphens')
    if parent_workspace(path) != expected:
        raise ValueError(f'{path} must extend {expected}')
    return {'epic': epic, 'variant': variant,
            'prefix': epic + '-' + (variant + '-' if variant else ''), 'placeholder': epic == 'ignition'}


def derive_provenance(workspace, path, parent=None):
    parent = parent or {'origins': {}, 'views': set()}
    elements = raw_elements(workspace)
    ids = [e.get('properties', {}).get('architecture.id') for e in elements]
    if None in ids or len(set(ids)) != len(ids):
        raise ValueError('Missing or duplicate architecture.id in parsed provenance')
    if not set(parent['origins']) <= set(ids):
        raise ValueError('A workspace removed or renamed inherited architecture identities')
    for element in elements:
        properties = element.get('properties', {})
        if properties.get('structurizr.dsl.identifier') != properties['architecture.id']:
            raise ValueError(f'DSL and architecture identifiers differ: {properties["architecture.id"]}')
    views = {v['key'] for k, entries in workspace.get('views', {}).items() if k.endswith('Views') for v in entries}
    # Structurizr may synthesize default diagrams when exporting the diagram-free
    # shared model by itself. Those are not authored views inherited by initiatives.
    if Path(path).resolve() == SHARED:
        views = set()
    return {'origins': {identifier: parent['origins'].get(identifier, str(path)) for identifier in ids}, 'views': views}


def identity_conflicts(provenances):
    definitions = {}
    for path, provenance in provenances.items():
        for identifier, origin in provenance['origins'].items():
            definitions.setdefault(identifier, {}).setdefault(origin, set()).add(path)
    errors = {}
    for identifier, origins in definitions.items():
        if len(origins) > 1:
            message = f'Independent definitions of {identifier}: ' + ', '.join(sorted(origins))
            for paths in origins.values():
                for path in paths:
                    errors.setdefault(path, []).append(message)
    return errors
