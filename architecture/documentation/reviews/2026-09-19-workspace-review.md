# Workspace consistency, duplication and maintainability review

> Historical review. Findings and evidence describe the earlier tooling; the
> implementation status at the end records the current maintenance scope.
> [Decision 9](../../decisions/workspace/0009-container-only-tooling.md) subsequently
> replaces host scripts, run history, evidence automation and product-specific audits
> with containerized validation/export and a Docker viewer. Retired source files can
> be inspected in Git history; current commands are in the [root README](../../../README.md).
> The current workflow explicitly runs native Structurizr `validate` and `inspect`.
> Historical links below may target removed source files or disposable build
> artifacts. Use Git history for removed files; generated evidence is not retained.
> All custom architecture validation is now removed. Team conventions are
> advisory; native inspection properties control findings while teams mature.

Reviewed: 2026-09-19. Scope: the current working tree, including the uncommitted
modular migration. This report records findings and proposed changes; it does
not apply them to the model or tooling.

The current architecture is internally consistent and preserves the reference
model. No duplicate reference definitions or exact duplicate reference diagrams
were found. The main improvements concern validation of future initiatives,
evidence refresh, consistent build publication, and reducing shared-file editing
hotspots. No immediate blocker was found in the two current workspaces.

## Verified baseline

| Check | Result |
|---|---|
| Reference workspace | PASS: 333 elements, 696 relationships, 95 views; 4,058 semantic assertions |
| Ignition workspace | PASS: 334 elements, 696 inherited relationships, one focused view; 3,305 assertions |
| Existing tests, including pinned Docker parser fixtures | All 27 passed |
| Historical semantic comparison | Zero differences in the fields represented by the historical catalog |
| Element breakdown | 4 people, 26 systems, 60 containers, 243 components in the reference model |
| Reference diagram breakdown | 3 landscapes, 12 contexts, 29 container views, 51 component views |
| DSL includes and extension paths | All resolve; no active DSL fragment is unreachable from the discovered entrypoints |
| Relationship placement | All 696 relationships are in their owning-system file or the cross-system integration file |
| Markdown file destinations | No broken local destinations found by the existing checker; anchor limitations are described below |
| Captured document evidence | All 159 recorded local snapshots exist and match their SHA-256 fingerprints |
| Use cases | Seven documents, two Mermaid blocks each; all annotated canonical participant IDs exist in the model |
| Style preservation | Current style block matches the previous tracked DSL after whitespace normalization |
| Compose layout | Resolves repository mounts and `build/architecture/` outputs correctly; images remain pinned |
| Source preservation | Validation, tests and isolated review probes left existing source files unchanged |

`dapp_platform` is defined only in ignition, remains proposed, has no children or
relationships, and appears alone in its context view. Shared modules contain no
system definitions. The two descriptive HSM relationship identifiers remain in
the integration fragment. The shared workspace contains definitions and styles;
the reference and initiative entrypoints select their own diagrams.

## Findings and possible fixes

Priorities: **P2** means a concrete workflow or validation weakness worth fixing
before broader team use. **P3** means a lower-impact assurance or maintenance
improvement. These findings do not imply that the current reference model is
incorrect.

### F1 — P2: Initiative-local elements can use the inherited-element exception

**Historical evidence:** In `architecture_validation.py` (retired),
lines 91–92 allow `model.element.noview = info` on any non-DApp element in any
initiative. The audit does not establish whether the element was inherited.
The documented policy in [decision 7](../../decisions/workspace/0007-modular-workspaces.md)
restricts that exception to inherited reference elements.

**Reproduced:** An isolated workspace added two connected local proposed systems,
applied this exception, and omitted both from every view. The pinned parser,
semantic audit and inspection gate all accepted it.

**Impact:** A copied or misplaced policy block can hide newly authored proposal
content while validation reports success.

**Possible fix:** Pass model provenance into the audit. Limit this exception to
the actual inherited reference IDs, and require local proposal elements to
appear in appropriate views. Treat variant inheritance explicitly so an
initiative-local element does not become exempt simply because a variant
inherits it.

**Acceptance:** The hidden-local-elements fixture must fail; ignition and an
ordinary additive variant must still pass.

### F2 — P2: Initiative view prefixes and duplicate selections are not checked

**Historical evidence:** `architecture_validation.py` (retired)
checks unique keys, but calls
`audit_logical_boundaries.py` (retired) only for
the reference workspace. That helper contains the exact duplicate-selection
check. Neither validator derives the required `<epic-id>-` prefix from the
entrypoint path.

**Reproduced:** Two identical landscape selections named `unprefixed-a` and
`unprefixed-b` were added to an ignition-derived fixture. Parsing, inspection
and semantic validation all passed.

