# petekSuite

**petekSuite** is the umbrella for a subsurface-modelling ecosystem: a small
family of Rust libraries (with Python bindings) that take raw subsurface data all
the way to static volumes and dynamic forecasts. The suite root itself builds no
code — it coordinates the peer libraries, keeps their seams coherent, and holds
the shared conventions ("the petek house style") that make them a family rather
than a monolith.

Dependencies flow **one direction, downward only** — no cycles, no sideways
sharing of code. Libraries share *conventions* freely and share *code* only
downward through the graph; each library stays usable standalone.

```
                          ┌─────────────────────────────────────────┐
   petekIO      DATA      │  ingest · normalize · validate ·         │
      │                   │  interpret → model-ready inputs          │
      ▼                   └─────────────────────────────────────────┘
   petekStatic  GEOMODEL   structural framework · grid · property
      │                    modelling · volumetrics + static uncertainty
      ▼
   petekSim     SIMULATION dynamic / engineering forecast · PVT ·
                           the `peteksim` Python product facade

   petekTools   TOOLKIT    horizontal · shared · domain-agnostic:
                           numeric kernels + units + container + viewer
                           (serves every layer)
```

## The libraries

### petekIO — the DATA layer
Ingests, normalizes, validates, and interprets subsurface data (wells, surfaces,
logs, seismic) into clean, **model-ready inputs**. A standalone Rust data-model +
IO library with optional PyO3 bindings — data only, no modelling framework.
Composes mature crates (`las_rs`, `geo`/`geozero`, `ndarray`, `rstar`,
`giga-segy`) behind its own IO traits.

### petekStatic — the GEOMODEL layer
Turns model-ready inputs into a populated **StaticModel**: the structural
framework (horizons + faults + zones), grid construction, and property modelling
(facies/petrophysics, geostatistics, trend population, log upscaling). It owns
**volumetrics + static uncertainty** — GRV / in-place volumes off the model
itself, Monte-Carlo over model realizations, and tornado analysis — producing a
StaticModel plus probabilistic (P90/P50/P10) curves.

### petekSim — the SIMULATION layer
Dynamic and engineering simulation: recoverable volumes and forecasting (decline,
p/z, material balance, and later full dynamic flow), plus PVT. It ships **the
product** — `peteksim`, the Python-facing appraisal toolkit that presents the
whole stack behind one façade.

### petekTools — the horizontal TOOLKIT
Domain-agnostic, shared numerics that serve every layer: the scattered-data
gridding / kriging / warm-start / geostatistics kernels Rust lacks, a units
system, the liftable container format, and a generic bundle viewer. A pure leaf —
it depends on none of the others; they build on it.

## Install

The whole suite installs with one command:

```sh
pip install peteksuite     # the meta-package: pulls all four libraries
```

Every library is also **directly installable** from both crates.io (Rust) and
PyPI (Python) — one crate and one wheel per library:

| Library      | version | pip                        | Status              |
|--------------|---------|----------------------------|---------------------|
| petekTools   | 0.2.3   | `pip install petektools`   | live                |
| petekIO      | 0.3.2   | `pip install petekio`      | live                |
| petekStatic  | 0.1.5   | `pip install petekstatic`  | live                |
| petekSim     | 0.1.3   | `pip install peteksim`     | live                |

### Rust (crates.io)

```sh
cargo add petektools@0.2.3     # TOOLKIT — numeric kernels, units, container
cargo add petekio@0.3.2        # DATA    — ingest + model-ready inputs
cargo add petekstatic@0.1.5    # GEOMODEL — StaticModel build + volumetrics + MC
cargo add peteksim@0.1.3       # SIMULATION — the appraisal facade over the stack
```

### Python (PyPI)

```sh
pip install petektools==0.2.3
pip install petekio==0.3.2
pip install petekstatic==0.1.5   # static workflow API, StaticModel, volumes + bundles
pip install peteksim==0.1.3      # the full appraisal facade over the whole stack
```

Dependencies resolve automatically in DAG order (peteksim pulls the stack;
petekstatic pulls petekio + petektools).

## License

The suite is split by layer:

| Library      | License                                              |
|--------------|------------------------------------------------------|
| petekTools   | Apache-2.0                                            |
| petekIO      | Apache-2.0                                            |
| petekStatic  | Business Source License 1.1 (converts to Apache-2.0) |
| petekSim     | Business Source License 1.1 (converts to Apache-2.0) |

The horizontal toolkit and the data layer are permissively licensed (Apache-2.0).
The geomodel and simulation layers ship under the Business Source License 1.1,
each released version converting to Apache-2.0 on its change date. See each
library's own `LICENSE` / `NOTICE` for the authoritative terms.
