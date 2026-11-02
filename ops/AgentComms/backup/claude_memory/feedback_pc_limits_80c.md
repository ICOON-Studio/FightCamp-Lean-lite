---
name: feedback_pc_limits_80c
description: Operator 2026-10-02 - CPU temp never above 84 C (raised from 80 same day), CPU load low enough to use the PC, run_tests jobs 2-3; meters on the ops board
metadata:
  type: feedback
---

Operator 2026-10-02: "I do not want the temperature to go above 80" and keep CPU load "so I can use the computer
without problems. use jobs 2 Or 3". LATER 10-02 (S144): "you can go upt to 84C" -> watchdog RED at 84 C / 80% CPU (amber 74 C / 60%); ops board top strip shows
the meters (/api/pc reads AgentComms/pc_health.txt).

**Why:** the PC overheated in S143 (emergency restart); he works on it while agents run.

**How to apply:** watchdog -Once before every launch/test/render; never --jobs 4. Speccy has NO data feed (its
/xml export does nothing while it runs; its window is custom-drawn, UIA reads nothing). CPU temp needs
LibreHardwareMonitor (MPL-2.0) with its web server on :8085, run elevated - the operator installs/allows it.
Pagefile was STILL on D: after the 10-02 restart (Windows "automatically manage" = picked D:). See [[project_d_drive_failing]].

S144 done: LHM v0.9.6 installed at C:\Tools\LibreHardwareMonitor (config: tray, web server :8085); first reading CPU
Tctl/Tdie 57-65 C near idle, matched Speccy's 60 C. Operator set pagefile C: system managed / D: none (restart pending).
16 finished worktrees removed (E: 4 -> 75 GB free).

S144 later: after the restart the CPU sat 68-83 C at 4-20% total CPU (Package 37-53 W) - the 7800X3D runs hot here, likely cooling (fan curve/dust/paste) - told the operator. A real heat source found and fixed: the ops board rebuilt its snapshot every 60 s while `board` took 51-90 s with agents running = one core pinned (TTL now 300 s). Restart the 'FightCamp PC Watchdog' scheduled task after changing limits (the loop holds them in memory).
S144 governor: the watchdog LOOP pins every Godot/Blender process to CPUs 0-5 (mask 0x3F, every 5 s) so parallel runs share 6 threads instead of stacking (operator asked about serial runs; sandboxes cannot share a lock, host affinity works, verified on sandboxed Codex Godots). Max 3 shell agents at once (operator). Temp RED = 84 C sustained 10 s.


S148 2026-10-02, operator verbatim: "launch with amber". Agent launches go ahead on GREEN or AMBER; only RED blocks (CLAUDE.md s4 updated). TRAP: `pc_watchdog.ps1 -Once | Select-Object -First 1` cuts the pipe and makes $LASTEXITCODE non-zero, so an AMBER read as RED. Capture the output first (`$w = ...; $rc = $LASTEXITCODE`), then print it.

S181 2026-10-09: RED can be C: free space, not heat - Windows grew C:\pagefile.sys to 40 GB (peak use 8.9 GB) when RAM hit 90% (browsers + a movie render + Cursor), C: fell 22.8 -> 3 GB in 3 min. A RED line in a chained command does not stop the chain: gate on it, never run suites after it. Operator was told how to fix the pagefile size (system setting = his).
