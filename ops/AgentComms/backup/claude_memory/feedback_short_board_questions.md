---
name: feedback_short_board_questions
description: S212 operator - board questions are short summaries (1-2 lines + the ask); all detail goes in the --attach document
metadata:
  node_type: memory
  type: feedback
  originSessionId: 16349a03-8b54-413e-8847-90d003be8921
  modified: 2026-10-12T18:19:22.901Z
---

Operator 2026-10-12 (S212), verbatim: "can you make the sumaries instead of all this text on the questions please".

**Why:** he reads the board on the main page; long question texts bury the decision. The attached verdict/still carries the detail.

**How to apply:** `agent_comms.py ask` text = one or two short sentences (what it is + the decision) ending in the question, under
~200 characters; everything else in the `--attach` file. Same spirit for chat replies to him: summary first, short. Related:
[[feedback_approvals_visible_on_board]], [[feedback_questions_for_operator_go_on_the_board]].
