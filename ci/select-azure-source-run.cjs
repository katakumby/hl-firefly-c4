// CI acquisition only. Run with provider credentials before offline diagram generation.
async function selectAzureSourceRun({collection, project, definition, sha, branch, token}, request = fetch) {
  if (![collection, project, definition, sha, branch, token].every(Boolean)) {
    throw new Error('Azure artifact lookup requires collection, project, pipeline, commit, branch and job token.');
  }
  const base = new URL(collection.endsWith('/') ? collection : collection + '/');
  if (base.protocol !== 'https:') throw new Error('Azure artifact lookup requires HTTPS.');
  const endpoint = new URL(encodeURIComponent(project) + '/_apis/build/builds', base);
  const tag = 'architecture-source-' + sha;
  const params = {'api-version': '7.1', definitions: String(definition), branchName: branch,
    tagFilters: tag, statusFilter: 'completed', resultFilter: 'succeeded',
    deletedFilter: 'excludeDeleted', queryOrder: 'finishTimeDescending', '$top': '100'};
  const seen = new Set();
  async function get(url, optional = false) {
    const response = await request(url, {headers: {Authorization: 'Bearer ' + token},
      redirect: 'error', signal: AbortSignal.timeout(30000)});
    if (optional && [404, 410].includes(response.status)) return null;
    if (!response.ok) throw new Error(`Azure artifact lookup failed (HTTP ${response.status}); check job-token permissions and service availability.`);
    const data = await response.json();
    if (!Array.isArray(data.value)) throw new Error('Azure artifact lookup returned an invalid response.');
    return {items: data.value, next: response.headers.get('x-ms-continuationtoken')};
  }
  let continuation;
  do {
    endpoint.search = new URLSearchParams({...params, ...(continuation ? {continuationToken: continuation} : {})});
    const page = await get(endpoint);
    const candidates = page.items.filter(build => build.sourceVersion === sha && build.sourceBranch === branch &&
      String(build.definition?.id) === String(definition) && build.status === 'completed' &&
      build.result === 'succeeded' && !build.deleted && build.tags?.includes(tag) &&
      Number.isSafeInteger(build.id) && build.id > 0);
    candidates.sort((a, b) => Date.parse(b.finishTime) - Date.parse(a.finishTime) || b.id - a.id);
    for (const build of candidates) {
      const url = new URL(endpoint.pathname + '/' + build.id + '/artifacts', base);
      url.search = new URLSearchParams({'api-version': '7.1'});
      const artifacts = await get(url, true);
      if (artifacts?.items.some(item => item.name === 'architecture-source' && item.resource?.type === 'PipelineArtifact')) {
        return build.id;
      }
    }
    continuation = page.next;
    if (continuation && seen.has(continuation)) throw new Error('Azure artifact lookup repeated a continuation token.');
    seen.add(continuation);
  } while (continuation);
  throw new Error('No successful, available architecture-source artifact for this commit and branch. ' +
    'Run the source job for this commit first, then retry preview generation.');
}

module.exports = selectAzureSourceRun;
if (require.main === module) {
  selectAzureSourceRun({collection: process.env.AZURE_COLLECTION_URI, project: process.env.AZURE_PROJECT_ID,
    definition: process.env.AZURE_DEFINITION_ID, sha: process.env.ARCHITECTURE_SOURCE_REVISION,
    branch: process.env.AZURE_SOURCE_BRANCH, token: process.env.SYSTEM_ACCESSTOKEN})
    .then(id => console.log(`##vso[task.setvariable variable=architectureSourceBuildId;isOutput=true]${id}`))
    .catch(error => { console.error(error.message); process.exitCode = 1; });
}
