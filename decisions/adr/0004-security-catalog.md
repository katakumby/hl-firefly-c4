# 4. Add a security product reference catalog with explicit evidence limits

Date: 2026-09-19

## Status

Accepted

## Context

The workspace needs reusable C4 levels 1–3 for identity, privileged access,
application secrets and HSM-backed cryptography. These products do not form one
mandatory FireFly deployment. Public documentation does not disclose every
proprietary implementation boundary.

## Decision

Model Keycloak, Azure Managed HSM, CyberArk PAM Self-Hosted, Conjur Enterprise,
Microsoft Entra ID, AD DS and AD FS as seven separate software systems. Use
documented runtime boundaries where available and clearly label inferred
proprietary components and managed-service subdivisions as logical reference
abstractions. Keep data stores separate from application responsibilities
without implying independently deployed database servers for owned stores.

Use Conjur Enterprise, documented as Secrets Manager Self-Hosted, including the
Vault Synchronizer. Do not attribute enterprise synchronization to Conjur OSS.
Use Cloud Sync's agent and provisioning service for the directory-sync example.
LDAP credential validation, browser federation and directory provisioning are
separate flows. IAM users are distinct from FireFly consortium identities.

Model optional integrations with existing member applications and a generic
managed SSH target. Introduce an application-owned proposed HSM signing adapter
for the DLT example; do not modify the documented FireFly Signer filesystem
wallet. Require explicit Ethereum digest/signature compatibility verification
before such an adapter is implemented. The example uses non-exportable keys,
with HSM private key material never delivered to applications.

Give relationships precise actions, payloads and mechanisms. Select relationships
by stable DSL identifiers so focused views can exclude competing paths even
when arrows share endpoints. Add only static C4 view types. Preserve existing
deployment definitions and historical exports unchanged; they remain deferred.

Decision 0005 consolidates the active DSL into one workspace, archives these
deployment definitions separately, and limits relationship identifiers to two
descriptive names required for precise selection of parallel arrows.

## Consequences

Every product gets a context view, container view and component coverage.
Documentation-backed security coverage is separate from the FireFly code-source
inventory. Recorded sources include fingerprints and capture methods; CyberArk
web-reader excerpts are explicitly distinguished from complete HTML snapshots.
These diagrams neither provision products nor verify runtime interoperability.
