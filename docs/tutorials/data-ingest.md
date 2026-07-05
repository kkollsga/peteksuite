# Data ingest with petekIO

**Goal.** Load a subsurface project — surfaces, wells, tops, logs — once into a
single substrate, read interpreted results without re-implementing any parsing,
and hand a clean, model-ready container to the layers above.

petekIO is the **DATA layer**: its pipeline is *ingest → normalize → validate →
interpret → characterise*. You load files; you get back normalized, validated,
interpreted domain objects — no LAS aliasing, unit harmonisation or gridding in
your own code.

!!! tip "Runnable notebook"
    This tutorial mirrors the executed notebook
    [petekIO — ingest tour](../notebooks/petekio/01_ingest_tour.ipynb), which
    authors a small **synthetic** project tree and loads it end-to-end.

## The GeoData substrate

Everything hangs off one project object. Load once; operations broadcast across
the whole collection (no per-item loops), and views are read-only filtered
subsets.

```python
import petekio

geo = petekio.GeoData(unit="m")
```

## Surfaces

Load an IRAP-classic surface, then sample, take stats, or compute an
`area_below` volumetric — the surface carries its own operations.

```python
top = geo.load_surface("top_res", "surfaces/top_res.irap")

top.stats.mean          # whole-surface statistics
top.area_below(2400)    # areal volumetric below a depth
resampled = top.resample(spacing=25.0)   # bilinear resample onto a finer lattice
```

Surfaces can also be **gridded from scattered points** (minimum-curvature) — the
petekTools kernel, honouring its control points, reached through petekIO's own
API.

## Wells: trajectories, sidetracks, logs

A multi-bore well is a Petrel export tree — one bore per `.wellpath`, plus its
logs. Heads and KB are optional; the `.wellpath` header fills them.

```python
geo.load_well("15/9-A1", files="wells/15_9-A1/")   # trajectory + logs
geo.load_well_tops("WellTops.tops")                # horizon picks → matching well/bore

w = geo.well("15/9-A1")
w.bores()                      # e.g. ["", "A", "B", "ST2"] — sidetracks
bore = w.sidetrack("A")
bore.log_stats("PHIE").mean    # whole-bore curve stats
```

Log mnemonics are **aliased at load** to canonical names, so `PHIE`, `PHIT`,
vendor variants all resolve to one curve identity downstream.

## Per-zone stats in stratigraphic order

Well tops define zones, and petekIO returns them in true **lithostratigraphic
order** — not measured-depth order. `load_well_tops` reads *every* well in the
tops file and merges their relative orderings into one field-wide column, so a
marker that pinches out (zero thickness) in one well is still ordered correctly
by a well that develops it.

```python
bore.zone_stats("PHIE")                 # [(zone, Stats), ...] in strat order
bore.zone_stats("PHIE", "Top A").mean   # one zone directly (None if absent)
geo.strat_order                         # the field-wide lithostratigraphic column

# A tidy per-zone × bore table (pandas):
w.zone_table("PHIE", stats=("mean", "p50"))
```

## Net conditioning with NetSettings

Net pay is a **net-cutoff** decision. `NetSettings` captures that decision as a
value you can vary and compare — an A/B sweep of cutoffs is one loop, driving the
per-zone net statistics. See the [well-analysis tutorial](well-analysis.md) for
the full sweep.

## Handing off model-ready inputs

Once a project is loaded, validated and interpreted, it is **model-ready**.
petekIO persists it into the liftable `.pproj` container — the seam the geomodel
layer (petekStatic) and the `peteksim` facade consume. The container round-trips
losslessly: save it, reload it, and the whole substrate is back.

## What you get

| Domain | What petekIO gives you |
|---|---|
| **Surfaces** | IRAP load, sample/resample, arithmetic, stats, `area_below`, scattered-point gridding (min-curvature) |
| **Wells** | positioned `.wellpath` trajectories (min-curvature), multi-bore sidetracks, LAS logs with mnemonic aliasing, well-tops, per-zone stats, field-wide strat ordering |
| **Points / polygons** | IRAP / GeoJSON / CSV load, clip, point-to-surface gridding |
| **Project** | `GeoData` — load once, broadcast; read-only views; `.pproj` container |

**Next:** feed these model-ready inputs into the
[flagship static-model build](static-model-build.md).