**Impact:** Initiative diagrams can proliferate under inconsistent names and
duplicate one another, despite the contribution rules.

**Possible fix:** Separate general diagram checks from FireFly/security-specific
reference assertions. Run duplicate-selection checks for all workspaces and
validate locally authored view prefixes using initiative identity. Account for
inherited views when validating a variant.

**Acceptance:** Reject a wrong prefix and an exact duplicate selection with a
different key. Keep distinct scenarios and inherited parent views valid.

### F3 — P2: Standalone static evidence refresh discards dependency records

**Evidence:** `capture_static_sources.py` (retired),
line 93, resets `embedded_dependencies` and recreates only EVMConnect and
FireFly bindings. TezosConnect and Sandbox bindings are restored by the separate
`capture_component_sources.py` (retired).
The [reference README](../../references/README.md) lists the refresh commands
without explaining this required sequence.

**Reproduced:** A network-free simulation of the static refresh, using isolated
copies of the current metadata, reduced five dependency bindings to three,
removing `tezosconnect/tezosfftm` and `sandbox/sdk`.

**Impact:** Running a listed maintenance command alone leaves the inventory
incomplete. The source-inventory report explicitly expects the Tezos binding;
refreshing repository revisions also requires deliberate alignment of DSL
evidence URLs with those revisions.

**Possible fix:** Provide one staged refresh workflow that rebuilds the complete
dependency inventory and validates it before publication. If individual
commands remain supported, either preserve unaffected bindings or refuse an
incomplete refresh with a clear instruction. Document the required order and
the separate review of DSL evidence changes.

**Acceptance:** Refreshing one source family preserves unrelated bindings;
the combined refresh retains all five current bindings and reports missing
records clearly. Simulate a partial failure without changing live evidence.

### F4 — P2: Evidence caches are updated in place across revisions

**Evidence:** `capture_component_sources.py` (retired),
lines 38–54, extracts each repository into the same `.cache/source-code/<key>/`
directory and writes only files present in the new archive. Files removed in a
new revision remain on disk. Static and security capture helpers also overwrite
stable cache filenames before writing the final inventory.

**Impact:** After a refresh, a source directory can contain files from multiple
revisions. A mid-refresh failure can leave old metadata pointing at overwritten
document content. This is a code-path finding; the current 159 document
fingerprints all match, and no current cache corruption is alleged.

**Possible fix:** Store snapshots under revision or content-hash directories,
extract into a new staging directory, verify the result, and publish metadata
last. Retain old snapshots deliberately and clean them through a separate,
bounded operation. Hash-check existing snapshots during evidence audits without
requiring a fresh checkout to contain ignored caches.

**Acceptance:** An A-to-B refresh where B removes a file must expose only B's
files. An interrupted refresh must leave the previously published inventory and
its referenced snapshots consistent.

### F5 — P2: A failed validation leaves artifacts from different runs together

**Evidence:** `validate_workspaces.py` (retired)
writes the catalog and coverage before the semantic audit, overwrites reports
in a shared directory, and publishes `workspace.json` only after success.

**Reproduced:** In an isolated output directory, a successful one-view run was
followed by a two-view run with a disconnected diagram. The second run correctly
failed, but left a two-view catalog beside the previous one-view workspace JSON
and the previous inspection log. The current `run.json` correctly reported
failure.

**Impact:** Consumers that open the catalog, inspection report or Compose
preview directly can mistake artifacts from different runs for one consistent
result. `preview.ps1` correctly refuses to start a fresh preview after failed
validation; an existing viewer or direct Compose invocation can still serve the
last successful JSON.

**Possible fix:** Write each run's complete artifact set to its own directory.
Publish a single manifest or pointer to the last successful set after all gates
pass, retain the latest failed-run record separately, and display freshness in
the preview workflow. Use atomic file replacement or per-workspace locking to
avoid concurrent publication and partial JSON reads.

**Acceptance:** A failed rerun preserves one coherent last-successful artifact
set, exposes the failure separately, and does not mix reports across runs.

### F6 — P3: The migration comparator does not cover presentation settings

**Historical evidence:** `workspace_catalog.py` (retired)
normalizes model fields and view selections but omits styles, most view layout
settings, view descriptions and additional properties. The historical catalog
contains only elements, relationships and views in that normalized format.

**Reproduced:** Changing an element style background in parsed JSON produced no
semantic difference. Independently, the current style block was verified equal
to the previous tracked DSL, so this is an assurance gap rather than a detected
migration loss.

**Possible fix:** State the comparator's field coverage explicitly and add a
separate presentation comparison against a parsed historical workspace or a
deliberately captured style/layout baseline. Keep the one-time migration check
separate from normal validation so reviewed future changes remain possible.

**Acceptance:** A style or layout-spacing mutation is detected by the
presentation check; harmless ordering changes remain ignored.

