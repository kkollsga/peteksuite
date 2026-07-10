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

- **Does:** own every managed agent, central todo, graph write, GitHub Actions
  operation, release, and cross-library initiative. Work inside one library is
  executed by a directly spawned owning-library agent through
  `run-library-task`; multi-library work uses `coordinate`.
- **Does NOT:** silently edit a library from the coordinator context or route
  managed work through inbox files. The coordinator scopes, spawns, supervises,
  verifies, and records; the owning agent edits its repository.

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

- `dev-docs/` — the single suite + owner-namespaced action index. Map:
  `dev-docs/README.md`.
- `inbox/` — external-project communication only. Managed libraries use direct
  agents. Map: `inbox/README.md`.

## Skills (central, version-controlled in `.agents/skills/`)

Use the skills — don't hand-roll their jobs:
- **`coordinate`** — run a cross-library initiative as gated phases (**one
  library / one migration step per phase**) using direct agents.
- **`run-library-task`** — spawn and supervise the owning sublibrary agent for
  any single-library task; preserve its technical gates and commit discipline.
- **`manage-actions`** — centrally inspect/change/dispatch/monitor repo-local CI
  and release endpoints. It never grants publishing authority.
- **`add-todo`** — capture any suite/library action in one central index with an
  explicit owner and owner-namespaced detail.
- **`dev-docs-cleanup`** — reconcile the central backlog and purge time-boxed state.
- **`read-inbox` / `notify`** — external projects only; never managed libraries.
- **`suite-status`** — roll up ecosystem readiness (each library's state + the
  graph's lifecycle dashboard + dependency-version coherence). The coordinator's
  "are we coherent to ship?" view.
- **`release`** — run the suite release train from here: prepare each subrepo
  independently, then publish in dependency waves (Tools → IO+Static → Sim →
  Suite). Raise downstream dependency floors only when code requires the new
  upstream API/fix, and advance on registry availability rather than waiting for
  unrelated GitHub Release/RTD jobs.

## Working style

- **Reproduce before fixing / claiming.** Confirm cross-library facts against the
  graph or the library itself before acting on them — evidence, not assumption.
- **No work dropped.** Every actionable finding gets an explicit owner in the
  central todo/graph state or is fixed by a directly supervised library agent.
- **Delegate, don't impersonate.** Spawn the owning library agent; keep control,
  authorization, Actions, todo, and release state in petekSuite.

## Git mode

petekSuite is a git repo. Cross-library initiatives use coordinator branches and
the full branch/PR checks; the planning graph remains gitignored working state at
`petekSuite/research/graph` and must still be saved through the `contract` MCP.

## Commits & releases

petekSuite is the sole release authority. Each repository retains a thin local
workflow as its GitHub/security boundary, but no library owns a release skill.
Invoking the suite-level **`release`** skill authorizes the coordinator to drive
the per-library release flows:
commit, push, dispatch Actions-owned tag/publish workflows, monitor them, and
make fix-and-recommit pushes needed to complete the release. Otherwise, the
coordinator does not bump or push library versions; it verifies ecosystem
coherence (`suite-status`) and coordinates sequencing. Commit format:
`type: short description`. Pushing outside `/release` requires explicit,
in-the-moment approval.
