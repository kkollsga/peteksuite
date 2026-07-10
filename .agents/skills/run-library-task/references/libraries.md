# Managed library profiles

| Library | Repository | Read first | Core local gates |
|---|---|---|---|
| petekTools | `petekTools/` | `CLAUDE.md`, then `SPEC.md`/`API.md` | fmt, clippy all targets/features, Rust tests, Python wheel/tests; benchmarks for kernels |
| petekIO | `petekIO/` | `CLAUDE.md`, then `SPEC.md`/`API.md` | fmt, clippy all targets/features, Rust tests, maturin wheel/develop, Python tests; never expose confidential data |
| petekStatic | `petekStatic/` | `CLAUDE.md`, then `SPEC.md`/`API.md` | fmt, clippy/test all features, default/minimal core, wheel/Python tests; perf/accuracy for geomodel kernels |
| petekSim | `petekSim/` | `CLAUDE.md`, `CLAUDE.local.md` if present, then `SPEC.md`/`API.md` | fmt, clippy/test workspace, wheel/Python tests, acceptance for product-path changes |

All paths resolve from the petekSuite root. Use documented Makefile/just targets
when they are stricter than this summary. Each library keeps architecture,
privacy, API, testing, and commit rules locally; petekSuite owns agents, todos,
graph writes, Actions, pushes, and releases.

