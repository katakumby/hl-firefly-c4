"""Audit source-to-component coverage across the documented FireFly ecosystem.

Independent input is the pinned repository tree, not the generated component
list. Unclassified implementation files fail the audit. Support and example
code have explicit owning responsibilities and are never silently discarded.
"""
from collections import Counter
from pathlib import Path
import csv
import json
import re

ROOT=Path(__file__).resolve().parents[2]
REPORT=ROOT/'build/architecture/reference/reports'

# Explicit non-component groups: public types, entrypoints, helpers, test and
# demonstration artifacts. Runtime modules use component source-path mappings.
GROUPS={
 'firefly':[
  ('internal/coremsgs','Shared constants','firefly.core.config'),
  ('internal/reference','Documentation tooling','firefly.core.api'),
  ('pkg','Public API types and plugin interfaces','firefly.core'),
  ('cmd','Process entrypoint','firefly.core'),
  ('db','Database migrations','firefly.core.database'),
  ('smart_contracts','Deployed contract examples and artifacts','firefly.core.blockchain'),
  ('doc-site','Documentation examples','firefly.core'),
  ('ffcmd','Command support','firefly.core'),
  ('ffconfig','Configuration migration utility','tools.config'),
  ('auditevents','Event audit utility','tools.eventAudit'),
 ],
 'common':[('pkg','Embedded shared library','firefly.core'),('examples','Library examples','firefly.core')],
 'evmconnect':[('cmd','Runtime entrypoint','firefly.evm'),('evmconnect','Executable bootstrap','firefly.evm'),('internal/msgs','Messages and configuration descriptions','firefly.evm.abi'),('internal/retryutil','Retry helper','firefly.evm.rpc'),('pkg/etherrors','RPC error mapping','firefly.evm.rpc')],
 'fftm':[
  ('cmd','Embedded manager initialization','firefly.evm.manager'),
  ('pkg/apitypes','Public API types','firefly.evm.manager'),
  ('pkg/ffcapi','Connector interface','firefly.evm.abi'),
  ('pkg/eventapi','Event interfaces','firefly.evm.streams'),
  ('internal/apiclient','API client library','firefly.evm.manager'),
  ('internal/tmconfig','Configuration definitions','firefly.evm.manager'),
  ('internal/tmmsgs','Messages and descriptions','firefly.evm.manager'),
 ],
 'tezosfftm':[('cmd','Embedded manager initialization','firefly.tezosconnect.api'),
  ('pkg','Embedded FFTM library','firefly.tezosconnect.api'),
  ('internal','Embedded FFTM library','firefly.tezosconnect.api')],
 'signer':[
  ('pkg/abi','Embedded ABI library','firefly.signer.signing'),
  ('pkg/rlp','Embedded RLP library','firefly.signer.signing'),
  ('pkg/secp256k1','Embedded cryptography library','firefly.signer.signing'),
  ('pkg/eip712','Typed-data library capability (not a proxy endpoint)','firefly.signer.signing'),
  ('pkg/ethtypes','Ethereum public types','firefly.signer.signing'),
  ('internal/signermsgs','Messages and descriptions','firefly.signer.proxy'),
  ('cmd','Process entrypoint','firefly.signer.proxy'),
  ('ffsigner','Executable bootstrap','firefly.signer.proxy'),
  ('internal/signerconfig','Configuration definitions','firefly.signer.proxy'),
  ('pkg/ethereum','Ethereum client library','firefly.signer.backend'),
  ('pkg/ffi2abi','FFI-to-ABI library','firefly.signer.signing'),
 ],
 'ethconnect':[
  ('cmd','Process entrypoint','firefly.ethconnect.rest'),
  ('internal/ethbind','Embedded ethbinding plugin','firefly.ethconnect.rpc'),
  ('internal/messages','Wire-message types','firefly.ethconnect.rest'),
  ('internal/errors','Shared errors','firefly.ethconnect.rest'),
  ('internal/utils','Shared helpers','firefly.ethconnect.rest'),
  ('pkg','Public plugin interface','firefly.ethconnect.auth'),
 ],
 'fabconnect':[
  ('cmd','Process entrypoint','firefly.fabconnect.rest'),
  ('internal/conf','Configuration definitions','firefly.fabconnect.rest'),
  ('internal/errors','Shared errors','firefly.fabconnect.rest'),
  ('internal/messages','Wire-message types','firefly.fabconnect.rest'),
  ('internal/utils','Shared helpers','firefly.fabconnect.rest'),
  ('internal/fabric','Fabric client support','firefly.fabconnect.client'),
  ('pkg','Public plugin interface','firefly.fabconnect.auth'),
 ],
 'tezosconnect':[('cmd','Process entrypoint','firefly.tezosconnect.api'),('tezosconnect','Executable bootstrap','firefly.tezosconnect.api'),('internal/msgs','Messages and descriptions','firefly.tezosconnect.adapter')],
 'cardano':[
  ('firefly-cardanoconnect/src/config.rs','Configuration definitions','firefly.cardanoconnect.server'),
  ('firefly-cardanoconnect/src/utils.rs','Shared helpers','firefly.cardanoconnect.server'),
  ('firefly-cardanoconnect/src/main.rs','Runtime initialization','firefly.cardanoconnect.server'),
  ('firefly-cardanosigner/src/config.rs','Configuration definitions','firefly.cardanosigner.server'),
  ('firefly-cardanosigner/src/main.rs','Runtime initialization','firefly.cardanosigner.server'),
  ('scripts','Example, deployment and key-generation tooling','firefly.cardanosigner'),
  ('wasm','Example application contract worker','firefly.cardanoconnect.balius'),
 ],
 'cordaconnect':[
  ('connector/src/main/java/io/kaleido/cordaconnector/config','Connector configuration','firefly.cordaconnect.api'),
  ('connector/src/main/java/io/kaleido/cordaconnector/exception','Connector errors','firefly.cordaconnect.flows'),
  ('connector/src/main/java/io/kaleido/cordaconnector/Server.java','Process entrypoint','firefly.cordaconnect.api'),
  ('connector/src/main/java/io/kaleido/cordaconnector/model','Public request and event types','firefly.cordaconnect.api'),
  ('cordapp','Custom CorDapp starter code','corda'),
 ],
 'cli':[
  ('internal/constants','Configuration constants','tools.cli.stacks'),
  ('internal/log','Logging support','tools.cli.stacks'),
  ('internal/utils','Shared helpers','tools.cli.stacks'),
  ('pkg','CLI manifest types','tools.cli.stacks'),
  ('ff','Executable bootstrap','tools.cli.commands'),
 ],
 'perf':[
  ('internal/conf','Workload configuration','tools.perf.runner'),
  ('internal/types','Workload types','tools.perf.runner'),
  ('internal/version','Build metadata','tools.perf.commands'),
  ('smart_contracts','Benchmark contracts','tools.perf.runner'),
  ('ffperf','Executable bootstrap','tools.perf.commands'),
 ],
 'sdk':[('lib','Embedded SDK interfaces, validation and logging','tools.sandbox.sdk'),('examples','SDK examples','tools.sandbox.sdk'),('scripts','SDK build tooling','tools.sandbox.sdk')],
 'dx':[('src/app.ts','Runtime initialization','firefly.dx.api'),('src/index.ts','Process entrypoint','firefly.dx.api'),('src/custom.d.ts','Type declarations','firefly.dx.api')],
 'sandbox':[],
 'ui':[('scripts','UI build tooling','firefly.explorer.app')],
 'erc20':[], 'erc1155':[],
}
for key in ('erc20','erc1155'):
 GROUPS[key]=[
  ('src/websocket-events','Shared WebSocket base','firefly.'+key+'.proxy'),
  ('src/request-context','Request context helpers','firefly.'+key+'.api'),
  ('src/health','Health endpoint','firefly.'+key+'.api'),
  ('src/main.ts','Process entrypoint','firefly.'+key+'.api'),
  ('src/app.module.ts','Runtime initialization','firefly.'+key+'.api'),
  ('src/request-logging.interceptor.ts','Request logging','firefly.'+key+'.api'),
  ('src/utils.ts','HTTP helpers','firefly.'+key+'.blockchain'),
  ('samples','Example token contracts and deployment scripts','firefly.'+key+'.mapper'),
 ]

