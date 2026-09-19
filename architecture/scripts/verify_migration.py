"""One-time semantic comparison with the historical pre-modular catalog.

Not part of normal validation: future reviewed model changes may differ.
"""
import argparse
import json
from workspace_catalog import semantic_difference
from workspace_paths import ROOT


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--before',default=str(ROOT/'architecture/references/legacy/pre-modular-catalog.json'))
    parser.add_argument('--after',default=str(ROOT/'build/architecture/reference/model-catalog.json'))
    args=parser.parse_args()
    with open(args.before,encoding='utf-8') as stream: before=json.load(stream)
    with open(args.after,encoding='utf-8') as stream: after=json.load(stream)
    differences=semantic_difference(before,after)
    report={'passed':not differences,'differences':differences,
            'counts':{section:len(after[section]) for section in after}}
    target=ROOT/'build/architecture/migration'; target.mkdir(parents=True,exist_ok=True)
    (target/'semantic-comparison.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
    print(json.dumps(report,indent=2))
    return 1 if differences else 0


if __name__=='__main__': raise SystemExit(main())
