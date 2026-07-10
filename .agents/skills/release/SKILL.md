---
name: release
description: "Centrally run the complete petekSuite release train across all managed repositories. Use only on an explicit release request: inspect releasable changes, supervise library agents for docs/version/gates, commit and push intentionally, delegate exact-SHA workflow operations to manage-actions, publish in dependency waves, verify registry installability, and fix/retry until complete."
---

# release

Run releases from the suite root, but treat each library as its own repo. The
coordinator drives the sequence and verification; it does not blend library
histories or release two repos in one commit.

This is the only skill that grants suite publishing authority. Use
`run-library-task` for each repository's preparation and `manage-actions` for
CI/release dispatch and monitoring. Managed libraries have no release skills.

## Automation boundary

Use GitHub Actions as much as possible. The agent's job is to prepare the repo,
run useful local preflight checks, create and push the release commit, dispatch
the release workflow, monitor automation, and fix failures. GitHub Actions is
the authoritative CI gate, the normal tag creator, and the only normal
publishing path.

- Do not publish to crates.io, PyPI, GitHub Releases, or Read the Docs manually
  from the agent unless the user explicitly authorizes a one-off recovery.
- Do not push release tags in the normal path. The repo release workflow creates
  or reuses the matching `v<version>` tag after its gates pass.
- Local gates are preflight only. Passing locally is not permission to publish;
  the branch CI and release workflow gates must pass before publishing.
- Release workflows may still accept an existing same-SHA tag for recovery, but
  they must reject a matching version tag that points at any other commit.

## Order

Default release train waves:

1. `petekTools`
2. `petekIO` and `petekStatic` in parallel, after the required petekTools
   version is visible on their consumed registries
3. `petekSim`, after any required IO/Static versions are visible
4. `petekSuite` meta-package, after all versions named by its dependency floors
   are installable from PyPI

Prepare and gate every repo independently. Repositories in the same wave may be
committed, pushed, gated, and published concurrently; never cross a dependency
wave until each actually required upstream artifact is installable. A GitHub
Release page is not an artifact-availability gate.

## Pre-sweep announcement

Before editing docs, changelogs, versions, or release files, inspect every
managed subrepo and report the release plan to the user:

- libraries with unreleased changes
- latest release tag for each
- old version and planned new version for each
- skipped libraries and why

Then continue directly into the docs/changelog sweep. This announcement is
informational only; do not wait for feedback unless the user asked for approval
or the planned version requires a major/minor decision the user has not made.

## Push authorization

Invoking `/release` is authorization to commit, tag, and push every managed
subrepo with unreleased changes in this release train, including the CI
fix-and-recommit loop needed to complete those releases. The authorization is
scoped to this one release run and these release targets; it does not authorize
unrelated pushes, force-pushes, or deleting/replacing a remote release tag.

Before the first push for each repo, report the repo, old version, new version,
commit message, tag, and whether the working tree is clean except for intended
release files. This is informational during `/release`; continue unless the
state is unsafe or the user interrupts.

Never force-push a release tag. If a pushed tag is wrong, stop and ask.

## Per-repo release loop

For each repo:

1. Enter the repo and inspect state:
   - `git status --short`
   - `git fetch --tags origin`
   - current branch, upstream, and ahead/behind status
   - latest reachable `v*` tag
   - commits since that tag
2. Decide whether a release is needed:
   - release if there are committed changes since the latest release tag, or if
     the user explicitly requested this repo
   - do not silently package unrelated dirty changes; inspect them and include
     only if they are intended for the release
   - skip clean repos with no release-worthy commits
3. Sweep docs and changelog against the release diff:
   - inspect the committed changes since the latest release tag, not just the
     dirty working tree
   - identify user-facing changes, API changes, CLI changes, data/schema/file
     format changes, workflow changes, examples/notebook changes, dependency
     version changes, and deprecations/removals
   - update the repo's docs at the right level: README quick-start, API docs,
     user guides, examples, notebooks, migration notes, release docs, and any
     suite-synced docs source that the repo owns
   - for notebooks, preserve the house pattern: separate cells for synthetic
     data generation, data loading, and the showcased method; make it clear how
     a user swaps synthetic data for their own dataset
   - update `CHANGELOG.md` or the repo's equivalent with concise release notes:
     enough detail for users to understand impact and migration needs, without
     dumping implementation history
   - if no docs or changelog update is needed, state why in the release report
   - run docs/notebook checks when the repo provides them; otherwise at least
     build or smoke the changed examples locally where practical
4. Determine the version:
   - read the current package version from Cargo metadata or workspace
     `Cargo.toml`
   - default bump is patch
   - use minor, major, or an exact version only if the user explicitly requested
     it for this run
   - check historical floors in `dev-docs/designs/release-versions.md` when doing a
     first clean release or after yanks/deletions
