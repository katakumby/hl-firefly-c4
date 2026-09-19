# Reference evidence

[sources.json](sources.json) records pinned repositories, documentation URLs,
retrieval timestamps and fingerprints. Model URLs and evidence classifications
live in authored DSL.

Normal validation uses recorded metadata without fetching new evidence.
Deliberate refresh commands are `architecture/scripts/capture_static_sources.py`,
`architecture/scripts/capture_component_sources.py`, `architecture/scripts/capture_besu_evidence.py`,
and `architecture/scripts/capture_security_sources.py`, run from the repository root.
They update this inventory and cache downloaded snapshots in ignored locations.
Review resulting evidence and architecture changes together.

[Legacy material](legacy/README.md) is retained for historical review only.
