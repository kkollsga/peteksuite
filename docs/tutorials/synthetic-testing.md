# Synthetic data & testing

**Goal.** Understand how the suite generates the **fully synthetic** assets every
example runs on, and how the acceptance / conformance testing story lets *you*
trust — and extend — the stack.

Everything in this documentation runs on synthetic data. There is no confidential
dataset anywhere; the generators plant fictional fields from deterministic seeds.

## `synth_asset` — a synthetic Petrel export

`ps.synth_asset` writes a complete, fictional Petrel-style export tree to disk and
returns a **manifest** of the planted truths.

```python
import peteksim as ps

man = ps.synth_asset("/tmp/asset", seed=20_260_704, n_wells=8, ncol=41)
sorted(man)     # root, crs, aliases, horizons, zones, zonation, contacts,
                # zone_targets, contact_plan, well_ids, net_cutoff, georef, ...
```

Key manifest fields:

| Field | What it is |
|---|---|
| `crs`, `aliases` | a fictional CRS and vendor→canonical mnemonic map |
| `horizons`, `zones` | the stratigraphic column (top→down) |
| `zonation` | per-zone `{below_horizon, conformity, nk, contacts}` |
| `contacts`, `contact_plan` | contacts + the per-zone plan (`single` / `two_contact` / `contactless`) |
| `zone_targets` | the planted NTG / net-porosity means to recover |
| `georef` | a fictional world origin (a `431000 / 6521000`-style frame) |

The asset is **structurally isomorphic to a real model**: deviated + vertical
wells, a tops-only internal horizon, per-zone contacts including a contactless
zone, and pinching zones with sub-threshold columns. Pass
`surfaces_as_points=True` to emit horizons as scattered point-sets (routing the
from-scatter conditioning path); pass a larger `ncol` for a spill-forcing variant.

## Synthetic trajectories & fields

The lower-level generators live in **petekTools** (domain-agnostic), and the asset
composes them. You can use them directly:

```python
import petektools as pt

surf  = pt.synth_dome_surface(...)          # a domal depth surface
iso   = pt.synth_isochore(...)              # a zone thickness field
wells = pt.place_wells(...)                 # well locations in an outline
traj  = pt.synth_trajectory_profile(...)    # a build/hold/drop deviated bore
por   = pt.synth_por_with_facies(...)       # coupled facies + porosity curves
```

The **well profiles** are string tags — `"vertical"`, `"build_hold"`,
`"build_hold_drop"` — realised by `synth_trajectory_profile`. See the
[petekTools synthetic-data notebook](../notebooks/petektools/02_synthetic_data_tour.ipynb).

## The testing story — why you can trust it

The suite's testing doctrine is derived from actual escaped bugs; each rule names
the bug class that proves its necessity. The three you meet as a user:

- **R3 — Planted-truth recovery.** Every modelling capability (population, trends,
  upscaling, MC, volumetrics) plants a known value in the synthetic asset and
  recovers it through the *full* pipeline within a derived tolerance.
  Zero-spread MC == the deterministic result is the canonical instance.
- **R6 — Round-trip / acceptance.** A cross-repo feature is done only when the
  **end-to-end acceptance suite** passes on the canonical synthetic asset — raw
  tree → load → build → zoned MC → every viewer bundle — with payload invariants
  asserted and the planted truths recovered.
- **R7 — API-contract / conformance.** Every spec and settings object ships a
  **conformance battery**: `from_dict(to_dict(s)) == s`, value semantics
  (`.replace` returns a new value, original unchanged), a snapshot-pinned table
  `repr`, names-not-objects construction, and apply determinism. The acceptance
  suite additionally locks the **workflow shape** — the canonical v2 sketch runs
  verbatim and scenario derivation is pinned (two derived specs → two
  deterministic, differing models).

### Running the acceptance gate yourself

```bash
# In the petekSim repo, on a fresh wheel:
python -m pytest crates/srs-py/tests/test_acceptance_v2.py -m acceptance -q
```

This is the same standing gate the suite runs before shipping — it exercises the
whole stack on the synthetic asset, so a green run is your assurance the modelling
API behaves as documented.

**That's the tour.** For the *why* behind the spec pattern and the engine, see
[Explanation](../explanation/spec-pattern.md).
