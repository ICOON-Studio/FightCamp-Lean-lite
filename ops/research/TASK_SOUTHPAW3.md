# TASK SOUTHPAW3 - QWEN (qwen3-coder) - the guard knock-knee fix, carried onto today's clips

Status: OPEN (S406, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).
Source: PR #78 (branch cursor/southpaw2, e2ac1f76) measured a southpaw knock-in of 0.139 m on main and 0.000 m after its fix, CI green. It was held in S399 until the clips matched their source. They do now: RETARGET2B merged, the proguard guard is ON. The branch was cut before those merges and was never run with the new guard.

BASE: cursor/southpaw2

## Contract
OWNS: scripts/fight3d/BoxerFootworkRig.gd, scripts/fight3d/BoxerFootwork.gd, tests/guard_valgus_test.gd
RED_TEST: tests/guard_valgus_test.gd -> GUARD_VALGUS failures=0
REGRESSION: ring_feet_test, foot_plant_test, boxer_footwork_test, fight_polish_test, corner_warm_test, knee_track_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/fight3d_film.gd -- E:/FightCamp/tmp/southpaw3 short seed=7

## Prior research
`python ops/Tools/prior_research.py southpaw knock knee guard`. ops/research/RETARGET2B_RESULT.md says why the clips changed. Read ops/research/GDSCRIPT_TRAPS.md before writing GDScript.

## What would a human do?
Bring the branch up to date, check whether the bug still exists with the new guard, and only keep the fix if it still earns its place.

## Prefab check
None needed.

## The job
1. Merge origin/main into this branch. Resolve only inside OWNS. Commit the merge.
2. With the two rig files temporarily put back as they are on origin/main (`git show origin/main:<file>` into place, then restore yours), run tests/guard_valgus_test.gd and write the printed valgus and knee_gap numbers for red and blue, orthodox and southpaw, in the PR body. This answers one question: is the knock-knee still there with the proguard guard?
3. If main no longer fails the test, say so in the PR body with the numbers, keep the test and revert the rig changes. A fix for a bug that is gone is not kept.
4. If main still fails, keep the fix. The test must pass on the branch.
5. `noproguard` must still behave: run tests/guard_valgus_test.gd once with that switch and print the numbers beside the others.

## Rules
Do not change any number or threshold in an existing test. boxer_footwork_test has a known torso-lean failure on main (bar 8-12): compare its failure list before and after, and report only a NEW failure. Godot runs go through `python ops/Tools/godot_slot.py run --who southpaw3 -- <godot cmd>`. Do not touch FootPlant.gd, RingFeet.gd, KneeTrack.gd, CornerCrew.gd, CornerMinute.gd or anything in scripts/rules.

## The one trap
The old PR body's lines for the regression tests only recorded that the Godot slot started, so nothing proves those six passed. Read each test's own pass line.
