# petekStatic

The geomodel layer: structural framework + grid construction + property modelling
+ volumetrics / static uncertainty → a populated `StaticModel`.

petekStatic is a **Rust workspace** — its public contract is the Rust API. A
minimal `petekstatic` Python wheel is emerging (`pip install petekstatic`), but
the full geomodel workflow is driven today through the **`peteksim` façade**,
which orchestrates petekStatic across the repo seam. So in Python you reach
petekStatic's capabilities via `peteksim`:

```python
import peteksim as ps
# surfaces_as_points=True routes petekStatic's from-scatter conditioning path:
man   = ps.synth_asset("/tmp/asset", surfaces_as_points=True)
proj  = ps.Project.load(man["root"], settings=ps.LoadSettings(crs=man["crs"], aliases=man["aliases"]))
grid  = proj.grid_geometry(cell=(50.0, 50.0)).build(
            ps.Horizons(*[ps.hz(h) for h in man["horizons"]], zones=man["zones"]))
model = grid.model(ps.Props(ps.Prop("PORO")), ps.Contacts({...}))
model.in_place_by_zone()      # petekStatic's per-zone volumetrics
```

## The Rust API

| Concern | Where |
|---|---|
| The `StaticModel` aggregate + builder + MC-regeneration seam | `srs-model` |
| Grid construction (convergent corner-point) | `srs-grid`, `srs-gridder`, `srs-wireframe` |
| Property modelling (priors / log upscaling) | `srs-petro` |
| Volumetrics + static uncertainty | `srs-volumetrics`, `srs-uncertainty` |
| Model-ready input access | `srs-data` |

Full Rust reference: [docs.rs/srs-model/0.1.0](https://docs.rs/srs-model/0.1.0)
(see the [Rust API page](rust.md)). Design constitution and the locked contract
live in the repo's `SPEC.md` / `API.md`.

See also the [petekStatic guide](../libraries/petekstatic.md) and the
[stack-model notebook](../notebooks/petekstatic/01_stack_model_from_scatter.ipynb).
