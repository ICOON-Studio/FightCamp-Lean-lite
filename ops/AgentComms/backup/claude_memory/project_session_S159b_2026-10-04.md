---
name: project-session-s159b-2026-10-04
description: S159b - corner neighbours green, fight_strike_whole root cause (sequence hand-offs), PR #44 merged, Antigravity agy seat installed (local, not cloud)
metadata:
  type: project
---

S159b (2026-10-04): `--only corner` 12/12 + fight_world_live green; fight_strike_whole red bisected to R16 d62f1e7f - R16 only moved the walk so seed 92012 reached boxing_one_two / boxing_catch_counter, whose parts `_advance_sequence` hands off; the test now exempts only the active sequence advancing (14741939). PR #44 RESULT2+DEMOSWITCH merged by diff (25507186). Google Antigravity installed: CLI `agy` at %LOCALAPPDATA%\agy\bin\agy.exe, wrote ratio_cell_test in 125 s.

**Why:** PR #41's "2 extra FAILs" was the same sequence artefact - retest it before sending it back. Antigravity only runs the models in Google's cloud; commands run on the PC, so it is not a cloud seat.
**How to apply:** launch agy with a one-line `-p` prompt pointing at a task file + `--add-dir`, `--mode accept-edits --sandbox`, never `--dangerously-skip-permissions` (the auto-mode classifier refuses it); Claude runs the acceptance. no_popups.ps1 was stopped for the operator's Photos; it restarts with agent_window.ps1. See [[feedback_cloud_first]], [[feedback_dont_recite_nightly_every_session]].
