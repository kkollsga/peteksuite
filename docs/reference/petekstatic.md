# petekStatic

The geomodel layer: structural framework + grid construction + property modelling
+ volumetrics / static uncertainty → a populated `StaticModel`.

petekStatic is the Python-facing geomodel layer. Project loading belongs to
`petekio`; static modelling starts from that loaded `petekio.Project` and keeps
the static workflow in `petekstatic`:

```python
import petekio as pio
import petekstatic as pst

project = pio.Project.load(
    "Data",
    settings=pio.LoadSettings(
        crs="EPSG:32631",
        aliases={"PHIE": ["PHI", "PHIE"], "NetSand": ["NTG", "NETSAND"]},
    ),
)

logs = project.wells.logs
grid = (
    pst.Grid.from_project(project)
    .geometry(cell=(50.0, 50.0), orient=0.0, outline="ModelEdge")
    .horizons(
        [
            {
                "name": "Top reservoir",
                "surface": "Top reservoir input surface",
                "well top": "well tops/Top reservoir",
                "zone": {
                    "name": "Reservoir",
                    "sub-zones": [
                        {"zone": "Top Reservoir", "type": "constant"},
                        {"name": "Intra Shale", "well top": "Top Lower Reservoir"},
                        {"name": "Lower Reservoir", "type": "isochore"},
                    ],
                },
            },
            "Base reservoir",
            {"name": "Custom model horizon name", "surface": "input surface"},
        ],
        well_tie={"influence_radius": 800},
    )
    .layers({"Top Reservoir": pst.Layering(n=10), "Lower Reservoir": pst.Layering(n=10)})
)

vgm = pst.Var("spherical", major=1500, minor=700, vertical=20, azimuth=35)
grid.properties.ntg = pst.upscale(logs.NetSand).sgs(variogram=vgm, seed=11)
grid.properties.por = pst.upscale(logs.PHIE(logs.NetSand > 0.50)).sgs(
    variogram=vgm,
    distribution=pst.distributions.from_logs(),
    seed=12,
)
```

## The Rust API

One crate — `petekstatic` — with the headline `StaticModel` API re-exported at
the crate root:

| Concern | Module |
|---|---|
| The `StaticModel` aggregate + builder + MC-regeneration seam | `petekstatic::model` (root re-export) |
| Grid construction (convergent corner-point) | `petekstatic::{grid, gridder, wireframe}` |
| Property modelling (priors / log upscaling) | `petekstatic::petro` |
| Volumetrics + static uncertainty | `petekstatic::{volumetrics, uncertainty}` |
| Model-ready input access | `petekstatic::data` |

Full Rust reference: [docs.rs/petekstatic/0.1.6](https://docs.rs/petekstatic/0.1.6)
(see the [Rust API page](rust.md)). Design constitution and the locked contract
live in the repo's `SPEC.md` / `API.md`.

See also the [petekStatic guide](../libraries/petekstatic.md) and the
[stack-model notebook](../notebooks/petekstatic/01_stack_model_from_scatter.ipynb).
