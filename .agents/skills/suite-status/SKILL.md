---
name: suite-status
description: Produce the central petekSuite readiness view across all managed repositories, the planning graph, Actions, dependencies, seams, and owner-namespaced todos. Use after initiatives, before releases, or to answer ecosystem status; file every gap centrally and delegate library fixes directly through run-library-task. Never bump, push, dispatch, or publish.
---

# Roll up suite readiness

Read each repository's version, changelog, git status, public contract changes,
and relevant workflow state. Read the central todo namespaces and planning graph;
managed library inboxes/todo indexes do not exist.

Check:

- compatible dependency floors and registry availability;
- producer/consumer seam coherence;
- graph Task/Artifact freshness and open blocking Questions;
- CI/release endpoint consistency and exact-SHA state through `manage-actions`
  in read-only mode;
- no central action lacks an owner and no library is waiting on an unassigned
  coordinator decision.

Return a compact per-repository readiness table plus coherence verdict and gap
list. Capture cross-library and library-scoped gaps centrally through `add-todo`;
use `run-library-task` for execution only when separately authorized. Finish with
`dev-docs-cleanup`. Never mutate versions, remotes, workflows, or registries.

