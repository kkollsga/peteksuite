---
name: add-todo
description: Capture any petekSuite or managed-library action in the single central backlog. Use for one-off tasks, audits, inbox findings, agent discoveries, and cross-library initiatives; assign an explicit owner, store detail in a central owner-namespaced plan/design file, deduplicate against the planning graph and existing todos, and add one lean backlink to petekSuite/dev-docs/todos.md.
---

# Add a central todo

All actionable state is indexed in `petekSuite/dev-docs/todos.md`. Managed
libraries do not own todo indexes.

## Classify and deduplicate

Read the central index and relevant graph nodes. Drop acknowledgements and
completed history. Merge duplicates by outcome, not wording.

Assign exactly one owner: `petekSuite`, `petekTools`, `petekIO`, `petekStatic`,
`petekSim`, or an external project. Cross-library work is owned by petekSuite;
library code work keeps its library owner even though the coordinator manages it.

## Store detail

- Cross-library/suite detail: `dev-docs/plans/` or `dev-docs/designs/`.
- Library action detail: `dev-docs/libraries/<library>/plans/<slug>.md`.
- Library durable state roll-up: `dev-docs/libraries/<library>/todos.md`.

Link retained library technical designs instead of copying them. What-to-build
contracts also get a graph Task/Question; todos track execution, not replace the
graph.

## Add one lean line

Use:

`- <emoji> **<title>** (owner: <owner>) -> [<detail>](<detail>) — <short hook>. Surfaced <YYYY-MM-DD>.`

Keep detail out of the index. Report owner, detail path, and whether the item was
new or merged. This skill adds/updates; pruning belongs to `dev-docs-cleanup`.

