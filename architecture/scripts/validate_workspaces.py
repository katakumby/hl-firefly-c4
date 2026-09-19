"""Parse authored DSL once, audit fresh JSON, and publish isolated completed runs."""
import argparse
from concurrent.futures import ThreadPoolExecutor
from contextlib import ExitStack
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import tempfile
from architecture_validation import audit, check_local_links
from artifact_store import atomic_json, file_lock, new_run, publish, timestamp, active_preview_runs, retain_runs
from check_inspect import assess
from static_source_inventory import main as source_inventory
from workspace_catalog import write_catalog
from workspace_dependencies import dependencies, parent_workspace, workspace_profile, derive_provenance, identity_conflicts
from workspace_paths import ROOT, REFERENCE, SHARED, BUILD, IMAGE, SOURCES, discover_workspaces, output_directory, workspace_path


def source_snapshot():
    result = subprocess.run(['git', 'ls-files', '-co', '--exclude-standard', '-z'], cwd=ROOT,
                            check=True, stdout=subprocess.PIPE)
    return {name: hashlib.sha256((ROOT / name).read_bytes()).hexdigest()
            for name in set(result.stdout.decode('utf-8').split('\0')) if name and (ROOT / name).is_file()}


def docker_command():
    BUILD.mkdir(parents=True, exist_ok=True)
    return ['docker', 'run', '--rm', '--mount', f'type=bind,source={ROOT},target=/usr/local/structurizr,readonly',
            '--mount', f'type=bind,source={BUILD},target=/usr/local/structurizr/build/architecture', IMAGE]


