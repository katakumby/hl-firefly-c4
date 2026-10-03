"""Locate explicit view declarations; Structurizr still parses and validates the DSL.

This lexical index only establishes provenance. Unsupported/generated declarations
fail the comparison with native view keys instead of guessing a destination.
"""
from pathlib import Path
import re

# Argument position of the explicit key, including the declaration keyword.
KEY_POSITION = {'systemlandscape': 1, 'systemcontext': 2, 'container': 2,
                'component': 2, 'dynamic': 2, 'deployment': 3,
                'filtered': 4, 'custom': 1, 'image': 2}
TOKEN = re.compile(r'"(?:\\.|[^"\\])*"|/\*.*?\*/|//[^\n]*|#[^\n]*|\n|[{}]|[^\s{}"]+', re.S)


def safe_name(name):
    # Portable filenames, including Windows checkouts and case-insensitive volumes.
    if (not name or name in ('.', '..') or name[-1:] in (' ', '.')
            or any(ord(c) < 32 or c in '/\\:<>"|?*' for c in name)
            or name.split('.')[0].upper() in {'CON', 'PRN', 'AUX', 'NUL',
                *(f'COM{i}' for i in range(1, 10)), *(f'LPT{i}' for i in range(1, 10))}):
        raise ValueError(f'Diagram keys used for export must be safe file names: {name!r}')
    return name


def namespace(workspace, root):
    relative = workspace.relative_to(root)
    return relative.parent if workspace.name == 'workspace.dsl' else relative.with_suffix('')


def index_views(workspace, root, native_keys):
    root, workspace = Path(root).resolve(), Path(workspace).resolve()
    found, active = {}, set()

    def local(value, source):
        if '://' in value or '${' in value:
            raise ValueError(f'View provenance requires literal local paths: {source}: {value}')
        path = (source.parent / value).resolve()
        path.relative_to(root)
        return path

    def visit(source, owner, stack):
        if source in active:
            raise ValueError(f'Cyclic DSL include/extension: {source}')
        active.add(source)
        statement = []

        def process(tokens):
            if not tokens:
                return ''
            values = [token[1:-1].replace('\\"', '"') if token.startswith('"') else token for token in tokens]
            keyword = values[0].lower()
            if keyword == '!include' and len(values) == 2:
                included = local(values[1], source)
                targets = sorted(included.iterdir()) if included.is_dir() else [included]
                for target in targets:
                    if target.is_file():
                        visit(target, owner, stack)
            elif keyword == 'workspace' and len(values) > 2 and values[1].lower() == 'extends':
                parent = local(values[2], source)
                visit(parent, parent.parent, [])
            elif stack and stack[-1] == 'views' and keyword in KEY_POSITION:
                position = KEY_POSITION[keyword]
                if len(values) <= position:
                    raise ValueError(f'Explicit stable view key required in {source}')
                key = safe_name(values[position])
                if key in found:
                    raise ValueError(f'Ambiguous view source for {key}: {found[key][0]} and {source}')
                # Includes outside an entrypoint's directory retain their root-relative tree.
                folder = source.parent.relative_to(owner) if source.is_relative_to(owner) else source.parent.relative_to(root)
                found[key] = (source, namespace(workspace, root) / folder / key)
            return keyword

        for match in TOKEN.finditer(source.read_text(encoding='utf-8-sig')):
            token = match.group()
            if token.startswith(('//', '/*', '#')):
                continue
            if token in ('\n', '{', '}'):
                kind = process(statement)
                statement = []
                if token == '{':
                    stack.append(kind)
                elif token == '}':
                    if not stack:
                        raise ValueError(f'Cannot map DSL block in {source}')
                    stack.pop()
            else:
                statement.append(token)
        process(statement)
        active.remove(source)

    visit(workspace, workspace.parent, [])
    if set(found) != set(native_keys):
        raise ValueError('View source index differs from native Structurizr keys; use explicit literal keys and local '
                         f'declarations. Missing: {sorted(set(native_keys) - set(found))}; '
                         f'extra: {sorted(set(found) - set(native_keys))}')
    return found
