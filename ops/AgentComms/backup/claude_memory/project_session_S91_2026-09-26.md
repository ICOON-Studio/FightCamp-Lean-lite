---
name: project-session-S91-2026-09-26
description: S91 shipped the front door (lobby, museum, capped G124 walk-in funnel, $320 desk hire, left-wall doorways); Q192 merged; operator bought Tripo Pro; agent windows now self-close
metadata:
  type: project
---

S91 (2026-09-26) shipped the front door: `FrontDoor.gd` (G124 funnel, conversion hard-capped at 40%, joins never past
the market gap, so the lobby can only close the gap faster), `Lobby3D.gd`/`LobbyPanel.gd` (route `lobby`), desk hire
$320/wk, floor doors moved into the LEFT wall (the front wall is a knee-high cutaway that cropped them). Q192 merged
(boxing plan sameness = `ROLE_PRIORITY_FROM_PLAN` off; 78% of MMA throws have an empty technique id) -> Q193 running.

**Operator 2026-09-26: "i got trippo pro"** -> S92 = regenerate the twelve fighters + portraits ([[project-tripo-free-plan-terms]]).
**Operator 2026-09-26: "close all admin cells that you do not need"** -> six finished agent cmd windows closed;
`Tools/agent_window.ps1` switched `/k` -> `/c` so agent windows close when the run ends.
**Why:** /k kept every finished Administrator window open. **How to apply:** before handover, list windows titled
"Administrator:" and close finished ones; check child processes first (a live cursor-agent runs as hidden node.exe).
Qwen launched from Claude's shell via `cmd //c Tools\qwen_task.cmd` runs headless (no window); set it Idle by hand.
