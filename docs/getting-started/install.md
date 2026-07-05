# Install

The suite is distributed **per library**, on both **crates.io** (Rust) and
**PyPI** (Python). Each library is usable standalone; you only need the layers
your work touches.

!!! info "Publishing shortly"
    The wheels and crates are cut and **publishing shortly**. The versions below
    are the pinned release versions; until they land on the public indexes, build
    from the sibling source trees (see [from source](#from-source)).

## The install matrix

| Library | Layer | `cargo` | `pip` | Version |
|---|---|---|---|---|
| **petekTools** | TOOLKIT | `cargo add petektools` | `pip install petektools` | `0.2.0` |
| **petekIO** | DATA | `cargo add petekio` | `pip install petekio` | `0.3.0` |
| **petekStatic** | GEOMODEL | `cargo add srs-model` (+ `srs-*`) | `pip install petekstatic` | `0.1.0` |
| **petekSim** | SIMULATION | `cargo add peteksim` | `pip install peteksim` | `0.1.0` |

`peteksim` is **the product** — the single Python facade over the whole stack. If
you just want to go from a data export to a STOIIP P-curve, install `peteksim`
and you pull in the rest transitively.

!!! note "petekStatic on crates.io"
    petekStatic is a Cargo **workspace** of small `srs-*` crates — there is no
    single `petekstatic` crate. Rust consumers add the aggregate `srs-model` (the
    `StaticModel` surface) and any specific `srs-*` crate they need (`srs-grid`,
    `srs-gridder`, `srs-volumetrics`, …). The Python **`petekstatic`** wheel is a
    minimal, emerging surface; the full geomodel workflow is driven today through
    the [`peteksim`](../libraries/peteksim.md) facade.

=== "Python (pip)"

    ```bash
    # The whole stack behind one façade:
    pip install peteksim

    # Or a single layer, standalone:
    pip install petekio          # the data layer
    pip install petektools       # the toolkit (kernels + units + viewer)
    ```

    Python 3.9+ ; the wheels are PyO3/abi3 (no local Rust toolchain needed once
    published).

=== "Rust (cargo)"

    ```toml
    [dependencies]
    petektools = "0.2"
    petekio    = "0.3"
    srs-model  = "0.1"   # petekStatic's StaticModel aggregate (+ other srs-* as needed)
    peteksim   = "0.1"
    ```

    Add only the layers you depend on — the DAG is one-directional, so a data-only
    consumer needs `petekio` (and transitively `petektools`) and nothing above it.
    petekStatic ships as the `srs-*` workspace crates (see the note above).

## From source

Before the indexes go live, build the wheels from the sibling repos. `peteksim`
composes the whole stack, so its build pulls the others in as path deps:

```bash
# 1. Build the horizontal toolkit wheel first (peteksim depends on it):
python -m pip install ./petekTools

# 2. Build peteksim (compiles the petekStatic + petekIO path deps via cargo):
python -m venv .venv-srs
VIRTUAL_ENV="$PWD/.venv-srs" .venv-srs/bin/maturin develop -m petekSim/crates/srs-py/Cargo.toml

# 3. Verify:
.venv-srs/bin/python -c "import peteksim as ps; print(ps.version())"
```

`petekIO` and `petekTools` build the same way (`maturin develop` / `pip install
.` in their repo). `petekStatic` is a Rust workspace today; its Python surface is
reached through the `peteksim` facade (see the [petekStatic
guide](../libraries/petekstatic.md)).

## Verify the toolchain

```python
import peteksim as ps

man  = ps.synth_asset("/tmp/petek-demo")     # a fully synthetic Petrel-style export
proj = ps.Project.load(man["root"],
                       settings=ps.LoadSettings(crs=man["crs"], aliases=man["aliases"]))
print(proj.inventory())
```

If that prints an inventory, the stack is wired end-to-end. Head to the
[flagship static-model tutorial](../tutorials/static-model-build.md) next.
