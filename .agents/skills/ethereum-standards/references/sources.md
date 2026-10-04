# Sources and maintenance

Snapshot date: **2026-10-04**. Includes **1,210 canonical documents**: 617 from ERCs and 593 from EIPs. Every status and category is retained. The 365 moved EIP stubs are excluded and recorded in [migrations.md](migrations.md).

| Repository | Pinned commit | Canonical documents |
|---|---|---:|
| [EIPs](https://github.com/ethereum/EIPs) | `3b3c832577ec4205d463d990d52006e299962449` | 593 |
| [ERCs](https://github.com/ethereum/ERCs) | `365b4c02879f3e882b91281d42b4f57b406205e9` | 617 |

## Catalogs

- [Core](index/core.md): 438 documents.
- [Erc](index/erc.md): 616 documents.
- [Informational](index/informational.md): 23 documents.
- [Interface](index/interface.md): 59 documents.
- [Meta](index/meta.md): 44 documents.
- [Networking](index/networking.md): 30 documents.

Use qualified identifiers. The ERCs process document originally lives at `ERCS/eip-1.md`; its local name is `standards/erc/erc-1.md` to keep it distinct from the EIPs repository's `EIPS/eip-1.md`. Number-only dependencies involving 1 need source context.

## Preservation and links

All original preamble fields, prose, inline code, tables, and test vectors in the canonical Markdown documents are retained. Each document adds a pinned source citation. Relative links to retained standards are adjusted for the local layout; references to omitted assets and supporting files point upstream. Existing defective upstream references may remain defective; a source link is not a claim that every cited destination works.

The collection does not contain repository clones, historical revisions, images, PDFs, standalone code assets, build files, scripts, dependencies, databases, or raw audit records. See [LICENSE.md](../LICENSE.md) for the shared upstream CC0 text. Respect any per-document notices.

## Explicit refresh only

When an update is requested, resolve the current commits of `ethereum/ERCs` and `ethereum/EIPs`, enumerate `ERCS/*.md` and `EIPS/*.md` using complete Git tree listings, and fetch only those Markdown files at the resolved commits. Do not clone or download whole repositories. Fetch the upstream Markdown license if it changes.

Exclude entries marked Moved, record their targets in the Markdown migration audit, retain all other statuses/categories, and rebuild the small category indexes. Keep both process documents numbered 1. Preserve source content except for provenance and link adjustments. Update the recorded commits and date.

Stage the Markdown-only replacement outside the installed skill. Check every upstream document is represented either by a canonical document or a migration entry, verify preserved prose/code against source, validate local file links and index coverage, and confirm every retained file ends in `.md`. Replace the installed directory only after those checks pass. Do not refresh during ordinary lookup.
