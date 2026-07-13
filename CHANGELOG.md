# Changelog

All notable changes to petekSuite are recorded here. The suite package is the
Python meta-package and documentation/release coordinator for the petek family.

## [Unreleased]

## [0.1.13] - 2026-07-13

### Changed
- Advanced the umbrella floors to `petektools>=0.2.13` and
  `petekio>=0.3.13`. The pair adds click-to-inspect Map/3D interaction,
  per-object viewer styling, automatic primary/Surface-attribute fill
  selection, 3.4-cell geometry fallback bridging, typed Surface attributes,
  instance `top.thickness(base)`, and smooth/dip/extrapolation operations.
- Refreshed the unified petekTools and petekIO guides from their owning
  repositories, including the exact viewer and Surface workflows released in
  this train. Corrected the remaining documentation provenance wording.

## [0.1.12] - 2026-07-10

### Changed
- Dependency floors raised to the coherent viewer↔data seam pair:
  `petektools>=0.2.10` (view2d value-coloured fills, contour lines with bold
  index levels, depth-coded points, trimesh wireframe rendering) and
  `petekio>=0.3.11` (three-level geometry-shell system, `max_bridge` open-seam
  closing, `iso_lines`/`value_layer` producers, shell-once `.pproj` lanes).
- Central skills are now shared between Codex and Claude through a tracked
  `.claude/skills → .agents/skills` symlink; managed sublibraries carry no
  skill trees.

## [0.1.11] - 2026-07-10

### Changed
- Centralized release, GitHub Actions, todo, planning, and managed-agent
  coordination in petekSuite; removed the redundant sublibrary skill systems.
- Reworked the release train to build reusable ABI3 wheels once, fan out
  compatibility installs, publish independent dependency waves in parallel,
  retry registry visibility, and report trigger-to-install timing without
  weakening Rust, Python-version, minimal-feature, or package gates.
- Advanced the suite floors to petekTools 0.2.8, petekIO 0.3.10,
  petekStatic 0.1.12, and petekSim 0.1.11.
- `PointSet.infer_geometry(...)` now falls back to an exact `TriSurface` when a
  point set cannot satisfy a regular lattice, while continuing to return
  `GridGeometry` for genuinely regular exports.

## [0.1.10] - 2026-07-09

### Changed
- Release-train dependency floors: `petekio>=0.3.9` and `peteksim>=0.1.10`.
  petekIO 0.3.9 rejects a curvilinear mesh instead of returning a `GridGeometry`
  no node sits on, changes what `PointSet.infer_geometry(edge="occupied")`
  returns, removes the `concave_hull`/`trimesh` edge aliases, and adds
  `detect_topology(...)` + `to_tri_surface(...)`. petekSim 0.1.10 carries the
  fixed `model_build_v2` example.
- Synced `docs/libraries/petekio.md` from petekIO's guide: the point-edge default
  is now `full_rect`, and the topology-recovery / TIN-fallback flow is documented.


## [0.1.9] - 2026-07-08

### Fixed
- Fixed `peteksuite.__version__` and `peteksuite.versions()["peteksuite"]` so
  they report the installed package metadata version instead of a stale
  hardcoded value.

## [0.1.8] - 2026-07-08

### Changed
- Updated the suite meta-package dependency floors for the current release train:
  petekTools 0.2.7, petekIO 0.3.8, petekStatic 0.1.11, and petekSim 0.1.9.
- Refreshed install/reference docs so the suite points at the corrected 2-D
  viewer rendering, topology-aware point-edge, and downstream static/simulation
  coherence releases.

## [0.1.7] - 2026-07-08

### Changed
- Updated the suite meta-package dependency floors for the current release train:
  petekTools 0.2.6, petekIO 0.3.7, petekStatic 0.1.10, and petekSim 0.1.8.
- Refreshed install/reference docs so the suite points at the new point-edge,
  structured surface, and viewer topology-grid QA releases.
- Hardened release/docs workflows with binary-only retrying installs and a PyPI
  visibility verification job before GitHub Release creation.

## [0.1.6] - 2026-07-08

### Changed
- Updated the suite meta-package dependency floors for the current release train:
  petekTools 0.2.5, petekIO 0.3.6, petekStatic 0.1.9, and petekSim 0.1.7.
- Refreshed install/reference docs and examples so the suite points at the
  current `petekio.Project.import_data` / `petekstatic` project workflow.

## [0.1.5] - 2026-07-08

### Changed
- Updated the suite meta-package dependency floors for the current release train:
  petekTools 0.2.4, petekIO 0.3.5, petekStatic 0.1.8, and petekSim 0.1.6.
- Refreshed install and reference docs so the suite points at the newly
  published family versions and petekIO's current `Project.import_data` API.

## [0.1.4] - 2026-07-07

### Changed
- Updated the suite meta-package dependency floors for the current release train:
  petekTools 0.2.4, petekIO 0.3.4, petekStatic 0.1.7, and petekSim 0.1.5.
- Refreshed install and reference docs so the suite points at the newly
  published family versions.

## [0.1.3] - 2026-07-07

### Added
- Added lazy `pio`, `pto`, `pst`, and `ps` shorthand imports to the `peteksuite`
  umbrella package.

### Changed
- Updated the suite meta-package dependency floors for the current release train:
  petekTools 0.2.4, petekIO 0.3.3, petekStatic 0.1.6, and petekSim 0.1.4.
- Updated the release workflow to the Actions-owned tag creation and publishing
  flow.

## [0.1.2] - 2026-07-07

### Changed
- Updated the suite meta-package dependency floors for the current release train:
  petekTools 0.2.3, petekIO 0.3.2, petekStatic 0.1.5, and petekSim 0.1.3.
- Refreshed install and reference docs so the suite points at the newly
  published family versions.

## [0.1.1] - 2026-07-06

### Changed
- Refreshed the unified documentation and executed notebook copies for the
  fortified foundation release wave.
- Updated the suite meta-package dependency floors to the new family patch
  releases: petekTools 0.2.2, petekIO 0.3.1, petekStatic 0.1.2, and petekSim
  0.1.2.
- Added the suite-level release skill: the coordinator now checks subrepos one by
  one, announces unreleased changes and planned versions, sweeps docs/changelogs,
  verifies release workflows, bumps versions, tags, and monitors CI/release/RTD.

## [0.1.0] - 2026-07-05

Initial public suite meta-package and unified documentation release.
