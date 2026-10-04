---
name: ethereum-standards
description: Find, compare, implement, and review Ethereum ERC/EIP requirements using a local Markdown collection of every canonical proposal in the recorded official snapshots. Use for named standards, token and contract interfaces, protocol proposals, and conformance checks.
---

# Ethereum standards

Load only the standards needed for the task. All proposal statuses and EIP categories are included; the collection is dated, not automatically refreshed.

- **Known identifier:** read `standards/erc/erc-N.md` or `standards/eip/eip-N.md`. Each file links to its official pinned source.
- **Discover candidates:** search the small [category indexes](references/sources.md#catalogs) with `rg -n -i 'keywords' <skill-directory>/references/index/`. Do not load every index or standard into context.
- **Read precisely:** find headings with `rg -n '^#{1,6} ' FILE`, then read the relevant line range. Inspect specification, compatibility, security, and applicable `requires` dependencies. Requirements can appear outside a section named Specification.
- **Moved EIP:** search [migrations.md](references/migrations.md), then read its canonical ERC. EIP-1 and the ERCs repository's process copy, indexed as ERC-1, remain distinct.
- **Implement or review:** read [conformance.md](references/conformance.md) when needed. Preserve MUST/SHOULD/MAY distinctions, optional behavior, and status.

For current-status questions, verify the relevant live primary source without replacing this snapshot. Final status does not prove chain activation or implementation security.

Only Markdown is bundled. Figures, code attachments, papers, and other omitted assets remain upstream links; retrieve them only if the task needs them. For provenance or an explicitly requested update, read [sources.md](references/sources.md). No scripts, dependencies, database, or runtime installation are needed.
