---
name: feedback_approvals_visible_on_board
description: S191 operator - every approval question on the ops board must show the thing approved (doc/still) under it; ask --attach
metadata:
  node_type: memory
  type: feedback
  originSessionId: fe303029-85b2-4be6-8131-da16524e6bd5
  modified: 2026-10-09T21:49:53.611Z
---

Operator S191 (2026-10-10): "when i need to approve something i want to be able to see it on the opsboard".

**Why:** he approves from the board (often his phone); a question that only names a research file he cannot open is not approvable.

**How to apply:** `python Tools/agent_comms.py ask "<text>" --options "Approve ...|..." --attach research/<doc>.md|previews/<still>.png`.
The board (8787/) renders a .md (tables included) and images under the question; `/attach?path=` opens the full page. `ask` REFUSES
an approval without `--attach` (rc 2). Allowed roots: research, Godot/docs, Godot/concepts, AgentComms. After editing
Tools/opsboard/server.py the scheduled-task server must be restarted (kill the 8787 listener by PID, Start-ScheduledTask
"FightCamp Ops Board") - and check for a SECOND stale server.py on 8787 (S191 found one from the day before answering half the
requests). Related: [[feedback_ask_pending_issues_at_start]], [[feedback_ludo_is_lead_designer]].
