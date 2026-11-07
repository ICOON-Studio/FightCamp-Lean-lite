# TASK GRAPPLEFIX1 - QWEN (qwen3-coder) - every played grappling move measured AS THE GAME DRAWS IT, the worst fixed first

Status: OPEN (S399, Claude main). Discipline: no-gi BJJ. Operator S399, on the board's "To 50/50" card ("bodies inside
bodies + a pop"): "i thought this was fixed ?", then "start rating/improving and putting them on board". The S391 contact
fix (GrappleLimbs, holds on the drawn bodies, tap on the mat) is now merged (b0fa2d66) but the board's 47 previews are all
PURE (tools/grapple_orbit.gd: push-out, IK, grips OFF), so no preview shows what the game does.

## Contract
OWNS: tools/grapple_orbit.gd, scripts/grapple/GrappleLimbs.gd, scripts/grapple/GrappleDrawn.gd, scripts/grapple/GrapplePose.gd, scripts/grapple/GrapplePlayer.gd, tests/grapple_fix_test.gd
RED_TEST: tests/grapple_fix_test.gd -> GRAPPLE_FIX failures=0
REGRESSION: grapple_limbs_test, grapple_contact_test, grapple_pose_test, bjj_match_test, bjj_finish_test, bjj_mat_test, golden_path_test
VISUAL: yes
FILM: --resolution 960x540 --script res://tools/grapple_orbit.gd -- game=1

## Board bar (operator S399: "a bit of overlap can be fine, rate of 7 should be ok for now")
Grappling page: a blind critic 7/10 (control arm, every-frame eyes) = VERIFIED. Pressed-together overlap is acceptable;
parked limbs, pops and trembling are not. Boxing clips stay at 8/10.

## Do
1. Add a `game=1` arm to tools/grapple_orbit.gd: the move as the belt match draws it (the S391 placement ON: contact push-out,
   GrappleLimbs clearance, holds, GrapplePose IK), same camera, same numbers, measured AS DRAWN (inside
   Skeleton3D.skeleton_updated - outside it Godot returns the pose without modifiers). Keep the pure arm as it is.
2. Measure all 47 played moves (ids: `python ops/Tools/lean_grapple_catalogue.py --json`, rows[].id) in BOTH arms, headless
   numbers only (no video needed for the table): jerk p95, direction flips/s, worst one-frame pop, deepest part inside the
   other body (and how many frames over 6 cm). Write ops/research/GRAPPLEFIX1_TABLE.md: one row per move, pure vs game,
   worst first. Start every Godot run through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`.
3. tests/grapple_fix_test.gd FIRST for the 5 worst moves of the game arm, bars per move (main must FAIL them):
   deepest inside <= 3 cm torso-in-torso and <= 2 cm a limb parked in a body (a run over 0.2 s); worst pop <= 3 cm in one
   frame; jerk p95 <= 60 m/s^3; flips <= 0.1 /s. Then fix the cause in OWNS (the placement, the limb clearance, the
   keyframe blend - one writer per bone), worst move first; re-measure all 47 so nothing else gets worse.
4. Do not loosen a bar, do not drop a move from the table, do not edit the BJJ rules (scripts/rules/Bjj*), ops/, or
   tools/run_tests.sh. Claude films and judges (blind critic, every-frame eyes bursts); you do not score your own work.

## Result lines (PR body)
RESULT: GRAPPLE_FIX main <n> failures -> after failures=0
RESULT: table pure vs game, worst 10 before -> after (inside cm / pop cm / jerk / flips)
RESULT: moves passing every bar: main <n>/47 -> after <n>/47
RESULT: regression <pass/fail per test>