## Duplication assessment

| Area | Finding | Recommendation |
|---|---|---|
| Reference elements | No duplicate identifiers or case-insensitive names within the same C4 owner | Keep current identities and boundaries |
| Reference relationships | No duplicate source/destination/description definitions | Preserve explicit directional actions and the two named HSM selections |
| Reference views | No exact duplicate selections for the same kind and scope | Retain the 95 stable view keys |
| Active files | No byte-identical files among the 247 active architecture files reviewed before adding this report | No blanket file deduplication is warranted |
| Repeated component names | Token connectors, WebSocket delivery and adapters recur in different owners | Keep them separate: ownership and runtime boundaries differ |
| Similar scenarios | PAM container/privileged-access views share 83% of relationship selections; Conjur container/secret-delivery views share 86% | Clarify each view's question and cross-link it to its scenario; do not merge merely because of overlap |
| Historical material | Legacy generators, catalogs, diagrams and documents intentionally repeat earlier content | Keep the history boundary explicit; exclude it from active duplicate enforcement |

The similarity percentages use intersection divided by union of relationship
selections, restricted to views with the same kind and scope. They are review
signals, not evidence that a diagram is redundant.

## Optimizations and team recommendations

### O1 — High value: Reduce relationship editing hotspots

[firefly.dsl](../../model/relationships/firefly.dsl) contains 282 relationships
across 1,973 lines; [integrations.dsl](../../model/relationships/integrations.dsl)
contains 253 across 1,770 lines. Together they hold 77% of all relationships.
These files are likely to attract overlapping edits as the team grows.

Split FireFly relationships by container or coherent runtime responsibility.
Split integrations by participating domain or owning integration scenario, with
each relationship defined once. Retain explicit ordered includes after all
element declarations, stable identifiers, and existing view selections. Use the
semantic comparator to verify this mechanical refactor.

### O2 — High value: Check identity ownership across initiatives

Current validation processes workspaces independently. It does not compare the
origin of definitions across unrelated initiatives, enforce shared-to-initiative
dependency direction, or associate the special DApp exemption with the ignition
entrypoint. The current files obey those policies.

Add a derived definition/provenance index covering all entrypoints. Treat one
definition inherited by several workspaces as reuse; flag separate definitions
of the same `architecture.id` in unrelated initiatives. Reject shared fragments
that depend on initiative folders. This supports stable-identity promotion
without requiring named CODEOWNERS before real team identities are available.

### O3 — Medium value: Reduce repeated validation work and bound retention

The measured validation run took about 20 seconds for the reference workspace
and 18 seconds for ignition. Each entrypoint starts four Docker commands:
validate, JSON export, full inspection, and error/warning inspection. All
initiatives are currently processed serially, and the repository-wide Markdown
link check repeats for each one.

Run repository-wide checks once per invocation, then consider bounded parallel
validation after artifact isolation is fixed. Investigate validating/inspecting
one fresh parsed JSON per workspace while retaining a DSL parse gate; verify
equivalence with the pinned image before changing behavior. Retain a bounded
number of parse runs. At review time, the two workspaces had nine retained JSON
parse copies totaling about 8.4 MiB, and the UUID directories have no retention
policy. Keep generated output under `build/architecture/`.

### O4 — Medium value: Make documentation checks repeatable

The current Markdown checker verifies common inline destination paths, but
skips fragment-only links, does not validate heading anchors, and does not cover
reference-style links. The use-case README records a previous rendering review;
the normal validator does not parse/render Mermaid or verify its annotated IDs.

Add a documented documentation-check command that verifies anchors, canonical
participant IDs and the paired diagram format. Run a pinned Mermaid render
check for changed diagrams. The 14 existing blocks and their participant IDs
passed this review's structural inventory; their layouts were not re-rendered
in this review.

### O5 — Medium value: Add a shared-change integration gate

There is no repository CI configuration. The README correctly requires every
initiative to be validated after shared changes, but this currently depends on
contributors running the command.

When the team's hosting/CI environment is selected, run all discovered
entrypoints and parser fault tests for shared model, style or tooling changes.
Publish workspace-specific failure reports. Keep named ownership enforcement
deferred as already agreed. Add a small initiative template or scaffolding
command so teams do not copy ignition's DApp-specific exception accidentally.

### O6 — Low effort: Simplify small maintenance surfaces

- [dsl_relationships.py](../../references/legacy/scripts/dsl_relationships.py) is not imported or
  invoked by any active script or test. Move it into legacy material, or retain
  only a tested, read-only relationship-selection audit with a documented user.
  Leave the actual named HSM relationships intact.
- Centralize the Structurizr version used by Python and Compose; currently the
  pin is repeated. Preserve the accepted version.
