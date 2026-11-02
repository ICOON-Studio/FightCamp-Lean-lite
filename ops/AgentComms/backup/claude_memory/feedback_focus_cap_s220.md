---
name: feedback_focus_cap_s220
description: "Operator S220 'act on this tighten the scope' - max 14 FOCUS queue rows on the demo path; PARKED rows need his call before any brief/launch/Ludo round"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 0f1fcebb-33a4-4ec0-9970-09f799f6ef89
  modified: 2026-10-13T19:32:12.970Z
---

At most 14 FOCUS rows in AgentComms/roadmap.json queue (`queue.focus_rule`, research/SCOPE_S220.md, CLAUDE.md s2). A row is
FOCUS only if it is on the demo path (New Career -> gym -> train -> book -> watch the fight -> result) or fixes a defect the operator
has seen. A new row enters only when one leaves; everything else is PARKED (`start` hides PARKED via _CLOSED_STATE).

**Why:** 92 open rows, 339 unmerged branches, 493 triage items - every area moved a little each session and nothing finished
(Claude's own assessment, operator: "act on this tighten the scope").

**How to apply:** before writing a brief, launching an agent or asking Ludo, check the row is FOCUS; a PARKED row needs the
operator's call first. A new operator request becomes a FOCUS row only by retiring or finishing one. Related: [[project_session_S220_2026-10-13]].
