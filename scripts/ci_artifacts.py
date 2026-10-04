"""Package verified source/preview handoffs or diagnostics, without local state."""
import argparse
import json
from pathlib import Path
import shutil

import architecture as cli
from artifact_store import atomic_json, confined
from diagram_renderers import check_toolchain


def package(destination, diagnostics=False, stage='source', renderer=None):
    destination = Path(destination)
    if not destination.is_dir() or any(destination.iterdir()):
        raise ValueError('Mount an empty writable artifact directory at /artifacts')
    selected = set()
    with cli.command_lock():
        if diagnostics:
            selected.update(p for p in (cli.BUILD / '.reports').rglob('*') if p.is_file() and p.suffix in ('.json', '.log'))
        else:
            if stage not in ('source', 'preview') or (stage == 'preview' and renderer not in ('plantuml', 'mermaid')):
                raise ValueError('Use --stage source or --stage preview --renderer plantuml|mermaid')
            if stage == 'source' and renderer:
                raise ValueError('--renderer applies only to preview packaging')
            source, source_digest = cli.verify_source_handoff()
            name, status = 'source', source
            if stage == 'preview':
                name = 'preview-' + renderer
                report = cli.BUILD / '.reports' / (name + '.json')
                if not report.is_file():
                    raise ValueError('Missing preview report; run the selected preview stage first')
                status = json.loads(report.read_text())
                if (not status.get('passed') or status.get('in_progress') or status.get('source_handoff_sha256') != source_digest):
                    raise ValueError('Refusing to package an incomplete or stale preview')
                check_toolchain(cli.TOOLCHAIN, status['renderers'])
                cli.verify_coverage(source['selection'], status['selection'], source['artifacts'])
                expected = {item['output'] for item in cli.preview_plan(source['artifacts'], renderer)
                            if cli.in_scope(item, status['selection'])}
                if expected != set(status['outputs']) or status['outputs'] != sorted(i['output'] for i in status['artifacts']):
                    raise ValueError('Incomplete preview inventory')
            else:
                selected.update(confined(cli.BUILD, path) for path in source['reports'])
            indexed = {item['output']: item for item in cli.inventory(name)}
            for item in status['artifacts']:
                path = confined(cli.BUILD, item['output'])
                if (indexed.get(item['output']) != item or not path.is_file() or cli.digest(path) != item['output_sha256']):
                    raise ValueError(f'Refusing to package missing or modified output: {item["output"]}')
                selected.add(path)
            selected.update(cli.BUILD / '.reports' / (name + suffix) for suffix in ('.json', '.log'))
            # Each package owns a unique inventory; preview packages can be combined.
            atomic_json(destination / (name + '.json'), {'schema_version': 2,
                        'artifacts': sorted(status['artifacts'], key=lambda item: item['output'])})
        selected.update(p for p in (cli.BUILD / '.reports').glob('tests*.log') if p.is_file())
        for file in sorted(selected):
            target = destination / file.relative_to(cli.BUILD)
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(file, target)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--diagnostics', action='store_true')
    parser.add_argument('--stage', choices=('source', 'preview'), default='source')
    parser.add_argument('--renderer', choices=('plantuml', 'mermaid'))
    args = parser.parse_args()
    package('/artifacts', args.diagnostics, args.stage, args.renderer)
