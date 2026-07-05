# Rust API (docs.rs)

Every library has a pure-Rust core; the Python wheels are thin PyO3 bindings over
it. The Rust API reference is published on **docs.rs** at each pinned version.

| Crate | Layer | docs.rs |
|---|---|---|
| `petektools` | TOOLKIT | [docs.rs/petektools/0.2.0](https://docs.rs/petektools/0.2.0) |
| `petekio` | DATA | [docs.rs/petekio/0.3.0](https://docs.rs/petekio/0.3.0) |
| `srs-model` (petekStatic) | GEOMODEL | [docs.rs/srs-model/0.1.0](https://docs.rs/srs-model/0.1.0) |
| `peteksim` | SIMULATION | [docs.rs/peteksim/0.1.0](https://docs.rs/peteksim/0.1.0) |

!!! info "Publishing shortly"
    These links resolve once the crates publish to crates.io. Until then, build
    the docs locally in each repo with `cargo doc --open`.

## Building the Rust docs locally

```bash
# In any library repo:
cargo doc --no-deps --open        # this crate's API
cargo doc --workspace --open      # the whole workspace (petekStatic / petekSim)
```

petekStatic and petekSim are Cargo **workspaces** of small, single-responsibility
crates — `cargo doc --workspace` renders every member. See each library's `SPEC.md`
and `API.md` for the design constitution and the locked public contract.
