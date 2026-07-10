---
name: run-library-task
description: Execute work in one managed petekSuite library by resolving its repository, reading its technical contract, spawning and supervising the owning subagent directly, enforcing phased implementation and local gates, committing intentionally, and reporting results to the central graph/todo state. Use for any petekTools, petekIO, petekStatic, or petekSim task; never route managed work through inbox files or depend on sublibrary-local skills.
---

# Run a managed-library task

Operate from the petekSuite root. The coordinator owns scope, agent lifecycle,
state, and verification; the spawned agent owns edits inside one library.

## 1. Resolve ownership

Map the task to exactly one managed repo using
[`references/libraries.md`](references/libraries.md). Cross-library work belongs
to `coordinate`; a task with one code owner belongs here.

## 2. Load the contract

Read the target's tracked `CLAUDE.md`, then the relevant `SPEC.md`, `API.md`,
`CONTRIBUTING.md`, and source/test surface. Read the planning graph when a seam,
Task, Decision, or lifecycle Artifact is involved. Do not look for local skills,
local inbox routing, or a library-local todo index.

## 3. Establish the execution unit

- Small fix: one scoped implementation, one focused/full gate, one commit.
- Large feature/refactor: create a central owner-namespaced plan under
  `dev-docs/libraries/<library>/plans/`; split it into independently green phases
  with one component and one commit per phase.
- Cross-library discovery: stop and hand control to `coordinate`.

Never create a branch, push, publish, or change external state unless the user
authorized that action. Reuse the current safe branch when one already exists.

## 4. Spawn the owning agent directly

For implementation, use the collaboration subagent mechanism. If no slot is
available, wait or finish another agent before editing; never impersonate the
owner to bypass the limit. A purely read-only orientation/status lookup may be
performed directly by the coordinator when spawning would add no ownership or
verification value.

Give an implementation agent:

- absolute repository path and explicit edit boundary;
- the user outcome and acceptance criteria;
- required tracked technical documents and graph ids;
- focused and full gates from the library profile;
- commit/push authority boundaries;
- instruction to report files, tests, commit SHA, issues, and deviations.

Do not create an inbox message. Do not ask the agent to use deleted local skills.
For independent library tasks, parallel agents are allowed; serialize changes to
shared central state.

## 5. Supervise and verify

Keep the user updated. Inspect the diff and evidence yourself; do not accept a
subagent's `done` without checking status, gates, and the public contract. Fix or
send a follow-up until the target is clean and the requested outcome is real.

For behavior changes require focused regression coverage plus the repository's
full relevant gate. For workflow/docs-only changes validate syntax, references,
and `git diff --check` proportionally.

## 6. Close centrally

- Update graph Task/Artifact status and provenance when the task has graph state.
- Add, trim, or retire the owner-namespaced central todo when actionable state
  exists; do not create state for a read-only lookup.
- Keep technical designs/benchmarks in the library when code references their
  stable paths; centralize only actionable coordination state.
- Report commit SHA, gates, remaining issues, and whether anything was pushed or
  published.
