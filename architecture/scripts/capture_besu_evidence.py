"""Capture primary Besu implementation evidence for the selected private profile."""
from concurrent.futures import ThreadPoolExecutor
import json
from capture_static_sources import ROOT, capture

def capture_besu(inventory):
    repo=inventory['repositories']['besu']
    names=['JsonRpcHttpService.java','EthProtocolManager.java','TransactionPool.java',
           'PeerDiscoveryAgent.java','AccountPermissioningController.java','NodePermissioningController.java',
           'QbftBesuControllerBuilder.java','QbftBlockHeightManager.java','AbstractBlockProcessor.java',
           'WorldStateArchive.java','RocksDBKeyValueStorageFactory.java','SecurityModule.java','PrometheusMetricsSystem.java']
    selected=[]
    for name in names:
        matches=[p for p in repo['paths'] if p.endswith('/'+name) and '/src/main/' in p]
        if len(matches)!=1:raise RuntimeError(f'Ambiguous Besu evidence {name}: {matches}')
        selected+=matches
    def fetch(path):
        return path,capture('besu-'+path.replace('/','_'),f'https://raw.githubusercontent.com/{repo["repository"]}/{repo["commit"]}/{path}')
    with ThreadPoolExecutor(max_workers=6) as pool:
        for path,document in pool.map(fetch,selected):repo['documents'][path]=document
    print(f'Captured {len(selected)} Besu implementation sources')

if __name__=='__main__':
    inventory=json.loads((ROOT/'architecture/references/sources.json').read_text(encoding='utf-8'))
    capture_besu(inventory)
    (ROOT/'architecture/references/sources.json').write_text(json.dumps(inventory,indent=2)+'\n',encoding='utf-8')
