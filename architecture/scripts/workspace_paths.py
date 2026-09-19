"""Shared paths for authored workspaces and disposable build outputs."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ARCHITECTURE = ROOT / 'architecture'
REFERENCE = ARCHITECTURE / 'workspace.dsl'
BUILD = ROOT / 'build/architecture'
IMAGE = 'structurizr/structurizr:2026.06.28-noble'
SOURCES = ARCHITECTURE / 'references/sources.json'


def workspace_path(value=REFERENCE):
    path = Path(value)
    path = (ROOT / path).resolve() if not path.is_absolute() else path.resolve()
    path.relative_to(ROOT)
    if not path.is_file() or path.suffix != '.dsl':
        raise ValueError(f'Workspace does not exist or is not DSL: {path}')
    return path


def output_directory(path):
    if Path(path).resolve() == REFERENCE:
        return BUILD / 'reference'
    return BUILD / Path(path).resolve().relative_to(ARCHITECTURE).with_suffix('')


def discover_workspaces():
    return [REFERENCE, *sorted((ARCHITECTURE / 'initiatives').rglob('workspace.dsl'))]
