# Well analysis

**Goal.** Read wells the way an interpreter does — a **correlation view** across
bores, a **net-cutoff (NetSettings) A/B** sweep, and tidy **zone tables** in
lithostratigraphic order.

This tutorial uses petekIO's well surface (loaded in the [data-ingest
tutorial](data-ingest.md)) and the viewer's Wells tab.

!!! tip "Runnable notebook"
    Mirrored by the executed notebook
    [petekIO — well analysis](../notebooks/petekio/02_well_analysis.ipynb).

## The correlation view

Attaching bores to a model (or opening a wells payload directly) lights up the
**Wells tab**: N wells side-by-side on a shared inverted depth axis, each with its
log tracks, tops as cross-track lines, and zones shaded in their identity colour.

```python
# On the model path — attach bores when you build:
model = grid.model(props, con, wells=proj.wells)
model.wells_bundle()          # the wells_logs payload the Wells tab renders (or None)
model.view()                  # open it; the Wells tab is populated
```

Two hanging modes: **TVD** (absolute depth) and **flatten-on-pick** — choose a
horizon and every well shifts so that pick aligns at Δ = 0 (the transform is
viewer-side). A well with no top for the chosen pick is *parked* at absolute TVD
with a dashed frame. Curve colour is **identity by track**, so `PHIE` reads one
colour across every well.

Each bore carries the **raw** logs (`PHIE` with its net-cutoff line + fill, `NTG`,
`SW`, a `FACIES` net strip) **and** the **upscaled** cube curves (`PHIE_UP` etc.,
the blocky cell value sampled back along the bore) as separate tracks — so you see
exactly what the model kept.

## NetSettings — a net-cutoff A/B sweep

Net pay hangs on a **cutoff** decision. `NetSettings` captures that decision as a
value, so comparing two cutoffs is one loop over the per-zone net statistics:

```python
import petekio

for cutoff in (0.08, 0.12):                      # A vs B
    net = petekio.NetSettings(porosity_cutoff=cutoff)   # discover exact params via help()
    table = w.zone_table("PHIE", net=net, stats=("mean", "p50", "net_fraction"))
    print(f"cutoff={cutoff}:")
    print(table)
```

The sweep shows how net fraction and net-conditioned averages move with the
cutoff — the interpreter's sensitivity, made a value you can version and diff.

!!! note "The net cutoff, end to end"
    The same net-cutoff decision flows into the model: `ps.Prop("PORO",
    net_only=True, net_cutoff=...)` conditions the porosity cube on net cells, and
    the viewer's Wells tab draws the `PHIE` net cutoff line at that value. One
    decision, one identity, all the way through.

## Zone tables in stratigraphic order

Zone tables come back in true **lithostratigraphic order** — merged field-wide
across every well in the tops file — not measured-depth order:

```python
w.zone_table("PHIE", stats=("mean", "p50"))     # pandas DataFrame, zone in strat order
bore.zone_stats("PHIE")                          # [(zone, Stats), ...]
bore.zone_stats("PHIE", "Top A").mean            # one zone directly (None if absent)
geo.strat_order                                  # the field-wide column
```

A marker that pinches out (zero thickness) in one bore is still ordered correctly
by a bore that develops it, because `load_well_tops` merges every well's relative
ordering into one column.

## Tie residuals

When a model ties surfaces to well picks, the per-horizon residuals are readable —
the Map tab shows a tie-quality glyph per well, and the numbers are one call away:

```python
model.well_tie_residuals()
# [{well, horizon, measured_depth_m, model_depth_m, residual_m}, ...]
```

**Next:** see the [visualization tutorial](visualization.md) for the full Wells
tab, or [synthetic data & testing](synthetic-testing.md) for how these wells are
generated.
