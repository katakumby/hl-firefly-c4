# 1. Model runtime boundaries and documented extension status

Date: 2026-09-18

## Status

Accepted

## Context

FireFly combines in-process plugins, separately running connectors, embedded
libraries and third-party infrastructure. Treating every package as a service
or every documented extension as a completed implementation misstates it.

## Decision

Use C4 levels 1–3. Give independent processes and stores container boundaries;
group embedded responsibilities as components. Include all documented FireFly
connectors and tools, with source coverage classifications for libraries,
support code and examples. Detail Besu, while other infrastructure stops at its
integration interface. Model the identity placeholder and Corda starter with
their actual implementation limitations. Reuse existing logical identifiers.

## Consequences

Optional configurations use separate views. Source coverage is broader than
Core top-level packages, but is not a class-level inventory. No code diagrams
or proprietary vendor implementation claims are introduced.
