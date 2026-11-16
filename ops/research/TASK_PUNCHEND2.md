# TASK PUNCHEND2 - PunchEnd's "home" read from her guard, not the punch's first frame

Status: OPEN (S504, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
Fight motion week. PUNCHEND1 (yours, merged S504: `scripts/rules/PunchEnd.gd`) reads where each punch ends and how many
frames the hand takes to come home. On the S504 film (`E:/FightCamp/tmp/fightweek/s504a/shown.csv`) it reads home = 30
(its "never") for nearly every cross, hook, uppercut and body shot - 1 of 34 crosses home within 4 frames, 0 of 23
hooks. The cause: "home" is the hand's place at the run's FIRST frame, and a punch clip often starts part-way through a
blend (a combination, a short inside punch), so that place is not her guard and the hand never returns to it. The
critics want the hand back in her guard within 4 frames of contact; the ruler must read her guard.

## What to change (PunchEnd.gd and its test only)
1. The HOME point of a punch: the punching hand's position RELATIVE TO HER OWN HIPS, averaged over the last up-to-5
   frames of that boxer BEFORE the run whose `clip` contains `idle` or `guard` (search back at most 45 frames; frames of
   any other clip are skipped, not counted). If no such frame exists, fall back to the run's first frame (today's rule)
   and mark the punch `home_from: "start"`; otherwise `home_from: "guard"`.
2. `home_frames`: frames after the FAR frame until the hand (relative to her hips) is within `HOME_RADIUS_M` (keep 0.08)
   of HOME, searching the same boxer's following rows (any clip) up to `HOME_SEARCH` (keep 30) frames; 30 if never.
3. New per-punch field `contact_home_frames`: the same count but starting from the CONTACT frame - the first frame of
   the run where that boxer's `hold` column is "1" (the hit-stop; a landed punch). Punches with no such frame get -1 and
   are left out of its percentiles.
4. Summary adds `contact_home_p50`, `contact_home_p90`, `contact_home_le4` (how many landed punches are home within 4
   frames of contact) and `landed_n`. `by_clip` adds `contact_home_p50`. Everything else stays as it is.
5. `tools/punch_end_probe.gd`: its last line becomes exactly
   `PUNCH_END punches=<n> head=<h> above10=<k> above_p50=<x.x> home_p50=<y> home_p90=<z> landed=<l> contact_home_p50=<c> contact_home_le4=<m>`.
6. `tests/punch_end_test.gd`: keep every existing check passing (adjust only the ones whose expected value the new HOME
   rule changes, and say so in a comment each). Add: a punch whose run starts mid-blend 30 cm off her guard but returns
   to the guard (home read from the idle frames before it, not 30); a punch with no idle frame in the 45 before it
   (home_from "start"); a landed punch with `hold` 1 on its 3rd frame whose hand is home 4 frames after (contact_home 4,
   counted in contact_home_le4); a punch with no hold frame (contact_home -1, not in the percentiles). Prove the test can
   fail: in a comment, what the old first-frame rule would print for the mid-blend case.

## Contract
OWNS: scripts/rules/PunchEnd.gd, tests/punch_end_test.gd, tools/punch_end_probe.gd
RED_TEST: tests/punch_end_test.gd -> PUNCH_END_TEST failures=0
REGRESSION: file_limits_test
VISUAL: no - a measuring tool; no game code changes.
NOT YOURS: every other file. Never delete or weaken a test. Work on your own branch, open a PR into main, never merge.
Each file under 500 lines. Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's
monitors. Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/punch_end_test.gd -> PUNCH_END_TEST failures=0`, `RESULT: tests/file_limits_test.gd -> ...`,
and the probe's last line on `E:/FightCamp/tmp/fightweek/s504a/shown.csv` and on
`E:/FightCamp/tmp/fightweek/r10blind/shown.csv`.

## Prior research
`scripts/rules/PunchEnd.gd` (yours, PUNCHEND1). `tools/fight_motion_rulers.py` "arm left out after contact" (Python; it
uses the `hold` column 0 -> 1 as the contact frame). `ops/research/GDSCRIPT_TRAPS.md` before writing GDScript.

## What would a human do?
A coach asks "how long until his hand is back at his chin?" - the chin he started from, not wherever the hand happened
to be when the punch began.

## Prefab check
None: a few loops over csv rows.

## The one trap
`hold` is a String in the csv rows ("0" / "1"); compare as int, and the hold frame belongs to the hitter's row only when
his punch landed.
