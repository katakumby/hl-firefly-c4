"""Run only static C4 validation; never call deployment or diagram exporters."""
from datetime import datetime, timezone
from pathlib import Path
import hashlib
import json
import os
import subprocess
import sys
import uuid
from check_inspect import assess
from audit_static_workspace import audit

ROOT=Path(__file__).resolve().parents[1]
REPORT=ROOT/'reports/static'
IMAGE='structurizr/structurizr:2026.06.28-noble'

def main():
    REPORT.mkdir(parents=True,exist_ok=True)
    started=datetime.now(timezone.utc).isoformat()
    commands=[]
    environment=os.environ.copy()
    def run(name,args,required=True):
        result=subprocess.run(args,cwd=ROOT,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,
                              text=True,encoding='utf-8',errors='replace',env=environment)
        (REPORT/(name+'.txt')).write_text(result.stdout,encoding='utf-8')
        commands.append({'name':name,'command':args,'exit_code':result.returncode,'report':name+'.txt'})
        print(f'{name}: exit {result.returncode}',flush=True)
        if required and result.returncode:
            raise RuntimeError(f'{name} failed:\n{result.stdout}')
        return result
    baseline=ROOT/'.cache/static-baseline'
    baseline.mkdir(parents=True,exist_ok=True)
    for name in ('workspace.dsl','model-catalog.json'):
        if not (baseline/name).exists():(baseline/name).write_bytes((ROOT/name).read_bytes())
    if not (baseline/'exports-hashes.json').exists():
        hashes={str(f.relative_to(ROOT)):hashlib.sha256(f.read_bytes()).hexdigest() for f in (ROOT/'exports').rglob('*') if f.is_file()}
        (baseline/'exports-hashes.json').write_text(json.dumps(hashes),encoding='utf-8')
    success=False;failure=None;inspection=None;result=None;parsed=None
    try:
        ready=run('docker-readiness',['docker','version','--format','{{.Server.Version}}'],False)
        if ready.returncode:
            run('docker-start',['docker','desktop','start'])
            run('docker-readiness',['docker','version','--format','{{.Server.Version}}'])
        run('generate',[sys.executable,'-B','scripts/build_workspace.py'])
        run('source-inventory',[sys.executable,'-B','scripts/static_source_inventory.py'])
        # Use the exact pinned image independently of changes to Compose.
        docker=['docker','run','--rm','--mount',f'type=bind,source={ROOT},target=/usr/local/structurizr',IMAGE]
        workspace='workspace-static.dsl'
        run('validate',docker+['validate','-workspace',workspace])
        full=run('inspect',docker+['inspect','-workspace',workspace],False)
        inspection=assess(full.stdout,full.returncode)
        if not inspection['passed']:raise RuntimeError('Unexpected inspection findings; see reports/static/inspect.txt')
        run('inspect-errors-warnings',docker+['inspect','-workspace',workspace,'-severity','error,warning'])
        scratch=ROOT/'.cache/static-validation'/uuid.uuid4().hex
        scratch.mkdir(parents=True)
        run('parse-json',docker+['export','-workspace',workspace,'-format','json','-output',scratch.relative_to(ROOT).as_posix()])
        files=list(scratch.glob('*.json'))
        if len(files)!=1:raise RuntimeError(f'Expected one fresh parsed workspace, found {files}')
        parsed=files[0]
        result=audit(parsed)
        if not result['passed']:raise RuntimeError('Parsed static architecture audit failed')
        environment['C4_PARSED_WORKSPACE']=str(parsed)
        run('validator-tests',[sys.executable,'-B','-m','unittest','discover','-s','scripts','-p','test_static_validation.py'])
        run('image',['docker','image','inspect',IMAGE,'--format','{{json .RepoDigests}}'])
        success=True
    except (RuntimeError,OSError) as exc:
        failure=str(exc);print(failure,file=sys.stderr)
    finally:
        manifest={'started_at':started,'completed_at':datetime.now(timezone.utc).isoformat(),'passed':success,
                  'image':IMAGE,'commands':commands,'inspection':inspection,'failure':failure,
                  'parsed_workspace':str(parsed.relative_to(ROOT)) if parsed else None,
                  'workspace_sha256':hashlib.sha256((ROOT/'workspace-static.dsl').read_bytes()).hexdigest() if (ROOT/'workspace-static.dsl').exists() else None,
                  'deployment_validation':'NOT RUN','diagram_exports':'NOT RUN'}
        (REPORT/'run.json').write_text(json.dumps(manifest,indent=2)+'\n',encoding='utf-8')
        lines=['# Static C4 validation report','',f'Recorded: {manifest["completed_at"]}',
               '',f'**Result: {"PASS" if success else "FAIL"}**','',f'Image: `{IMAGE}`',
               '', 'Inspected input: `workspace-static.dsl`. The main workspace includes preserved, unvalidated deployment definitions.',
               '', '## Commands','','| Check | Exit | Log |','|---|---:|---|']
        for command in commands:lines.append(f'| {command["name"]} | {command["exit_code"]} | [{command["report"]}]({command["report"]}) |')
        if result:
            lines+=['','## Parsed-model checks','',f'- {result["views"]} static views, {result["elements"]} logical elements, {result["components"]} components, {result["relationships"]} relationships.',
                    f'- {result["assertions"]} assertions; {len(result["errors"])} failures.',
                    '- Every view has visible, labeled, directed static dataflows and no disconnected boxes.',
                    '- Every component appears in its owning container\'s component views.',
                    '- Parsed element selections and arrow endpoints exactly match the authored model.',
                    '- Deployment definitions and all existing exports pass preservation comparisons. This is not deployment validation.']
        if inspection:
            lines+=['','## Retained scope advisories','',
                    'Only `workspace.scope` is informational. All other inspection severities retain their defaults. Full inspect returns the displayed violation count (some command wrappers collapse it to 1); the separate error/warning gate must return 0.']
            lines += ['']+['- '+f['message'] for f in inspection['findings']]
        if failure:lines+=['','## Failure','',failure]
        lines+=['','## Evidence and deferred work','',
                '- [Official sources and component coverage](source-inventory.md); [source coverage CSV](source-coverage.csv); [relationship evidence](relationship-evidence.csv).',
                '- [Parsed architecture audit](architecture-audit.json); [machine-readable run and exit codes](run.json).',
                '- Deployment architecture, node counts, quorum sizing, zone resilience, recovery, and deployment layouts: **not validated**.',
                '- Diagram rendering, visual-layout QA, galleries, SVG/PNG/PDF exports: **not run**.',
                '- This validates architecture artifacts, not a running FireFly/Besu installation.']
        (REPORT/'validation-summary.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
    return 0 if success else 1

if __name__=='__main__':raise SystemExit(main())
