# Changelog

All notable changes to petekSuite are recorded here. The suite package is the
Python meta-package and documentation/release coordinator for the petek family.

## [Unreleased]

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
