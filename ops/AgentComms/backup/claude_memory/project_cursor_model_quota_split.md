---
name: project_cursor_model_quota_split
description: "Cursor Pro has two pools; 2026-09-26 BOTH nearly spent (Cursor Models 88%, Other 100%) - operator: use Cursor until it runs out (resets 10-07), on-demand spend set to $0"
metadata:
  node_type: memory
  type: project
---

**UPDATE 2026-09-26 (operator screenshot): Cursor Models 88% used, Other Models 100%. Past the limit it bills
ON-DEMAND spend. Operator then ruled: 'continue using cursor until it runs out' - so keep assigning it until the
quota stops it (resets 2026-10-07); operator asked to set on-demand spending to $0 so running out stops, not bills.**

Cursor Pro ($20/mo) meters **two pools independently**, and on 2026-09-08 only
one was empty:

- **Other Models** (Claude, GPT, Gemini through Cursor): **100% used**. Refills
  at the plan reset, **2026-10-07**. Anything beyond it is on-demand spend -
  actual money, not included quota.
- **Cursor Models** (Composer, Cursor Grok): **6% used**. A separate allowance,
  unaffected by the above.

**Why:** the operator read "100% used" as "Cursor is out of credits" and
assumed the agent was dead for the month. It is not - it lost its frontier
models, not its seat.

**How to apply:** the Cursor Models pool carries **Grok 4.6**, not just
Composer - the operator confirmed it running U8 on 2026-09-08. That is a
top-tier model on the untouched meter, so Cursor stays the preferred build
agent ([[project_cursor_preferred_build_agent]]) at FULL task difficulty. Until
Oct 7 just set the task's `Model:` line to Cursor Grok 4.6; do NOT simplify the
spec or reroute hard work elsewhere. Only the Claude/GPT route is closed.

Separately, the **Grok Bot** meter is WEEKLY, not monthly: 98% used on
2026-09-08, resets 2026-09-10.
