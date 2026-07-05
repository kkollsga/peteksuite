# petekSuite

**petekSuite** is the umbrella for a subsurface-modelling ecosystem: a small
family of Rust libraries (with Python bindings) that take raw subsurface data all
the way to static volumes and dynamic forecasts.

The suite root itself builds no code — it **coordinates** the peer libraries,
keeps their seams coherent, and holds the shared conventions that make them a
family rather than a monolith. Dependencies flow **one direction, downward only**
— no cycles, no sideways sharing of code. Libraries share *conventions* freely
and share *code* only downward through the graph; each library stays usable
standalone.

```
   petekIO      DATA        ingest · normalize · validate · interpret
      │                     → model-ready inputs
      ▼
   petekStatic  GEOMODEL    structural framework · grid · property modelling
      │                     · volumetrics + static uncertainty → StaticModel
      ▼
   petekSim     SIMULATION  dynamic / engineering forecast · PVT ·
                            the `peteksim` Python product facade

   petekTools   TOOLKIT     horizontal · shared · domain-agnostic:
                            numeric kernels + units + container + viewer
```

## The four libraries

| Library | Layer | What it does |
|---|---|---|
| [**petekTools**](libraries/petektools.md) | TOOLKIT | Domain-agnostic numerics: scattered-data gridding / kriging / warm-start / SGS kernels, a units system, the liftable container, and the generic bundle viewer. A pure leaf — serves every layer. |
| [**petekIO**](libraries/petekio.md) | DATA | Ingests, normalizes, validates and interprets subsurface files (surfaces, wells, tops, logs) into clean, **model-ready inputs**. |
| [**petekStatic**](libraries/petekstatic.md) | GEOMODEL | Turns model-ready inputs into a populated **StaticModel** — framework + grid + property cubes — and owns **volumetrics + static uncertainty** (GRV / in-place, Monte-Carlo, P-curves). |
| [**petekSim**](libraries/peteksim.md) | SIMULATION | Dynamic / engineering simulation (decline, p/z, material balance, PVT) and **the product** — `peteksim`, the single Python-facing facade over the whole stack. |

## Where to start

<div class="grid cards" markdown>

- :material-download: **[Install](getting-started/install.md)** — the cargo + pip matrix and the pinned versions.
- :material-sitemap: **[Architecture & the DAG](getting-started/architecture.md)** — the four layers, the coupling rule, the seams.
- :material-school: **[Tutorials](tutorials/index.md)** — one guide per workflow, from data ingest to the flagship static-model build.
- :material-notebook: **[Notebooks](notebooks/index.md)** — eight fully executed, runnable notebooks on synthetic data.
- :material-book-open-variant: **[Reference](reference/index.md)** — the Python API for each wheel + Rust docs.rs links.
- :material-image-multiple: **[Gallery](gallery/index.md)** — the viewer on a synthetic asset.

</div>

!!! note "Everything here runs on synthetic data"
    Every example, tutorial and notebook in this site is built on **fully
    synthetic** subsurface data generated from deterministic seeds — fictional
    fields, wells and coordinates. No confidential dataset is referenced or
    embedded anywhere.
