# TASK IDLEIN1 - StandOff also counts idle time inside 1.0 m (nobody punching, nobody tying up)

Status: OPEN (S504, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
Fight motion week. Both blind critics (r10) named "stand-offs": the two boxers close together doing nothing. Your
STANDOFF1 (`scripts/rules/StandOff.gd`, merged S504) counts GLOVE-PRESSING stand-offs and found only one 0.3 s press in
180 s, while 619 frames were inside 1.0 m. So the critics see something else: both boxers inside range, both in guard or
idle, nobody throwing. We need that number before the fix, and the same number after it.

## What to change (StandOff.gd, its test and its probe only)
1. New static function `idle_inside(rows: Array, near_m: float = 1.0, min_frames: int = 20) -> Dictionary`, beside
   `analyse` (same rows, same pairing of the two boxers by frame - reuse `_pair_by_frame`).
   A frame is IDLE INSIDE when the two boxers' hips (Hips_x / Hips_z, ground distance only) are under `near_m` AND
   neither boxer's `clip` contains any of `BUSY_WORDS` (keep that list as it is) AND the `phase` column is "fight" for
   both (when the column exists).
2. A SPELL is a run of consecutive idle-inside frames (a missing frame number ends it), kept when it lasts `min_frames`
   or more.
3. Returns `{spells: [{start_frame, start_s, frames, secs, hips_m (mean), clip_a, clip_b (the most common clip of each
   boxer in the spell)}], count, total_frames, total_s, longest_s, near_frames, idle_share}` where `secs` / `start_s`
   come from the `film_s` column (the spell's last minus first film_s plus one frame's step), `near_frames` = all frames
   under `near_m` (busy or not), `idle_share` = total_frames / near_frames (0.0 when near_frames is 0). Rows empty ->
   the same keys with zeros / [].
4. `tools/stand_off_probe.gd`: after its current last line, print exactly one more line:
   `IDLE_INSIDE spells=<n> total_s=<x.x> longest_s=<y.y> near_frames=<k> idle_share=<z.zz>`
   and before it, one line per spell: `  idle start_s=<s> secs=<d> hips_m=<m> a=<clip> b=<clip>`.
5. `tests/stand_off_test.gd`: keep every existing check. Add: (a) 30 frames inside 0.9 m, both "idle" -> 1 spell of 30
   frames; (b) the same with one boxer in "pro_left_jab" on frames 10-14 -> two spells only if each part is >= 20 frames,
   else fewer (write the exact expected count for your fixture); (c) 30 frames at 1.2 m both idle -> 0 spells and
   near_frames 0; (d) 15 idle frames inside -> 0 spells (under min_frames) but near_frames 15; (e) a missing frame number
   splits a spell. Prove the test can fail: in a comment, what `analyse` (the glove rule) would report for fixture (a).

## Contract
OWNS: scripts/rules/StandOff.gd, tests/stand_off_test.gd, tools/stand_off_probe.gd
RED_TEST: tests/stand_off_test.gd -> STAND_OFF_TEST failures=0
REGRESSION: file_limits_test
VISUAL: no - a measuring tool; no game code changes.
NOT YOURS: every other file. Never delete or weaken a test. Work on your own branch, open a PR into main, never merge.
Each file under 500 lines. Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's
monitors. Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/stand_off_test.gd -> STAND_OFF_TEST failures=0`, `RESULT: tests/file_limits_test.gd -> ...`,
and the probe's last two lines on `E:/FightCamp/tmp/fightweek/s504g/shown.csv` and on
`E:/FightCamp/tmp/fightweek/r10blind/shown.csv`.

## Prior research
`scripts/rules/StandOff.gd` (yours, STANDOFF1) and `tools/stand_off_probe.gd`. `scripts/rules/PunchEnd.gd` reads the
same csv. `ops/research/GDSCRIPT_TRAPS.md` before writing GDScript.

## What would a human do?
A coach watching the tape says "they stood in range for four seconds and nobody threw" - he counts the seconds both
were close and both were waiting, not only the moments the gloves touched.

## Prefab check
None: a loop over csv rows, the same as STANDOFF1.

## The one trap
The csv values are Strings: convert with float()/int(). The two boxers' rows share a frame number; pair them by frame
(the existing `_pair_by_frame`), never by row order.
