# TASK BLOCKLOOK4 - GROK DEV - the block, round 4: the puncher's arm keeps its shape (MATCH), the catch meets the punch further out

Status: OPEN (S450, Claude main), queued at Grok Dev behind OFFICE1. Discipline: boxing (demo). Model: Grok Dev.
His marks still open (review board S449, ops/Feedback/2026-11-13-15): "the arm looks shorter", "90 degrees angle ? wtf is that move ?",
"colission!!". BLOCKLOOK3 (merged S450, docs/BLOCKLOOK3_RESULT.md) fixed the absorb and left MATCH red: a blocked punch reaches 36-74 % of
its landed twin with the elbow 30-106 degrees off, because the blocking glove sits 0.12-0.14 m in front of her face and the arm IK folds to
reach it. Arming blocked straights with the landed reach passed MATCH for the jab but pushed block_meet 10 -> 13 (glove TOUCH).

## Decided (Claude, S450): move the CATCH, not the punch
The blocking glove meets the punch where the puncher's arm is at 90 % of its landed reach: BlockCatch places the catching glove on the
punch's line at that point (further out from her face than today, for a straight about 0.20-0.28 m; a hook on its arc), the punch is
armed as today (no landed carry), and the front of the punching glove stops ON the catching glove there. The blocker's forearm angles out
to meet it; her head stays behind it. The absorb (BLOCKLOOK3) then plays from that meeting point.

## Contract
OWNS: scripts/fight3d/BlockCatch.gd (315 lines; a helper scripts/fight3d/BlockCatchPoint.gd you also own if it would pass 500),
tests/block_catch_test.gd, docs/BLOCKLOOK4_RESULT.md
RED_TEST: tests/block_catch_test.gd -> BLOCK_CATCH failures=<MATCH rows 0; the one flaky MEETS B_A lead-hook row named>
REGRESSION: block_absorb_test, block_set_test, block_meet_test (must not rise above main's 10), beat_clips_test, hit_carry_test,
fight_feel_test, file_limits_test
VISUAL: yes - Claude films tools/fight3d_gallery.gd only=block on the PC and the operator closes it
NOT YOURS: PunchReach.gd, FightStage.gd, BeatFire.gd (read them; if a one-line hook is needed outside OWNS, name it in the PR).

## Bars (block_catch_test MATCH, as BLOCKLOOK3 wrote them)
- reach >= 90 % of the landed twin, elbow within 15 deg, chest within 10 deg, shoulder drop <= 0.04 m, all 8 rows both directions;
- GAP: the front of the punching glove at contact >= -0.005 m into the catching glove (no glove in glove);
- the catching glove stays in front of her own face (to_face_min >= 0.08 m) and is back in guard by 0.5 s (BLOCKLOOK3's absorb bars hold).

## Traps
- Godot headless for tests; the plain binary; Dummy audio. Do not delete or weaken a test. Files under 500 lines.
- Hooks: the catch point is on the hook's arc at 90 % reach, not on the face line.

## Prior research
- docs/BLOCKLOOK3_RESULT.md (what was tried and why it failed), ops/research/TASK_BLOCKLOOK3.md.

## What would a human do?
A boxer catching a cross meets it out in front with the glove, arm angled forward; the cross stays a straight arm that was stopped.

## Prefab check
None: our own catch.

Test command: `<godot> --headless --audio-driver Dummy --path . --script res://tests/block_catch_test.gd`
RESULT lines for the PR body: one per test above, `RESULT: tests/<x>.gd -> <PASS line>`.
