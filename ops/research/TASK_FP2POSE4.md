# TASK FP2POSE4 - fight player v2: the hip drive on power punches, authored at the bake (S537)

Model: claude-fable-5-2 (headless on the API credit). Discipline: boxing (demo). Standing approval for animation fixes (S510).
METHOD (owner S537): "the power does not come from twisting the knee use our research/clips when you make animations".
Fight player v2 ONLY (scripts/fight3d/v2).

## Why
docs/FP2POSE3_RESULT.md: knee fixed (goes with the hips), stance 46-63 cm; what holds the cross under 8 is the DRIVE: the rear
knee flexes 1-16 deg into the contact instead of extending ~25 (Cheraghi, K46), hips travel ~3 cm vs ~28 real
(CROSS_POWER_S439). docs/CASCTEST1_RESULT.md: Cascadeur AutoPhysics does not add it (knee 11 -> 10 deg, hips 2.9 cm both) -
it is not in the take; it must be authored. CROSS_POWER_S439 fix 3: a hip drive of 10-18 cm on power punches.

## Do
1. At the bake (pattern of tools/cross_legs_bake.gd + v2/CrossLegs.gd; new rule in its own file): on the cross, rear hook and
   rear uppercut takes, move the pelvis forward along the line 10-18 cm from the take's load to the contact (eased, peaking at
   contact, returned on the recoil), with the rear foot pivoting on its ball and the rear knee EXTENDING ~20-25 deg through
   the drive; the lead leg braces (takes ~61 % of the ground force, K46). Knee stays with the hips (FP2POSE3 KNEE test).
2. Glove speed: re-measure the cross's glove-face peak (CROSS_POWER_S439: ours 4.4-5.4 m/s vs real 6-11.5) before/after.
3. Tests in tests/player2_test.gd: DRIVE (hips forward >= 10 cm guard->contact, rear knee extends >= 15 deg) red as now,
   green after; KNEE, HEEL, FEET, STANCE, GAZE, landed gloves, JUMPS, SLIDE no worse; choreographer, arm_build, file_limits.
4. Films on the game camera (hidden desktop, both men head to feet): cross + rear hook, before left / after right; contact
   still. ops/previews/s537_fp2pose4/, docs/FP2POSE4_RESULT.md with our numbers beside the studies' and your score /10.

## Prior research
docs/FP2POSE3_RESULT.md, docs/CASCTEST1_RESULT.md, ops/research/CROSS_POWER_S439.md, K46_BOXER_FEET_DURING_PUNCHES.md,
K49_TORSO_IN_A_HOOK.md, G75_STRIKE_SPEEDS.md.

## What would a human do?
"Push off the back foot and drive the hip through" - the weight moves forward onto the braced front leg as the fist lands.

## Prefab check
None (our bake on bought takes).

## Contract
OWNS: tools/drive_bake.gd (new), scripts/fight3d/v2/<new drive file>.gd, scripts/fight3d/v2/CrossLegs.gd,
assets/anim/baked/v2/ (re-baked takes), tests/player2_test.gd, docs/FP2POSE4_RESULT.md
RED_TEST: tests/player2_test.gd DRIVE
REGRESSION: choreographer_test, arm_build_test, file_limits_test
VISUAL: yes - films above, opened by you

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who fp2pose4 -- <command>`; windowed only on the hidden desktop.
Never stage LineGrade.gd, LiveRound.gd, StepWire.gd, MHRig.gd, tools/export.sh. No script over 500 lines. `git add -- <new>`
then `git commit -m ... -- <your paths>` with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, push, report in two
lines, stop.
