# TASK PUNCHEND1 - a ruler: where each punch ends and how fast the hand comes home

Status: OPEN (S503, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
Fight motion week (deal: 5+ from both blind critics or the 3D fight leaves the first release). Blind round r9, both
critics: several punches finish ABOVE the opponent's head and the hand stays out 8+ frames; they want each punch to end
on its target and the hand home in 3-4 frames. Claude fixes the motion next session; first we need a ruler that reads it
from the film log, so the fix can be measured before and after. You build the ruler only - no game code changes.

## The data
The fight film tool writes `shown.csv` (one row per drawn frame per boxer). A real one:
`E:/FightCamp/tmp/fightweek/r10blind/shown.csv` (read its header line first). Columns used: `frame`, `who` (0 / 1),
`clip` (the animation playing), `phase`, and world positions `<Bone>_x`, `<Bone>_y`, `<Bone>_z` for `Hips`, `Head`,
`LeftHand`, `RightHand` (metres, y up). 30 frames a second.

## What to build
1. `scripts/rules/PunchEnd.gd` - `extends RefCounted`, pure static, ZERO preloads.
   `static func analyse(rows: Array) -> Dictionary` where `rows` is an Array of Dictionaries (one per csv row, values as
   Strings or numbers - convert with `float()` / `int()`).
   - A PUNCH is a run of consecutive frames of one boxer whose `clip` begins with `pro_` and contains `jab`, `cross`,
     `hook`, `uppercut` or `body_shot`, and does not contain `hit_by`, `dodge`, `weave`, `idle`. A new run starts when
     the clip name changes or a frame is skipped. Runs shorter than 3 frames are ignored.
   - The punching hand: of LeftHand / RightHand, the one whose distance from that boxer's own Hips grows most from the
     run's first frame to its maximum (do NOT pick by the clip's left/right word: southpaws play mirrored clips).
   - FAR frame: the frame of the run where that hand is furthest from her own Hips.
   - The target: the OTHER boxer's Head at the same `frame` number (skip the punch if that row is missing).
     `body` punch = clip contains `body`; every other punch is a head punch.
   - Per punch: `clip`, `who`, `start_frame`, `far_frame`, `out_frames` (far - start), `above_cm` = (hand y - target head
     y) x 100 at the far frame, `miss_cm` = 3D distance hand to target head x 100 at the far frame, `home_frames` = frames
     after the far frame until the hand is back within 8 cm of where it was at the run's first frame, both measured
     RELATIVE TO HER OWN HIPS (hand - hips), searching on through the rows of the same boxer after the run ends (any
     clip) up to 30 frames; 30 if it never comes back.
   - Returns `{punches: [...], head_n, above_10_n (head punches ending more than 10 cm above the target head),
     above_p50, above_p90, home_p50, home_p90, by_clip: {clip: {n, above_p50, home_p50}}}`. Percentiles: sort, index
     `int(p * (n - 1))`. Empty input -> all counts 0, empty arrays/dicts.
2. `tools/punch_end_probe.gd` - `extends SceneTree`. Reads the csv given as `-- csv=<path>` (FileAccess, split the
   header, one Dictionary a row), calls `PunchEnd.analyse`, prints one line per punch and the summary, and ends with
   exactly `PUNCH_END punches=<n> head=<h> above10=<k> above_p50=<x.x> home_p50=<y> home_p90=<z>`. Quits 0.
   Headless only: `godot --headless --audio-driver Dummy --path . --script res://tools/punch_end_probe.gd -- csv=E:/FightCamp/tmp/fightweek/r10blind/shown.csv`.
3. `tests/punch_end_test.gd` (`extends SceneTree`, prints `PUNCH_END_TEST failures=<n>`, quits 1 on failure). Hand-built
   rows (no csv): a jab that ends on the head (above_cm about 0), a cross that ends 20 cm above (above10 counts it), a
   body shot (not a head punch, not in above10), a southpaw run where the RIGHT hand punches under a `pro_left_jab` clip
   (the hand picked must be the right), a hand that comes home in 3 frames and one that never does (30), a 2-frame run
   (ignored), a skipped frame splitting one clip into two runs, an opponent row missing at the far frame (skipped),
   `analyse([])`. Prove the test can fail: for one check, write in a comment what a mutant (e.g. picking the hand by
   the clip's word) would print.

## Contract
OWNS: scripts/rules/PunchEnd.gd, tests/punch_end_test.gd, tools/punch_end_probe.gd
RED_TEST: tests/punch_end_test.gd -> PUNCH_END_TEST failures=0
REGRESSION: file_limits_test
VISUAL: no - a measuring tool; no game code changes.
NOT YOURS: every other file. Never delete or weaken a test. Work on your own branch, open a PR into main, never merge.
Each file under 500 lines (aim for under 250). Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on
the owner's monitors. Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/punch_end_test.gd -> PUNCH_END_TEST failures=0`, `RESULT: tests/file_limits_test.gd -> ...`,
and the probe's last line on `E:/FightCamp/tmp/fightweek/r10blind/shown.csv` plus its five worst head punches by
above_cm.

## Prior research
`tools/fight_motion_rulers.py` ("arm left out after contact", how it reads the same csv - Python, for the column
meanings), `tools/human_fight_report.py`, `assets/data/clip_recovery.json` (each clip's contact and far times).
`ops/research/GDSCRIPT_TRAPS.md` before writing GDScript (Variant `:=`, `%%`, reused names, typed Arrays of Strings).

## What would a human do?
A boxing coach scrubbing tape frame by frame: where did the glove finish against the other man's head, and how many
frames until the hand was back at the chin. Count those, punch by punch.

## Prefab check
None: a few loops over csv rows.

## The one trap
Southpaws play mirrored clips: `pro_left_jab` may be thrown with the RIGHT hand. Pick the hand by how it moves, never by
the clip's name.