def require_docker():
    result = subprocess.run(['docker', 'version', '--format', '{{.Server.Version}}'], capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError('Docker is unavailable. Start Docker Desktop with Linux containers and retry.\n' + result.stderr)


def run_command(directory, manifest, name, arguments, required=True):
    result = subprocess.run(arguments, cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                            text=True, encoding='utf-8', errors='replace', timeout=180)
    (directory / 'reports' / (name + '.txt')).write_text(result.stdout, encoding='utf-8')
    manifest['commands'].append({'name': name, 'exit_code': result.returncode, 'command': arguments})
    if required and result.returncode:
        raise RuntimeError(f'{name} failed: {result.stdout[-2000:]}')
    return result


def parse_workspace(path, directory, manifest):
    deps = dependencies(path)
    manifest['dependencies'] = [p.relative_to(ROOT).as_posix() for p in sorted(deps)]
    run_command(directory, manifest, 'parse', docker_command() + ['export', '-workspace',
                path.relative_to(ROOT).as_posix(), '-format', 'json', '-output', directory.relative_to(ROOT).as_posix()])
    files = list(directory.glob('*.json'))
    if len(files) != 1:
        raise ValueError(f'Expected one freshly parsed workspace; found {files}')
    destination = directory / 'workspace.json'
    if files[0] != destination:
        files[0].replace(destination)
    return json.loads(destination.read_text(encoding='utf-8-sig'))


def complete_report(directory, manifest):
    lines = ['# Architecture validation', '', f'**Result: {"PASS" if manifest["passed"] else "FAIL"}**', '',
             f'Workspace: `{manifest["workspace"]}`', f'Run: `{directory.name}`',
             f'Completed: {manifest["completed_at"]}', f'Image: `{IMAGE}`',
             f'Source fingerprint: `{manifest["source_sha256"]}`', '',
             f'Counts: {manifest.get("counts", {})}', '',
             '[Run manifest](run.json) | [Parsed workspace](../workspace.json)', '',
             'This report belongs only to this run. Resolve current results through the workspace status.json.']
    for name in ('architecture-audit.json', 'inspect.txt', 'source-audit.json'):
        if (directory / 'reports' / name).exists():
            lines.append(f'- [{name}]({name})')
    if manifest['failure']:
        lines += ['', '## Failure', '', manifest['failure']]
    (directory / 'reports/validation-summary.md').write_text('\n'.join(lines) + '\n', encoding='utf-8')


def validate_workspaces(paths=None, jobs=2):
    """Ancestors parse first; siblings can run in parallel. Selected runs own locks until publication."""
    if jobs < 1:
        raise ValueError('Jobs must be positive')
    selected = [workspace_path(p) for p in (paths if paths is not None else discover_workspaces())]
    before = source_snapshot()
    fingerprint = hashlib.sha256(json.dumps(before, sort_keys=True).encode()).hexdigest()
    require_docker()
    BUILD.mkdir(parents=True, exist_ok=True)
    sources = json.loads(SOURCES.read_text(encoding='utf-8'))
    # Repository checks run once. Missing ignored evidence caches are informational.
    from evidence_store import verify_inventory
    evidence = verify_inventory(sources, ROOT)
    link_errors = check_local_links()
    shared_errors = link_errors + evidence['errors']
    parents, setup_errors = {}, {}
    def ancestry(path, active=None):
        active = set() if active is None else active
        if path in active:
            raise ValueError(f'Cyclic workspace extension: {path}')
        if path in parents:
            return
        dependencies(path)
        workspace_profile(path)
        parent = parent_workspace(path)
        if path == SHARED and parent is not None:
            raise ValueError('The shared model must not extend an initiative')
        if path == REFERENCE and parent != SHARED:
            raise ValueError('The reference workspace must extend the shared model')
        if parent:
            ancestry(parent, active | {path})
        parents[path] = parent
    for path in selected:
        try:
            ancestry(path)
        except (ValueError, OSError) as exc:
            setup_errors[path] = str(exc)
    with ExitStack() as locks, tempfile.TemporaryDirectory(dir=BUILD, prefix='validation-session-') as temporary:
        for path in sorted(selected):
            locks.enter_context(file_lock(output_directory(path) / '.publication.lock'))
        runs = {path: new_run(output_directory(path)) for path in selected}
        manifests = {path: {'workspace': path.relative_to(ROOT).as_posix(), 'image': IMAGE,
                            'started_at': timestamp(), 'source_sha256': fingerprint,
                            'passed': False, 'commands': [], 'failure': setup_errors.get(path)} for path in selected}
        parsed, provenances, failures = {}, {}, dict(setup_errors)
        pending = set(parents) - failures.keys()
        def parse_one(path):
            directory = runs.get(path)
            manifest = manifests.get(path)
            if directory is None:
                directory = Path(temporary) / hashlib.sha256(str(path).encode()).hexdigest()[:16]
                (directory / 'reports').mkdir(parents=True)
                manifest = {'commands': []}
            try:
                parent = parents[path]
                if parent in failures:
                    raise ValueError(f'Ancestor failed: {parent}: {failures[parent]}')
                raw = parse_workspace(path, directory, manifest)
                provenance = derive_provenance(raw, path, provenances.get(parent))
                return path, raw, provenance, None
            except (ValueError, KeyError, RuntimeError, OSError, subprocess.SubprocessError) as exc:
                return path, None, None, str(exc)
        with ThreadPoolExecutor(max_workers=jobs) as pool:
            while pending:
                wave = sorted(p for p in pending if parents[p] not in pending)
                if not wave:
                    raise ValueError('Unresolvable workspace ancestry')
                for path, raw, provenance, error in pool.map(parse_one, wave):
                    if error:
                        failures[path] = error
                    else:
                        parsed[path], provenances[path] = raw, provenance
                    pending.remove(path)
            conflicts = identity_conflicts(provenances)
            shared_ids = set(provenances.get(SHARED, {}).get('origins', {}))
            def inspect_one(path):
                manifest, directory = manifests[path], runs[path]
                try:
                    errors = shared_errors + conflicts.get(path, [])
                    if path in failures:
                        errors.append(failures[path])
                    if errors:
                        raise ValueError('; '.join(errors[:15]))
                    parent = parents[path]
                    context = workspace_profile(path) | {'shared_ids': shared_ids,
                        'inherited_views': provenances.get(parent, {}).get('views', set())}
                    # DApp is permitted only when its original definition is the ignition entrypoint.
                    ignition = ROOT / 'architecture/initiatives/ignition/workspace.dsl'
                    context['placeholder'] &= provenances[path]['origins'].get('dapp_platform') == str(ignition)
                    catalog = write_catalog(parsed[path], directory)
                    result = audit(parsed[path], catalog, sources, path == REFERENCE, context)
                    atomic_json(directory / 'reports/architecture-audit.json', result)
                    atomic_json(directory / 'reports/provenance.json', provenances[path]['origins'])
                    atomic_json(directory / 'reports/evidence-integrity.json', evidence)
                    atomic_json(directory / 'reports/link-check.json', {'passed': not link_errors, 'errors': link_errors})
                    manifest['counts'] = {key: result[key] for key in ('elements', 'relationships', 'views', 'assertions')}
                    if not result['passed']:
                        raise ValueError('Architecture audit failed: ' + '; '.join(result['errors'][:15]))
                    inspected = run_command(directory, manifest, 'inspect', docker_command() + ['inspect', '-workspace',
                                            (directory / 'workspace.json').relative_to(ROOT).as_posix()], required=False)
                    allowed = {'workspace.scope'}
                    if path != REFERENCE:
                        allowed |= {'model.element.noview', 'model.element.disconnected'}
                    manifest['inspection'] = assess(inspected.stdout, inspected.returncode, allowed)
                    if not manifest['inspection']['passed']:
                        raise ValueError('Unexpected inspection findings; see this run\'s inspect.txt')
                    if path == REFERENCE and source_inventory(directory / 'model-catalog.json', directory / 'reports'):
                        raise ValueError('Reference evidence coverage failed')
                    manifest['passed'] = True
                except (ValueError, KeyError, RuntimeError, OSError, subprocess.SubprocessError, StopIteration, AssertionError) as exc:
                    manifest['failure'] = str(exc)
                return manifest
            list(pool.map(inspect_one, selected))
        unchanged = before == source_snapshot()
        atomic_json(BUILD / 'source-preservation.json', {'passed': unchanged})
        for path in selected:
            manifest, directory = manifests[path], runs[path]
            if not unchanged:
                manifest.update(passed=False, failure='Source files changed during validation; no success published')
            manifest['completed_at'] = timestamp()
            complete_report(directory, manifest)
            publish(output_directory(path), directory, manifest)
            print(f'{manifest["workspace"]}: {"PASS" if manifest["passed"] else "FAIL"} ({directory.name})', flush=True)
            if manifest['failure']:
                print(manifest['failure'], file=sys.stderr)
        try:
            protected = active_preview_runs()
            for path in selected:
                retain_runs(output_directory(path), protected)
        except (OSError, RuntimeError, subprocess.SubprocessError) as exc:
            print(f'Retention skipped: {exc}', file=sys.stderr)
        return [manifests[path] for path in selected]


def validate_one(path):
    return validate_workspaces([path])[0]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--workspace', help='Validate this repository-relative or absolute DSL entrypoint')
    parser.add_argument('--jobs', type=int, default=2)
    args = parser.parse_args()
    try:
        results = validate_workspaces([args.workspace] if args.workspace else None, args.jobs)
        return 0 if all(result['passed'] for result in results) else 1
    except (ValueError, RuntimeError, OSError, subprocess.SubprocessError) as exc:
        print(str(exc), file=sys.stderr)
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
