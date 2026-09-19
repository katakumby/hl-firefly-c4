"""Shared paths for authored workspaces and disposable build outputs."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ARCHITECTURE = ROOT / 'architecture'
REFERENCE = ARCHITECTURE / 'workspace.dsl'
BUILD = ROOT / 'build/architecture'
TOOLCHAIN = dict(line.split('=', 1) for line in (ARCHITECTURE / '.env').read_text().splitlines()
                 if line and not line.startswith('#'))
VERSION = TOOLCHAIN['STRUCTURIZR_VERSION']


def workspace_path(value=REFERENCE):
    path = Path(value)
    path = (ROOT / path).resolve() if not path.is_absolute() else path.resolve()
    path.relative_to(ARCHITECTURE)
    if not path.is_file() or path.suffix != '.dsl':
        raise ValueError(f'Workspace does not exist or is not DSL: {path}')
    return path


def output_directory(path):
    if Path(path).resolve() == REFERENCE:
        return BUILD / 'workspaces/reference'
    return BUILD / 'workspaces' / Path(path).resolve().relative_to(ARCHITECTURE).with_suffix('')


def discover_workspaces():
    return [REFERENCE, *sorted((ARCHITECTURE / 'initiatives').rglob('workspace.dsl'))]
