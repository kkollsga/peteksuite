# petekTools (Python)

The horizontal toolkit: gridding / kriging / SGS kernels, a units system, curated
stats / sampling front-doors, synthetic generators, and the viewer unit.

```python
import petektools as pt
```

## At a glance

| Group | Names |
|---|---|
| **Geometry** | `Lattice`, `Georef` |
| **Gridding / geostat** | `sgs`, `local_kriging_grid`, `resample`, `Variogram`, `experimental_variogram`, `ExperimentalVariogram` |
| **Sampling / RNG** | `Sampler`, `Rng`, `ZoneSpec` |
| **Synthetic generators** | `synth_dome_surface`, `synth_isochore`, `synth_trend_map`, `synth_facies_series`, `synth_log_series`, `synth_por_with_facies`, `synth_trajectory`, `synth_trajectory_profile`, `tops_from_surface`, `place_wells`, `place_wells_in_polygon`, `closure_outline`, `study_area_outline` |
| **Units** | `km2_to_m2`, `m2_to_km2`, `m3_to_msm3`, `m3_to_bcm`, `m3_to_mcm`, `format_volume`, … |
| **Stats** | `mean`, `median`, `percentile`, `std`, `variance`, `weighted_mean`, `weighted_percentile`, `reservoir_summary`, `aggregate` |
| **Viewer** | `petektools.viewer` — `serve`, `save_view`, `build_server` |

See the [petekTools guide](../libraries/petektools.md) for a narrative tour and
the [geostat notebook](../notebooks/petektools/01_geostat_tour.ipynb).

## API

::: petektools
    options:
      show_root_heading: false
      show_root_toc_entry: false
      heading_level: 3
      members_order: alphabetical
