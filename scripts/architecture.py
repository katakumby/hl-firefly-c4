"""Offline source generation, independent previews, and on-demand native exports."""
import argparse
from contextlib import contextmanager
from copy import deepcopy
from datetime import datetime, timezone
import fcntl
import hashlib
import json
import math
import os
from pathlib import Path
import re
import shutil
import subprocess
import sys
import tempfile

from workspace_paths import ROOT, BUILD, REFERENCE, VERSION, TOOLCHAIN, discover_workspaces, output_directory, workspace_path
from diagram_renderers import render, renderer_versions, require_capability, check_toolchain
from view_sources import index_views, safe_name
from artifact_store import atomic_json, staging, publish, recover, confined
from source_inputs import input_files, source_files
import native_exports

JAVA = ['java', '-Dio.netty.noUnsafe=true', '--enable-native-access=ALL-UNNAMED', '-jar', '/usr/local/structurizr.war']

def timestamp():
    return datetime.now(timezone.utc).isoformat()


def source_fingerprint():
    """No host Git executable or .git mount is needed."""
    digest = hashlib.sha256()
    for path in sorted(source_files(ROOT, discover_workspaces())):
        digest.update(path.relative_to(ROOT).as_posix().encode() + b'\0')
        digest.update(hashlib.sha256(path.read_bytes()).digest())
    return digest.hexdigest()


