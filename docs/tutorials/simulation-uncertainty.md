# Simulation & uncertainty

**Goal.** Turn a deterministic static model into a **probabilistic** one — zoned
Monte-Carlo, structural uncertainty, P-curves and tornado — and derive
**scenarios** off the same geometry.

This tutorial continues from the [flagship static-model
build](static-model-build.md); `model` is the populated model from there.

!!! tip "Runnable notebook"
    Mirrored by the executed notebook
    [petekSim — scenarios & uncertainty](../notebooks/peteksim/02_scenarios_uncertainty.ipynb).

## Zoned Monte-Carlo — one Mc spec

A single `Mc` spec describes the uncertainty, and `zoned_uncertainty` runs it
per zone, drawing per-zone contact spreads and per-property level shifts. On a
zoned model it auto-routes to the per-zone run.

```python
mc = model.zoned_uncertainty(
    ps.Mc(porosity=0.01,      # sd on the porosity level shift
          contacts=4.0,       # sd (m) on the lower FWL / OWC pick
          goc=3.0,            # sd (m) on the gas-oil contact
          n=2000, seed=42),
)

mc.total["stoiip"]     # {p90_msm3, p50_msm3, p10_msm3, mean, samples}
mc.zones               # [{zone, stoiip:{...}, giip:{...}, two_contact}, ...]
```

Every `Mc` field accepts a scalar `sd` (sugar for `ps.shift(sd)`), an explicit
`ps.shift(...)` / `ps.dist(...)`, or `None`. `per_zone={"Z2": ps.Mc(...)}`
overrides a single zone.

!!! info "The reservoir P-convention"
    Percentiles follow the petroleum exceedance convention: **P90 = low, P10 =
    high**. `p90_msm3 < p50_msm3 < p10_msm3`.

## Structural uncertainty (sd / vgm)

Declaring `sd` and `vgm` on the horizon rows adds a **correlated depth /
thickness perturbation** to each MC draw:

- the **top** row's `sd`/`vgm` is a correlated **top-depth** field;
- every **deeper** row's `sd`/`vgm` is a correlated **isochore (thickness)**
  perturbation of the zone above it, clamped ≥ 0 and zero-masked where the base
  isochore is exactly 0.

By construction, ordering and exact merges survive every draw, so the structural
field **widens** the in-place spread without ever producing an invalid geometry.

```python
hz_struct = ps.Horizons(
    ps.hz(man["horizons"][0], sd=12.0, vgm=("spherical", 2500.0)),   # top-depth field
    ps.hz(man["horizons"][1], sd=12.0, vgm=("spherical", 2500.0)),   # zone-0 isochore
    *[ps.hz(h) for h in man["horizons"][2:]],
    zones=man["zones"], ties=ps.TieSettings(method="convergent"),
    gridding=ps.Gridding(collapse=True),
)
grid_s  = geom.build(hz_struct, layering=lay, collapse_negative=True, min_thickness_m=0.0)
model_s = grid_s.model(props, con, fluid="oil", fvf=1.30, gas_fvf=0.005)
mc_s    = model_s.zoned_uncertainty(ps.Mc(contacts=4.0, n=128, seed=42))
# mc_s total spread is WIDER than the no-field control at the same seed.
```

!!! warning "Loud on a flat model"
    A structural field on a **non-zoned** (flat) model has no hook yet — the build
    raises `ps.NotYetSupported` rather than silently ignoring it. No silent
    degradation.

## Distributions & charts

Chart bundles are computed here (deterministically, in Rust) and rendered by the
viewer's Charts tab — the viewer fits and bins nothing.

```python
dist_field = ps.Distribution().bundle(mc)             # the field STOIIP distribution
dist_z4    = ps.Distribution(zone="Z4").bundle(mc)    # a single zone
model.save_view("model.html", property="PORO", charts=[dist_field, dist_z4])
```

### Tornado — the flat path

!!! note "Tornado is flat-path only"
    Ranked sensitivity (**tornado**) lives on the **flat** (non-zoned) MC path.
    Run `model.uncertainty(...)` for a whole-model MC, then build the tornado
    bundle from it. The zoned run exposes per-zone distributions, not a tornado.

```python
flat = model.uncertainty(ps.Mc(porosity=0.02, contacts=5.0, n=2000, seed=42))
tor  = ps.Tornado(units="MSm³").bundle(flat)          # ranked input swings
```

`ps.aggregate([seg_a, seg_b], correlation="independent")` rolls up several flat
segments into a **field** distribution; `ps.distribution_bundle([a, b],
aggregate=..., names=[...])` overlays per-structure + field series in one chart.

## Scenario derivation

A scenario is a **derived spec** — `.replace` returns a new value; the original is
untouched — so the same geometry yields N deterministic, differing models.

```python
# Contacts scenario: a deeper OWC ⇒ more oil in Z2
con_b   = con.replace("Z2", owc=man["contacts"]["owc_z2"] + 40.0)
model_b = grid.model(props, con_b, fluid="oil", fvf=1.30, gas_fvf=0.005)

# Horizon scenario: drop the deepest zone (and its base horizon)
hz_drop = hz.replace(rows=hz.rows[:-1], zones=hz.zones[:-1])
model_c = geom.build(hz_drop, layering=lay).model(props, con)

# Layering scenario: finer cells in every zone
lay_fine = lay.replace("Z*", dz=0.5)
```

Rebuilding from the same spec is **bit-deterministic** — the acceptance suite pins
exactly this (two derived specs → two deterministic, differing models).

## Durable scenarios

A whole scenario is a savable file. `AssetSpec` bundles the load settings +
structure + layering + contacts + props into one value that round-trips through a
plain dict:

```python
asset = ps.AssetSpec(name="demo", load=ps.LoadSettings(crs=man["crs"]),
                     horizons=hz, layering=lay, contacts=con, props=props)
assert ps.spec_from_dict(asset.to_dict()) == asset      # durable, comparable
```

**Next:** inspect any of these models in the [viewer](visualization.md).
