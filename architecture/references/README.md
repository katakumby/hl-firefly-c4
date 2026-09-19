# Reference evidence

[sources.json](sources.json) preserves captured repository revisions,
documentation URLs, retrieval timestamps and fingerprints. Authored DSL
retains evidence classifications and source URLs.

The [Unleash reference](../documentation/system/unleash/03-behavior-and-evidence.md)
pins Unleash 8.2.0 and OSS Edge 20.5.0 to immutable commits. Its component map
links implementation modules, and every internal relationship carries source
metadata and a corresponding flow-catalog entry. Edition/lifecycle documentation
is recorded separately from the source revision.

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
