# Notebooks

Eight synthetic-data notebooks — two per library — are carried as rendered
examples. They are useful for orientation, but the project/static workflow is
moving quickly; use the library guides and reference pages as the API authority
when a notebook lags a release.

| Library | Notebook | What it shows |
|---|---|---|
| **petekTools** | [Geostat tour](petektools/01_geostat_tour.ipynb) | variogram fit, SGS, local kriging on synthetic fields |
| **petekTools** | [Synthetic data tour](petektools/02_synthetic_data_tour.ipynb) | dome / isochores / trend maps, well placement, trajectories, coupled petro curves |
| **petekIO** | [Ingest tour](petekio/01_ingest_tour.ipynb) | author a synthetic file tree, load a `GeoData`, wells / tops / surfaces, `.pproj` round-trip |
| **petekIO** | [Well analysis](petekio/02_well_analysis.ipynb) | NetSettings A/B sweep, zone tables, the correlation view |
| **petekStatic** | [Stack model from scatter](petekstatic/01_stack_model_from_scatter.ipynb) | build a stack model from synthetic scatter, per-zone volumes |
| **petekStatic** | [Volumes & bundles](petekstatic/02_volumes_and_bundles.ipynb) | GRV / in-place, a contact scenario, a bundle JSON peek |
| **petekSim** | [Full workflow](peteksim/01_full_workflow.ipynb) | `synth_asset` → the v2 spec workflow → zoned MC → `save_view` |
| **petekSim** | [Scenarios & uncertainty](peteksim/02_scenarios_uncertainty.ipynb) | `.replace` derivations, structural sd/vgm, P-curve comparison plots |

!!! note "Reproducibility"
    Every notebook uses fixed seeds and fictional data. Noisy or absolute-path
    outputs are cleared; the small plots are kept inline. The notebooks live in
    each library's own `examples/notebooks/` and are pulled into this site at
    build time.