def matches(path,prefix):
 return path==prefix or path.startswith(prefix+'/') or path==prefix+'.rs'

def main(catalog_path=None, report_directory=None):
 global REPORT
 if report_directory is not None: REPORT=Path(report_directory)
 REPORT.mkdir(parents=True,exist_ok=True)
 s=json.loads((ROOT/'architecture/references/sources.json').read_text(encoding='utf-8'))
 m=json.loads(Path(catalog_path or ROOT/'build/architecture/reference/model-catalog.json').read_text(encoding='utf-8'))
 components=[e for e in m['elements'] if e['kind']=='component']
 element_ids={e['id'] for e in m['elements']}
 mappings={}
 for key,repo in s['repositories'].items():
  prefix=repo['url']+'/'
  mappings[key]=[(url[len(prefix):],e['id']) for e in components for url in e.get('sources',[e['source']]) if url.startswith(prefix)]
 records=[];unmapped=[]
 for key in GROUPS:
  repo=s['repositories'][key]
  for path in repo['paths']:
   if not path.endswith(('.go','.ts','.tsx','.rs','.java','.kt','.sol')):continue
   if any(x in path.lower() for x in ('_test.','.test.','.spec.','/test/','/tests/','/mocks/','/mock/','/fixtures/','/fixture/','/integration/','setuptests','vite-env.d.ts','react-app-env.d.ts')) or path.startswith(('test/','tests/','mocks/')):
    classification='Test or generated test support';owners=[]
   else:
    found=[(len(prefix),owner) for prefix,owner in mappings[key] if matches(path,prefix)]
    if found:
     best=max(length for length,_ in found)
     owners=sorted({owner for length,owner in found if length==best})
     classification='Modeled component responsibility'
    else:
     grouped=[(len(prefix),label,owner) for prefix,label,owner in GROUPS[key] if matches(path,prefix)]
     if grouped:
      _,classification,owner=max(grouped);owners=[owner]
     elif '/' not in path and path.endswith('.go'):
      classification='Root executable/bootstrap';owners=[next(e['id'] for e in m['elements'] if repo['url'] in e['source'] and e['kind'] in ('container','component'))]
     elif any(part.endswith('.config.ts') for part in path.split('/')):
      classification='Build/test configuration';owners=[]
     else:
      classification='UNMAPPED';owners=[];unmapped.append(key+':'+path)
   assert all(owner in element_ids for owner in owners),(path,owners)
   records.append({'repository':key,'path':path,'classification':classification,'elements':';'.join(owners),
                   'source':f'https://github.com/{repo["repository"]}/blob/{repo["commit"]}/{path}'})
 with (REPORT/'source-coverage.csv').open('w',encoding='utf-8',newline='') as f:
  writer=csv.DictWriter(f,fieldnames=['repository','path','classification','elements','source']);writer.writeheader();writer.writerows(records)
 with (REPORT/'relationship-evidence.csv').open('w',encoding='utf-8',newline='') as f:
  writer=csv.writer(f);writer.writerow(['source','destination','dataflow','mechanism','classification','evidence'])
  for r in m['relationships']:writer.writerow([r['source'],r['destination'],r['description'],r['technology'],r['classification'],';'.join(r['evidence'])])
 lines=['# Official source inventory','','This covers the documented open-source FireFly ecosystem. Every implementation file in the selected FireFly runtime repositories is mapped to a component responsibility or explicitly classified. This is evidence coverage, not a code-level diagram.','','## Pinned repository snapshots','','| Repository | Commit | Evidence |','|---|---|---|']
 for key,repo in s['repositories'].items():
  if key=='charts':continue
  evidence='source archive + documentation' if repo.get('source_archive') else 'documentation + repository tree'
  lines.append(f'| {key} | [{repo["commit"][:12]}]({repo["url"]}) | {evidence} |')
 lines+=['','Retrieved: '+s['static_retrieved_at'],'','## Embedded versions','','| Owning runtime | Library | Version |','|---|---|---|']
 for d in s['embedded_dependencies']:lines.append(f'| {d["runtime"]} | {d["library"]} | [{d["version"]}]({d["evidence"]}) |')
 lines+=['','## Coverage and evidence limits','',f'- {len(records)} source files inventoried; {len(unmapped)} unclassified implementation files.',
  '- Core plugin factories are checked through the captured factory sources and concrete adapter components. The onchain identity implementation is a placeholder.',
  '- Corda starter CorDapps and Cardano demo/key-generation tools are customization/example artifacts; they are not services in the selected Besu stack.',
  '- The official samples repository is cataloged as example applications represented by the member-application boundary; it is not a mandatory runtime.',
  '- Explorer is served by Core. The UI source snapshot is a reference implementation; Core does not pin a UI source commit in its Dockerfile.',
  '- Signer ABI/RLP/EIP-712 utilities, common helpers, SDKs and public interfaces are mapped to owning responsibilities, without claiming independent services.',
  '- Besu source modules are mapped to its focused node views. Security products have separate documentation-backed logical reference coverage; their proprietary implementation files are not inventoried.',
  '- Relationship rows state architecture-level dataflow inferred from the cited source responsibilities. They do not claim every arrow is one direct method call.',
  '- Tezos embeds FFTM '+next(d['version'] for d in s['embedded_dependencies'] if d['runtime']=='tezosconnect')+'; it is not silently assigned EVMConnect\'s FFTM revision.',
  '- Alternative EVM chain guides reuse the Ethereum adapter rather than duplicating its implementation.',
  '', '## Official documentation','']
 for key in ('firefly-head','firefly-architecture','firefly-plugins','qbft','permissioning','besu-rpc','structurizr-dsl','inspect'):
  lines.append(f'- [{key}]({s["pages"][key]["url"]})')
 security=[e for e in m['elements'] if 'SecurityCatalog' in e.get('tags','').split(',')]
 security_pages={v['url']:v for k,v in s['pages'].items() if k.startswith('security-')}
 lines+=['','## Security product reference catalog','',
  'Proprietary component decompositions are logical reference abstractions, not a verified internal code inventory. Proposed application integrations are labeled separately. Conjur Enterprise (Secrets Manager Self-Hosted) is the selected edition.',
  '', 'Retrieved: '+s['security_retrieved_at'], '',
  '| Documentation | Capture method | SHA-256 |','|---|---|---|']
 for key,entry in s['pages'].items():
  if key.startswith('security-'):
   lines.append(f'| [{key}]({entry["url"]}) | {entry["capture_method"]} | `{entry["sha256"]}` |')
 lines+=['','CyberArk entries use web-reader text excerpts because direct HTTP downloads returned 404. Fingerprints describe those excerpts; they are not full HTML snapshots.',
         '', '[Security element-to-document coverage](security-source-coverage.csv). Broad product documentation supports capabilities; grouping those capabilities into logical components is explicitly inferred.']
 security_records=[]
 for e in security:
  for url in e.get('sources',[e['source']]):
   entry=security_pages[url]
   security_records.append({'element':e['id'],'level':e['kind'],'classification':e['classification'],
       'source':url,'sha256':entry['sha256'],'retrieved_at':entry['retrieved_at'],'capture_method':entry['capture_method']})
 with (REPORT/'security-source-coverage.csv').open('w',encoding='utf-8',newline='') as f:
  writer=csv.DictWriter(f,fieldnames=['element','level','classification','source','sha256','retrieved_at','capture_method'])
  writer.writeheader();writer.writerows(security_records)
 (REPORT/'source-inventory.md').write_text('\n'.join(lines)+'\n',encoding='utf-8')
 report={'passed':not unmapped,'source_files':len(records),'unmapped':unmapped,'classifications':dict(Counter(r['classification'] for r in records)),
         'repository_count':len(GROUPS),'embedded_dependencies':s['embedded_dependencies'],
         'security_elements':len(security),'security_document_links':len(security_records)}
 (REPORT/'source-audit.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
 print(json.dumps({'source_files':len(records),'unmapped':unmapped},indent=2))
 return 1 if unmapped else 0

if __name__=='__main__':raise SystemExit(main())
