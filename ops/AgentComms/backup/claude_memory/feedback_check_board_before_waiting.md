---
name: feedback_check_board_before_waiting
description: S219 operator - always read the board's answers (AgentComms/questions.json + media_comments.json) before saying "waiting for your answers"
metadata:
  type: feedback
---
Operator S219, verbatim: "always check board before stating you are waiting for my answers". I told him twice I was waiting on
Q-S212-16/17 while he had answered both 15 min earlier ("Approve all", "attachment does not work").

**Why:** he answers on the board (8787/), not in chat; a "waiting on you" line that is already answered wastes his time and stalls work.

**How to apply:** before any status line that names a pending question or comment, read AgentComms/questions.json (answer field) and
AgentComms/media_comments.json (seen_by_claude false) and act on what is there. Board attachments must live inside the repo
(an E:\ path outside it is not served - "attachment does not work"). Related: [[feedback_questions_for_operator_go_on_the_board]],
[[feedback_approvals_visible_on_board]].
