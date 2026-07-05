# Tutorials

One guide per defined workflow, top to bottom of the stack. Every tutorial runs
on **fully synthetic data** — `peteksim`'s `synth_asset` generator plants a
fictional Petrel-style export from a deterministic seed, so you can follow along
without any real dataset.

<div class="grid cards" markdown>

- :material-database-import: **[Data ingest with petekIO](data-ingest.md)**
  Load a project — surfaces, wells, tops — into a `GeoData`, and save a `.pproj`.

- :material-cube-outline: **[Static model build](static-model-build.md)** *(the flagship)*
  The ratified v2 spec workflow end-to-end: geometry → Horizons/Layering → build
  → Props/Contacts → model → volumes.

- :material-chart-bell-curve: **[Simulation & uncertainty](simulation-uncertainty.md)**
  Zoned Monte-Carlo, structural uncertainty, P-curves, charts, and scenario
  derivation.

- :material-eye-outline: **[Visualization](visualization.md)**
  The viewer tabs (map / intersection / volume / wells / charts); serve vs
  self-contained export.

- :material-chart-line: **[Well analysis](well-analysis.md)**
  Correlation views, net-cutoff (NetSettings) A/B, and zone tables.

- :material-flask-outline: **[Synthetic data & testing](synthetic-testing.md)**
  `synth_asset`, synthetic trajectories, and the acceptance / R7 testing story.

</div>

## The shape of every workflow

The stack has one spine, and each tutorial walks a stretch of it:

```
 raw export ──petekIO──▶ model-ready inputs ──petekStatic──▶ StaticModel + volumes
                                                    │
                                              petekSim facade
                                                    │
                                    zoned MC · P-curves · scenarios · the viewer
```

New here? Start with the [flagship static-model build](static-model-build.md) —
it is the canonical end-to-end path and the other tutorials branch off it.
