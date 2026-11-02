---
name: feedback-restart-board-via-task
description: S197 - never restart the ops board or watchdog by hand; Start-ScheduledTask only. A pythonw server flashed a cmd window per git call.
metadata:
  node_type: memory
  type: feedback
  originSessionId: 64afc40a-7ee3-4770-a77c-92b84ab34efe
  modified: 2026-10-10T21:39:11.690Z
---

S197 (2026-10-11): I killed the ops board server and restarted it with `pythonw.exe` (no console). Every `git` /
`agent_comms.py triage` child it spawned then got its OWN console window -> cmd windows blinking on the operator's screen
for minutes ("i do not want this to happen ever again", "stop it", furious). Also started a duplicate watchdog loop.

**Why:** a console-less parent makes each console child (git, python) open a visible window; the scheduled tasks run them
correctly hidden.

**How to apply:** after editing Tools/opsboard/server.py or Tools/pc_watchdog.ps1, restart ONLY with
`Stop-Process -Id <pid>` then `Start-ScheduledTask -TaskName "FightCamp Ops Board"` / `"FightCamp PC Watchdog"`.
Never `pythonw`/`Start-Process` a server that spawns subprocesses. After any restart, diff the process list for 20 s and
confirm no new conhost/cmd/git appear. Related: [[feedback-verify-the-launch-not-the-guess]].
