---
name: read-inbox
description: "Process the petekSuite external inbox. Use for messages from projects outside the managed library set: lift durable actions into the central owner-namespaced todo/graph state, delegate managed-library work directly through run-library-task, archive handled messages, and purge old read copies. Managed libraries no longer maintain inboxes."
---

# Read the external inbox

Operate `petekSuite/inbox/` only. Purge read messages older than seven days,
read every unread message, and classify it as external coordination, central
action, managed-library action, decision, or acknowledgement.

- Capture actions through `add-todo` with an explicit owner.
- Record seams/what-to-build in the planning graph.
- For managed-library work, invoke or schedule `run-library-task` directly; do
  not create a library inbox note.
- Use `notify` only for an external project that must act.

Append a status footer, move handled messages to `read/`, and report new central
actions, direct delegations, external handoffs, and decisions.
