---
name: feedback-usage-economy
description: Operator 2026-10-02 (Pro plan, 12% weekly in ~13 h) chose "the cheaper mode" - Sonnet/medium default, connectors off, one stage per session, delegate by default
metadata:
  type: feedback
---
Operator 2026-10-02: "switch to the cheaper mode first and do 1-4 actions" after asking why 12% of the weekly limit went
in ~10 h. Done: ~/.claude/settings.json model=sonnet effortLevel=medium; Higgsfield, Higgsfield Blender, Claude Docs
connectors OFF by default (~270 tools); CLAUDE.md s3 + s8 rules (one stage per session, hand over at ~250k context (raised from 150k 2026-10-03: "i want to finish bigger tasks per session"),
delegate implementation to shell agents). Not chosen: relaxing the never-idle Stop hook (action 5).

**Why:** Pro plan weekly limit; at the S140 pace it runs out ~day 5 of 7.
**How to apply:** check `get_usage` at stage boundaries; `start` once; brief agents instead of coding; re-enable a
connector only for a task that needs it. Related: [[feedback_working_brief_2026-09-29]], [[project_credit_budget_2026-09]].
