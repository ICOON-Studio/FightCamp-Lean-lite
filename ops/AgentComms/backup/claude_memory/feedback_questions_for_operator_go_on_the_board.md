---
name: feedback-questions-for-operator-go-on-the-board
description: S199 - a question for the operator belongs on the ops board main page (agent_comms.py ask --attach), not only the review page or chat prose
metadata:
  type: feedback
---
S199: I posted "your call: keep the right 38% clear?" in chat and the /review page only; operator: "why this is not on the opsboard?".

**Why:** he answers at 8787/ ("Questions for you"); /review is a comment thread. CLAUDE.md s3 says every question goes on the board.
**How to apply:** `python Tools/agent_comms.py ask "<text>" --options "a|b|c" --attach <still>` the moment a taste/scope question appears; stills still go to review_add too. Related: [[feedback_approvals_visible_on_board]].