5. Update dependency floors for the release train:
   - update a downstream floor only when its code or public contract requires
     an API/fix first shipped by that upstream version; a synchronized train by
     itself is not a reason to raise a floor
   - preserve the oldest compatible floor when the downstream diff does not use
     the new upstream behavior, avoiding no-op cascade releases
   - update Cargo workspace dependencies, in-repo self dependency versions, and
     Python package dependency floors (`pyproject.toml`) as applicable
   - update the `petekSuite` meta-package floors after all library planned
     versions are known
   - keep floors as lower bounds unless the repo intentionally uses exact pins
   - run the downstream repo gates after floor updates so dependency coherence is
     tested before tagging
6. Run the repo's pre-release gates before the bump:
   - prefer the repo's documented local gate if present (`Makefile.local`,
     `justfile`, release docs, or `AGENTS.md`)
   - otherwise mirror CI/release workflow gates: format, clippy, Rust tests,
     Python wheel build/import tests, notebook/docs gates when present
7. Bump the version in the authoritative TOML:
   - Rust/PyO3 libraries: bump workspace/package version in `Cargo.toml`
   - keep in-repo self dependency versions aligned, such as
     `petekstatic = { path = ".", version = "..." }` or
     `peteksim = { path = ".", version = "..." }`
   - PyPI versions should remain derived from Cargo/maturin when
     `pyproject.toml` has `dynamic = ["version"]`
   - update `Cargo.lock` if it changed or if the package version is locked there
8. Run the full release gates again after the bump.
9. Verify the tag/version contract locally:
   - compute the package version from Cargo metadata
   - planned tag must be exactly `v<version>`
   - if they differ, fix the TOML/version plan before committing
10. Commit the release:
   - commit only intended release files, intended already-existing work, and the
     docs/changelog updates justified by the release diff
   - use `chore: release <version>` unless the repo has a stricter convention
11. Push the branch commit under `/release` authorization:
    - push the branch commit only
    - do not push the `v<version>` tag in the normal path
12. Monitor branch CI on GitHub:
    - use `gh run list` / `gh run watch` when available
    - watch the CI workflow(s) triggered by the branch push
    - inspect failing logs with `gh run view --log`
    - if CI fails, fix locally, run relevant local checks, recommit, push the
      branch again, and repeat this step
13. Dispatch the repo release workflow after branch CI passes:
    - verify the pushed branch commit SHA is the intended release commit
    - pass the intended branch/ref and expected version when dispatching
    - the workflow must verify the version contract, run release gates, create
      or reuse `v<version>` on that same commit, and publish
14. Monitor the release/publish workflow:
    - use `gh run list` / `gh run watch` when available
    - watch the release workflow triggered by `workflow_dispatch`
    - inspect failing logs with `gh run view --log`
    - verify crates.io, PyPI, GitHub Release, and RTD outcomes as applicable
    - advance a dependent wave as soon as the required crate/PyPI artifact is
      installable; do not wait for unrelated GitHub Release or RTD jobs
15. Fix and retry until complete:
    - for CI failures on the branch commit: fix, test locally, recommit, push
    - for release workflow failures before tag creation or registry publish:
      fix, test locally, recommit, push, wait for branch CI, then rerun the
      release workflow for the same planned version
    - trusted-publishing steps retry transient failures in-workflow. If all
      attempts fail after the tag exists, rerun only when `skip-existing` makes
      a partial upload safe
    - for partial registry publishes: never re-use the same version blindly;
      inspect which targets published, then decide whether to re-run safely or
      bump again

## Required release workflow checks

Before trusting a repo's automation, confirm its GitHub Actions release workflow:

- supports `workflow_dispatch` with a release ref and expected version
- validates `v<version>` equals the Cargo metadata version
- creates or reuses `v<version>` only after release gates pass, and refuses an
  existing same-version tag on another commit
- publishes to crates.io when the Rust crate is meant to be public
- publishes PyPI through trusted publishing or a configured token
- creates a GitHub Release if the user expects GitHub Releases
- leaves Read the Docs to its webhook/tag build unless the repo intentionally
  calls the RTD API

If any of these are missing, report the gap before pushing. Fix the workflow
first when the missing piece would make the release incomplete.

## Read the Docs

Read the Docs does not read `Cargo.toml` as the release authority. It builds
branches/tags according to the RTD project webhook and `.readthedocs.yaml`.
During release:

- confirm the repo has the intended `.readthedocs.yaml`, or that docs are served
  only by the suite-level unified docs
- after the release workflow creates the tag, confirm the RTD build for that tag
  or default branch started and completed when RTD is part of the release
  promise

## Reporting

Report one line per repo:

- skipped / released / blocked
- old version -> new version
- docs/changelog status, including why no update was needed if unchanged
- commit SHA and tag
- CI status
- crates.io, PyPI, GitHub Release, and RTD status

End with the first unresolved blocker, or with "release train complete" only
when every requested repo is published and verified.

Also report elapsed time for each wave and trigger-to-install time for the suite
meta-package so regressions in the release train stay visible.
