"""Validate authored DSL entrypoints; write derived artifacts under build/architecture/."""
import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import subprocess
import sys
import uuid
from architecture_validation import audit, check_local_links
from check_inspect import assess
from static_source_inventory import main as source_inventory
from workspace_catalog import write_catalog
from workspace_paths import ROOT, REFERENCE, BUILD, IMAGE, SOURCES, discover_workspaces, output_directory, workspace_path


def source_snapshot():
    result=subprocess.run(['git','ls-files','-co','--exclude-standard','-z'],cwd=ROOT,
                          check=True,stdout=subprocess.PIPE)
    return {name:hashlib.sha256((ROOT/name).read_bytes()).hexdigest()
            for name in set(result.stdout.decode('utf-8').split('\0')) if name and (ROOT/name).is_file()}


def dependencies(path, active=None, seen=None):
    """Check local include/extension/document paths, including cycles, before Docker."""
    active=set() if active is None else active; seen=set() if seen is None else seen
    path=Path(path).resolve(); path.relative_to(ROOT)
    if path in active: raise ValueError(f'Cyclic DSL dependency: {path}')
    if path in seen: return seen
    active.add(path); seen.add(path)
    text=path.read_text(encoding='utf-8')
    pattern=r'^\s*(?:workspace\s+extends|(!include|!docs|!adrs))\s+("[^"]+"|\S+)'
    for match in re.finditer(pattern,text,re.M):
        token=match[2].strip('"')
        if '://' in token: raise ValueError(f'Use same-checkout dependencies, not URLs: {path}: {token}')
        child=(path.parent/token).resolve(); child.relative_to(ROOT)
        if not child.exists(): raise ValueError(f'Missing DSL/document dependency: {path}: {token}')
        if match[1] in ('!docs','!adrs'): continue
        if child.is_dir(): raise ValueError(f'Use explicit ordered file includes: {path}: {token}')
        dependencies(child,active,seen)
    active.remove(path)
    return seen


def docker_command():
    BUILD.mkdir(parents=True, exist_ok=True)
    return ['docker','run','--rm','--mount',f'type=bind,source={ROOT},target=/usr/local/structurizr,readonly',
            '--mount',f'type=bind,source={BUILD},target=/usr/local/structurizr/build/architecture',IMAGE]


def require_docker():
    result=subprocess.run(['docker','version','--format','{{.Server.Version}}'],capture_output=True,text=True)
    if result.returncode: raise RuntimeError('Docker is unavailable. Start Docker Desktop with Linux containers and retry.\n'+result.stderr)


