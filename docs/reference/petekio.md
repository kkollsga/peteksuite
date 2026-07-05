# petekIO (Python)

The data layer: load a project once into a `GeoData`, read interpreted results.

```python
import petekio
```

## At a glance

| Group | Names |
|---|---|
| **Project** | `GeoData`, `BBox`, `Interval`, `Stats` |
| **Surfaces** | `Surface`, `PointSet`, `PolygonSet`, `GridGeometry` |
| **Wells** | `Well`, `WellsView`, `Sidetrack`, `Trajectory`, `LogSession`, `LogView` |
| **Net conditioning** | `NetSettings` |
| **Ingest / view** | `IngestSpec`, `ViewSpec`, `ViewSettings` |
| **Helpers** | `canonical_mnemonic`, `build_well_log_bundle`, `encode_lane` |

See the [petekIO guide](../libraries/petekio.md), the
[data-ingest tutorial](../tutorials/data-ingest.md), and the
[ingest notebook](../notebooks/petekio/01_ingest_tour.ipynb).

## API

::: petekio
    options:
      show_root_heading: false
      show_root_toc_entry: false
      heading_level: 3
      members_order: alphabetical
