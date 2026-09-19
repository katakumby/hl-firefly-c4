"""Resolve isolated artifacts before invoking the pinned Compose services."""
import argparse
import hashlib
import json
import os
import subprocess
import sys
from artifact_store import atomic_json, file_lock, read_status, resolve_run
from preview import preview_runtime
from validate_workspaces import source_snapshot, require_docker
from workspace_paths import ROOT, ARCHITECTURE, BUILD, VERSION, REFERENCE, output_directory, workspace_path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=('Preview', 'Export', 'Validate', 'Down', 'Config'))
    parser.add_argument('--workspace', default=REFERENCE)
    parser.add_argument('--port', type=int, default=8080)
    parser.add_argument('--view', help='Export one existing view key instead of all views')
    args = parser.parse_args()
    if not 1 <= args.port <= 65535:
        parser.error('port must be between 1 and 65535')
    if args.view and args.action != 'Export':
        parser.error('--view is only available for Export')
    try:
        path = workspace_path(args.workspace)
        require_docker()
        before = source_snapshot()
        project = 'dlt-architecture-' + hashlib.sha256(str(ROOT).encode()).hexdigest()[:8] + '-' + str(args.port)
        environment = os.environ.copy()
        environment.update(STRUCTURIZR_VERSION=VERSION, STRUCTURIZR_PORT=str(args.port),
            ARCHITECTURE_ROOT=str(ROOT), STRUCTURIZR_RUN='none', STRUCTURIZR_DSL=path.relative_to(ROOT).as_posix(),
            STRUCTURIZR_JSON='unused', STRUCTURIZR_EXPORT_DIR='build/architecture/unused',
            STRUCTURIZR_PREVIEW_DIR=(BUILD / 'previews' / project).as_posix())
        command = ['docker', 'compose', '--project-name', project, '-f', str(ARCHITECTURE / 'compose.yaml')]
        with file_lock(BUILD / 'previews' / f'.port-{args.port}.lock'), file_lock(output_directory(path) / '.publication.lock'):
            if args.action in ('Preview', 'Export', 'Config'):
                run, manifest = resolve_run(output_directory(path))
                status = read_status(output_directory(path))
                fingerprint = hashlib.sha256(json.dumps(before, sort_keys=True).encode()).hexdigest()
                if not status['latest_attempt']['passed'] or fingerprint != manifest['source_sha256']:
                    raise RuntimeError('Latest successful run is stale; validate this workspace before using Compose')
                environment['STRUCTURIZR_RUN'] = run.name
                environment['STRUCTURIZR_JSON'] = (run / 'workspace.json').relative_to(ROOT).as_posix()
                environment['STRUCTURIZR_PREVIEW_DIR'] = (BUILD / 'previews' / project / run.name).as_posix()
                export_directory = output_directory(path) / 'exports' / run.name
                environment['STRUCTURIZR_EXPORT_DIR'] = (export_directory / 'svg').relative_to(ROOT).as_posix()
                if args.action == 'Preview':
                    runtime = preview_runtime(path, run, project)
                    environment['STRUCTURIZR_PREVIEW_DIR'] = runtime.as_posix()
                if args.view:
                    raw = json.loads((run / 'workspace.json').read_text(encoding='utf-8-sig'))
                    found = 0
                    for kind, views in raw['views'].items():
                        if kind.endswith('Views'):
                            selected = [v for v in views if v['key'] == args.view]
                            found += len(selected)
                            raw['views'][kind] = selected
                    if found != 1:
                        raise ValueError('Export view key must identify exactly one existing view')
                    # Use a digest, not a user-provided view key, as a filesystem name.
                    subset = export_directory / ('selection-' + hashlib.sha256(args.view.encode()).hexdigest()[:12] + '.json')
                    atomic_json(subset, raw)
                    environment['STRUCTURIZR_JSON'] = subset.relative_to(ROOT).as_posix()
                print(f'Using run {run.name}, completed {manifest["completed_at"]}; source {manifest["source_sha256"]}', flush=True)
            arguments = {'Preview': ['up', '-d', '--force-recreate', 'structurizr'],
                         'Export': ['run', '--rm', '--no-deps', 'export'],
                         'Validate': ['run', '--rm', '--no-deps', 'cli'],
                         'Down': ['down'], 'Config': ['--profile', 'tools', 'config', '--format', 'json']}[args.action]
            result = subprocess.run(command + arguments, env=environment, cwd=ROOT)
        if before != source_snapshot():
            raise RuntimeError('Source files changed during Compose operation')
        return result.returncode
    except (ValueError, RuntimeError, OSError, subprocess.SubprocessError) as exc:
        print(str(exc), file=sys.stderr)
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
