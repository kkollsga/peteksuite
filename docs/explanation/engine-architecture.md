# Engine architecture

How the geomodel is actually constructed underneath the [spec
pattern](spec-pattern.md) — the parts that shape what the API can and can't do.

## Isochore build-down

The layered corner-point grid is built **top-down by isochores**, not by
independently gridding each horizon. The top structure is gridded first; every
deeper horizon is placed by adding a (possibly perturbed) **thickness** to the
horizon above it, then clamped against the envelope so it can never cross the
surface above.

This is what `collapse_negative` / `collapse=True` in the `Gridding` settings
*is* — the construction that clamps a negative thickness to zero rather than
producing an inverted cell. The consequence matters: **ordering and exact merges
survive by construction.** Two horizons that touch stay touching; a zone that
pinches out pinches to exactly zero thickness, never to a sliver or a crossing.

## Structural fidelity

The grid honours its control — well-tie picks and the gridded surfaces — to a
stated tolerance rather than smoothing them away. Surfaces tie to well picks by
the declared `TieSettings` method:

- **convergent** — a control-replacement re-solve that pulls the surface onto the
  picks;
- **radius** (forward-declared) — a locality-limited tie.

The gridder behind this is petekTools' warm-start `ConvergentGridder`: it seeds
each re-solve from the prior field and converges in a fraction of the iterations,
which is what makes interactive, one-control-at-a-time refinement — and the
per-realization Monte-Carlo rebuild — cheap.

## The Monte-Carlo regeneration seam

Static uncertainty is **not** a level-shift on a frozen cube. It **re-generates
the model per realization**: each draw perturbs the structure and re-runs the
build, so volumes reflect a genuinely different geometry, not a scaled one. This
is the seam petekSim asks petekStatic to run — `StaticModelTemplate::realize(&
RealizationDraw)` — and the warm-start gridder is what keeps it affordable.

The **structural-uncertainty field** rides this seam:

- the top horizon's `sd` / `vgm` is a correlated **top-depth** perturbation field;
- every deeper horizon's `sd` / `vgm` is a correlated **isochore** perturbation of
  the zone above it, clamped ≥ 0 and zero-masked where the base isochore is
  exactly 0.

Because each draw goes through the same isochore build-down, **every realization is
a valid geometry** — ordering and exact merges hold on every draw. That is why the
structural field widens the in-place spread honestly instead of occasionally
producing a crossed or inverted model that would have to be discarded.

## Why the volumes live with the model

Volumetrics (GRV / in-place) are computed **off the model itself** — the same
corner-point cells, contacts and property cubes — so a Monte-Carlo run is a loop
over re-generated models, each yielding its own volume. That is why volumetrics
and static uncertainty are the geomodel layer's job (petekStatic), and the
simulation layer (petekSim) *presents* the P-curves rather than re-deriving them.
FVF crosses the seam as a validated scalar input, never as PVT code reaching
upward.

## SI throughout

Depths are metres, positive-down; volumes are Sm³ (reported in MSm³), GRV in mcm
(10⁶ m³); FVF is Rm³/Sm³. There is no imperial default anywhere — conversion is
opt-in on the caller's side.
