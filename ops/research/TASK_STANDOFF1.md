# TASK STANDOFF1 - a ruler: glove-pressing stand-offs inside 1.0 m

Status: OPEN (S504, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
Fight motion week (deal: 5+ from both blind critics or the 3D fight leaves the first release). Blind round r10, both
critics: the two boxers stand chest to chest with their gloves touching and nobody does anything ("glove-pressing
stand-offs"). Real boxers inside 1 m either punch, tie up, or step out. Claude fixes the behaviour; first we need a ruler
that counts these stand-offs from the film log, so the fix can be measured before and after. You build the ruler only -
no game code changes.

## The data
The fight film tool writes `shown.csv` (one row per drawn frame per boxer). A real one:
`E:/FightCamp/tmp/fightweek/r10blind/shown.csv` (read its header line first). Columns used: `frame`, `film_s`, `who`
(0 / 1), `clip` (the animation playing), `phase`, and world positions `<Bone>_x`, `<Bone>_y`, `<Bone>_z` for `Hips`,
`Head`, `LeftHand`, `RightHand` (metres, y up). 30 frames a second.

## What to build
1. `scripts/rules/StandOff.gd` - `extends RefCounted`, pure static, ZERO preloads.
   `static func analyse(rows: Array, near_m: float = 1.0, glove_m: float = 0.15, min_frames: int = 10) -> Dictionary`
   where `rows` is an Array of Dictionaries (one per csv row, values as Strings or numbers - convert with `float()` /
   `int()`).
   - Pair the rows by `frame`: a frame counts only when both boxers (who 0 and who 1) have a row.
   - A frame is a STAND-OFF frame when ALL hold:
     a. the horizontal distance (x and z only) between the two boxers' `Hips` is under `near_m`;
     b. neither boxer's `clip` is a punch or a reaction: a clip is "busy" when it contains any of `jab`, `cross`, `hook`,
        `uppercut`, `body_shot`, `hit_by`, `clinch`, `dodge`, `weave`, `slip`, `knock`;
     c. the gloves press: the smallest of the four distances between one boxer's LeftHand/RightHand and the other
        boxer's LeftHand/RightHand (3D) is under `glove_m`.
   - A STAND-OFF is a run of consecutive stand-off frames (frame numbers +1 each step) of at least `min_frames`.
     Shorter runs are not counted.
   - Per stand-off: `start_frame`, `end_frame`, `frames`, `start_s` (the `film_s` of the first frame, as float),
     `hips_m` (median hips distance in the run), `glove_m` (median smallest glove distance), `clips` (the two boxers'
     clips at the run's first frame, as a two-String Array `[clip of who 0, clip of who 1]`).
   - Returns `{standoffs: [...], count, total_frames, total_s (total_frames / 30.0), longest_frames, near_frames (frames
     where only rule a holds), pressing_share (stand-off frames / near_frames, 0.0 when near_frames is 0)}`.
     Empty input -> every count 0, empty array.
2. `tools/stand_off_probe.gd` - `extends SceneTree`. Reads the csv given as `-- csv=<path>` (FileAccess, split the header,
   one Dictionary a row), calls `StandOff.analyse`, prints one line per stand-off and the summary, and ends with exactly
   `STAND_OFF count=<n> total_s=<x.x> longest_frames=<k> near_frames=<m> pressing_share=<p.pp>`. Quits 0.
   Headless only: `godot --headless --audio-driver Dummy --path . --script res://tools/stand_off_probe.gd -- csv=E:/FightCamp/tmp/fightweek/r10blind/shown.csv`.
3. `tests/stand_off_test.gd` (`extends SceneTree`, prints `STAND_OFF_TEST failures=<n>`, quits 1 on failure). Hand-built
   rows (no csv): a 12-frame run of idle clips at 0.8 m with gloves 10 cm apart (one stand-off, 12 frames); the same at
   1.2 m (none, not near); the same with gloves 30 cm apart (none, near_frames counted); a 9-frame run (none, too short);
   a 12-frame run with one boxer in `pro_left_jab` for frames 5-6 (splits into runs of 4 and 6: none); a skipped frame
   number splitting a 20-frame run into 10 + 10 (two stand-offs); a frame where who 1's row is missing (that frame does
   not count); custom `near_m` / `glove_m` / `min_frames` arguments honoured; `analyse([])`. Prove the test can fail:
   for one check, write in a comment what a mutant (e.g. measuring the hips distance in 3D instead of x/z) would print.

## Contract
OWNS: scripts/rules/StandOff.gd, tests/stand_off_test.gd, tools/stand_off_probe.gd
RED_TEST: tests/stand_off_test.gd -> STAND_OFF_TEST failures=0
REGRESSION: file_limits_test
VISUAL: no - a measuring tool; no game code changes.
NOT YOURS: every other file. Never delete or weaken a test. Work on your own branch, open a PR into main, never merge.
Each file under 500 lines (aim for under 250). Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on
the owner's monitors. Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/stand_off_test.gd -> STAND_OFF_TEST failures=0`, `RESULT: tests/file_limits_test.gd -> ...`,
and the probe's last line on `E:/FightCamp/tmp/fightweek/r10blind/shown.csv` plus its five longest stand-offs.

## Prior research
`scripts/rules/PunchEnd.gd` + `tools/punch_end_probe.gd` (S504: the same shape - pure analyser over shown.csv rows and a
probe that loads the csv; copy its csv loader). `tools/fight_motion_rulers.py` (Python, the column meanings).
`ops/research/GDSCRIPT_TRAPS.md` before writing GDScript (Variant `:=`, `%%`, reused names, typed Arrays of Strings).

## What would a human do?
A coach scrubbing tape: every time the two men stand inside arm's length with their gloves touching and nobody punches,
ties up or steps out, he stops the tape and counts the seconds.

## Prefab check
None: a few loops over csv rows.

## The one trap
Distance between the boxers is HORIZONTAL (x, z): a boxer bending over a body shot drops his hips and a 3D distance would
read him nearer or further than he stands.
