"""Validate and preview a successful immutable run using a separate writable runtime."""
import argparse
import json
from pathlib import Path
import subprocess
import sys
import time
import urllib.request
from artifact_store import atomic_json, file_lock, resolve_run
from validate_workspaces import require_docker, source_snapshot, validate_one
from workspace_paths import IMAGE, ROOT, REFERENCE, BUILD, output_directory, workspace_path


def preview_runtime(path, run, name):
    directory = BUILD / 'previews' / name / run.name
    directory.mkdir(parents=True, exist_ok=True)
    raw = json.loads((run / 'workspace.json').read_text(encoding='utf-8-sig'))
    manifest = json.loads((run / 'reports/run.json').read_text())
    raw['description'] = raw.get('description', '') + f' [Preview of validated run {run.name}, completed {manifest["completed_at"]}]'
    atomic_json(directory / 'workspace.json', raw)
    atomic_json(directory / 'preview-status.json', {'workspace': path.relative_to(ROOT).as_posix(),
                'run': run.name, 'completed_at': manifest['completed_at'], 'source_sha256': manifest['source_sha256']})
    return directory


def stale_notice(path, name):
    result = subprocess.run(['docker', 'inspect', name], capture_output=True, text=True)
    if result.returncode == 0:
        labels = json.loads(result.stdout)[0]['Config'].get('Labels') or {}
        if labels.get('com.dlt-architecture.root') == str(ROOT):
            print(f'Existing preview is stale after failed validation: {name}; previous run '
                  f'{labels.get("com.dlt-architecture.run", "historical/unlabelled")}. It was not restarted.', file=sys.stderr)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--workspace', default=REFERENCE)
    parser.add_argument('--port', type=int, default=8080)
    args = parser.parse_args()
    if not 1 <= args.port <= 65535:
        parser.error('port must be between 1 and 65535')
    before = source_snapshot()
    try:
        path = workspace_path(args.workspace)
        require_docker()
        name = f'dlt-architecture-preview-{args.port}'
        with file_lock(BUILD / 'previews' / f'.port-{args.port}.lock'):
            result = validate_one(path)
            if not result['passed']:
                stale_notice(path, name)
                return 1
            with file_lock(output_directory(path) / '.publication.lock'):
                run, manifest = resolve_run(output_directory(path))
                directory = preview_runtime(path, run, name)
                existing = subprocess.run(['docker', 'container', 'inspect', name], capture_output=True, text=True)
                if existing.returncode == 0:
                    labels = json.loads(existing.stdout)[0]['Config'].get('Labels') or {}
                    if labels.get('com.dlt-architecture.root') != str(ROOT):
                        raise RuntimeError(f'Container {name} belongs to another owner; choose another port')
                    subprocess.run(['docker', 'rm', '-f', name], check=True, stdout=subprocess.PIPE)
                subprocess.run(['docker', 'run', '-d', '--name', name,
                    '--label', f'com.dlt-architecture.root={ROOT}',
                    '--label', f'com.dlt-architecture.workspace={path.relative_to(ROOT).as_posix()}',
                    '--label', f'com.dlt-architecture.run={run.name}',
                    '-p', f'127.0.0.1:{args.port}:8080',
                    '--mount', f'type=bind,source={directory},target=/usr/local/structurizr',
                    '-e', 'STRUCTURIZR_EDITABLE=false', '-e', 'STRUCTURIZR_AUTOSAVEINTERVAL=0',
                    '-e', 'STRUCTURIZR_WORKSPACE_MAXSIZE=10MB', IMAGE, 'local'], check=True, stdout=subprocess.PIPE)
            url = f'http://localhost:{args.port}'
            for attempt in range(40):
                try:
                    with urllib.request.urlopen(url, timeout=2) as response:
                        if response.status == 200:
                            break
                except OSError:
                    time.sleep(1)
            else:
                raise RuntimeError(f'Preview did not become ready. Inspect docker logs {name}')
            if source_snapshot() != before:
                raise RuntimeError('Source files changed during preview')
            print(f'Preview ready: {url}\nWorkspace: {path.relative_to(ROOT)}\nRun: {run.name}\n'
                  f'Completed: {manifest["completed_at"]}\nSource: {manifest["source_sha256"]}\nStop: docker stop {name}')
            return 0
    except (ValueError, RuntimeError, OSError, subprocess.SubprocessError) as exc:
        print(str(exc), file=sys.stderr)
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
