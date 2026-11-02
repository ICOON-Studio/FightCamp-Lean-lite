---
name: project-session-s144-2026-10-02
description: "S144 - PC heat control (84 C sustained, 6-core governor), empty-gym start, live agents page, first real playtest (loop does not start for a female boxer -> C243)"
metadata:
  node_type: memory
  type: project
  originSessionId: a0c11f3b-8165-4897-82c5-dc3987d05dd4
  modified: 2026-10-02T15:08:31.128Z
---

S144 (2026-10-02, after the PC restart). Operator rulings, verbatim: "go ahead and relaunch the agents but watch the pc load";
"ok go with 3 agents"; "you can go upt to 84C"; "yes make it sustained 10 seconds"; "the walk needs to be done from the start
without any boxer, maybe only some basic equipment and you need to evaluate the whole game experience and loop"; "first
evaluate this process and always check how pros do the playtests then apply the proper methods"; "make it more clear , who is
working on what , ETA etc"; Sketchfab glove: "i signed in download it".

Done: watchdog RED = 84 C sustained 10 s + host-loop governor pinning Godot/Blender to CPUs 0-5; ops board TTL 300 s (was
pinning a core); /agents live page + AgentComms/live_runs.json; empty-gym start (game only, tests keep starters); C242 idle
single source; 4 career tests fixed for FightGate; PLAYTEST_PROTOCOL.md + tools/s144_live_walk.gd; PLAYTEST_S144_PASS1.md.

**Why:** the operator judges the demo by the player's real first hour; pass 1 showed it stalls after signing a boxer.
**How to apply:** next session launches C241 run 4 -> C243 -> U213 (max 3 agents), then PLAYTEST pass 2 with `-- as_game`.
See [[feedback_pc_limits_80c]], [[feedback_operator_is_the_playtester]], [[project_session_log]].
Trap S144: a Monitor's expiry/TaskStop did NOT kill its watch.sh loop - 7 stale loops ran; at handover kill by PID (CommandLine match scratchpad/watch.sh). Bisect worktree E:/FightCamp/wt/C242 removed at handover.
