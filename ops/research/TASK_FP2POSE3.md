# TASK FP2POSE3 - fight player v2: a boxer's stance length, and the rear heel on hooks and uppercuts (S537, owner C454/C458)

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Standing approval (owner S510): "i approve anything that..." animation fixes - no question needed; film to the owner at the end.
METHOD (CLAUDE.md item 8): fight player v2 ONLY (scripts/fight3d/v2); no new fix layer in scripts/fight3d outside v2.

## Why (docs/FP2POSE2_RESULT.md "Not fixed, said plainly")
The cross's rear leg is fixed (6/10). What holds it under 7 is the GUARD's stance: 36-42 cm along the line in the guard,
32-39 cm at a cross's contact, chest 9-14 cm ahead of the hips - two boots close under a body leaning past them (owner C458:
"looks like a weak 12 year old kid"). A boxing stance is 1 to 1.5 shoulder widths long, 45-65 cm here. Also: rear hooks and
rear uppercuts have the same flat rear foot (CrossLegs.TAKES is one table away from them).

## Do
0. FIRST, owner S537 on the FP2POSE2 film (ops/previews/s536_fp2pose2/3_loop_cross_before_left_after_right.mp4, after = right):
   "blue fighter twists knee unnaturally outwards when he throws". The re-baked rear leg's knee swings OUTWARD (away from the
   body's centre line) through the cross. A cross drives the rear knee IN and forward with the hip turn. Find why (the leg
   solve's pole / knee direction in tools/cross_legs_bake.gd, likely not following the foot's turn-in) and fix it at the bake.
   OWNER S537: "the power does not come from twisting the knee use our research/clips when you make animations". METHOD for
   every leg/hip change in this task - from OUR research and clips, never invented:
   - ops/research/K46_BOXER_FEET_DURING_PUNCHES.md: the cross's leg drive is ankle extension ~12 deg + knee EXTENSION ~25 deg
     (Cheraghi 2014), knee ~143 deg at impact (Dinu & Louis 2020), ground force ~61 % lead / 39 % rear; the rear heel is
     soft, not locked.
   - ops/research/CROSS_POWER_S439.md: real fighters drive the hips ~28 cm FORWARD and carry ~11 cm through the target; our
     takes move the hips 0 cm. The power chain is rear foot pivots on its ball -> hip turns and drives forward -> shoulder ->
     arm; the knee follows the hip and the foot, it never twists out on its own.
   - ops/research/K49_TORSO_IN_A_HOOK.md for the hooks' trunk; the clean captured Mixamo Cross_Punch measured in FP2POSE2 and
     the labelled clips in E:/FightCamp/fight_video_data as the reference to measure against (numbers, not copies).
   Write the reference numbers beside ours in the RESULT (knee yaw relative to the foot, knee extension, ankle extension, hip
   forward travel) before and after.
   Test: tests/player2_test.gd KNEE - at the contact the rear knee sits on or inside the line from the rear hip to the rear
   foot (seen from above), every cross take; red on the current bake, green fixed. Film before/after of this alone first.
1. Measure first on the takes v2 plays (st_wait / st_wait_g and every punch take's start): stance length along the line,
   width across it, chest-over-hips offset, in the guard and at each contact. Write the table.
2. Fix at the bake, as FP2POSE2 did (tools/cross_legs_bake.gd + v2/CrossLegs.gd pattern): a stance-length pass that sets the
   guard to ~50-55 cm along the line (lead foot forward, weight centred between the feet, chest over the hips) and keeps every
   punch take's lead leg on it at the joins (no pop, no slide added). Then extend the rear-heel table to the rear hooks and
   rear uppercuts.
3. Tests: tests/player2_test.gd gains STANCE (guard length 45-65 cm, chest over hips within 6 cm) red as bought, green
   re-baked; HEEL covers the new takes; FEET / GAZE / landed gloves / JUMPS / SLIDE no worse; choreographer_test,
   arm_build_test, file_limits_test green.
4. Films on the game camera (both men head to feet, hidden desktop, still_framing rules): guard + cross + rear hook, before
   left / after right; stills at the contact. `ops/previews/s537_fp2pose3/`, `docs/FP2POSE3_RESULT.md` with your score /10
   and what still holds it under 8.

## Prior research
docs/FP2POSE1_RESULT.md, docs/FP2POSE2_RESULT.md, `python ops/Tools/prior_research.py stance length guard feet`.

## What would a human do?
A coach's first correction for a new boxer: "widen your base" - feet a little more than shoulder-width apart along the line,
weight between them, head over the knees, never leaning past the front foot.

## Prefab check
Mixamo takes already measured in FP2POSE2 (reference only, none taken into the repo).

## Contract
OWNS: tools/stance_bake.gd (new), scripts/fight3d/v2/CrossLegs.gd, scripts/fight3d/v2/<new stance file>.gd,
assets/anim/baked/v2/ (the re-baked takes), tests/player2_test.gd, docs/FP2POSE3_RESULT.md
RED_TEST: tests/player2_test.gd STANCE (red as bought)
REGRESSION: choreographer_test, arm_build_test, file_limits_test
VISUAL: yes - films above, opened by you

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who fp2pose3 -- <command>`; windowed only on the hidden desktop.
Never stage LineGrade.gd, LiveRound.gd, StepWire.gd, MHRig.gd, tools/export.sh. No script over 500 lines (Player2.gd is at
the line - put new rules in their own file). `git add -- <new>` then `git commit -m ... -- <your paths>` with
`Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two lines, stop.
