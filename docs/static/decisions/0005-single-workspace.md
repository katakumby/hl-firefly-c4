# 5. Use one canonical workspace and readable static relationships

Date: 2026-09-19

## Status

Accepted

## Decision

Use only `workspace.dsl` and `model-catalog.json` for the active C4 levels 1–3
model. Remove the duplicate static entrypoint and catalog. Archive the historical
deployment-only catalog and exact DSL fragments in
`archive/deployment-reference.json`; do not emit or load them during generation.
Historical exports remain unchanged and are not a preview of the current model.

Emit ordinary relationships anonymously and select their static view arrows
using readable source-to-destination expressions. Retain only
`hsmWorkloadTokenRequest` and `hsmWorkloadTokenResponse` as named relationships,
because the HSM example selects a subset of arrows between the same endpoints.
Do not use generated hashes, numeric aliases or bulk relationship variables.
Reject an ambiguous partial selection unless it has an explicit descriptive
name; never broaden it silently to all arrows between those elements.

The validation entrypoint always runs the static workflow. Its older switches
remain accepted for compatibility. Validate the parsed elements, labels,
protocols and exact view relationships against the single catalog. Check that
the archive and exports are untouched by generation and validation.

## Consequences

The consolidation changes representation and maintenance paths only. All 331
logical elements, 673 relationships and 89 static view definitions are retained.
Deployment generation, dual-workspace comparisons and opaque relationship
identifiers no longer complicate the active source.
