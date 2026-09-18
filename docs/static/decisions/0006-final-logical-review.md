# 6. Correct runtime boundaries and group related products

Date: 2026-09-19

## Status

Accepted. Supersedes decision 0001's treatment of the browser Explorer as a Core
component and decision 0005's frozen model counts. The single-workspace decision
and all existing view keys remain in force.

## Decision

Represent Explorer and Sandbox browser code as containers separate from their
servers. Represent Core and FFTM PostgreSQL databases separately by data ownership;
remove the standalone PostgreSQL standby from the active logical model.

Use same-level Structurizr groups for related product ecosystems. These are
navigation groups, not ownership, security or deployment boundaries. Preserve
separate AD DS, AD FS, Entra ID and Keycloak systems, and separate PAM and Conjur
systems. Distinguish Besu client components from application contracts hosted by
its EVM with component groups and the existing evidence classifications.

Retain repeated responsibilities in independent runtimes, including each token
connector and embedded dependency copy. Rename the FFTM WebSocket component so
it no longer overlaps the separate webhook responsibility. Keep proprietary
managed-service subdivisions explicitly identified as logical abstractions.

## Consequences

The PostgreSQL standby identifier is retired. Browser responsibilities move to
new containers; the Sandbox server identifier is retained. All existing view
keys remain stable, with extra contexts and browser views added. Historical
deployment archives and exports are unchanged and require an explicit migration
before reuse with these revised logical identifiers.

Validation now checks parsed group membership and view scopes, unique directed
relationships, relationship coverage, connected diagrams and process boundaries.
Details and source links are recorded in the final architecture review.
