---
name: feedback-idle-godot-is-a-script-error
description: A SceneTree tool run through godot_hidden.ps1 that sits at ~0.15 core with no I/O is almost always a SCRIPT ERROR that stopped _run - not a slow run; run it with --log-file and read the first SCRIPT ERROR
metadata:
  type: feedback
---
S125 lost ~2.5 hours to two "hung" c223_sequence_gate runs. Symptom: 60-90 min wall, CPU ~0.15 core, 0 page faults,
0 disk I/O, working set trimmed. Cause: `reach_by_part[part]` on a part whose certificate row had FAILED -> SCRIPT ERROR
inside the deferred `_run` -> `_run` stops, `quit()` is never reached, and the windowed Godot idles forever.
godot_hidden.ps1 prints output only at EXIT, so nothing shows. (Priority and Windows power throttling were ruled out.)

**Why:** a tool with a script error does not exit; there is no timeout in godot_hidden.ps1 (run_tests.py has one).
**How to apply:** launch long tool runs with `--log-file <scratchpad>/x_live.log` so progress and the first SCRIPT ERROR
are readable live; if a run is idle, read that log before guessing. Make lookups on certificate files `has()`-guarded
and turn a miss into a named `_fail`. Related: [[feedback_godot_verification_gate]], [[feedback_kill_by_worktree_path]].
