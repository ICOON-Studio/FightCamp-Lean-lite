---
name: feedback_no_agent_windows
description: "Operator: NOTHING may pop up on his monitors - no agent consoles (hidden), no Photos/viewer windows (agents read images with their file tool; Tools/no_popups.ps1 guard), previews as SendUserFile attach"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 5812acc7-b375-4080-9320-a46dffa31a68
  modified: 2026-10-01T21:32:57.895Z
---

Nothing Claude or an agent starts may open a window on the operator's screens (he has two monitors; the second, 1360x768
at x=1920, is where things land).

History: 09-20 "i want to see the agents clis" -> 09-22 "stop making those cli shells popping up" -> 09-25 Minimized ->
09-30 (S131) "i do not want to see these at all" (empty Administrator consoles) -> S138 "open everything in background do
not interupt on the other monitor" -> **2026-10-02 (S139): "stop the windows popping up on my other monitor and put that
in your memory" + "wtf are all these photos popping up all the time"** - seven Microsoft Photos windows in two hours:
agents told to "OPEN every still" launched the PNGs in the default viewer instead of reading them with their file tool.

**Why:** every pop-up steals his screen while he works or plays; he has asked five times.

**How to apply:**
- Agent consoles: `Tools/agent_window.ps1` starts them `WindowStyle Hidden` (Windows Terminal ignores Minimized).
  Grok via `Start-Process powershell -WindowStyle Hidden ... Tools\grok_task.ps1`.
- Images/videos: view with the Read/file tool or ffmpeg contact sheets only - never `start`, `Invoke-Item`,
  `os.startfile`, `explorer`, a browser pane or SendUserFile display=render. Every brief/prompt says "OPEN = your
  file-read tool, never a viewer" (CLAUDE.md s4 rule, ROLE_QWEN_ROOM_DESIGNER.md).
- Guard: `Tools/no_popups.ps1` (hidden, idle) closes Photos/Paint processes started after it began; agent_window.ps1
  starts it on every launch; start it by hand at session start if agents are already running. Log:
  AgentComms/no_popups.log. He can pause it with AgentComms/allow_viewers.flag.
- Windowed Godot only via Tools/godot_hidden.ps1 (moved to -32000,-32000).
- If a window is already open: SW_HIDE the agent's own console (never close it - that kills the agent); close viewer
  windows the guard missed. [[feedback_verify_the_launch_not_the_guess]]
