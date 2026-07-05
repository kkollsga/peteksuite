# Static model build — the flagship

**Goal.** Go from a data export to a per-zone **STOIIP** volume through the
ratified **v2 modelling API**: declarative *specs* applied at explicit *moments*.
This is the canonical end-to-end path — every other tutorial branches off it.

!!! success "This whole page is CI-tested"
    The [complete example](#the-complete-tested-example) at the bottom is
    included verbatim from `examples/model_build_v2.py`, which runs green as part
    of peteksim's acceptance suite (testing-doctrine **R7**, workflow-shape lock)
    on the canonical synthetic asset. The step-by-step snippets below narrate that
    same tested flow.

## The pattern

The v2 API rests on one ruling:

> **Specs are declarative values; applications are explicit moments; settings are
> specs too.**

- A **spec** says *WHAT* (`Horizons`, `Subzones`, `Layering`, `Contacts`,
  `Props`, `Mc`). It is an immutable value, holds **names** not project objects
  (resolved at apply time, so it is project-independent and reusable across
  re-exports and synthetic assets), serializes to/from a dict, compares by value,
  and pretty-prints as its domain table.
- A **settings** object says *HOW* (`TieSettings`, `Gridding`, `Run`), attached
  to a spec with per-row exceptions allowed.
- An **application** is one explicit call — `geom.build(...)`, `grid.model(...)`,
  `model.zoned_uncertainty(...)`. Errors at apply are **loud**, naming both the
  missing project object and the spec entry.
- **Scenarios are derived specs**: `hz.replace(...)`, `con.replace(...)` — same
  geometry, N specs → N models.

## 0 · A synthetic asset to build on

```python
import peteksim as ps

man  = ps.synth_asset("/tmp/petek-model")     # a fully synthetic Petrel-style export
```

`synth_asset` returns a **manifest** — the planted truths (horizons, zones,
contacts, aliases, CRS) you build the specs against.

## 1 · Ingest

Loading is itself a spec: `LoadSettings` is a value carrying the CRS and the
mnemonic aliases.

```python
proj = ps.Project.load(
    man["root"],
    settings=ps.LoadSettings(crs=man["crs"], aliases=man["aliases"]),
)
proj.inventory()          # what loaded, and what was skipped-with-reason
```

## 2 · Declare the structure (names, not objects)

A `Horizons` spec is an ordered stack of horizon rows (top→down) plus the zone
names between them, with tie and gridding **settings** attached. Because it holds
names, it constructs fine even before a project exists — resolution happens at
apply.

```python
hz = ps.Horizons(
    *[ps.hz(h) for h in man["horizons"]],       # ordered top→down
    zones=man["zones"],
    ties=ps.TieSettings(method="convergent"),   # how surfaces tie to well picks
    gridding=ps.Gridding(collapse=True),        # collapse negative thickness
)
print(hz)     # a spec pretty-prints as its stratigraphic column
```

A single horizon row is `ps.hz(name, surface=<name>, tie=<pick set>, sd=<m>,
vgm=(model, range))`. `surface=` defaults to the horizon name; `sd` / `vgm`
declare a **structural-uncertainty** field used later by the zoned MC (see
[Simulation & uncertainty](simulation-uncertainty.md)).

## 3 · Subzones & layering

Optionally split a zone into subzones, then declare the vertical layering. Both
are specs; `Layering` accepts glob overrides via `.replace`.

```python
sz  = ps.Subzones({ "Reservoir": ps.splits("Upper", "Lower") })   # optional
lay = ps.Layering(nk=2)              # or Layering(dz=1.0, min_cell=0.5)
```

## 4 · Build the geometry

Two explicit moments turn declarations into a grid: `grid_geometry` fixes the
areal lattice, then `build` constructs the layered corner-point grid.

```python
geom = proj.grid_geometry(cell=(50.0, 50.0), orient=0.0)
grid = geom.build(hz, layering=lay,
                  collapse_negative=True, min_thickness_m=0.0)
```

`collapse_negative` is the isochore build-down construction: deeper horizons are
clamped against the envelope so ordering and exact merges survive.

## 5 · Properties & contacts

`Props` populates the cubes; each `Prop` upscales the well logs then propagates
by geostatistics. `Contacts` places the fluid contacts per zone.

```python
props = ps.Props(
    ps.Prop("PORO", net_only=True,
            propagate=ps.Propagate(variogram=ps.variogram("spherical", 1500.0), seed=11)),
    ps.Prop("NTG",
            propagate=ps.Propagate(variogram=ps.variogram("spherical", 1500.0), seed=12)),
)
con = ps.Contacts({ z["zone"]: dict(z["contacts"])
                    for z in man["zonation"] if z["contacts"] })
```

A contact entry is `{"goc": ..., "owc": ...}` or `{"goc": ..., "fwl": ...}`; a
zone with two contacts becomes a gas-cap + oil-rim `two_contact` zone, a zone
with none contributes GRV with zero hydrocarbon.

## 6 · Model & volumes

`grid.model(...)` is the application that populates the model, places contacts and
computes volumes. `wells=` attaches bore tracks for the viewer's Wells tab.

```python
model = grid.model(props, con, fluid="oil",
                   fvf=1.30, gas_fvf=0.005, wells=proj.wells())

for r in model.in_place_by_zone()["zones"]:
    print(f"{r['zone']:5s} STOIIP={r['stoiip_msm3']:8.3f} MSm³  "
          f"two_contact={r['two_contact']}")
```

`in_place_by_zone()` returns per-zone `grv_mcm`, `stoiip_sm3` / `stoiip_msm3`,
GIIP and the `two_contact` flag, plus a field `total`. All SI: depths in metres
positive-down, volumes in **Sm³** (reported in **MSm³**), GRV in **mcm** (10⁶ m³).

## 7 · Uncertainty & scenarios

One `Mc` spec runs the zoned Monte-Carlo; `.replace` derives scenarios off the
same geometry. Both are covered in depth in the
[Simulation & uncertainty tutorial](simulation-uncertainty.md).

```python
mc = model.zoned_uncertainty(ps.Mc(porosity=0.01, contacts=4.0, goc=3.0, n=2000, seed=42))
t  = mc.total["stoiip"]
print(f"field STOIIP P90/P50/P10 = "
      f"{t['p90_msm3']:.3f} / {t['p50_msm3']:.3f} / {t['p10_msm3']:.3f} MSm³")

# A scenario: a deeper FWL in one zone — same geometry, a new model.
deeper  = con.replace("Z4", goc=man["contacts"]["goc_z4"],
                            fwl=man["contacts"]["fwl_z4"] + 30.0)
model_b = grid.model(props, deeper, fluid="oil", fvf=1.30, gas_fvf=0.005)
```

## The complete tested example

The full flow above, exactly as it runs in peteksim's acceptance suite:

```python
--8<-- "model_build_v2.py"
```

**Next:** widen it with [Monte-Carlo uncertainty and
scenarios](simulation-uncertainty.md), or inspect the result in the
[viewer](visualization.md).
