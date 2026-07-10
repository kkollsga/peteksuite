---
name: coordinate
description: Run a cross-library petekSuite initiative as a gated phased plan using the planning graph, central owner-namespaced todos, and directly supervised sublibrary agents. Use for migrations, extractions, seam changes, or initiatives spanning two or more managed libraries. Never route managed work through inboxes or depend on sublibrary-local skills.
---

# Coordinate a cross-library initiative

Operate from petekSuite. Split work into one library or one migration seam per
phase; keep every phase independently green and committable.

## Investigate

Before editing, read the relevant graph Decisions/Questions/Tasks and each
affected library's tracked technical contract. Use read-only exploration agents
and the code-review graph to measure callers and blast radius. Read central
owner-namespaced todos; do not inspect deleted local skill/inbox systems.

## Plan and approve

Write `dev-docs/plans/<slug>.md` with outcome, invariants, risks, graph ids, and
numbered phases ordered by the dependency DAG. Each phase names one owner, the
seam, and its proof. Add one lean central todo backlink. Present the plan and wait
for explicit approval before implementation.

## Execute

For each phase:

1. Claim or MERGE the graph Task as `in_progress`, owner `petekSuite`.
2. Invoke `run-library-task` to spawn the owning library agent directly. Never
   use `notify` for a managed library.
3. Verify the producer and consumer seam yourself, including downstream gates.
4. Record graph Task/Artifact status, SHA, tests, and provenance.
5. Update or retire the central owner-namespaced todo.

Parallelize independent library phases when safe, but serialize central graph and
todo writes. Stop only for a real architectural or authority blocker.

## Close

Run `suite-status`, validate every affected repo is clean/coherent, archive the
plan, and report phases, commits, gates, issues, todo changes, deviations, and
whether anything was pushed or published.

