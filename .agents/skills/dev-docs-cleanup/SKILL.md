---
name: dev-docs-cleanup
description: "Tidy the single central petekSuite dev-docs control plane, including owner-namespaced managed-library actions. Use before coordinate initiatives and after suite-status/release: purge aged temp/bin files, reconcile central todos with plans and graph state, archive completed actions, and ensure no sublibrary-local todo or inbox control surface has reappeared. Never delete referenced technical designs or benchmark records."
---

# Clean central dev-docs

Operate only from petekSuite.

1. Purge `dev-docs/temp/` files older than one day and `dev-docs/bin/` files
   older than seven days; report paths.
2. Read `dev-docs/todos.md`, then only its referenced plan files and any
   unbacklinked files under `dev-docs/plans/` or
   `dev-docs/libraries/*/plans/`.
3. Reconcile each action with git and graph state. Archive complete/superseded
   action docs to `dev-docs/bin/<owner>/` and remove their index lines. Trim
   partial items to remaining work.
4. Verify every active line has an explicit owner and durable backlink.
5. Verify managed libraries contain no `.claude/skills`, local todo index, or
   inbox routing state. Preserve library technical designs, benchmark
   scripts/results, and source-referenced paths.

Never read or prune design directories indiscriminately. In a larger authorized
flow, perform the tidy directly; standalone, show the proposed destructive moves
before applying them.
