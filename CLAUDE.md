# petekSuite — the coordinator

This is the **suite root**, and the home of the **coordinator agent**. petekSuite
is not a library — it builds no code of its own. It **coordinates** the peer
libraries that make up the subsurface-modelling ecosystem, keeps their seams
coherent, routes work between them, and tracks the whole against the plan.

## The ecosystem — 3 vertical layers + 1 horizontal toolkit

Dependencies flow **one direction, downward only** (no cycles, no sideways
sharing of code).

```
petekIO      DATA       ingest·normalize·validate·interpret → model-ready inputs (data only; NO framework)
   ↓
petekStatic  GEOMODEL   structural framework (horizons+faults+zones)·grid construction·
   ↓                     property modelling (facies/petro, geostatistics, trend population, log
                         upscaling)·volumetrics + static uncertainty (GRV/in-place, MC over
                         model realizations, tornado; FVF as input) → StaticModel + P-curves
petekSim     SIMULATION dynamic/engineering simulation (recoverable·forecast: decline, p/z,
                         material balance; later full dynamic flow)·PVT·the product
                         (`peteksim` — the Python-facing appraisal toolkit, a facade over the stack)

petekTools   TOOLKIT    horizontal, shared, domain-agnostic: numeric kernels (gridding/kriging/
                         warm-start/geostat) + units + the liftable pproj container + the viewer
                         unit (generic bundle renderer, wheel package data). Serves all layers.
```

**Today:** all four libraries exist as sibling folders under `petekSuite/`
(petekStatic extracted 2026-07-01; graph decisions `decision_static_layer` /
`decision_petektools_rebrand` / `decision_master_structure` all **done**). The
long-term sequencing is the graph's **`plan_suite_roadmap`** (phases P1..P6;
every task carries `phase` + `owner` = the library agent that does it).

## The coupling rule (the one rule that keeps them a family, not a monolith)

Share **conventions** freely; share **code** only **downward** through the DAG,
never sideways. Each library must stay **usable standalone**. When in doubt,
duplicate a small type and convert at the seam rather than introduce a shared
dependency. The shared conventions are the **petek family house style**
(canonically `petekSuite/dev-docs/petek-house-style.md`) — every library's
`CLAUDE.md` embodies it; the coordinator upholds it across seams.

## The coordinator's job (what this agent does — and doesn't)

- **Does:** own managed agents, central todos, graph writes, Actions, releases,
  and cross-library initiatives. A single-library task is executed by a directly
  spawned owning agent through `run-library-task`.
- **Does NOT:** route managed work through inboxes or silently edit a library as
  the coordinator. It scopes, supervises, verifies, and records the owning
  agent's work.

## The planning graph is the hub

The **planning graph** (`petekSuite/research/graph/research.kgl`, served by the
`contract` MCP) is the cross-library single source of truth — the architecture,
the inter-library contracts, decisions, open questions, the long-term
**`plan_suite_roadmap`**, and every component's lifecycle (spec · tests · review
· bench · accuracy · freshness). **Reach for it on anything cross-cutting** and
write results back; don't keep coordination state in your head or scattered
docs. Discipline: **MERGE on id, never CREATE**; runtime nodes only
(`Question`/`Decision`/`Artifact`/`Task`) — never touch managed research nodes;
stamp provenance (`git_sha`, `modified_by="petekSuite"`); write discipline in
`research/graph/README.md`.

## Working folders (both gitignored)

- `dev-docs/` — one suite + owner-namespaced action index. Map: `dev-docs/README.md`.
- `inbox/` — external-project communication only. Map: `inbox/README.md`.

## Skills (central, version-controlled in `.agents/skills/`; `.claude/skills` symlinks there so Claude and Codex load the same tree — managed sublibraries carry no skills, only coordinator-organized agents)

Use the skills — don't hand-roll their jobs:
- **`coordinate`** — gated multi-library initiatives using direct agents.
- **`run-library-task`** — directly supervise the owning sublibrary agent.
- **`manage-actions`** — centrally operate repo-local Actions endpoints.
- **`add-todo`** / **`dev-docs-cleanup`** — own one central owner-namespaced backlog.
- **`read-inbox`** / **`notify`** — external projects only.
- **`suite-status`** — roll up ecosystem readiness (each library's state + the
  graph's lifecycle dashboard + dependency-version coherence). The coordinator's
  "are we coherent to ship?" view.
- **`release`** — the only publishing authority; prepare through direct agents
  and dispatch/monitor dependency-wave workflows through `manage-actions`.

## Working style

- **Reproduce before fixing / claiming.** Confirm cross-library facts against the
  graph or the library itself before acting on them — evidence, not assumption.
- **No work dropped.** Every action gets a central owner or is fixed directly.
- **Delegate, don't impersonate.** Spawn the owning agent and verify its work.

## Git mode

petekSuite and all four managed libraries are git repositories. The graph and
central operational state remain gitignored and are persisted through their
own graph/dev-docs mechanisms.

## Commits & releases

petekSuite is the sole release authority. Repositories retain thin local Actions
entrypoints for credentials/triggers, centrally dispatched by `release` through
`manage-actions`. Outside an explicit release, pushing requires in-the-moment
approval. Commit format: `type: short description`.
