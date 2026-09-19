"""One-time semantic comparison with the historical pre-modular catalog.

Not part of normal validation: future reviewed model changes may differ.
"""
import argparse
import json
from workspace_catalog import semantic_difference
from workspace_paths import ROOT, REFERENCE
from artifact_store import successful_run
from presentation_catalog import normalize_presentation, presentation_difference


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--before',default=str(ROOT/'architecture/references/legacy/pre-modular-catalog.json'))
    parser.add_argument('--after',help='Catalog override; its sibling workspace.json supplies presentation')
    args=parser.parse_args()
    with open(args.before,encoding='utf-8') as stream: before=json.load(stream)
    from pathlib import Path
    directory = Path(args.after).parent if args.after else successful_run(REFERENCE)
    with open(args.after or directory/'model-catalog.json',encoding='utf-8') as stream: after=json.load(stream)
    differences=semantic_difference(before,after)
    baseline=json.loads((ROOT/'architecture/references/legacy/presentation-baseline.json').read_text(encoding='utf-8'))
    workspace=json.loads((directory/'workspace.json').read_text(encoding='utf-8-sig'))
    presentation=presentation_difference(baseline['presentation'],normalize_presentation(workspace))
    report={'passed':not differences and not presentation,'differences':differences,
            'presentation_differences':presentation, 'presentation_baseline_revision':baseline['source_revision'],
            'counts':{section:len(after[section]) for section in after}}
    target=ROOT/'build/architecture/migration'; target.mkdir(parents=True,exist_ok=True)
    (target/'semantic-comparison.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(report,indent=2))
    return 1 if differences or presentation else 0


if __name__=='__main__': raise SystemExit(main())
