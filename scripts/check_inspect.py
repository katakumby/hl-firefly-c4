"""Accept only documented scope advisories; never hard-code their count."""
from pathlib import Path
import argparse
import re

def assess(text, exit_code):
    findings=[{'severity':m[1],'type':m[2].strip(),'message':m[3].strip()}
              for m in re.finditer(r'^\s*(ERROR|WARNING|WARN|INFO|IGNORE)\s*\|\s*([^|]+)\|\s*(.+)$',text,re.M)]
    unexpected=[f for f in findings if f['severity']!='INFO' or f['type']!='workspace.scope']
    # The Java launcher returns 1 for positive findings in the pinned Docker
    # image; other launchers can return the number of displayed violations.
    expected_codes={0} if not findings else {1,len(findings),len(findings)%256}
    passed=not unexpected and exit_code in expected_codes
    return {'passed':passed,'exit_code':exit_code,'findings':findings,'unexpected':unexpected}

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('report');p.add_argument('exit_code',type=int);a=p.parse_args()
    result=assess(Path(a.report).read_text(encoding='utf-8-sig'),a.exit_code)
    print(f'Inspection findings: {len(result["findings"])}; accepted: {result["passed"]}')
    raise SystemExit(0 if result['passed'] else 1)
