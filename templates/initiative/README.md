# Initiative template

Copy the `.template` files recursively, preserving their directories, into a new `workspaces/<epic-id>/`
directory, removing the suffix and replacing `<epic-id>`. Copy
`README.md.template` as the initiative README. Add an agreed model and focused
views before validating. Empty templates are intentionally incomplete and are
not discovered as entrypoints.

The workspace extends the shared model and uses native missing-view informational
settings for inherited elements. Teams can adjust inspection properties in DSL.
The starter keeps local model definitions and C4 views inline in `workspace.dsl`
for convenient editing and autocomplete. Extract `model.dsl`, `views/` or other
fragments with native `!include` only when that helps the workspace grow; those
files are optional and do not require a preparation script.
Global styles, including the `Planned` and `Available` tags, are inherited from
[styles.dsl](../../styles/styles.dsl); no separate style include is needed.
Stable identifiers, proposal evidence/status properties, connected views and
`<epic-id>-` keys are recommended conventions; no custom validator enforces them.
Variants normally extend the initiative and use `<epic-id>-<variant>-` for new
view keys. Custom validation can be introduced progressively as teams mature.

Add a service under `services:` in [compose.yaml](../../compose.yaml), replacing
`<epic-id>` and assigning an unused localhost port (8083 in this example;
the existing viewers use 8080–8082):

```yaml
  <epic-id>:
    <<: *viewer
    command: ["local", "/usr/local/structurizr/workspaces/<epic-id>"]
    ports:
      - "127.0.0.1:8083:8080"
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

Keep local C4 views inline or in optional `views/` fragments, standalone
PlantUML/Mermaid diagrams in `uml/`, and explanations in `docs/`.
The starter's `!docs .` attaches the initiative README to the viewer. Change it to
`!docs docs` if the workspace should publish those design notes instead.
`validate` and `build-source` discover new
`workspaces/**/workspace.dsl` entrypoints automatically; a Compose service is
needed only for an interactive viewer. Run validation after replacing placeholders:

```text
docker compose run --rm --pull never tools validate --workspace workspaces/<epic-id>/workspace.dsl
docker compose run --rm --pull never tools build-source --workspace workspaces/<epic-id>/workspace.dsl
```

The shared model supplies definitions and styles, not the root workspace's views.
Local changes stay isolated until reviewed promotion. See the
[repository layout](../../README.md#layout-and-ownership) and
[generated output layout](../../README.md#outputs-and-maintenance).

Follow the [contribution workflow](../../README.md#contributing-an-initiative).

Use explicit view references for required dependencies: deleting a referenced
element then fails native validation. Generic big-picture views may intentionally
use `include *` or selectors and change membership with the model. Review those
artifact changes; no additional build rule enforces membership. A coordinated
model/view removal is valid when all references are updated in the same change.
