---
name: feedback-check-pc-before-heavy-jobs
description: Operator 2026-09-26 "i do not want this to happen ever again" - run Tools/pc_watchdog.ps1 -Once before any heavy job; RED = don't start; installs/caches on D:, never scan a whole drive
metadata:
  type: feedback
---
S92 lagged the PC badly: C: was full (3.7 GB free of 465), and I ran a 2.4 GB ROCm download plus a whole-AppData `du`
scan, which set Defender off. The operator wants warnings for low memory/CPU/temperature/space and to be told which
tabs to close.

**Why:** the PC is the operator's only machine ("i cant buy new pc"), shared with their own work. **How to apply:** before
any suite/subset, install, big download, agent launch or disk scan run
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` - exit 1 = RED, stop and tell the
operator what to close. The logon task "FightCamp PC Watchdog" pops up warnings; its last reading is
AgentComms/pc_health.txt. Put installs and caches on D: (D:\AI). Size named folders only, never `du` a whole tree. Related:
[[feedback-two-agents-max-idle-priority]], [[project-pc-thermal-limit]].
