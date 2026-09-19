# Reference evidence

[sources.json](sources.json) records pinned repositories, documentation URLs,
retrieval timestamps and fingerprints. Model URLs and evidence classifications
live in authored DSL.

Normal validation uses recorded metadata without fetching new evidence. It
checks fingerprints for locally available caches; missing ignored caches do not
make a clean checkout fail.

Deliberate refresh commands, from the repository root:

```powershell
./architecture/scripts/refresh_evidence.ps1 -Scope All
./architecture/scripts/refresh_evidence.ps1 -Scope Static
./architecture/scripts/refresh_evidence.ps1 -Scope Components
./architecture/scripts/refresh_evidence.ps1 -Scope Besu
./architecture/scripts/refresh_evidence.ps1 -Scope Security -Only security-hsm
```

`All` refreshes static repositories and their dependency bindings, component
archives/Besu evidence, then security documents. `Static` updates all affected
runtime bindings, including Tezos and Sandbox. Scoped refreshes preserve
unaffected bindings. The four previous `capture_*.py` commands remain wrappers
for their corresponding scopes; the security wrapper retains `--only`.

Documents are stored by content hash and archives are extracted into separate
revision/hash directories under `.cache/architecture/evidence/`. New snapshots
never overwrite published cache objects. Removed files do not survive across
revisions. Existing cache records and old snapshots remain readable and are not
automatically cleaned.

Refresh stages and validates the candidate inventory, then atomically replaces
`sources.json` only if the original inventory is unchanged. A failure retains
the previous publication. Receipts and candidate metadata are written under
`build/architecture/evidence-refresh/`. Cached fallback excerpts keep their
original retrieval time and record the new refresh attempt separately.

Review changed revisions and authored DSL evidence URLs together, then validate
every workspace. Refresh never rewrites authored DSL. The workspace-improvement
tests use local fixtures and do not refresh live product evidence.

[Legacy material](legacy/README.md) is retained for historical review only.