def validate_one(path):
    path=workspace_path(path); directory=output_directory(path); report=directory/'reports'
    report.mkdir(parents=True,exist_ok=True)
    relative=path.relative_to(ROOT).as_posix(); reference=path==REFERENCE
    manifest={'workspace':relative,'image':IMAGE,'started_at':datetime.now(timezone.utc).isoformat(),
              'passed':False,'commands':[],'failure':None}
    def run(name, args, required=True):
        result=subprocess.run(args,cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,
                              text=True,encoding='utf-8',errors='replace',timeout=180)
        (report/(name+'.txt')).write_text(result.stdout,encoding='utf-8')
        manifest['commands'].append({'name':name,'exit_code':result.returncode,'command':args})
        if required and result.returncode: raise RuntimeError(f'{name} failed; see {report/(name+".txt")}\n{result.stdout[-2000:]}')
        return result
    try:
        manifest['dependencies']=[p.relative_to(ROOT).as_posix() for p in sorted(dependencies(path))]
        digest=hashlib.sha256()
        for relative_path in manifest['dependencies']:
            digest.update(relative_path.encode()); digest.update((ROOT/relative_path).read_bytes())
        manifest['dsl_sha256']=digest.hexdigest()
        command=docker_command()
        run('validate',command+['validate','-workspace',relative])
        run_directory=directory/'parsed'/uuid.uuid4().hex
        run_directory.mkdir(parents=True)
        run('parse',command+['export','-workspace',relative,'-format','json','-output',run_directory.relative_to(ROOT).as_posix()])
        files=list(run_directory.glob('*.json'))
        if len(files)!=1: raise RuntimeError(f'Expected one fresh parsed workspace, found {files}')
        workspace=json.loads(files[0].read_text(encoding='utf-8-sig'))
        manifest['parsed_workspace']=files[0].relative_to(ROOT).as_posix()
        catalog=write_catalog(workspace,directory)
        result=audit(workspace,catalog,json.loads(SOURCES.read_text(encoding='utf-8')),reference)
        (report/'architecture-audit.json').write_text(json.dumps(result,indent=2)+'\n',encoding='utf-8')
        manifest['counts']={key:result[key] for key in ('elements','relationships','views','assertions')}
        if not result['passed']: raise RuntimeError('Architecture audit failed: '+'; '.join(result['errors'][:15]))
        full=run('inspect',command+['inspect','-workspace',relative],False)
        allowed={'workspace.scope'}
        if not reference: allowed.update(('model.element.noview','model.element.disconnected'))
        inspection=assess(full.stdout,full.returncode,allowed)
        manifest['inspection']=inspection
        if not inspection['passed']: raise RuntimeError('Unexpected inspection findings; see '+str(report/'inspect.txt'))
        run('inspect-errors-warnings',command+['inspect','-workspace',relative,'-severity','error,warning'])
        if reference and source_inventory(directory/'model-catalog.json',report):
            raise RuntimeError('Reference evidence coverage failed')
        errors=check_local_links()
        (report/'link-check.json').write_text(json.dumps({'passed':not errors,'errors':errors},indent=2)+'\n',encoding='utf-8')
        if errors: raise RuntimeError('Broken documentation links: '+'; '.join(errors[:10]))
        # Publish preview input only after every check passes; a failed run cannot serve stale success.
        (directory/'workspace.json').write_text(json.dumps(workspace,indent=2)+'\n',encoding='utf-8')
        manifest['passed']=True
    except (ValueError,KeyError,RuntimeError,OSError,subprocess.SubprocessError) as exc:
        manifest['failure']=str(exc)
    finally:
        manifest['completed_at']=datetime.now(timezone.utc).isoformat()
        (report/'run.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
        lines=['# Architecture validation','',f'**Result: {"PASS" if manifest["passed"] else "FAIL"}**',
               '',f'Workspace: `{relative}`',f'Image: `{IMAGE}`','',
               'Authored DSL is read-only. Reports and catalogs are derived from a fresh parse.',
               '',f'Counts: {manifest.get("counts",{})}', '',
               '[Architecture audit](architecture-audit.json) | [Run manifest](run.json) | [Inspection](inspect.txt)',
               '', 'Reference workspaces enforce complete view coverage; initiative workspaces use focused views.',
               'Retained informational findings are listed individually in the inspection log.',
               'Deployment provisioning and deployment validation are outside this workflow.']
        if manifest['failure']: lines+=['','## Failure','',manifest['failure']]
        (report/'validation-summary.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
    print(f'{relative}: {"PASS" if manifest["passed"] else "FAIL"}',flush=True)
    if manifest['failure']: print(manifest['failure'],file=sys.stderr)
    return manifest


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--workspace',help='Validate only this repository-relative or absolute DSL entrypoint')
    args=parser.parse_args()
    before=source_snapshot()
    try:
        require_docker()
        workspaces=[workspace_path(args.workspace)] if args.workspace else discover_workspaces()
        results=[validate_one(path) for path in workspaces]
        unchanged=before==source_snapshot()
        (BUILD/'source-preservation.json').write_text(json.dumps({'passed':unchanged},indent=2)+'\n',encoding='utf-8')
        if not unchanged: raise RuntimeError('Validation changed files outside ignored build/cache outputs')
        return 0 if all(result['passed'] for result in results) else 1
    except (ValueError,RuntimeError,OSError,subprocess.SubprocessError) as exc:
        print(str(exc),file=sys.stderr); return 1


if __name__=='__main__': raise SystemExit(main())
