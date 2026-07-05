# Architecture & the DAG

petekSuite is **three vertical layers plus one horizontal toolkit**. Dependencies
flow one direction, **downward only** — no cycles, no sideways sharing of code.

```
petekIO      DATA        ingest·normalize·validate·interpret → model-ready inputs
   ↓
petekStatic  GEOMODEL    structural framework (horizons+faults+zones) · grid
   ↓                     construction · property modelling · volumetrics +
                         static uncertainty → StaticModel + P-curves
petekSim     SIMULATION  dynamic / engineering simulation (decline, p/z,
                         material balance; later full flow) · PVT · the product

petekTools   TOOLKIT     horizontal, shared, domain-agnostic: numeric kernels
                         (gridding / kriging / warm-start / geostat) + units +
                         the liftable container + the viewer. Serves all layers.
```

## The four homes

- **petekIO — the DATA layer.** Files in; normalized, validated, interpreted
  domain objects out. Surfaces, wells (trajectories / tops / logs), points,
  polygons — with mnemonic and unit normalisation, petrophysical interpretation,
  gridding that honours its control points. Data only, **no modelling framework**.
- **petekStatic — the GEOMODEL layer.** Model-ready inputs → a populated
  `StaticModel`: the structural framework, the convergent corner-point grid, the
  property cubes. It **owns volumetrics + static uncertainty** — GRV / in-place off
  the model itself, Monte-Carlo regeneration over model realizations, tornado —
  producing a StaticModel plus P90/P50/P10 curves.
- **petekSim — the SIMULATION layer + the product.** Recoverable volumes and
  forecasting, plus PVT. It ships **`peteksim`**, the single Python-facing façade
  that presents the whole stack: from a Petrel export to a STOIIP P-curve in a
  handful of calls.
- **petekTools — the horizontal TOOLKIT.** The scattered-data gridding / kriging /
  warm-start / geostatistics kernels Rust lacks, a units system, the container
  format, and the generic bundle viewer. A pure leaf — it depends on none of the
  others; they build on it.

## The coupling rule

> Share **conventions** freely; share **code** only **downward** through the DAG,
> never sideways. Each library must stay **usable standalone**.

When in doubt, duplicate a small type and convert at the seam rather than
introduce a shared dependency. petekTools may be depended on by any layer
*because* it is domain-agnostic — the moment something needs a `Grid` / `Surface`
/ `Model` type it belongs in a domain layer, not the toolkit.

## The cross-library seams

- **petekIO → petekSim (ModelInputs).** The data-layer output contract the
  simulation layer consumes (the `.pproj` container). Locked.
- **petekStatic ↔ petekSim (StaticModel).** A populated static model: grid
  geometry + layered corner-point grid + per-cell property cubes + zones +
  framework metadata + provenance. For Monte-Carlo, petekSim asks petekStatic to
  **re-generate the model per realization** — the warm-start gridder (in
  petekTools) is what makes that efficient.
- **The container.** The liftable on-disk project container lives in
  `petektools::container`; the domain DTOs stay in petekIO.

## What lives where

| Concern | Home |
|---|---|
| LAS / IRAP / well-tops readers, `GeoData`, per-zone stats | petekIO |
| Structural framework, corner-point grid, property cubes, volumetrics, static MC | petekStatic |
| The `peteksim` facade, PVT, forecasting, the analytic box model | petekSim |
| Gridding / kriging / SGS kernels, units, the container, the viewer | petekTools |

The authoritative sequencing lives in petekSuite's planning graph; this page is
the reader's map of the shape. For the *why* behind the spec-driven modelling API
and the engine, see [Explanation](../explanation/spec-pattern.md).