@contextmanager
def command_lock():
    """One writer per checkout; OS releases the lock if a container is interrupted."""
    BUILD.mkdir(parents=True, exist_ok=True)
    with (BUILD / '.tools.lock').open('a') as stream:
        try:
            fcntl.flock(stream, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError as exc:
            raise RuntimeError('Another architecture command is running in this checkout') from exc
        try:
            recover(BUILD)
            yield
        finally:
            fcntl.flock(stream, fcntl.LOCK_UN)


def run_java(arguments, log, timeout=240, check=True):
    log.append('structurizr ' + ' '.join(arguments) + '\n')
    try:
        result = subprocess.run(JAVA + arguments, cwd=ROOT, capture_output=True, text=True,
                                encoding='utf-8', errors='replace', timeout=timeout)
    except subprocess.TimeoutExpired as exc:
        # TimeoutExpired may contain bytes even when subprocess.run uses text=True.
        for output in (exc.stdout, exc.stderr):
            if output:
                log[-1] += output.decode('utf-8', errors='replace') if isinstance(output, bytes) else output
        log[-1] += f'\nTimed out after {exc.timeout} seconds'
        raise
    log[-1] += result.stdout + result.stderr
    if check and result.returncode:
        raise RuntimeError(log[-1][-4000:])
    return result


def inspect_workspace(path, logs):
    """Separate native quality findings from inspector execution failures."""
    result = run_java(['inspect', '-workspace', str(path), '-severity', 'error,warning'],
                      logs, check=False)
    findings, unexpected = [], []
    for line in result.stdout.splitlines():
        if not line.strip():
            continue
        match = re.fullmatch(r'\s*(ERROR|WARNING)\s*\|\s*([\w.-]+)\s*\|\s*(.+)', line)
        if match:
            findings.append(dict(zip(('severity', 'rule', 'message'), match.groups())))
        else:
            unexpected.append(line)
    # The pinned inspector exits with the finding count (limited to a Unix exit
    # byte). A nonzero status with a crash/unknown diagnostic is still a failure.
    if result.returncode and (not findings or unexpected or result.stderr.strip()
                              or result.returncode != len(findings) % 256):
        raise RuntimeError('Inspector execution failed:\n' + logs[-1][-4000:])
    return findings


def inspection_message(finding):
    return f'{finding["severity"]} | {finding["rule"]} | {finding["message"]}'


def validate(paths=None, inspections_blocking=True):
    """Native parsing/validation always block; inspection policy is caller-specific."""
    check_toolchain(TOOLCHAIN)
    selected = [workspace_path(p) for p in (paths if paths is not None else discover_workspaces())]
    before = source_fingerprint()
    parsed, reports, logs = {}, {}, {}
    BUILD.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory(prefix='architecture-validate-') as temporary:
        for index, path in enumerate(selected):
            logs[path] = []
            report = {'workspace': path.relative_to(ROOT).as_posix(),
                      'structurizr_version': VERSION, 'source_sha256': before,
                      'inspection_severity': 'error,warning',
                      'inspection_policy': 'strict' if inspections_blocking else 'report-only',
                      'inspection_passed': None, 'inspection_findings': [],
                      'passed': False, 'errors': []}
            reports[path] = report
            try:
                directory = Path(temporary) / str(index)
                directory.mkdir()
                # The native parser resolves includes and workspace extensions.
                run_java(['export', '-workspace', str(path), '-format', 'json', '-output', str(directory)], logs[path])
                files = list(directory.glob('*.json'))
                if len(files) != 1:
                    raise ValueError('Parser did not produce exactly one JSON workspace')
                # Reuse the parsed workspace for both official commands.
                run_java(['validate', '-workspace', str(files[0])], logs[path])
                findings = inspect_workspace(files[0], logs[path])
                report['inspection_findings'] = findings
                report['inspection_passed'] = not findings
                parsed[path] = json.loads(files[0].read_text(encoding='utf-8-sig'))
                report['passed'] = not (inspections_blocking and findings)
                if not report['passed']:
                    report['errors'].append(f'Inspection reported {len(findings)} error/warning findings')
            except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
                report['errors'].append(str(exc))
            report['completed_at'] = timestamp()
        unchanged = before == source_fingerprint()
        for path, report in reports.items():
            if not unchanged:
                report.update(passed=False, errors=report['errors'] + ['Sources changed during validation'])
            directory = output_directory(path)
            directory.mkdir(parents=True, exist_ok=True)
            if report['passed']:
                atomic_json(directory / 'workspace.json', parsed[path])
            atomic_json(directory / 'validation.json', report)
            (directory / 'validation.log').write_text('\n'.join(logs[path] + report['errors']), encoding='utf-8')
            summary = 'PASS' if report['passed'] else 'FAIL'
            if report['inspection_findings']:
                summary += f' ({len(report["inspection_findings"])} inspection findings; {report["inspection_policy"]})'
            print(f'{report["workspace"]}: {summary}', flush=True)
            for finding in report['inspection_findings']:
                print('  ' + inspection_message(finding), flush=True)
            for error in report['errors']:
                print(error, file=sys.stderr)
        return reports


def fresh_workspace(path):
    report = validate([path], inspections_blocking=False)[path]
    if not report['passed']:
        raise ValueError('Validation failed. Previous exports were not updated.')
    raw = json.loads((output_directory(path) / 'workspace.json').read_text(encoding='utf-8'))
    return raw, report


def selected_keys(keys):
    if keys is None:
        return None
    return list(dict.fromkeys([keys] if isinstance(keys, str) else keys))


def select_view(raw, key):
    raw = deepcopy(raw)
    keys = selected_keys(key)
    if keys is not None:
        available = view_keys(raw)
        invalid = [key for key in keys if available.count(key) != 1]
        if invalid:
            raise ValueError('View keys must each identify exactly one existing diagram; unknown or ambiguous: '
                             + ', '.join(repr(key) for key in invalid))
        for kind, views in raw['views'].items():
            if kind.endswith('Views'):
                raw['views'][kind] = [view for view in views if view['key'] in keys]
    # The exporter uses view keys as file names. Reject paths rather than silently renaming them.
    for kind, views in raw['views'].items():
        if kind.endswith('Views'):
            for view in views:
                safe_name(view['key'])
    return raw


def view_keys(raw):
    return [diagram['key'] for kind, views in raw['views'].items()
            if kind.endswith('Views') for diagram in views]


def check_collisions(entries):
    seen = {}
    for entry in entries:
        output = entry['output']
        folded = output.casefold()
        if folded in seen:
            raise ValueError(f'Diagram output collision: {seen[folded]} and {entry["source"]}: {output}')
        confined(BUILD, output)
        seen[folded] = entry['source']


def check_c4_views(raw):
    filtered = [view['key'] for view in raw['views'].get('filteredViews', [])]
    if filtered:
        raise ValueError('C4-PlantUML exports and derived images do not support filtered views: '
                         + ', '.join(filtered) + '. Export supported views with --view, or use '
                         'tools-browser export-native for filtered views and saved layouts.')



INVENTORIES = ('source', 'preview-plantuml', 'preview-mermaid', 'preview-native')


def inventory(stage=None):
    if stage is None:
        return [item for name in INVENTORIES for item in inventory(name)]
    file = BUILD / (stage + '.json')
    if not file.exists():
        return []
    value = json.loads(file.read_text())
    if value.get('schema_version') != 2 or not isinstance(value.get('artifacts'), list):
        raise ValueError(f'Incompatible inventory: {file}; run clean and build-source')
    return value['artifacts']


def digest(file):
    return hashlib.sha256(file.read_bytes()).hexdigest()


def clean_build():
    """Caller owns the lock; do not unlink its inode or the mounted build root."""
    if BUILD.resolve() != ROOT.resolve() / 'build':
        raise ValueError('Refusing to clean outside build')
    if (BUILD / 'local.env').exists():
        raise ValueError('Move build/local.env to docker/local.env before clean; sources are read-only here.')
    for path in BUILD.iterdir():
        if path.name == '.tools.lock':
            continue
        if path.is_dir() and not path.is_symlink():
            shutil.rmtree(path)
        else:
            path.unlink()
    print('Cleaned generated build contents; saved workspace JSON and writer lock preserved', flush=True)


def artifact(output, source, workspace, format, fingerprint, key=None, **details):
    confined(BUILD, output)
    return {'output': Path(output).as_posix(), 'source': source.relative_to(ROOT).as_posix(),
            'workspace': workspace.relative_to(ROOT).as_posix() if workspace else None,
            'view': key, 'format': format, 'source_sha256': fingerprint, **details}


def phase_status(stage, selection=None):
    return {'handoff_version': 2, 'stage': stage, 'passed': False, 'errors': [],
            'outputs': [], 'artifacts': [], 'reports': {}, 'selection': selection,
            'inspection_findings': [], 'started_at': timestamp(), 'toolchain': TOOLCHAIN,
            'source_revision': os.environ.get('ARCHITECTURE_SOURCE_REVISION') or None,
            'ci_run': os.environ.get('ARCHITECTURE_CI_RUN') or None}


def write_phase(status, logs, in_progress=False):
    value = status | {'in_progress': in_progress}
    if not in_progress:
        value['completed_at'] = timestamp()
    file = BUILD / '.reports' / (status['stage'] + '.json')
    atomic_json(file, value)
    file.with_suffix('.log').write_text('\n'.join(logs + status['errors']), encoding='utf-8')


def selection(paths=None, views=None):
    keys = selected_keys(views)
    all_workspaces = paths is None and keys is None
    selected = discover_workspaces() if all_workspaces else [workspace_path(p) for p in (paths or [REFERENCE])]
    if keys is not None and len(selected) != 1:
        raise ValueError('Select one workspace when selecting view keys')
    return {'all_workspaces': all_workspaces,
            'workspaces': [p.relative_to(ROOT).as_posix() for p in selected], 'views': keys}


def in_scope(item, selected):
    return (selected['all_workspaces'] or item['workspace'] in selected['workspaces']) and (
        selected['views'] is None or item['view'] in selected['views'])


def commit_artifacts(name, entries, retained, replacements, removed, stage):
    combined = sorted(entries + retained, key=lambda item: item['output'])
    check_collisions(combined)
    metadata = stage / (name + '.json')
    atomic_json(metadata, {'schema_version': 2, 'artifacts': combined})
    destinations = {destination for _, destination in replacements}
    replacements.extend((None, path) for path in sorted(removed) if path not in destinations)
    replacements.append((metadata, BUILD / (name + '.json')))
    publish(replacements, stage / 'previous')


def discover_uml():
    candidates = set(input_files(ROOT / 'uml'))
    candidates.update(path for path in input_files(ROOT / 'workspaces')
                      if 'uml' in path.relative_to(ROOT / 'workspaces').parts[:-1])
    candidates = sorted(p for p in candidates if p.is_file() and p.suffix in ('.puml', '.mmd'))
    included = set()
    for source in candidates:
        source.resolve().relative_to(ROOT.resolve())
        if source.suffix == '.puml':
            included.update(diagram_dependencies(source))
    selected, stems = [], {}
    for source in candidates:
        if source in included and source.suffix == '.puml' and '@startuml' not in source.read_text():
            continue  # A referenced text fragment is not a standalone diagram.
        relative = source.relative_to(ROOT)
        stem = relative.with_suffix('').as_posix().casefold()
        if stem in stems:
            raise ValueError(f'Diagram output collision: {stems[stem]} and {relative}')
        stems[stem] = relative
        selected.append(source)
    return selected


def diagram_dependencies(source):
    """Portable literal local includes; keep original bytes and relative paths."""
    from source_inputs import REFERENCE as INCLUDE, BLOCK_COMMENT, include_files
    pending, visited = [source], set()
    while pending:
        path = pending.pop()
        if path in visited:
            continue
        visited.add(path)
        for match in INCLUDE.finditer(BLOCK_COMMENT.sub('', path.read_text(encoding='utf-8-sig'))):
            value = match.group(1) or match.group(2)
            if '://' in value or value.startswith('<'):
                continue  # Installed libraries remain supplied by the pinned image.
            value = value.split('!', 1)[0]
            if Path(value).is_absolute():
                raise ValueError(f'Use a relative local diagram include for portable sources: {value}')
            dependency = (path.parent / value).resolve()
            if not dependency.exists():
                raise ValueError(f'Missing local diagram include: {value} in {path.relative_to(ROOT)}')
            pending.extend(include_files(dependency, ROOT))
    return sorted(visited - {source})


def uml_owner(source):
    owners = [workspace for workspace in discover_workspaces() if source.is_relative_to(workspace.parent)]
    return max(owners, key=lambda path: len(path.parts)) if owners else REFERENCE


def preview_plan(entries, renderer=None):
    return [item | {'output': (Path('preview') / Path(item['output']).relative_to('source')).with_suffix('.' + format).as_posix(),
                    'format': format, 'generated_source': item['output'], 'input_sha256': item.get('output_sha256')}
            for item in entries if item.get('kind') != 'include' and (renderer is None or item['renderer'] == renderer)
            for format in ('svg', 'png')]


def stage_c4(path, raw, entries, stage, logs):
    if not entries:
        return []
    stage.mkdir(parents=True, exist_ok=True)
    atomic_json(stage / 'workspace.json', raw)
    diagrams = stage / 'diagrams'
    run_java(['export', '-workspace', str(stage / 'workspace.json'), '-format', 'plantuml/c4plantuml',
              '-output', str(diagrams)], logs, timeout=600)
    replacements = []
    for item in entries:
        file = diagrams / ('structurizr-' + item['view'] + '.puml')
        if not file.is_file() or not file.stat().st_size:
            raise ValueError('Exporter did not produce every requested diagram')
        item['output_sha256'] = digest(file)
        replacements.append((file, BUILD / item['output']))
    print(f'Generated C4 text: {path.relative_to(ROOT)} ({len(entries)} views)', flush=True)
    return replacements


def build_source(paths=None, views=None):
    selected = selection(paths, views)
    status, logs = phase_status('source', selected), []
    write_phase(status, logs, True)
    try:
        versions = check_toolchain(TOOLCHAIN)
        with staging(BUILD) as stage:
            authored = discover_uml()  # Check cross-format collisions before publication.
            reports = validate(selected['workspaces'], inspections_blocking=False)
            if not reports or not all(report['passed'] for report in reports.values()):
                raise ValueError('Validation failed. Previous source artifacts were not updated.')
            fingerprint = next(iter(reports.values()))['source_sha256']
            status.update(source_sha256=fingerprint, renderers=versions)
            entries, jobs = [], {}
            for path, report in reports.items():
                status['inspection_findings'].extend(f | {'workspace': report['workspace']} for f in report['inspection_findings'])
                raw = json.loads((output_directory(path) / 'workspace.json').read_text())
                chosen = select_view(raw, selected['views'])
                check_c4_views(chosen)
                mapping = index_views(path, ROOT, view_keys(raw))
                plan = [artifact(Path('source') / (stem.as_posix() + '.puml'), source, path, 'plantuml', fingerprint,
                                 key, kind='c4', renderer='plantuml', dependencies=[], structurizr_version=VERSION)
                        for key, (source, stem) in mapping.items() if key in view_keys(chosen)]
                jobs[path] = (chosen, plan)
                entries.extend(plan)
            includes = {}
            for source in authored:
                owner = uml_owner(source)
                item = artifact(Path('source') / source.relative_to(ROOT), source, owner,
                                'mermaid' if source.suffix == '.mmd' else 'plantuml', fingerprint,
                                kind='uml', renderer='mermaid' if source.suffix == '.mmd' else 'plantuml')
                if not in_scope(item, selected):
                    continue
                dependencies = diagram_dependencies(source) if source.suffix == '.puml' else []
                item['dependencies'] = [(Path('source') / p.relative_to(ROOT)).as_posix() for p in dependencies]
                for dependency in dependencies:
                    output = Path('source') / dependency.relative_to(ROOT)
                    includes[output.as_posix()] = artifact(output, dependency, None, 'include', fingerprint,
                                                          kind='include', renderer=None, dependencies=[])
                entries.append(item)
            old = inventory('source')
            retained = [item for item in old if item.get('kind') != 'include' and not in_scope(item, selected)]
            # A dependency can itself be a separately renderable entrypoint.
            by_output = {item['output']: item for item in entries + retained}
            for output, item in includes.items():
                if output in by_output:
                    if by_output[output]['source'] != item['source'] or by_output[output]['kind'] == 'c4':
                        raise ValueError(f'Diagram output collision: {output}')
                    if by_output[output] in retained:
                        # A previously exported diagram can also supply an include
                        # section. Refresh its text as part of this dependency closure.
                        retained.remove(by_output[output])
                        entries.append(by_output[output] | {'source_sha256': fingerprint})
                else:
                    entries.append(item)
            needed = {name for item in entries + retained for name in item['dependencies']}
            retained.extend(item for item in old if item.get('kind') == 'include' and item['output'] in needed
                            and item['output'] not in includes)
            check_collisions(entries + retained)
            check_collisions(preview_plan(entries + retained))
            replacements = []
            for path, (raw, plan) in jobs.items():
                replacements.extend(stage_c4(path, raw, plan, stage / 'c4' / path.relative_to(ROOT), logs))
            for item in entries:
                if item['kind'] == 'c4':
                    continue
                file = stage / 'copied' / item['output']
                file.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(ROOT / item['source'], file)
                item['output_sha256'] = digest(file)
                replacements.append((file, BUILD / item['output']))
            for path in reports:
                for name in ('workspace.json', 'validation.json', 'validation.log'):
                    relative = Path('.reports/source') / path.relative_to(ROOT) / name
                    file = stage / relative
                    file.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copyfile(output_directory(path) / name, file)
                    status['reports'][relative.as_posix()] = digest(file)
                    replacements.append((file, BUILD / relative))
            if source_fingerprint() != fingerprint:
                raise ValueError('Sources changed during source generation')
            kept = {item['output'] for item in entries + retained}
            removed = {BUILD / item['output'] for item in old if item['output'] not in kept}
            removed.update(file for file in (BUILD / '.reports/source').rglob('*')
                           if file.is_file() and file.relative_to(BUILD).as_posix() not in status['reports'])
            commit_artifacts('source', entries, retained, replacements, removed, stage)
            status.update(passed=True, artifacts=sorted(entries, key=lambda item: item['output']),
                          outputs=sorted(item['output'] for item in entries))
            logs.extend(inspection_message(f) for f in status['inspection_findings'])
        print(f'Generated {len(entries)} source files; previews remain separate', flush=True)
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        status['errors'].append(str(exc))
        raise
    finally:
        write_phase(status, logs)


def verify_source_handoff():
    """Never parse DSL or regenerate text when accepting a source handoff."""
    try:
        file = BUILD / '.reports/source.json'
        if not file.is_file():
            raise ValueError('Missing source handoff. Run tools build-source for this checkout/commit first.')
        report = json.loads(file.read_text())
        if (report.get('handoff_version') != 2 or report.get('stage') != 'source'
                or not report.get('passed') or report.get('in_progress')
                or report.get('source_sha256') != source_fingerprint() or report.get('toolchain') != TOOLCHAIN):
            raise ValueError('Source handoff is incompatible, failed or stale; run tools build-source first.')
        check_toolchain(TOOLCHAIN, report['renderers'])
        revision = os.environ.get('ARCHITECTURE_SOURCE_REVISION') or None
        if revision and report.get('source_revision') != revision:
            raise ValueError('Source handoff belongs to a different commit; run the source job for this commit.')
        entries = {item['output']: item for item in inventory('source')}
        if report['outputs'] != sorted(item['output'] for item in report['artifacts']):
            raise ValueError('Incomplete source artifact manifest')
        check_collisions(report['artifacts'])
        check_collisions(preview_plan(report['artifacts']))
        recorded = {item['output'] for item in report['artifacts']}
        for item in report['artifacts']:
            path = confined(BUILD, item['output'])
            if (not item['output'].startswith('source/') or entries.get(item['output']) != item
                    or item['source_sha256'] != report['source_sha256'] or not path.is_file()
                    or digest(path) != item['output_sha256'] or not set(item['dependencies']) <= recorded):
                raise ValueError(f'Source artifact is missing or modified: {item["output"]}')
        if not report['reports'] or not report['selection']['workspaces']:
            raise ValueError('Source handoff is missing its workspace reports')
        for relative, expected in report['reports'].items():
            path = confined(BUILD, relative)
            if not relative.startswith('.reports/source/') or not path.is_file() or digest(path) != expected:
                raise ValueError(f'Source report is missing or modified: {relative}')
        return report, digest(file)
    except (KeyError, TypeError, AttributeError) as exc:
        raise ValueError('Malformed source handoff; run tools build-source first.') from exc


def verify_coverage(recorded, requested, artifacts):
    if requested['all_workspaces'] and not recorded['all_workspaces']:
        raise ValueError('Source handoff covers only a selection; run build-source for all workspaces first.')
    if not set(requested['workspaces']) <= set(recorded['workspaces']):
        raise ValueError('Requested workspace is missing from source handoff; rerun build-source.')
    if requested['views'] is None and recorded['views'] is not None:
        raise ValueError('Source handoff covers only selected views; rerun build-source for this workspace.')
    if requested['views'] is not None:
        known = {i['view'] for i in artifacts if i['workspace'] in requested['workspaces']}
        missing = [key for key in requested['views'] if key not in known]
        if missing:
            raise ValueError('Unknown or unavailable view keys in source handoff: ' + ', '.join(missing))


def build_preview(renderer, paths=None, views=None):
    if renderer not in ('plantuml', 'mermaid'):
        raise ValueError('Preview renderer must be plantuml or mermaid')
    if renderer == 'mermaid' and views is not None:
        raise ValueError('Mermaid previews do not have C4 view keys; use workspace selection')
    selected = selection(paths, views)
    name = 'preview-' + renderer
    status, logs = phase_status(name, selected), []
    write_phase(status, logs, True)
    try:
        require_capability(renderer)
        with staging(BUILD) as stage:
            source, handoff_digest = verify_source_handoff()
            verify_coverage(source['selection'], selected, source['artifacts'])
            status.update(source_sha256=source['source_sha256'], source_handoff_sha256=handoff_digest,
                          renderers=renderer_versions(), source_revision=source['source_revision'],
                          inspection_findings=source['inspection_findings'])
            entries = [item for item in preview_plan(source['artifacts'], renderer) if in_scope(item, selected)]
            for item in entries:
                item['renderers'] = status['renderers']
            old = inventory(name)
            retained = [item for item in old if not in_scope(item, selected)]
            check_collisions(entries + retained + inventory('preview-native'))
            replacements = []
            for item in entries:
                output = stage / item['output']
                render(confined(BUILD, item['generated_source']), output, logs)
                item['output_sha256'] = digest(output)
                replacements.append((output, BUILD / item['output']))
                print(f'Generated preview: {item["output"]}', flush=True)
            if verify_source_handoff()[1] != handoff_digest:
                raise ValueError('Source handoff changed during preview rendering')
            # Another renderer may now own a stem after a .puml/.mmd format change.
            other = 'mermaid' if renderer == 'plantuml' else 'plantuml'
            protected = {item['output'] for item in preview_plan(inventory('source'), other)}
            removed = {BUILD / item['output'] for item in old if in_scope(item, selected) and item['output'] not in protected}
            commit_artifacts(name, entries, retained, replacements, removed, stage)
            status.update(passed=True, artifacts=entries, outputs=sorted(item['output'] for item in entries))
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        status['errors'].append(str(exc))
        raise
    finally:
        write_phase(status, logs)


def export_native(paths, format='svg', views=None, frame_duration=3, all_workspaces=False):
    require_capability('native')
    check_toolchain(TOOLCHAIN)
    paths = [workspace_path(path) for path in paths]
    keys = selected_keys(views)
    selected = {'all_workspaces': all_workspaces, 'workspaces': [p.relative_to(ROOT).as_posix() for p in paths], 'views': keys}
    status, logs = phase_status('preview-native', selected) | {'format': format}, []
    diagnostics = {}
    write_phase(status, logs, True)
    try:
        with staging(BUILD) as stage:
            entries, jobs, layouts = [], {}, {}
            versions = native_exports.versions()
            for path in paths:
                raw, report = fresh_workspace(path)
                status.update(source_sha256=report['source_sha256'], renderers=versions)
                status['inspection_findings'].extend(f | {'workspace': report['workspace']}
                                                     for f in report['inspection_findings'])
                diagnostics[path] = {'workspace': report['workspace'], 'passed': False,
                                     'inspection_findings': report['inspection_findings'], 'outputs': [], 'errors': []}
                chosen = select_view(raw, keys)
                mapping = index_views(path, ROOT, view_keys(raw))
                workspace_stage = stage / 'native' / path.relative_to(ROOT)
                request = native_exports.prepare(path, raw, view_keys(chosen), keys is not None, format,
                    frame_duration, ROOT, BUILD, workspace_stage, logs, run_java)
                layouts[path] = request['layout_sha256']
                diagnostics[path].update({k: request[k] for k in ('layout_sha256', 'skipped_views', 'warnings')})
                plan = []
                for key in request['keys']:
                    source, stem = mapping[key]
                    for role in ('diagram', 'key') if format != 'gif' else ('diagram',):
                        output = Path('preview') / native_exports.output_path(stem, format, role)
                        plan.append(artifact(output, source, path, format, report['source_sha256'], key,
                            renderer='structurizr', kind='native', role=role, renderers=versions,
                            layout_sha256=request['layout_sha256'],
                            frame_duration=frame_duration if format == 'gif' else None))
                jobs[path] = (request, report, plan, workspace_stage)
                entries.extend(plan)
            old = inventory('preview-native')
            replaced = [item for item in old if in_scope(item, selected) and item['format'] == format]
            retained = [item for item in old if item not in replaced]
            check_collisions(entries + retained + preview_plan(inventory('source')))
            replacements, generated = [], []
            for path, (request, report, plan, workspace_stage) in jobs.items():
                results = native_exports.render_native(request, workspace_stage, logs, run_java)
                for entry in plan:
                    result = results.get((entry['view'], entry['role']))
                    if result is None:
                        if entry['role'] == 'key':
                            continue
                        raise ValueError(f'Native renderer omitted view {entry["view"]}')
                    file, details = result
                    entry.update(details, output_sha256=digest(file))
                    replacements.append((file, BUILD / entry['output']))
                    generated.append(entry)
            if any(source_fingerprint() != report['source_sha256'] for _, report, _, _ in jobs.values()):
                raise ValueError('Sources changed during native export')
            for path, fingerprint in layouts.items():
                if native_exports.layout_fingerprint(path, ROOT, BUILD) != fingerprint:
                    raise ValueError(f'Saved layout changed during export: {path.relative_to(ROOT)}')
            commit_artifacts('preview-native', generated, retained, replacements,
                             {BUILD / item['output'] for item in replaced}, stage)
            status.update(passed=True, artifacts=generated, outputs=sorted(item['output'] for item in generated))
            for path, diagnostic in diagnostics.items():
                diagnostic.update(passed=True, outputs=[i['output'] for i in generated if i['workspace'] == diagnostic['workspace']])
        print(f'Exported native {format.upper()}: {len(generated)} files under build/preview', flush=True)
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        status['errors'].append(str(exc))
        for diagnostic in diagnostics.values():
            diagnostic['errors'].append(f'Native batch not published: {exc}')
        raise
    finally:
        for path, diagnostic in diagnostics.items():
            atomic_json(output_directory(path) / 'export-native-status.json', diagnostic)
        write_phase(status, logs)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='command', required=True)
    commands.add_parser('clean', help='Clear generated output before generation or handoff restoration')
    for name in ('validate', 'build-source', 'build-preview', 'export-native'):
        command = commands.add_parser(name)
        choice = command.add_mutually_exclusive_group()
        choice.add_argument('--workspace', help='Workspace DSL path')
        if name != 'validate':
            choice.add_argument('--all-workspaces', action='store_true')
            command.add_argument('--view', action='append', help='C4 view key; repeat for several views')
        if name == 'build-preview':
            command.add_argument('--renderer', choices=('plantuml', 'mermaid'), required=True)
        if name == 'export-native':
            command.add_argument('--format', choices=('svg', 'png', 'gif'), default='svg')
            command.add_argument('--frame-duration', type=float)
    args = parser.parse_args()
    if getattr(args, 'all_workspaces', False) and args.view:
        parser.error('--all-workspaces cannot be combined with --view; select one workspace')
    if args.command == 'build-preview' and args.renderer == 'mermaid' and args.view:
        parser.error('Mermaid previews do not have C4 view keys; use workspace selection')
    if args.command == 'export-native':
        if args.format != 'gif' and args.frame_duration is not None:
            parser.error('--frame-duration applies only to --format gif')
        if args.frame_duration is None:
            args.frame_duration = 3
        if not math.isfinite(args.frame_duration) or not 0.01 <= args.frame_duration <= 655.35:
            parser.error('--frame-duration must be between 0.01 and 655.35 seconds')
    try:
        if not Path('/usr/local/structurizr.war').is_file():
            raise RuntimeError('Run this command through the Docker Compose tools service')
        with command_lock():
            if args.command == 'clean':
                clean_build()
            elif args.command == 'validate':
                return 0 if all(r['passed'] for r in validate([args.workspace] if args.workspace else None).values()) else 1
            elif args.command == 'build-source':
                build_source([args.workspace] if args.workspace else None, args.view)
            elif args.command == 'build-preview':
                build_preview(args.renderer, [args.workspace] if args.workspace else None, args.view)
            else:
                selected = discover_workspaces() if args.all_workspaces else [workspace_path(args.workspace or REFERENCE)]
                export_native(selected, args.format, args.view, round(args.frame_duration, 2), args.all_workspaces)
        return 0
    except (ValueError, OSError, RuntimeError, subprocess.SubprocessError) as exc:
        print(str(exc), file=sys.stderr)
        return 1


if __name__ == '__main__':
    raise SystemExit(main())
