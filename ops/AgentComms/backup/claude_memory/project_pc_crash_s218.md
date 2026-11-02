---
name: project-pc-crash-s218
description: "S218 2026-10-13 13:09 hard crash (Kernel-Power 41, bugcheck 0) under 3 agents + their Godot tests; heat governor had no autostart; now 2 PC agents max"
metadata:
  node_type: memory
  type: project
  originSessionId: 9d3decfa-4161-4cef-87b2-2a35b32f351f
  modified: 2026-10-13T10:27:01.174Z
---

2026-10-13 ~13:09 the PC hung and rebooted (Event 41, bugcheck 0 = hang/power, no BSOD). Before it: heat_governor.log shows RED
(84 C+) suspends at 12:12, 12:31, 12:38 with 3 shell agents (2 Codex + Cursor) each running Godot tests, plus Brave 7.7 GB and
TheCrust 4.3 GB; watchdog at 13:00 said AMBER 81 C, COMMIT_free 4.1 GB. The reboot killed all agents and the heat governor
(it had no scheduled task).

**Why:** three agents' Godot jobs + the operator's own apps exceed what the PC holds; low commit memory + heat.
**How to apply:** "FightCamp Heat Governor" scheduled task now starts at logon (S218). Run at most 2 PC shell agents until a few
crash-free days; put the rest on cloud seats (Arena, cloud Qwen, Goose). After any crash: check Event 41, git status in each
worktree (commit agent WIP), relaunch with a RESUME prompt, restart the background queue. Related: [[feedback_pc_limits_80c]],
[[feedback_s217_visual_and_heat]].