- Add consistent text line-ending/editor settings to reduce Windows/Linux
  contribution noise. Apply normalization as an explicit separate change.
- Add a `Proposed` style when the platform model grows. Current proposal status
  is clear in text and properties, but the tag has no dedicated visual style.
- Keep the large reference diagrams as navigation views and emphasize focused
  scenarios for discussion. The security landscape has 13 elements and 42
  relationships; density is a reason for visual review, not proof of a layout
  defect.
- Define how the temporary DApp restrictions will be retired when real design
  begins. The validator currently rejects DApp children, integrations and shared
  promotion by design. Evolve those checks in the same reviewed change that
  advances the initiative; retain ordinary connectivity requirements.

## Suggested implementation order

1. Fix F1 and F2; turn the reproduced initiative policy failures into regression
   tests. Add provenance checks from O2 while the initiative count is small.
2. Fix F3 and F4 before the next evidence refresh, using staged snapshots and
   explicit dependency preservation.
3. Fix F5 before introducing parallel runs or additional preview consumers.
4. Split the two relationship hotspots, preserving semantic equivalence.
5. Add presentation/documentation checks, CI integration and bounded artifact
   retention as focused follow-up changes.

## Evidence, reproducibility and limits

The original review used the following commands, which are now retired.
Use the [Docker-only workflow](../../../README.md#docker-only-workflow) for current commands.

```powershell
./architecture/scripts/validate.ps1
$env:C4_DOCKER_TESTS = '1'
python -B -m unittest discover -s architecture/scripts -p test_workspace_validation.py -v
python -B architecture/scripts/verify_migration.py
docker compose -f architecture/compose.yaml --profile tools config --format json
```

Review-specific probes and results are local generated artifacts:

- [Review evidence](../../../build/architecture/review-2026-09-19/evidence.json)
  and [reproduction script](../../../build/architecture/review-2026-09-19/review_evidence.py).
- [Failed-publication evidence](../../../build/architecture/review-2026-09-19/publication-probe.json)
  and [isolated reproduction script](../../../build/architecture/review-2026-09-19/publication_probe.py).
- [Reference validation](../../../build/architecture/reference/reports/validation-summary.md),
  [ignition validation](../../../build/architecture/initiatives/ignition/workspace/reports/validation-summary.md),
  and [migration comparison](../../../build/architecture/migration/semantic-comparison.json).

These files are ignored build outputs and are not required for a clean checkout.
The report above preserves the findings independently of them. The probes use
temporary fixtures under `build/architecture/`, remove those fixtures after use,
and verify source preservation. Evidence-refresh behavior was simulated locally;
no remote source refresh or product-version revalidation was performed.

This review does not certify deployed behavior, proprietary implementation
details, or diagram rendering quality. Compose configuration was resolved, but
existing preview containers were not restarted. The authored DSL, executable
tooling, ADRs and reference evidence were left unchanged; this report is the
durable deliverable.

## Implementation status

Updated: 2026-09-20. The first implementation of points 1–4 was subsequently
simplified under [decision 9](../../decisions/workspace/0009-container-only-tooling.md).
Teams now rely on native Structurizr validation and configurable inspections.
Historical evidence links above describe earlier implementations.

| Item | Current status |
|---|---|
| F1 / O2, F2 | Custom provenance, identity, dependency, coverage, prefix and duplicate-selection gates removed; team conventions are advisory |
| F3, F4 | Automatic evidence refresh and inventory audits retired; removed snapshots are available in Git history |
| F5 / O3 | Native Docker viewers read authored DSL; tools write the latest results and preserve successful artifacts after failure; custom run history and manifests retired |
| F6 | Presentation baseline preserved as historical evidence; automatic comparison retired |
| O1 | Ordered FireFly and integration relationship fragments remain active |
| O6 | Shared version pin, formatting settings, proposed style and initiative templates remain; no custom DApp validation rule |
| O4 / O5 | CI, documentation-check commands and Mermaid automation remain excluded; custom Markdown-link validation removed |

At the time of that migration, the reference contained 333 elements, 696 relationships and 95 views. The switch
to native-only validation preserved the parsed model and views. Current tests
cover native severity settings, workspace selection, flexible inheritance and
artifact safety. They do not enforce retired architecture policies.

Use the current [workflow](../../../README.md#docker-only-workflow).
Reports from the earlier implementation were selected by the historical
[reference status](../../../build/architecture/reference/status.json) and
[ignition status](../../../build/architecture/initiatives/ignition/workspace/status.json).
The simplified Docker workflow now writes the latest
[reference validation](../../../build/architecture/workspaces/reference/validation.json)
and [ignition validation](../../../build/architecture/workspaces/workspaces/ignition/workspace/validation.json)
directly.
