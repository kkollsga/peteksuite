# The spec pattern

The v2 modelling API rests on one design ruling:

> **Specs are declarative values; applications are explicit moments; settings are
> specs too.**

This page explains *why* that shape was chosen and what it buys you. The
[flagship tutorial](../tutorials/static-model-build.md) shows the mechanics.

## The three roles

- A **spec** says *WHAT* — `Horizons`, `Subzones`, `Layering`, `Contacts`,
  `Props`, `Mc`.
- A **settings** object says *HOW* — `TieSettings`, `Gridding`, `Run`.
- An **application** is the single explicit *moment* where a spec meets a project
  and produces a result — `geom.build(...)`, `grid.model(...)`,
  `model.zoned_uncertainty(...)`.

Separating the declaration from the moment it runs is the whole idea. A spec is
inert data; nothing happens until you apply it.

## Names, not objects

A spec holds **names**, not resolved project objects. `ps.hz("TopReservoir")`
records the *string* `"TopReservoir"`; the actual surface is looked up at apply
time. Five consequences follow, and they are the payoff:

1. **Project-independent.** The same spec applies to a re-exported project, a
   different vintage, or a synthetic asset — anything that resolves the same
   names. A scenario authored once is reusable everywhere.
2. **Serializable.** Because a spec is names + scalars, it round-trips through a
   plain dict: `from_dict(to_dict(s)) == s`. **A scenario is a savable file** —
   version it, diff it, share it.
3. **Comparable by value.** Two specs are equal iff they describe the same thing.
   That makes a scenario library a set of values, and a change a visible diff.
4. **Derivable.** `.replace(...)` returns a *new* spec with one field changed; the
   original is untouched (immutability pinned by test). Scenarios are derived
   specs — same geometry, N specs → N models.
5. **Constructible without a project.** Building a spec touches no project object,
   so a spec against a name that doesn't exist yet constructs fine; the error
   comes **at apply**, and it is loud.

## Loud at the moment, not silent at construction

Because resolution is deferred to the application moment, that is where errors
surface — and they name **both** the missing project object **and** the spec
entry, so you know exactly which line of your declaration is wrong and what it was
looking for. `spec.validate(proj)` gives the same check early, as an option, when
you'd rather fail before building. No silent no-ops: a capability that isn't wired
yet (a structural field on a flat model) raises `NotYetSupported` rather than
quietly ignoring the request.

## Settings are specs too

`TieSettings`, `Gridding` and `Run` are values with the same properties —
serializable, comparable, attachable to a spec with per-row exceptions. There is
no second mechanism for "how"; it is the same pattern, so everything about a build
is captured in comparable data.

!!! note "Forward-declared fields"
    A few settings fields are recorded and serialized but not yet honoured by the
    engine (they emit a warning when set). This is deliberate: the *contract* is
    declared and durable ahead of the capability, so scenario files stay stable as
    the engine catches up.

## Why this shape

Reservoir modelling is a space of **scenarios** — the same structure with a deeper
contact, a finer layering, a dropped zone, a wider uncertainty. Modelling those as
**derived, comparable, savable values** rather than as sequences of mutating calls
means a scenario is a first-class artifact: reproducible (rebuild from the spec →
bit-identical), auditable (diff two specs), and portable (apply to any project
that resolves the names). The eight-call v1 chain — a stateful builder you mutate
step by step — still works, but the declarative surface is the primary one because
it makes the unit of work a value, not a procedure.
