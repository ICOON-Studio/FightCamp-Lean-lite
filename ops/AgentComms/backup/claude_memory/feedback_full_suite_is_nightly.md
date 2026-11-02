---
name: feedback-full-suite-is-nightly
description: "Operator 2026-09-25 - the full Godot suite runs ONCE a day at 03:00 (scheduled task), never in a session; sessions run subsets and cite AgentComms/nightly/latest.txt"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 2cdfc054-a9df-45f0-9ad5-6dd1545d96c2
  modified: 2026-09-25T11:08:21.755Z
---

Operator, verbatim: *"can we run the full suite only 1 time per day when i am asleep ?"* - asked after Speccy showed
the Ryzen 7800X3D at 90 C while a session's `run_tests.py --jobs 4` ran alongside Cursor's and Qwen's Godot tests.

**Why:** a daytime full suite costs 20+ minutes and pins the CPU at its thermal limit while agents also test
([[project_pc_thermal_limit]]).

**How to apply:** Windows task "FightCamp Nightly Suite" runs `Tools/nightly_suite.ps1` daily 05:00 (warning popup; postpone 20 min; skipped if the operator is still on the PC at 06:00) then `nightly_suite.cmd` with `--jobs 2`
(stage gate off). Log `AgentComms/nightly/suite_<date>.log`, summary `latest.txt` (untracked). A session runs only the
subsets its change touches and cites the latest nightly line (date + HEAD) in its digest. Never start a full suite in a
session; never tell an agent to. Rule is in CLAUDE.md test tiers.
