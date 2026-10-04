"""Architecture inputs and literal local include dependencies used for freshness."""
import os
from pathlib import Path
import re


TREES = ('model', 'views', 'styles', 'uml', 'workspaces', 'documentation',
         'decisions', 'templates', 'scripts', 'tests', 'ci', 'docker')
EXCLUDED_DIRECTORIES = {'build', '.git', '.agents', '.codex', '.aws', '.cache',
                        '.pytest_cache', '.mypy_cache', '.ruff_cache', '.structurizr',
                        '__pycache__', 'node_modules'}
SOURCE_SUFFIXES = {'.dsl', '.puml', '.pumlinc', '.mmd'}
REFERENCE = re.compile(
    r'^\s*(?:!include(?:_once|_many)?\s+|workspace\s+extends\s+)'
    r'(?:"([^"\n]+)"|([^\s{]+))', re.I | re.M)
BLOCK_COMMENT = re.compile(r'/\*.*?\*/|/\'.*?\'/', re.S)


def input_files(directory):
    """Walk authoring trees consistently, including hidden folders but no caches."""
    for parent, directories, files in os.walk(directory):
        directories[:] = [name for name in directories if name not in EXCLUDED_DIRECTORIES]
        yield from (Path(parent) / name for name in files)


def source_files(root, discovered=()):
    """Keep unrelated checkout files out, but follow includes beyond standard trees.

    Hidden authoring folders are valid inputs. Only named tool caches and generated
    trees are excluded; this matches discovery of hidden workspace/UML folders.
    Installed/remote PlantUML libraries are covered by toolchain metadata instead.
    """
    root = Path(root).resolve()

    def allowed(path):
        return not any(part in EXCLUDED_DIRECTORIES for part in path.relative_to(root).parts)

    paths = {root / name for name in ('README.md', 'workspace.dsl', 'model.dsl', 'compose.yaml', '.env')}
    paths.update(path for path in root.iterdir() if path.suffix in SOURCE_SUFFIXES)
    paths.update(Path(path) for path in discovered)
    for tree in TREES:
        paths.update(path for path in input_files(root / tree)
                     if path.name not in ('workspace.json', 'workspace.json.bak') and path.suffix != '.pyc')
    paths = {path for path in paths if path.is_file() and allowed(path)}
    pending = [path for path in paths if path.suffix in SOURCE_SUFFIXES - {'.mmd'}]
    visited = set()
    while pending:
        source = pending.pop()
        if source in visited:
            continue
        visited.add(source)
        text = BLOCK_COMMENT.sub('', source.read_text(encoding='utf-8-sig'))
        for match in REFERENCE.finditer(text):
            value = match.group(1) or match.group(2)
            if '://' in value or value.startswith('<'):
                continue
            # PlantUML can select a named !startsub section using file.puml!name.
            if source.suffix != '.dsl':
                value = value.split('!', 1)[0]
            included = (source.parent / value).resolve()
            if not included.exists():
                continue
            if not included.is_relative_to(root):
                raise ValueError(f'Local architecture dependency must stay inside the repository: {source}: {value}')
            if not allowed(included):
                raise ValueError(f'Local architecture dependency uses an excluded generated/cache/agent directory: '
                                 f'{source}: {value}')
            targets = sorted(included.iterdir()) if included.is_dir() else [included]
            for target in targets:
                if target.is_file() and allowed(target):
                    paths.add(target)
                    # Included fragments need not use one of the usual extensions.
                    pending.append(target)
    return paths
