# How-to recipes

Short, task-focused recipes. Each assumes you have a populated `model` from the
[static-model build](../tutorials/static-model-build.md) and `import peteksim as
ps`.

## Change the contacts and re-run

Derive a new `Contacts` spec — the original is untouched — and rebuild off the
same geometry:

```python
deeper  = con.replace("Z4", goc=2700.0, fwl=2780.0)     # a deeper FWL
model_b = grid.model(props, deeper, fluid="oil", fvf=1.30, gas_fvf=0.005)
model_b.in_place_by_zone()["total"]["stoiip_msm3"]
```

## Re-run Monte-Carlo with a different spread

`Mc` is a value — change it and re-run; the model is unchanged:

```python
mc = model.zoned_uncertainty(ps.Mc(porosity=0.02, contacts=6.0, goc=3.0, n=5000, seed=7))
mc.total["stoiip"]["p50_msm3"]
```

## Derive and save a scenario

Bundle a whole scenario into a durable, comparable value and round-trip it through
a dict (a scenario is a savable file):

```python
asset = ps.AssetSpec(name="deep-case", load=ps.LoadSettings(crs=man["crs"]),
                     horizons=hz, layering=lay, contacts=deeper, props=props)
blob  = asset.to_dict()                       # JSON-able; write it to a file
assert ps.spec_from_dict(blob) == asset       # reload it later, exactly
```

## Export a view to share

Write one self-contained HTML file (all data + JS inlined, no network) that opens
off `file://`:

```python
charts = [ps.Distribution().bundle(mc), ps.Distribution(zone="Z4").bundle(mc)]
model.save_view("model.html", property="PORO", charts=charts)
```

## Build a tornado (flat MC path)

Tornado lives on the **flat** (non-zoned) MC path:

```python
flat = model.uncertainty(ps.Mc(porosity=0.02, contacts=5.0, n=2000, seed=42))
tor  = ps.Tornado(units="MSm³").bundle(flat)
flat.save_view("tornado.html", charts=[tor])
```

## Sweep a net cutoff (petekIO)

```python
import petekio
for cutoff in (0.08, 0.12):
    net = petekio.NetSettings(porosity_cutoff=cutoff)   # confirm params via help()
    print(cutoff, w.zone_table("PHIE", net=net, stats=("mean", "net_fraction")))
```

## Stay within a memory budget (spill to disk)

Large grids can exceed core. Cap the live set and the model builds out-of-core:

```python
grid.model(props, con, run=ps.Run(memory_budget=2_000_000_000))   # ~2 GB budget
```

The build spills to disk past the budget rather than OOMing; the result is
identical to the in-core path.

## Roll up several structures into a field

```python
seg_a = model_a.uncertainty(ps.Mc(contacts=4.0, n=2000, seed=1))
seg_b = model_b.uncertainty(ps.Mc(contacts=4.0, n=2000, seed=2))
field = ps.aggregate([seg_a, seg_b], correlation="independent")
overlay = ps.distribution_bundle([seg_a, seg_b], aggregate=field,
                                 names=["North", "South"])
```
