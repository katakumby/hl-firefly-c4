# 3. Isolate static validation and retain scope advisories

Date: 2026-09-18

## Status

Superseded in pipeline arrangement by [decision 7](0007-modular-workspaces.md).
The original decision below is retained as history.

## Context

The user requested full ecosystem coverage, Docker inspection, and no deployment
validation or diagram export in this phase.

## Decision

Generate full and static entrypoints from one logical model. Inspect only the
static entrypoint using the pinned official Structurizr image. Require zero
errors and warnings. Set only workspace.scope to informational because the
requested workspace describes multiple systems. Preserve every scope advisory
and its actual exit code; do not hard-code a finding count or suppress other
inspection categories. Independently audit the freshly parsed static model.

## Consequences

Full inspect may return nonzero for retained informational findings; the
error/warning gate must return zero. Temporary parsed JSON is audit input, not
a diagram export. Existing exports and deployment definitions are preserved.
