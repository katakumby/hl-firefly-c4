# 4. Keep source evidence and executable architecture checks

Date: 2026-09-15

## Status

Accepted

## Context

A parser-valid diagram can still omit a component, connect the wrong member database, or claim an invalid quorum.

## Decision

Pin official source revisions, retain element-to-view coverage, define each logical implementation once and instantiate it for the three members, run Docker validate and inspect, audit the rendered JSON, and inspect SVG layouts. Use workspace scope none because this deliverable intentionally includes several software systems at all three C4 levels.

## Consequences

The generator is the maintainable source; workspace.dsl is directly loadable without a Python runtime. Only workspace.scope is classified as informational: Structurizr recommends one software system per workspace, whereas this requested deliverable explicitly requires the whole consortium. All four scope findings remain visible in the complete inspect report. No global inspection suppression is used; every other inspection retains its default severity. Passing model checks is not a live deployment or a substitute for failover testing.

