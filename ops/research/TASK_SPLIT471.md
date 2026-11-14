# TASK SPLIT471 - three scripts at the 500-line limit get room (pure moves, no behaviour change, headless)

Status: OPEN (S471, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
The project rule is "no script over 500 lines". Three files sit on it, so the next one-line change in any of them breaks
the rule: scripts/state/BoutNight.gd 499, scripts/fight3d/PunchReach.gd 498, scripts/fight3d/Clinch.gd 496.

## What to do (MOVE code, change nothing it does)
1. scripts/state/BoutNight.gd: move `_finish` (lines ~344-483, about 140 lines) and the helpers ONLY it uses into a new
   scripts/state/BoutFinish.gd (static funcs, `extends RefCounted`, same preloads it needs). BoutNight keeps a one-line
   `static func _finish(c, f, m) -> void: BoutFinish.run(c, f, m)` so every caller and test still works. Every other
   public name on BoutNight (fight_modal, rounds_of, fight_step, play_out, outcome_of, corner_jobs, arrow_limit, stopped,
   count_sides, _counts, _lines, _energy, coach_note, notes_bank) stays where it is with the same signature.
   Watch for a preload circle: BoutFinish may preload BoutNight only if BoutNight does not preload BoutFinish at load
   time in a way Godot rejects; if it does, pass what is needed as arguments or move the shared helper too.
2. scripts/fight3d/PunchReach.gd and scripts/fight3d/Clinch.gd: for each, move ONE self-contained group of functions
   (the biggest block that reads no private state of the rest, 80-150 lines) into a new file beside it
   named scripts/fight3d/PunchReachMath.gd and scripts/fight3d/ClinchPose.gd, and call it from the old place.
   Read each file first and say in the result doc which block you chose and why it is self-contained.
3. Target: each of the three old files at 400 lines or fewer; no new file over 300. Header comments move with their code.
4. Write docs/SPLIT471_RESULT.md: the line counts before and after, which functions moved where, each test's line.

## Pass lines (each must print the same failures count as main does on the same day: run main first, print both)
- golden_path_test: `GOLDEN_PATH failures=0`
- crack_wire_test: `CRACK_WIRE failures=0`
- towel_wire_test, plan_bout_test, ko_continues_test, rib_damage_test, bout_read_test: same count as main
- for PunchReach / Clinch: short_punch_test (`SHORT_PUNCH failures=0`), clinch_rest_test, punch_form_test: same as main
Every Godot run takes `--fixed-fps 60` (tools/run_tests.sh does; a run without it is not comparable).

## Contract
OWNS: scripts/state/BoutNight.gd, scripts/state/BoutFinish.gd, scripts/fight3d/PunchReach.gd, scripts/fight3d/Clinch.gd, scripts/fight3d/PunchReachMath.gd, scripts/fight3d/ClinchPose.gd, docs/SPLIT471_RESULT.md
RED_TEST: tests/golden_path_test.gd -> GOLDEN_PATH failures=
REGRESSION: crack_wire_test, towel_wire_test, plan_bout_test, ko_continues_test, short_punch_test, clinch_rest_test
VISUAL: no (a move of code; Claude plays one bout in the exe before the build ships)
NOT YOURS: tests/ (never change a bar), every other script. No renamed public function, no changed number, no new
feature, no opt-in flag. If a move needs a change in another file, STOP and write it in the result doc.
Runs only through `python ops/Tools/godot_slot.py run --who split471 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/<name>.gd`
(never the _console exe, never a window). One run at a time. Nothing opens on a monitor.
PR body: `RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0` and one line per regression test (main's number, yours).

## Prior research
SPLIT500 (branch qwen/split500, S4xx: the same kind of move, collected), CLAUDE.md "How we work" item 5 (small files),
ops/research/GDSCRIPT_TRAPS.md (preload circles, static funcs calling each other across files).
## What would a human do?
Cut each file at its natural seam (the end-of-bout bookkeeping; a block of pure maths), keep every caller untouched.
## Prefab check
None: our own code.
