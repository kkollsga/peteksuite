---
name: manage-actions
description: Centrally inspect, dispatch, monitor, retry, and reconcile GitHub Actions across petekSuite, petekTools, petekIO, petekStatic, and petekSim. Use for CI status, workflow failures, required-check coherence, workflow changes, release-run monitoring, or multi-repository Actions operations. Repository workflows remain thin local security/event endpoints; this skill never grants publish authority by itself.
---

# Manage suite Actions

Operate every repository's Actions from petekSuite. Read
[`references/workflows.md`](references/workflows.md) for repository and workflow
identity.

## Authority

- Read/diagnose/status requests authorize inspection only.
- Workflow implementation requests authorize scoped YAML/script changes and
  local validation, not pushes or dispatches unless requested.
- CI dispatch/retry requests authorize only named non-publishing workflows.
- Tagging, version bumps, registry publishing, and release workflow dispatch are
  authorized only through an explicit `release` invocation or equivalent clear
  user instruction.

Never force-push, replace tags, expose secrets, or publish manually as a shortcut.

## Inspect

For each target repo, record current branch/SHA, workflow file, run id/event/SHA,
job/check state, and first actionable failure. Prefer GitHub connector metadata;
use `gh run list/view/watch` for detailed Actions logs and exact dispatch when
needed. Correlate checks by commit SHA, never by branch name alone.

## Change

Keep push/PR triggers and repo-scoped credentials in the owning repository.
Centralize policy and orchestration, but retain thin local workflow entrypoints
because GitHub tokens, environments, required checks, tag creation, crates.io
secrets, and PyPI trusted-publisher identities are repository-bound.

Validate workflow YAML and `git diff --check`; use `actionlint` when available.
If it is unavailable, parse YAML with a safe local runtime and state clearly
that this proves syntax/readability, not GitHub expression semantics.
Preserve exact-ref validation, platform wheels, interpreter coverage, registry
visibility checks, concurrency, retries, and timing summaries.

## Operate

Dispatch explicit refs and expected versions. Monitor until terminal state,
inspect logs on failure, and retry only when idempotent. Treat `skip-existing`
publishing retries as safe only for the same version/tag/SHA. Advance dependent
release waves on actual registry availability, not unrelated GitHub Release jobs.

## Report

For remote runs, return one line per repo with workflow/run, exact SHA, status,
duration, and action. For a local entrypoint audit, report file/readability and
omit nonexistent run/duration fields. State clearly whether any dispatch, push,
tag, or publish occurred.
