# Initiative template

Copy the `.template` files recursively, preserving their directories, into a new `workspaces/<epic-id>/`
directory, removing the suffix and replacing `<epic-id>`. Copy
`README.md.template` as the initiative README. Add an agreed model and focused
views before validating. Empty templates are intentionally incomplete and are
not discovered as entrypoints.

The workspace extends the shared model and uses native missing-view informational
settings for inherited elements. Teams can adjust inspection properties in DSL.
Global styles, including the `Proposed` tag, are inherited from
[styles.dsl](../../styles/styles.dsl); no separate style include is needed.
Stable identifiers, proposal evidence/status properties, connected views and
`<epic-id>-` keys are recommended conventions; no custom validator enforces them.
Variants normally extend the initiative and use `<epic-id>-<variant>-` for new
view keys. Custom validation can be introduced progressively as teams mature.

Add a service under `services:` in [compose.yaml](../../compose.yaml), replacing
`<epic-id>` and assigning an unused localhost port (8082 in this example):

```yaml
  <epic-id>:
    <<: *viewer
    command: ["local", "/usr/local/structurizr/workspaces/<epic-id>"]
    ports:
      - "127.0.0.1:8082:8080"
```

Start the initiative directly from the repository root:

```text
docker compose up -d <epic-id>
```

Structurizr reads the selected directory's authored `workspace.dsl` directly.
No preprocessing is required. After DSL edits, refresh the browser.
Plain `docker compose up -d` from the repository root starts all defined viewers.
For a variant, add a separate service with the variant's workspace directory
and another unused localhost port.

Follow the [contribution workflow](../../README.md#contributing-an-initiative).
