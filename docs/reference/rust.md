# Rust API (docs.rs)

Every library has a pure-Rust core; the Python wheels are thin PyO3 bindings over
it. The Rust API reference is published on **docs.rs** at each pinned version.

| Crate | Layer | docs.rs |
|---|---|---|
| `petektools` | TOOLKIT | [docs.rs/petektools/0.2.0](https://docs.rs/petektools/0.2.0) |
| `petekio` | DATA | [docs.rs/petekio/0.3.0](https://docs.rs/petekio/0.3.0) |
| `petekstatic` | GEOMODEL | [docs.rs/petekstatic/0.1.0](https://docs.rs/petekstatic/0.1.0) |
| `peteksim` | SIMULATION | [docs.rs/peteksim/0.1.0](https://docs.rs/peteksim/0.1.0) |

Each library publishes exactly **one crate**; internal structure is modules,
not extra crates.

## Building the Rust docs locally

```bash
# In any library repo:
cargo doc --no-deps --open        # this crate's API
```

See each library's `SPEC.md` and `API.md` for the design constitution and the
locked public contract.
