"""Provider-response fixtures run offline using the browser image's Node runtime."""
import subprocess
import unittest

from test_architecture import ROOT
from diagram_renderers import has_capability


@unittest.skipUnless(has_capability('native'), 'Provider fixtures need tools-browser Node')
class AzureSelection(unittest.TestCase):
    def test_commit_availability_pagination_and_api_failures(self):
        script = r'''
const assert = require('node:assert/strict');
const select = require('./ci/select-azure-source-run.cjs');
const options = {collection:'https://dev.azure.com/org/',project:'project',definition:7,
 sha:'abc',branch:'refs/heads/main',token:'job-secret'};
const base = {sourceVersion:'abc',sourceBranch:'refs/heads/main',definition:{id:7},
 status:'completed',result:'succeeded',tags:['architecture-source-abc'],finishTime:'2026-10-04T00:00:00Z'};
const run = id => ({...base,id});
let pages = [[{...run(9),sourceVersion:'other'}, {...run(8),result:'failed'},
 {...run(7),sourceBranch:'refs/heads/other'}, {...run(6),definition:{id:8}},
 {...run(5),tags:[]}, run(4), run(3)], [run(2),run(1)]];
let artifacts = {4:404,3:[],2:[],1:[{name:'architecture-source',resource:{type:'PipelineArtifact'}}]};
const calls = [];
const response = (items, next, status=200) => ({ok:status===200,status,
 json:async()=>({value:items}),headers:{get:()=>next}});
const request = async (input, init) => {
 const url = new URL(input); calls.push(url);
 assert.equal(init.headers.Authorization,'Bearer job-secret');
 assert.equal(init.redirect,'error');
 const match = url.pathname.match(/\/builds\/(\d+)\/artifacts$/);
 if(match) {
   const data=artifacts[match[1]];
   assert.notEqual(data,undefined,'Ineligible build queried');
   return response(Array.isArray(data)?data:[],null,typeof data==='number'?data:200);
 }
 assert.equal(url.searchParams.get('definitions'),'7');
 assert.equal(url.searchParams.get('branchName'),'refs/heads/main');
 assert.equal(url.searchParams.get('tagFilters'),'architecture-source-abc');
 assert.equal(url.searchParams.get('queryOrder'),'finishTimeDescending');
 const index=url.searchParams.get('continuationToken')==='next'?1:0;
 return response(pages[index],index===0?'next':null);
};
(async()=>{
 assert.equal(await select(options,request),1);
 assert(calls.some(url=>url.searchParams.get('continuationToken')==='next'));
 artifacts[3]=[{name:'architecture-source',resource:{type:'PipelineArtifact'}}];
 assert.equal(await select(options,request),3);
 artifacts[3]=[]; artifacts[1]=[];
 await assert.rejects(select(options,request),/Run the source job/);
 artifacts[4]=403;
 await assert.rejects(select(options,request),/HTTP 403/);
 await assert.rejects(select(options,async()=>response([],null,401)),/HTTP 401/);
 await assert.rejects(select({...options,token:''},request),/job token/);
 await assert.rejects(select({...options,collection:'http://example.com/'},request),/HTTPS/);
 await assert.rejects(select(options,async()=>response([],'again')),/repeated a continuation/);
})().catch(error=>{console.error(error);process.exitCode=1;});
'''
        result = subprocess.run(['node', '-e', script], cwd=ROOT, capture_output=True, text=True)
        self.assertEqual(0, result.returncode, result.stderr)
