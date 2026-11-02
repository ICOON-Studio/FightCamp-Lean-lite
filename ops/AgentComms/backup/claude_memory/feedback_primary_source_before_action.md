---
name: feedback-primary-source-before-action
description: "Operator 2026-09-27: never act on a summary (memory note, topic page, digest headline, triage verdict) - open the primary source's whole section before writing a task, retiring a route or telling the operator what exists"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 248418a0-216f-4847-bc58-ebe4dee2b716
  modified: 2026-09-27T19:48:59.309Z
---

Operator 2026-09-27 (S114): "we have already done these steps and produced clips that fixed the grip ... why we are moving backwards?" and "why didn't you catch that earlier?".

I re-routed C221/C222 and retired the C199 branch because a memory note said "the suit route ... failed" and C199's first line said "NOT PROVEN - stopped at row 2". The digest body said the Blender-MCP authoring WORKED and a finished closed guard waited to be bound.

**Why:** summaries compress away exactly the part that matters; acting on them undoes finished work and costs the operator's trust.
**How to apply:** before a task, a stop/retire, a merge/discard, or a status claim, open the primary source (digest body, delivered files, branch diff, live tool state), read the relevant section whole, and say which source you read. Source beats summary; fix the summary in the same session. CLAUDE.md rule + prior-research gate (topic pages alone fail). Related: [[feedback_research_is_the_projects_memory]], [[feedback_verify_live_state_not_notes]].

**S115 repeat (2026-09-28), operator: "stop doing that every session, are you really inteligent ?"** - Claude told him video
had "never turned into usable game motion" while route_decisions.json held his suit route RESUMED with tracking PASSED
(C180). Same failure, spoken in chat instead of acted on. Mechanical fix: `agent_comms.py start` now prints ROUTE STATUS
(every live route's PROVEN / OPEN, quoted from its digest). **Before stating any route's or tool's status to the operator,
quote that block or the digest - never a paraphrase from memory.**
