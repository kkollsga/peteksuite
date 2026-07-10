---
name: notify
description: Send an asynchronous coordination note from petekSuite to an external project outside the four managed libraries. Use only when direct agent execution is impossible or another repository/team must act. Managed petekTools, petekIO, petekStatic, and petekSim work must use run-library-task instead of inbox messages.
---

# Notify an external project

Never notify a managed library; spawn its agent through `run-library-task`.

Resolve the external repository under the Koding parent, avoiding build/cache
directories and treating `mcp-servers` as one project. If resolution is
ambiguous, ask before writing.

Write `<target>/inbox/unread/YYYY-MM-DD-from-petekSuite-<topic>.md` with From,
To, Date, Type, context, concrete ask, and references. Sign as `petekSuite`.
Report the exact path and keep the note concise. Use only for genuine external
handoffs, not as a substitute for direct collaboration.

