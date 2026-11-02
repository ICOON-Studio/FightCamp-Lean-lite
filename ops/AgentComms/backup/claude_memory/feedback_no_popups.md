---
name: feedback-no-popups
description: operator 2026-09-25 "stop those popups" - agent/app windows must never jump in front of him; launch minimized
metadata:
  type: feedback
---

While the operator works at the PC, windows Claude launches (agent consoles, Grok Bot, Cici) must not pop up. `Tools/agent_window.ps1` now uses WindowStyle Minimized; minimize any app window Claude starts.

**Why:** "stop those popups" (2026-09-25) - the visible agent windows from the 2026-09-20 "i want to see the agents clis" rule landed on top of his work.
**How to apply:** launch minimized (taskbar only); godot_hidden.ps1 for Godot renders; only open a VISIBLE window when he asks to watch (e.g. the tutorial playthrough).
