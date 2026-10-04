// Provider API lookup only; diagram generation stays offline.
module.exports = async function selectSourceRun(github, {owner, repo, workflow_id, sha, branch}) {
  const runs = await github.paginate(github.rest.actions.listWorkflowRuns,
    {owner, repo, workflow_id, head_sha: sha, branch, status: 'success', per_page: 100});
  const eligible = runs.filter(run => run.head_sha === sha && run.head_branch === branch &&
    run.status === 'completed' && run.conclusion === 'success' &&
    ['push', 'workflow_dispatch'].includes(run.event));
  eligible.sort((a, b) => b.run_number - a.run_number || b.run_attempt - a.run_attempt);
  for (const run of eligible) {
    const artifacts = await github.paginate(github.rest.actions.listWorkflowRunArtifacts,
      {owner, repo, run_id: run.id, per_page: 100});
    const artifact = artifacts.find(item => item.name === 'architecture-source' && !item.expired &&
      (!item.expires_at || Date.parse(item.expires_at) > Date.now()));
    if (artifact) return {run_id: run.id, artifact_id: artifact.id};
  }
  throw new Error(`No successful, unexpired architecture-source artifact for ${sha} on ${branch}. ` +
    'Run the source job for this commit first, then retry preview generation.');
};
