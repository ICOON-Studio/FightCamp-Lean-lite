---
name: feedback-watchdog-gate-before-launch
description: Gate every launch/render on the watchdog result - never chain the check and the job in one command (S192 ran twice on RED)
metadata:
  type: feedback
---
S192: twice the watchdog printed RED (84 C, 88 C) and the Cursor launch / video re-record ran anyway, because the check and the job were
chained in one PowerShell command that ignored the result. CLAUDE.md s4: RED does not launch.
**Why:** the operator set the 84 C limit for his PC; a printed RED that does not stop the job protects nothing.
**How to apply:** run the watchdog as its own step (or `if exit 1 -> stop`) before any Godot run, render or agent launch; for a waiting
launch use a loop that breaks only on non-RED (the S192 SMOOTH2 waiter pattern). Related: [[feedback_pc_limits_80c]].

S198: did it AGAIN (Qwen CAMPFOCUS1A launched at RED 84 C from a `watchdog; launch` chain; killed by PID within a minute). Structural fix: Tools/agent_window.ps1 now runs the watchdog itself and exits 3 on RED. Trap found while building it: `& ps ... | Select-Object -First 1` leaves $LASTEXITCODE = -1 - capture all output, then read the code.
