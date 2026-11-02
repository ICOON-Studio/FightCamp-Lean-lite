---
name: feedback_ludo_gate_visual_ui
description: "S212 operator - every visual improvement and every UI change passes Ludo FIRST (plan before build + result stills after), then the operator"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 16349a03-8b54-413e-8847-90d003be8921
  modified: 2026-10-12T17:44:57.450Z
---

Operator 2026-10-12 (S212), verbatim: "visual approvements and UI must pass from ludo first then ask me".

**Why:** Ludo is the lead game + art designer ([[feedback_ludo_is_lead_designer]]); the operator wants to see only work the designer
already passed, not raw agent output.

**How to apply:** for any look/UI task (gym textures/effects, HUD, screens, cast look, wardrobe): (1) before build, send Ludo the
current stills + the plan, save the reply verbatim, write "## Ludo direction" into the TASK file - the agent builds to it; (2) after
build, send Ludo the result stills (game camera), agent fixes rejects; (3) only then `review_add.py` + board `ask --attach` for the
operator. Write the gate into every such brief (TASK_GYMLOOK3A.md has the template "LUDO GATE"). Ask rules:
[[feedback_ludo_huge_questions]], [[feedback_ludo_game_facts_sheet]], [[feedback_ludo_wrong_chat]].
Not for pure defect fixes that restore approved behaviour (e.g. bodies overlapping) - those go straight to the operator's stills.
