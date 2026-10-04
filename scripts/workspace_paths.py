"""Shared paths for authored workspaces and disposable build outputs."""
from pathlib import Path
from source_inputs import input_files

ROOT = Path(__file__).resolve().parents[1]
REFERENCE = ROOT / 'workspace.dsl'
BUILD = ROOT / 'build'
TOOLCHAIN = dict(line.split('=', 1) for line in (ROOT / '.env').read_text().splitlines()
                 if line and not line.startswith('#'))
VERSION = TOOLCHAIN['STRUCTURIZR_VERSION']


def workspace_path(value=REFERENCE):
    path = Path(value)
    path = (ROOT / path).resolve() if not path.is_absolute() else path.resolve()
    path.relative_to(ROOT)
    if not path.is_file() or path.suffix != '.dsl':
        raise ValueError(f'Workspace does not exist or is not DSL: {path}')
    return path


def output_directory(path):
    relative = Path(path).resolve().relative_to(ROOT)
    return BUILD / '.reports' / relative


def discover_workspaces():
    return [REFERENCE, *sorted(path for path in input_files(ROOT / 'workspaces') if path.name == 'workspace.dsl')]
