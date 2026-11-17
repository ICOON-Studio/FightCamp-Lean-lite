# TASK FREEHAND1 - a ruler for the free hand: does the glove that is NOT punching stay at the chin?

Status: OPEN (S505, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
Fight motion week. Blind round r11 (2026-11-17): coach 5/10, animator 5.0/10 - both critics' FIRST change: "the rear
hand keeps falling to the belt" / "while one arm punches, hold the other glove within 8 cm of the chin or cheekbone".
We have no ruler for it. Build one first (a pure module + probe + test); the fix comes after, measured by it.

## What to build
1. `scripts/rules/FreeHand.gd` (new, pure static, ZERO preloads). `analyse(rows: Array) -> Dictionary` over shown.csv
   rows (Strings; columns `frame`, `who`, `clip`, `hold`, `phase`, and `<Bone>_x/_y/_z` world metres for Head,
   LeftHand, RightHand, Hips, UpperChest, LeftShoulder, RightShoulder).
2. A PUNCH RUN = consecutive frames of one boxer whose clip contains jab / cross / hook / uppercut / body_shot and none
   of hit_by / dodge / weave / idle (the same words as `scripts/rules/PunchEnd.gd` PUNCH_WORDS / EXCLUDE_WORDS - copy
   them, do not preload). The PUNCHING hand = the hand that moves furthest from her UpperChest during the run; the
   FREE hand = the other one.
3. Per frame of a run: `free_cm` = distance from the free hand to the Head bone (cm); `free_drop_cm` = Head_y minus the
   free hand's y (cm; positive = below the head). Per run: `max_free_cm`, `max_drop_cm`, `frames_off` = frames with
   free_cm > OFF_CM (const 20.0) or drop > DROP_CM (const 25.0), `body_shot` (clip contains "body").
4. Summary: `runs`, `runs_off` (runs with frames_off >= 2, body shots excluded), `off_share` (runs_off / non-body runs),
   `free_cm_p50`, `free_cm_p90`, `drop_cm_p90`, and `by_clip` {n, off_share}. Also the same two numbers over GUARD frames
   (clip contains idle or guard, both hands, `guard_free_cm_p50`) so we see her normal glove-to-head distance.
5. `tools/free_hand_probe.gd -- csv=<path>`: one line per off run (`  off clip=.. who=.. start=.. frames_off=..
   max_free=..cm max_drop=..cm`), then the last line exactly
   `FREE_HAND runs=<n> runs_off=<k> off_share=<x.xx> free_p50=<a.a> free_p90=<b.b> drop_p90=<c.c> guard_free_p50=<d.d>`.
6. `tests/free_hand_test.gd`: fixtures built in code (no files): a jab whose free hand stays 12 cm from the head (not
   off); a cross whose free hand drops 35 cm below the head for 5 frames (off); a body shot with a dropped free hand
   (not counted in runs_off); a run where the hands swap which is "punching" mid-run (the furthest-moving hand wins);
   an empty input. Print `FREE_HAND_TEST failures=<n>`; quit(1) on failures.

## Contract
OWNS: scripts/rules/FreeHand.gd, tests/free_hand_test.gd, tools/free_hand_probe.gd
RED_TEST: tests/free_hand_test.gd -> FREE_HAND_TEST failures=0
REGRESSION: file_limits_test
VISUAL: no - a measuring tool; no game code changes.
NOT YOURS: every other file (the brief too). Never delete or weaken a test. Own branch, commit, push, never merge.
Each file under 500 lines. Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's
monitors. One test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/free_hand_test.gd -> FREE_HAND_TEST failures=0`, `RESULT: tests/file_limits_test.gd -> ...`,
and the probe's last line on `E:/FightCamp/tmp/fightweek/r11blind/shown.csv` and `E:/FightCamp/tmp/fightweek/s505b/shown.csv`.

## Prior research
`scripts/rules/PunchEnd.gd` and `scripts/rules/StandOff.gd` (yours: csv rows, runs, `_bone_pos`). The critics' reviews:
`E:/FightCamp/tmp/fightweek/r11blind/critic_coach.md` and `critic_animator.md` (read only their "rear hand" lines).
`ops/research/GDSCRIPT_TRAPS.md` before writing GDScript.

## What would a human do?
A coach watches the hand that is NOT punching: if it leaves the cheek while the other one throws, he shouts "hands up".

## Prefab check
None: loops over csv rows like PunchEnd.

## The one trap
Head_y is the head bone's centre, ~10 cm above the chin: a glove at the chin reads ~10-15 cm from it, so OFF_CM 20 is
"clearly away", not "touching". Csv values are Strings - `float()` each, `int()` the frame and who.
