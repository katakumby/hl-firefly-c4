# Reference evidence

[sources.json](sources.json) preserves captured repository revisions,
documentation URLs, retrieval timestamps and fingerprints. Authored DSL
retains evidence classifications and source URLs.

Evidence is maintained deliberately by architects during reference updates.
Check the original product documentation, edit the relevant metadata and DSL
together, and explain the change in review. Evidence fields and source currency
are reviewed manually. Native Structurizr validation does not verify this
repository's evidence metadata or cached source snapshots.

Automatic refresh commands, repository extraction and dependency-binding audits
have been retired to reduce maintenance. Existing ignored caches remain
historical evidence and are neither required nor modified by the tools.
The previous implementation is retained in Git history.

See the [Docker-only workflow](../../README.md#docker-only-workflow) and
[tooling decision](../decisions/workspace/0009-container-only-tooling.md).
[Legacy material](legacy/README.md) remains historical reference only.
