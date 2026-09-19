# Historical deployment reference

`deployment-reference.json` preserves the deployment-only catalog, six view
definitions, node-placement records and exact DSL blocks from the former full
workspace. It contains no duplicate logical model and is not another runnable
Structurizr workspace. The active model is the root `workspace.dsl`.

The archived DSL blocks refer to logical identifiers retained in the active
model. They would require a deliberate deployment review and reintegration
before use. Current generation and validation do not load them or validate
their topology, availability or recovery claims.

Existing files under `exports/` and older reports outside `reports/static/`
remain historical and unchanged. Legacy layout/export helpers in `scripts/`
are not invoked by the current validation entrypoint.
