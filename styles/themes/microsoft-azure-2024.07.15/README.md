# Microsoft Azure icons only

The official [Structurizr Azure 2024.07.15 theme](https://github.com/structurizr/themes/tree/67da2b503abc708f941e5aa2ea35dd553f742c3a/microsoft-azure-2024.07.15)
is the latest icons-only version listed in the Structurizr catalogue when selected
on 2026-10-04. This local subset contains the 11 service icons used by the deployment
model. Original tag names and PNG bytes are preserved; icons are embedded as data
URIs so both the web UI and offline native exports resolve the same assets.
There are no colour, shape, size or relationship overrides.

`icons.json` is a checked-in theme dependency, not generated architecture output.
`sources.json` records the pinned upstream revision and SHA-256 hashes. To add an
Azure service, take its exact tag and icon from that revision, embed the unchanged
PNG, and record its hash. Apply Azure tags only to deployment elements. Do not use
a different service's icon when the selected theme has no matching entry.

The theme JSON is copyright Structurizr Limited and licensed under Apache 2.0;
see `LICENSE`. Azure icons remain copyright Microsoft. See the
[Microsoft Azure icon guidance](https://learn.microsoft.com/azure/architecture/icons/)
and [upstream licensing](https://github.com/structurizr/themes#license).
