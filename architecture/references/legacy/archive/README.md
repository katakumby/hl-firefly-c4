# Historical deployment reference

`deployment-reference.json` preserves the deployment-only catalog, six view
definitions, node-placement records and exact DSL blocks from the former full
workspace. It contains no duplicate logical model and is not another runnable
Structurizr workspace. The active reference entrypoint is
[architecture/workspace.dsl](../../../workspace.dsl).

The archived DSL blocks refer to logical identifiers retained in the active
model. They would require a deliberate deployment review and reintegration
before use. Current validation does not load them or validate
their topology, availability or recovery claims.

The sibling [exports](../exports), [reports](../reports) and [scripts](../scripts)
directories are historical material. Their helpers are not invoked by the
current validation entrypoint.
