# 3. Use in-cluster stateful services and fenced recovery

Date: 2026-09-15

## Status

Accepted

## Context

The requested reference keeps runtime services on AKS across three zones and permits brief recovery interruptions.

## Decision

Use separate member namespaces, three-instance CloudNativePG clusters, one required synchronous standby, dedicated ZRS volumes and single-active member runtimes. Preserve identities and configuration. Require fencing before replacement after ambiguous node failure.

## Consequences

This illustrates crash recovery, not arbitrary active-active scalability. Volume survival does not preserve Data Exchange's in-memory queue. Automatic failover is conditional on the deployment's safe fencing capability; otherwise operator action is required. Namespace isolation shares the cluster administrator's trust boundary.

