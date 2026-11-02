---
name: be-concise-every-response
description: "User rule 2026-09-05 - every response, report and digest from every agent is concise; answer first, no padding"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 74b28f67-5460-4729-9964-f13b4064a13f
  modified: 2026-09-04T21:43:34.857Z
---

Be concise in every response, report and digest (user rule 2026-09-05, all agents).

**Why:** Credit budget ([[credit-budget-2026-09]]); long replies cost output tokens and the user reads several agents' reports a day.

**How to apply:** Answer first, no restating the ask, no narrated reasoning, no closing summary of what was just said. Cut words before facts. Mirrored as HANDOFF.md Protocol item 9 and a CLAUDE.md line. Same commit added Protocol item 10: Grok gets pure modules only, its slice goes in `## GROK START HERE` with one claim of max 20 lines, Claude splices and runs the suite after Grok pushes.
