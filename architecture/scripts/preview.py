"""Validate and serve fresh parsed JSON without exposing source files for editing."""
import argparse
import json
import subprocess
import sys
import time
import urllib.request
from validate_workspaces import require_docker, source_snapshot, validate_one
from workspace_paths import IMAGE, ROOT, REFERENCE, output_directory, workspace_path


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--workspace',default=REFERENCE)
    parser.add_argument('--port',type=int,default=8080)
    args=parser.parse_args()
    if not 1<=args.port<=65535: parser.error('port must be between 1 and 65535')
    before=source_snapshot()
    try:
        path=workspace_path(args.workspace); require_docker()
        result=validate_one(path)
        if not result['passed']: return 1
        name=f'dlt-architecture-preview-{args.port}'
        existing=subprocess.run(['docker','container','inspect',name],capture_output=True,text=True)
        if existing.returncode==0:
            labels=json.loads(existing.stdout)[0]['Config'].get('Labels') or {}
            if labels.get('com.dlt-architecture.root')!=str(ROOT):
                raise RuntimeError(f'Container {name} belongs to another owner; choose another port')
            subprocess.run(['docker','rm','-f',name],check=True,stdout=subprocess.PIPE)
        # The viewer receives only build outputs. Its editable state cannot affect DSL.
        directory=output_directory(path)
        subprocess.run(['docker','run','-d','--name',name,
            '--label',f'com.dlt-architecture.root={ROOT}',
            '--label',f'com.dlt-architecture.workspace={path.relative_to(ROOT).as_posix()}',
            '-p',f'127.0.0.1:{args.port}:8080',
            '--mount',f'type=bind,source={directory},target=/usr/local/structurizr',
            '-e','STRUCTURIZR_EDITABLE=false','-e','STRUCTURIZR_AUTOSAVEINTERVAL=0',
            '-e','STRUCTURIZR_WORKSPACE_MAXSIZE=10MB',IMAGE,'local'],check=True,stdout=subprocess.PIPE)
        url=f'http://localhost:{args.port}'
        for attempt in range(40):
            try:
                with urllib.request.urlopen(url,timeout=2) as response:
                    if response.status==200: break
            except OSError: time.sleep(1)
        else: raise RuntimeError(f'Preview did not become ready. Inspect docker logs {name}')
        if source_snapshot()!=before: raise RuntimeError('Preview changed source files')
        print(f'Preview ready: {url}\nWorkspace: {path.relative_to(ROOT)}\nStop: docker stop {name}')
        return 0
    except (ValueError,RuntimeError,OSError,subprocess.SubprocessError) as exc:
        print(str(exc),file=sys.stderr); return 1


if __name__=='__main__': raise SystemExit(main())
