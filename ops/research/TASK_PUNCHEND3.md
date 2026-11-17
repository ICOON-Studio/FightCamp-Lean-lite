# TASK PUNCHEND3 - PunchEnd reads the hand in her chest's own frame, not the ring's

Status: OPEN (S505, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
Fight motion week. PunchEnd (yours, PUNCHEND1 + PUNCHEND2, `scripts/rules/PunchEnd.gd`) measures each punch's hand
FROM HER HIPS IN RING AXES (`_local`). When her chest turns between her guard frames and the punch's end (a cross turns
the chest ~40 degrees), a hand that is back at her chin reads "not home", because the guard place was taken with the
chest facing another way. The S504 collect tried the hip line as the boxer's frame (worse: hips turn further than the
shoulders). Since S505 the film log has the bones that fix it: `Chest_*`, `UpperChest_*`, `Neck_*`,
`LeftShoulder_*`, `RightShoulder_*` (each `_x/_y/_z`, world metres, same rows as before).

## What to change (PunchEnd.gd, its test and its probe only)
1. A boxer's CHEST FRAME on one row: origin = `UpperChest`; right axis = (RightShoulder - LeftShoulder) with its y set
   to 0, normalised; up = world up (0,1,0); forward = up x right (or right x up - pick the one that points from her
   chest toward her own hands' average on a guard row, and say which in a comment). If a row lacks the shoulder
   columns (an old film), fall back to today's ring axes from the hips, and count those rows.
2. `_local(row, bone)` becomes the bone's position in that chest frame: (dot(right), dot(up), dot(forward)) of
   (bone - UpperChest). Every reader of `_local` (home from guard, home after far point, contact home) uses it.
3. Summary adds `chest_frame_rows` (rows read in the chest frame) and `ring_axes_rows` (fallback rows).
4. `tools/punch_end_probe.gd`: its last line keeps every field it has and appends ` chest_rows=<n> ring_rows=<m>`.
5. `tests/punch_end_test.gd`: keep every existing check passing (old fixtures have no shoulder columns: they must take
   the fallback and read exactly as today). Add: (a) a cross whose chest turns 40 degrees between the guard frames
   and the far point and back by the end, the hand returning to the same spot IN HER CHEST FRAME - home within 4
   frames in the chest frame; in a comment, what the ring-axes rule reads for it (it must read later or never: prove
   the test fails on the old rule by running it once with the fallback forced, and quote the number); (b) a row set
   with shoulders and one without - counts in `chest_frame_rows` / `ring_axes_rows`.

## Contract
OWNS: scripts/rules/PunchEnd.gd, tests/punch_end_test.gd, tools/punch_end_probe.gd
RED_TEST: tests/punch_end_test.gd -> PUNCH_END_TEST failures=0
REGRESSION: file_limits_test
VISUAL: no - a measuring tool; no game code changes.
NOT YOURS: every other file. Never delete or weaken a test. Work on your own branch, open a PR into main, never merge.
Each file under 500 lines. Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's
monitors. Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/punch_end_test.gd -> PUNCH_END_TEST failures=0`, `RESULT: tests/file_limits_test.gd -> ...`,
and the probe's last line on `E:/FightCamp/tmp/fightweek/s505a/shown.csv` (has the chest columns) and on
`E:/FightCamp/tmp/fightweek/s504o/shown.csv` (has none: all rows ring_rows).

## Prior research
`scripts/rules/PunchEnd.gd` (yours; read its S504 comment above `_local`). `tools/human_fight_film.gd` line 19 (the
bone list). `ops/research/GDSCRIPT_TRAPS.md` before writing GDScript.

## What would a human do?
A coach watches the glove come back to the chin - the chin moves with the shoulders, so he judges it against the
shoulders, not against the ring's corners.

## Prefab check
None: a dot product per row.

## The one trap
Csv values are Strings: `float()` each. A row from an old film has no `LeftShoulder_x` key - check `row.has()` before
reading, never index it blind.
