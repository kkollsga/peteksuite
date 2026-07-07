# Install

The suite is distributed **per library**, on both **crates.io** (Rust) and
**PyPI** (Python). Each library is usable standalone; you only need the layers
your work touches.

All four libraries are **live** on both indexes. The one-command install:

```bash
pip install peteksuite     # the meta-package — pulls the whole family
```

Then import the layer shorthands from the umbrella package:

```python
from peteksuite import pio, pto, pst, ps
```

## The install matrix

| Library | Layer | `cargo` | `pip` | Version |
|---|---|---|---|---|
| **petekTools** | TOOLKIT | `cargo add petektools` | `pip install petektools` | `0.2.4` |
| **petekIO** | DATA | `cargo add petekio` | `pip install petekio` | `0.3.4` |
| **petekStatic** | GEOMODEL | `cargo add petekstatic` | `pip install petekstatic` | `0.1.7` |
| **petekSim** | SIMULATION | `cargo add peteksim` | `pip install peteksim` | `0.1.5` |

`peteksim` is **the product** — the single Python facade over the whole stack. If
you just want to go from a data export to a STOIIP P-curve, install `peteksim`
and you pull in the rest transitively.

!!! note "One crate per library"
    Each library publishes exactly **one crate**. petekStatic's internals
    (grid, gridder, wireframe, petro, volumetrics, uncertainty, …) are modules
    of the `petekstatic` crate, with the headline `StaticModel` API re-exported
    at the crate root. The Python **`petekstatic`** wheel is a minimal, emerging
    surface; the full property workflow is canonical in petekStatic and is also
    reachable through the [`peteksim`](../libraries/peteksim.md) facade.

=== "Python (pip)"

    ```bash
    # The whole stack behind one façade:
    pip install peteksim

    # Or a single layer, standalone:
    pip install petekio          # the data layer
    pip install petektools       # the toolkit (kernels + units + viewer)
    pip install petekstatic      # static model workflows
    ```

    Python 3.10+ ; the wheels are PyO3/abi3 (no local Rust toolchain needed once
    published).

=== "Rust (cargo)"

    ```toml
    [dependencies]
    petektools  = "0.2"
    petekio     = "0.3"
    petekstatic = "0.1"
    peteksim    = "0.1"
    ```

    Add only the layers you depend on — the DAG is one-directional, so a data-only
    consumer needs `petekio` (and transitively `petektools`) and nothing above it.

## From source

For a local checkout, build the wheels from the sibling repos. `peteksim`
composes the whole stack, so its build pulls the family dependencies through
Cargo:

```bash
# 1. Build the horizontal toolkit wheel first (peteksim depends on it):
python -m pip install ./petekTools

# 2. Build peteksim (compiles the petekStatic + petekIO path deps via cargo):
python -m venv .venv-srs
VIRTUAL_ENV="$PWD/.venv-srs" .venv-srs/bin/maturin develop -m petekSim/crates/srs-py/Cargo.toml

# 3. Verify:
.venv-srs/bin/python -c "import peteksim as ps; print(ps.version())"
```

`petekIO`, `petekTools`, and `petekStatic` build the same way (`maturin develop`
/ `pip install .` in their repo); `petekStatic`'s full workflow is also reachable
through the `peteksim` facade (see the [petekStatic
guide](../libraries/petekstatic.md)).

## Verify the toolchain

```python
from peteksuite import pio, ps

man  = ps.synth_asset("/tmp/petek-demo")     # a fully synthetic Petrel-style export
proj = pio.Project.load(
    man["root"],
    settings=pio.LoadSettings(crs=man["crs"], aliases=man["aliases"]),
)
print(proj.inventory())
```

If that prints an inventory, the stack is wired end-to-end. Head to the
[flagship static-model tutorial](../tutorials/static-model-build.md) next.
