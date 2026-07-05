# petekSim (Python)

The product façade — the v2 declarative spec API and the whole stack behind one
import.

```python
import peteksim as ps
```

## At a glance

| Group | Names |
|---|---|
| **Ingest** | `Project`, `LoadSettings`, `synth_asset` |
| **Structure specs** | `Horizons`, `hz`, `Subzones`, `splits`, `Layering`, `Contacts`, `zone` |
| **Settings** | `TieSettings`, `Gridding`, `decay_to_flat`, `flat`, `nearest`, `Run`, `ViewSettings` |
| **Property specs** | `Props`, `Prop`, `Propagate`, `variogram`, `collocated` |
| **Uncertainty** | `Mc`, `McSettings`, `shift`, `dist`, `aggregate`, `distribution_bundle` |
| **Charts** | `Distribution`, `Tornado`, `Crossplot` |
| **Scenarios** | `AssetSpec`, `spec_from_dict`, `registered_specs` |
| **Apply results** | `Model`, `StaticModel`, `Uncertainty`, `ZonedUncertainty` |
| **Analytic box** | `run_box_model` |
| **Errors** | `NotYetSupported`, `ApplyError` |

See the [petekSim guide](../libraries/peteksim.md), the
[flagship tutorial](../tutorials/static-model-build.md), and the
[full-workflow notebook](../notebooks/peteksim/01_full_workflow.ipynb).

!!! note
    The v1 eight-call build chain (`Framework`, `build_grid`, staged
    `property`/`upscale`/`propagate`) still works but emits a
    `DeprecationWarning`; new code uses the declarative v2 surface above.

## API

::: peteksim
    options:
      show_root_heading: false
      show_root_toc_entry: false
      heading_level: 3
      members_order: alphabetical
      filters: ["!^_"]
