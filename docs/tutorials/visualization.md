# Visualization

**Goal.** Inspect a model in the browser — structure, properties, cross-sections,
well correlation, analytics — and export a self-contained file you can share.

The viewer is petekTools' horizontal **`petektools.viewer`** unit: a
domain-agnostic, **strictly bundle-driven** renderer. It never computes anything —
every tab renders whatever typed layers / columns / mesh the JSON payload
declares. `peteksim` composes the payload from the model and hands it over.

!!! tip "Runnable notebook"
    The [petekSim — full workflow notebook](../notebooks/peteksim/01_full_workflow.ipynb)
    builds a model and calls `save_view`; see the [Gallery](../gallery/index.md)
    for the rendered result.

## Two modes: serve vs export

```python
model.view()                    # non-blocking: a background local server, prints its URL
model.view(block=True)          # blocking: serve until Ctrl-C
model.save_view("model.html")   # ONE self-contained HTML file (opens off file://)
```

| | `view()` (live server) | `save_view()` (single file) |
|---|---|---|
| Map / Intersection / Volume / Wells / Charts | ✅ | ✅ |
| Pan · zoom · hover · toggles · colormaps · dark mode | ✅ | ✅ |
| Pre-computed sections | ✅ | ✅ |
| **Draw-a-fence** → new section | ✅ (live callback) | ⛔ disabled, with a tooltip |
| **Click a well** → along-bore section | ✅ (live) | ↩ switches to a pre-computed section if present |

`save_view` writes **one file** with all data + JS inlined and **zero external
network fetches** — it opens straight off `file://`, so confidential data never
leaves the machine. It is a frozen snapshot: it ships only what was computed at
save time.

## The tabs

### Map
Areal plan view. A **Layer** picker chooses which georeferenced scalar layer to
raster (any horizon depth or property zone-average / k-slice) with a
perceptually-uniform colormap; it defaults to the **top-horizon depth map**
(structure first, properties by choice). Overlays: the outline ring(s), per-kind
**contact subcrop masks**, and **well markers** (co-located sidetracks collapse to
one wellhead with a bore-count badge). The raster is windowed and
resolution-capped, so a repaint costs a screenful regardless of grid size.

### Intersection
A vertical cross-section. Each column is filled per layer by the property
colormap — or, with a **Color by: property | zone** select, by the fixed
**categorical zone identity**. Cells follow the zone edges as **trapezoids** whose
top/base dip across the column (flat "sugar-cube" rects only for
`sugar_cube: true` or older payloads). Top/base and interior horizon traces and
flat contact lines overlay it, plus the bore path for an along-bore section. A
vertical-exaggeration slider (default 5×) and a hover readout complete it.

### Volume
The corner-point cell **exterior shell**, flat-shaded per cell by the property
(three.js, decoded off the UI thread). A **threshold** slider hides cells below a
cutoff; a **z-exaggeration** slider (default 5×, with a *fit z ×N* button) reads a
thin, wide reservoir with relief; **zone toggles** show/hide zones; orbit to
rotate. Past a triangle budget it **auto-degrades** to a decimated preview with a
loud banner — it never crashes, OOMs, or blanks silently.

### Wells
Multi-well **log correlation** — N wells side-by-side on a shared inverted depth
axis, each with a net/facies flag strip, `PHIE` with a cutoff line + reservoir
fill, `NTG`, `SW`, and the **upscaled** cube curves sampled back along the bore.
Tops draw as cross-track lines; zones shade the band in the zone's identity
colour. Two hanging modes: **TVD** (absolute) and **flatten-on-pick** (choose a
horizon; every well shifts so that pick aligns at Δ = 0). Curve colour is
**identity by track** — `PHIE` is one colour across every well.

### Charts
Analytics marks, **strictly render-only** (pivots, bins, exceedance points and
regression coefficients are pre-computed by peteksim):

- **Tornado** — ranked sensitivity, nested bars around a base line ([flat MC
  path](simulation-uncertainty.md#tornado-the-flat-path) only).
- **Distribution** — histogram + exceedance-CDF as two stacked panels, P90/P50/P10
  markers in the reservoir convention, multi-series overlay for structure-vs-field.
- **Scatter (crossplot)** — x/y from positioned logs, optional per-axis log scale,
  colour-by-third, optional trend line.

## Colour: two jobs, never conflated

- **Continuous fields** use a perceptually-uniform scientific colormap (viridis
  default — never rainbow).
- **Categorical identity** (wells, horizons, contacts, zones) uses fixed token
  slots assigned **by entity** — an entity keeps its colour across all tabs and
  across sessions of the same bundle, and never recolours when a toggle changes
  the visible count or the theme flips.

**Dark mode is selected, not auto-flipped** — a toggle swaps a separately-chosen,
CVD- and contrast-validated palette.

## Attaching charts to a view

```python
mc     = model.zoned_uncertainty(ps.Mc(contacts=4.0, n=2000, seed=42))
charts = [ps.Distribution().bundle(mc), ps.Distribution(zone="Z4").bundle(mc)]

model.view(charts=charts)                 # geometry tabs + a Charts tab
model.save_view("model.html", charts=charts)   # baked into the self-contained file
```

**Next:** the [well-analysis tutorial](well-analysis.md) drills into the Wells tab
and net conditioning.
