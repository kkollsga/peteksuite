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
`AGENTS.md` embodies it; the coordinator upholds it across seams.

## The coordinator's job (what this agent does — and doesn't)

- **Does:** sequence cross-library initiatives (`coordinate`), route work to the
  owning library (`read-inbox` → `notify`), track ecosystem coherence
  (`suite-status`), keep the cross-library contracts/seams in `dev-docs/designs/`,
  and hold the plan against the graph.
- **Does NOT:** build or refactor a library's internals from here. A task scoped
  to one library is **routed to that library's inbox** and done by that library's
  agent, in its own `dev-docs/`. The coordinator plans and connects; it does not
  reach in.

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

- `dev-docs/` — cross-library plans/designs + `todos.md`. Map: `dev-docs/README.md`.
- `inbox/` — the coordinator's channel + routing hub. Map: `inbox/README.md`.

## Skills (in the gitignored `.Codex/`)

Use the skills — don't hand-roll their jobs:
- **`coordinate`** — run a cross-library initiative as gated phases (**one
  library / one migration step per phase**). The manager analog of a phased plan.
- **`add-todo`** — capture a coordination thread into `todos.md` + a `plans/` doc.
- **`dev-docs-cleanup`** — tidy the working folder; purge time-boxed dirs.
- **`read-inbox`** — triage the coordinator inbox; **route** library-scoped tasks
  down to the owning library.
- **`notify`** — send a note to a managed library or an outside sibling. Sign as
  **`petekSuite`**. Never hand-read/write inbox files.
- **`suite-status`** — roll up ecosystem readiness (each library's state + the
  graph's lifecycle dashboard + dependency-version coherence). The coordinator's
  "are we coherent to ship?" view.
- **`release`** — run the suite release train from here: check each subrepo one
  by one, sweep docs/changelog against the release diff, bump patch by default
  unless the user specifies otherwise, run gates, commit/tag, push with explicit
  approval, then monitor CI/release/RTD before moving to the next repo.

## Working style

- **Reproduce before fixing / claiming.** Confirm cross-library facts against the
  graph or the library itself before acting on them — evidence, not assumption.
- **No coordination dropped.** A surfaced cross-library issue gets a `todos.md`
  thread or a routed note — never silently stepped over.
- **Route, don't hoard.** Keep only genuinely cross-library work here; push the
  rest down to the owning library.

## Pre-git mode

petekSuite is **not yet a git repo** (the graph HAS moved here — it lives at
`petekSuite/research/graph`). Until `git init` happens, `coordinate`'s branch/PR
steps and `suite-status`'s push/publish coherence checks run in a local, pre-git
mode. Activate the full flow once git lands.

## Commits & releases

Each library releases **itself** (per-library release artifacts and workflows).
When the owner invokes the suite-level **`release`** skill, that invocation is
authorization to drive the per-library release flows one subrepo at a time:
commit, tag, push, monitor CI/release workflows, and make fix-and-recommit pushes
needed to complete the release. Otherwise, the coordinator does not bump or push
library versions; it verifies ecosystem coherence (`suite-status`) and
coordinates the sequencing. Commit format (once this folder is under git):
`type: short description`. Pushing outside `/release` requires explicit,
in-the-moment approval.
